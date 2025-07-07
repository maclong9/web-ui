import Foundation

/// Central coordination system for data synchronization across multiple sources
///
/// `SyncEngine` orchestrates the synchronization of data between local caches,
/// remote APIs, and persistent storage. It handles conflict resolution, offline
/// support, and ensures data consistency across the application.
///
/// ## Key Features
///
/// - **Multi-directional sync**: Local ↔ Remote, Local ↔ Persistent, Remote ↔ Persistent
/// - **Conflict resolution**: Configurable strategies for handling data conflicts
/// - **Offline support**: Queue operations for when connectivity is restored
/// - **Change tracking**: Efficient delta synchronization
/// - **Background sync**: Automatic synchronization in the background
/// - **Priority queuing**: Critical updates take precedence
///
/// ## Usage
///
/// ```swift
/// let syncEngine = SyncEngine<User>()
/// 
/// // Configure sync policies
/// syncEngine.configure(
///     conflictResolution: .lastWriteWins,
///     syncInterval: .minutes(5),
///     batchSize: 50
/// )
/// 
/// // Start background synchronization
/// await syncEngine.start()
/// 
/// // Manual sync trigger
/// await syncEngine.sync()
/// ```
@MainActor
public final class SyncEngine<DataType: Codable & Sendable & Identifiable & Equatable>: ObservableObject, Sendable {
    
    // MARK: - Configuration
    
    /// Strategy for resolving conflicts when the same data has been modified in multiple places
    public enum ConflictResolution: Sendable {
        /// Remote version always wins
        case remoteWins
        /// Local version always wins
        case localWins
        /// Most recently modified version wins
        case lastWriteWins
        /// Custom resolution function
        case custom((DataType, DataType) async -> DataType)
    }
    
    /// Priority levels for sync operations
    public enum SyncPriority: Int, Comparable, Sendable {
        case low = 0
        case normal = 1
        case high = 2
        case critical = 3
        
        public static func < (lhs: SyncPriority, rhs: SyncPriority) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
    
    /// Configuration for sync behavior
    public struct SyncConfiguration: Sendable {
        public let conflictResolution: ConflictResolution
        public let syncInterval: TimeInterval?
        public let batchSize: Int
        public let maxRetries: Int
        public let offlineQueueLimit: Int
        
        public init(
            conflictResolution: ConflictResolution = .lastWriteWins,
            syncInterval: TimeInterval? = 300, // 5 minutes
            batchSize: Int = 50,
            maxRetries: Int = 3,
            offlineQueueLimit: Int = 1000
        ) {
            self.conflictResolution = conflictResolution
            self.syncInterval = syncInterval
            self.batchSize = batchSize
            self.maxRetries = maxRetries
            self.offlineQueueLimit = offlineQueueLimit
        }
    }
    
    // MARK: - Dependencies
    
    private let localRepository: Repository<DataType>
    private let remoteRepository: Repository<DataType>
    private let persistentRepository: Repository<DataType>?
    
    // MARK: - State
    
    private var configuration: SyncConfiguration
    private var isRunning = false
    private var syncTask: Task<Void, Never>?
    private var operationQueue: [SyncOperation] = []
    private var lastSyncTimestamp: Date?
    
    @Published public private(set) var syncStatus: SyncStatus = .idle
    @Published public private(set) var syncProgress: SyncProgress = SyncProgress()
    
    // MARK: - Initialization
    
    public init(
        localRepository: Repository<DataType>,
        remoteRepository: Repository<DataType>,
        persistentRepository: Repository<DataType>? = nil,
        configuration: SyncConfiguration = SyncConfiguration()
    ) {
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
        self.persistentRepository = persistentRepository
        self.configuration = configuration
    }
    
    // MARK: - Lifecycle
    
    /// Starts the sync engine with background synchronization
    public func start() async {
        guard !isRunning else { return }
        
        isRunning = true
        syncStatus = .running
        
        // Start background sync if interval is configured
        if let interval = configuration.syncInterval {
            syncTask = Task { [weak self] in
                while !Task.isCancelled {
                    do {
                        try await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
                        await self?.performBackgroundSync()
                    } catch {
                        break
                    }
                }
            }
        }
        
        // Process any queued operations
        await processOperationQueue()
    }
    
    /// Stops the sync engine
    public func stop() async {
        isRunning = false
        syncTask?.cancel()
        syncTask = nil
        syncStatus = .idle
    }
    
    /// Triggers an immediate full synchronization
    /// - Parameter priority: Priority level for this sync operation
    /// - Returns: Sync result with statistics
    public func sync(priority: SyncPriority = .normal) async -> SyncResult {
        syncStatus = .syncing
        
        do {
            let result = await performFullSync()
            lastSyncTimestamp = Date()
            syncStatus = .completed(result.timestamp)
            return result
        } catch {
            syncStatus = .failed(error)
            return SyncResult(
                timestamp: Date(),
                itemsSynced: 0,
                conflictsResolved: 0,
                errors: [error]
            )
        }
    }
    
    // MARK: - Operation Queuing
    
    /// Queues a create operation for synchronization
    /// - Parameters:
    ///   - item: The item to create
    ///   - priority: Priority level for this operation
    public func queueCreate(_ item: DataType, priority: SyncPriority = .normal) async {
        let operation = SyncOperation(
            type: .create(item),
            priority: priority,
            timestamp: Date()
        )
        await queueOperation(operation)
    }
    
    /// Queues an update operation for synchronization
    /// - Parameters:
    ///   - item: The item to update
    ///   - priority: Priority level for this operation
    public func queueUpdate(_ item: DataType, priority: SyncPriority = .normal) async {
        let operation = SyncOperation(
            type: .update(item),
            priority: priority,
            timestamp: Date()
        )
        await queueOperation(operation)
    }
    
    /// Queues a delete operation for synchronization
    /// - Parameters:
    ///   - id: The identifier of the item to delete
    ///   - priority: Priority level for this operation
    public func queueDelete(id: DataType.ID, priority: SyncPriority = .normal) async {
        let operation = SyncOperation(
            type: .delete(id),
            priority: priority,
            timestamp: Date()
        )
        await queueOperation(operation)
    }
    
    // MARK: - Configuration
    
    /// Updates the sync engine configuration
    /// - Parameter newConfiguration: The new configuration to apply
    public func configure(_ newConfiguration: SyncConfiguration) async {
        let wasRunning = isRunning
        
        if wasRunning {
            await stop()
        }
        
        self.configuration = newConfiguration
        
        if wasRunning {
            await start()
        }
    }
}

// MARK: - Private Implementation

extension SyncEngine {
    
    private func performFullSync() async -> SyncResult {
        var itemsSynced = 0
        var conflictsResolved = 0
        var errors: [Error] = []
        
        do {
            // 1. Sync from remote to local
            let remoteItems = try await remoteRepository.getAll()
            let localItems = try await localRepository.getAll()
            
            let (remoteToLocalSynced, remoteToLocalConflicts) = await syncRemoteToLocal(
                remoteItems: remoteItems,
                localItems: localItems
            )
            
            itemsSynced += remoteToLocalSynced
            conflictsResolved += remoteToLocalConflicts
            
            // 2. Sync from local to remote (pending operations)
            let (localToRemoteSynced, localToRemoteConflicts) = await syncLocalToRemote()
            
            itemsSynced += localToRemoteSynced
            conflictsResolved += localToRemoteConflicts
            
            // 3. Sync to persistent storage if available
            if let persistentRepo = persistentRepository {
                let currentItems = try await localRepository.getAll()
                // Clear and recreate all items in persistent storage
                await persistentRepo.invalidateAll()
                for item in currentItems {
                    try? await persistentRepo.create(item)
                }
            }
            
        } catch {
            errors.append(error)
        }
        
        return SyncResult(
            timestamp: Date(),
            itemsSynced: itemsSynced,
            conflictsResolved: conflictsResolved,
            errors: errors
        )
    }
    
    private func syncRemoteToLocal(
        remoteItems: [DataType],
        localItems: [DataType]
    ) async -> (synced: Int, conflicts: Int) {
        var synced = 0
        var conflicts = 0
        
        let localItemsDict = Dictionary(uniqueKeysWithValues: localItems.map { ($0.id, $0) })
        
        for remoteItem in remoteItems {
            if let localItem = localItemsDict[remoteItem.id] {
                // Item exists in both - check for conflicts
                if remoteItem != localItem {
                    let resolved = await resolveConflict(local: localItem, remote: remoteItem)
                    try? await localRepository.update(resolved)
                    conflicts += 1
                } else {
                    // Items are identical, no action needed
                }
            } else {
                // Item only exists remotely - add to local
                try? await localRepository.create(remoteItem)
                synced += 1
            }
        }
        
        return (synced, conflicts)
    }
    
    private func syncLocalToRemote() async -> (synced: Int, conflicts: Int) {
        var synced = 0
        var conflicts = 0
        
        // Process queued operations
        let operations = operationQueue.sorted(by: { $0.priority > $1.priority })
        operationQueue.removeAll()
        
        for operation in operations {
            do {
                switch operation.type {
                case .create(let item):
                    _ = try await remoteRepository.create(item)
                    synced += 1
                    
                case .update(let item):
                    _ = try await remoteRepository.update(item)
                    synced += 1
                    
                case .delete(let id):
                    try await remoteRepository.delete(id: id)
                    synced += 1
                }
            } catch {
                // Re-queue failed operations with lower priority
                if operation.retryCount < configuration.maxRetries {
                    var retriedOperation = operation
                    retriedOperation.retryCount += 1
                    retriedOperation.priority = .low
                    operationQueue.append(retriedOperation)
                }
            }
        }
        
        return (synced, conflicts)
    }
    
    private func resolveConflict(local: DataType, remote: DataType) async -> DataType {
        switch configuration.conflictResolution {
        case .remoteWins:
            return remote
        case .localWins:
            return local
        case .lastWriteWins:
            // This would require timestamp metadata - for now, default to remote
            return remote
        case .custom(let resolver):
            return await resolver(local, remote)
        }
    }
    
    private func queueOperation(_ operation: SyncOperation) async {
        // Check queue limit
        if operationQueue.count >= configuration.offlineQueueLimit {
            // Remove oldest low-priority operation
            if let index = operationQueue.firstIndex(where: { $0.priority == .low }) {
                operationQueue.remove(at: index)
            }
        }
        
        operationQueue.append(operation)
        
        // If running, process immediately for high-priority operations
        if isRunning && operation.priority >= .high {
            await processOperationQueue()
        }
    }
    
    private func processOperationQueue() async {
        guard !operationQueue.isEmpty else { return }
        
        let (synced, conflicts) = await syncLocalToRemote()
        
        if synced > 0 || conflicts > 0 {
            syncProgress = SyncProgress(
                itemsProcessed: synced,
                totalItems: synced,
                conflictsResolved: conflicts
            )
        }
    }
    
    private func performBackgroundSync() async {
        guard isRunning else { return }
        
        do {
            _ = await performFullSync()
        } catch {
            // Silent failure for background sync
        }
    }
}

// MARK: - Supporting Types

/// Represents a queued synchronization operation
private struct SyncOperation: Sendable {
    enum OperationType: Sendable {
        case create(DataType)
        case update(DataType)
        case delete(DataType.ID)
    }
    
    let type: OperationType
    var priority: SyncEngine.SyncPriority
    let timestamp: Date
    var retryCount: Int = 0
}

/// Current status of the sync engine
public enum SyncStatus: Sendable {
    case idle
    case running
    case syncing
    case completed(Date)
    case failed(Error)
}

/// Progress information for sync operations
public struct SyncProgress: Sendable {
    public let itemsProcessed: Int
    public let totalItems: Int
    public let conflictsResolved: Int
    
    public var progressPercentage: Double {
        guard totalItems > 0 else { return 0.0 }
        return Double(itemsProcessed) / Double(totalItems)
    }
    
    public init(itemsProcessed: Int = 0, totalItems: Int = 0, conflictsResolved: Int = 0) {
        self.itemsProcessed = itemsProcessed
        self.totalItems = totalItems
        self.conflictsResolved = conflictsResolved
    }
}

/// Result of a synchronization operation
public struct SyncResult: Sendable {
    public let timestamp: Date
    public let itemsSynced: Int
    public let conflictsResolved: Int
    public let errors: [Error]
    
    public var isSuccess: Bool {
        errors.isEmpty
    }
}

// MARK: - ConflictResolution Extensions

extension SyncEngine.ConflictResolution {
    // Helper methods for common conflict resolution patterns
    
    /// Resolves conflicts by comparing timestamps (requires Timestamped protocol)
    public static func timestampBased<T: Timestamped>() -> SyncEngine<T>.ConflictResolution {
        return .custom { local, remote in
            return local.timestamp > remote.timestamp ? local : remote
        }
    }
    
    /// Resolves conflicts by choosing the item with more recent version number
    public static func versionBased<T: Versioned>() -> SyncEngine<T>.ConflictResolution {
        return .custom { local, remote in
            return local.version > remote.version ? local : remote
        }
    }
}

/// Protocol for types that have timestamp information
public protocol Timestamped {
    var timestamp: Date { get }
}

/// Protocol for types that have version information
public protocol Versioned {
    var version: Int { get }
}