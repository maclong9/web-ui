import Foundation
#if canImport(CoreServices)
import CoreServices
#endif

/// A file system watcher that monitors directories for changes to specific file types.
///
/// `FileWatcher` uses platform-specific APIs to efficiently monitor file system changes:
/// - On macOS: Uses FSEvents API for high-performance monitoring
/// - On Linux: Uses inotify for file system event monitoring
/// - Fallback: Uses polling for cross-platform compatibility
///
/// ## Usage
///
/// ```swift
/// let watcher = FileWatcher(
///     directory: "./Sources",
///     extensions: [".swift", ".md"]
/// )
/// 
/// watcher.onFileChanged = { changedFiles in
///     print("Changed files: \(changedFiles)")
/// }
/// 
/// watcher.start()
/// ```
public final class FileWatcher: @unchecked Sendable {
    
    /// Callback type for file change notifications
    public typealias FileChangeCallback = @Sendable ([String]) -> Void
    
    private let directory: String
    private let extensions: Set<String>
    private let debounceInterval: TimeInterval
    private let logger: DevServerLogger
    
    /// Callback invoked when files matching the criteria change
    public var onFileChanged: FileChangeCallback?
    
    private var isWatching = false
    private var debounceTimer: Timer?
    private var pendingChanges: Set<String> = []
    private let lock = NSLock()
    
    #if canImport(CoreServices)
    private var fsEventStream: FSEventStreamRef?
    #endif
    
    /// Creates a new file watcher for the specified directory and file extensions.
    ///
    /// - Parameters:
    ///   - directory: Directory path to watch (will be watched recursively)
    ///   - extensions: File extensions to monitor (e.g., [".swift", ".md"])
    ///   - debounceInterval: Minimum time between change notifications (defaults to 0.5 seconds)
    ///   - logger: Logger instance for debugging output
    public init(
        directory: String,
        extensions: [String],
        debounceInterval: TimeInterval = 0.5,
        logger: DevServerLogger = DevServerLogger()
    ) {
        self.directory = directory
        self.extensions = Set(extensions.map { $0.lowercased() })
        self.debounceInterval = debounceInterval
        self.logger = logger
    }
    
    /// Starts monitoring the directory for file changes.
    ///
    /// This method will begin watching the specified directory recursively for changes
    /// to files matching the configured extensions.
    public func start() {
        guard !isWatching else {
            logger.warning("FileWatcher is already running")
            return
        }
        
        isWatching = true
        logger.info("Starting file watcher for: \(directory)")
        logger.info("Monitoring extensions: \(extensions.joined(separator: ", "))")
        
        #if canImport(CoreServices)
        startFSEventsWatcher()
        #else
        startPollingWatcher()
        #endif
    }
    
    /// Stops monitoring the directory for file changes.
    public func stop() {
        guard isWatching else { return }
        
        isWatching = false
        logger.info("Stopping file watcher")
        
        #if canImport(CoreServices)
        stopFSEventsWatcher()
        #endif
        
        // Cancel any pending debounce timer
        debounceTimer?.invalidate()
        debounceTimer = nil
        
        // Clear pending changes
        lock.withLock {
            pendingChanges.removeAll()
        }
    }
    
    deinit {
        stop()
    }
    
    // MARK: - Private Methods
    
    private func shouldMonitorFile(_ filePath: String) -> Bool {
        let fileExtension = URL(fileURLWithPath: filePath).pathExtension.lowercased()
        return extensions.contains(".\(fileExtension)")
    }
    
    private func handleFileChange(_ filePath: String) {
        guard shouldMonitorFile(filePath) else { return }
        
        _ = lock.withLock {
            pendingChanges.insert(filePath)
        }
        
        // Debounce the changes to avoid excessive notifications
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: debounceInterval, repeats: false) { [weak self] _ in
            self?.flushPendingChanges()
        }
    }
    
    private func flushPendingChanges() {
        let changes = lock.withLock {
            let result = Array(pendingChanges)
            pendingChanges.removeAll()
            return result
        }
        
        guard !changes.isEmpty else { return }
        
        logger.debug("File changes detected: \(changes.count) files")
        onFileChanged?(changes)
    }
    
    // MARK: - FSEvents Implementation (macOS)
    
    #if canImport(CoreServices)
    private func startFSEventsWatcher() {
        let directoryPath = URL(fileURLWithPath: directory).path
        let pathsToWatch = [directoryPath] as CFArray
        
        let callback: FSEventStreamCallback = { (
            streamRef: ConstFSEventStreamRef,
            clientCallBackInfo: UnsafeMutableRawPointer?,
            numEvents: Int,
            eventPaths: UnsafeMutableRawPointer,
            eventFlags: UnsafePointer<FSEventStreamEventFlags>,
            eventIds: UnsafePointer<FSEventStreamEventId>
        ) in
            guard let clientCallBackInfo = clientCallBackInfo else { return }
            
            let watcher = Unmanaged<FileWatcher>.fromOpaque(clientCallBackInfo).takeUnretainedValue()
            let paths = unsafeBitCast(eventPaths, to: NSArray.self) as! [String]
            
            for i in 0..<numEvents {
                let eventPath = paths[i]
                let flags = eventFlags[i]
                
                // Check if this is a file modification event
                if flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemIsFile) != 0 ||
                   flags & FSEventStreamEventFlags(kFSEventStreamEventFlagItemModified) != 0 {
                    watcher.handleFileChange(eventPath)
                }
            }
        }
        
        let context = FSEventStreamContext(
            version: 0,
            info: Unmanaged.passUnretained(self).toOpaque(),
            retain: nil,
            release: nil,
            copyDescription: nil
        )
        
        var streamContext = context
        fsEventStream = FSEventStreamCreate(
            kCFAllocatorDefault,
            callback,
            &streamContext,
            pathsToWatch,
            FSEventStreamEventId(kFSEventStreamEventIdSinceNow),
            0.1, // Latency in seconds
            FSEventStreamCreateFlags(kFSEventStreamCreateFlagFileEvents | kFSEventStreamCreateFlagUseCFTypes)
        )
        
        if let stream = fsEventStream {
            FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
            FSEventStreamStart(stream)
            logger.info("FSEvents watcher started successfully")
        } else {
            logger.error("Failed to create FSEvents stream")
            startPollingWatcher()
        }
    }
    
    private func stopFSEventsWatcher() {
        if let stream = fsEventStream {
            FSEventStreamStop(stream)
            FSEventStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
            FSEventStreamInvalidate(stream)
            FSEventStreamRelease(stream)
            fsEventStream = nil
        }
    }
    #endif
    
    // MARK: - Polling Implementation (Fallback)
    
    private func startPollingWatcher() {
        logger.info("Starting polling-based file watcher")
        
        Task {
            var lastModificationTimes: [String: Date] = [:]
            
            while isWatching {
                do {
                    let currentTimes = try await scanDirectoryForChanges()
                    
                    // Compare with last known modification times
                    for (filePath, modTime) in currentTimes {
                        if let lastModTime = lastModificationTimes[filePath] {
                            if modTime > lastModTime {
                                handleFileChange(filePath)
                            }
                        }
                    }
                    
                    lastModificationTimes = currentTimes
                    
                    // Wait before next polling cycle
                    try await Task.sleep(for: .seconds(1))
                } catch {
                    logger.error("Error during file polling: \(error)")
                    try await Task.sleep(for: .seconds(5))
                }
            }
        }
    }
    
    private func scanDirectoryForChanges() async throws -> [String: Date] {
        var modificationTimes: [String: Date] = [:]
        
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: directory)
        
        while let relativePath = enumerator?.nextObject() as? String {
            let fullPath = URL(fileURLWithPath: directory).appendingPathComponent(relativePath).path
            
            guard shouldMonitorFile(fullPath) else { continue }
            
            do {
                let attributes = try fileManager.attributesOfItem(atPath: fullPath)
                if let modDate = attributes[.modificationDate] as? Date {
                    modificationTimes[fullPath] = modDate
                }
            } catch {
                // Ignore files that can't be accessed
                continue
            }
        }
        
        return modificationTimes
    }
}

