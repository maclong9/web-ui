import Foundation
import Network
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A lightweight development server for WebUI applications with hot reload capabilities.
///
/// The `DevServer` provides a complete development environment with:
/// - Static file serving from build output
/// - WebSocket-based hot reload communication
/// - Swift file watching and automatic rebuilds
/// - Live browser refresh on changes
/// - Development-friendly error handling
///
/// ## Usage
///
/// ```swift
/// let server = DevServer(
///     port: 3000,
///     buildDirectory: "./build",
///     sourceDirectory: "./Sources"
/// )
/// try await server.start()
/// ```
public final class DevServer: @unchecked Sendable {
    
    /// Configuration for the development server
    public struct Configuration: Sendable {
        /// Port number for the HTTP server
        public let port: UInt16
        /// Directory containing built static files
        public let buildDirectory: String
        /// Directory to watch for Swift source changes
        public let sourceDirectory: String
        /// Build command to execute when files change
        public let buildCommand: String
        /// Whether to automatically open browser on start
        public let autoOpenBrowser: Bool
        /// Host address to bind to
        public let host: String
        /// WebSocket port for hot reload communication
        public let websocketPort: UInt16
        
        public init(
            port: UInt16 = 3000,
            buildDirectory: String = "./build",
            sourceDirectory: String = "./Sources",
            buildCommand: String = "swift run",
            autoOpenBrowser: Bool = true,
            host: String = "localhost",
            websocketPort: UInt16 = 3001
        ) {
            self.port = port
            self.buildDirectory = buildDirectory
            self.sourceDirectory = sourceDirectory
            self.buildCommand = buildCommand
            self.autoOpenBrowser = autoOpenBrowser
            self.host = host
            self.websocketPort = websocketPort
        }
    }
    
    private let configuration: Configuration
    private let fileWatcher: FileWatcher
    private let httpServer: HTTPServer
    private let websocketServer: WebSocketServer
    private let buildManager: BuildManager
    private let logger: DevServerLogger
    
    /// Creates a new development server with the specified configuration.
    ///
    /// - Parameter configuration: Server configuration settings
    public init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
        self.logger = DevServerLogger()
        self.fileWatcher = FileWatcher(
            directory: configuration.sourceDirectory,
            extensions: [".swift"]
        )
        self.httpServer = HTTPServer(
            port: configuration.port,
            host: configuration.host,
            buildDirectory: configuration.buildDirectory,
            logger: logger
        )
        self.websocketServer = WebSocketServer(
            port: configuration.websocketPort,
            host: configuration.host,
            logger: logger
        )
        self.buildManager = BuildManager(
            buildCommand: configuration.buildCommand,
            buildDirectory: configuration.buildDirectory,
            logger: logger
        )
    }
    
    /// Starts the development server and begins watching for file changes.
    ///
    /// This method will:
    /// 1. Perform an initial build
    /// 2. Start the HTTP server for static file serving
    /// 3. Start the WebSocket server for hot reload communication
    /// 4. Begin watching Swift files for changes
    /// 5. Optionally open the browser
    ///
    /// - Throws: `DevServerError` if the server cannot be started
    public func start() async throws {
        logger.info("Starting WebUI Development Server...")
        
        // Perform initial build
        logger.info("Performing initial build...")
        try await buildManager.performBuild()
        
        // Start servers
        try await httpServer.start()
        try await websocketServer.start()
        
        // Setup file watching
        setupFileWatching()
        
        // Open browser if requested
        if configuration.autoOpenBrowser {
            openBrowser()
        }
        
        logger.success("Development server started successfully!")
        logger.info("🚀 Server running at: http://\(configuration.host):\(configuration.port)")
        logger.info("🔄 WebSocket server at: ws://\(configuration.host):\(configuration.websocketPort)")
        logger.info("👀 Watching for changes in: \(configuration.sourceDirectory)")
        logger.info("📁 Serving files from: \(configuration.buildDirectory)")
        logger.info("Press Ctrl+C to stop the server")
        
        // Keep the server running
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            // This will keep the server running until cancelled
            Task {
                do {
                    try await Task.sleep(for: .seconds(Double.greatestFiniteMagnitude))
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// Stops the development server and cleanup resources.
    public func stop() async {
        logger.info("Shutting down development server...")
        
        await httpServer.stop()
        await websocketServer.stop()
        fileWatcher.stop()
        
        logger.info("Development server stopped.")
    }
    
    // MARK: - Private Methods
    
    private func setupFileWatching() {
        fileWatcher.onFileChanged = { [weak self] changedFiles in
            guard let self = self else { return }
            
            Task {
                await self.handleFileChanges(changedFiles)
            }
        }
        
        fileWatcher.start()
    }
    
    private func handleFileChanges(_ changedFiles: [String]) async {
        logger.info("Files changed: \(changedFiles.map { URL(fileURLWithPath: $0).lastPathComponent }.joined(separator: ", "))")
        
        do {
            // Rebuild the project
            logger.info("Rebuilding project...")
            try await buildManager.performBuild()
            
            // Notify connected clients to reload
            await websocketServer.broadcastReload()
            
            logger.success("Build completed successfully - browser should reload automatically")
        } catch {
            logger.error("Build failed: \(error.localizedDescription)")
            await websocketServer.broadcastError(error.localizedDescription)
        }
    }
    
    private func openBrowser() {
        let url = "http://\(configuration.host):\(configuration.port)"
        
        #if os(macOS)
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = [url]
        task.launch()
        #endif
        
        logger.info("Opening browser at: \(url)")
    }
}

// MARK: - Error Types

/// Errors that can occur during development server operation
public enum DevServerError: Error, LocalizedError {
    case portInUse(UInt16)
    case buildFailed(String)
    case fileSystemError(String)
    case networkError(String)
    
    public var errorDescription: String? {
        switch self {
        case .portInUse(let port):
            return "Port \(port) is already in use"
        case .buildFailed(let message):
            return "Build failed: \(message)"
        case .fileSystemError(let message):
            return "File system error: \(message)"
        case .networkError(let message):
            return "Network error: \(message)"
        }
    }
}

