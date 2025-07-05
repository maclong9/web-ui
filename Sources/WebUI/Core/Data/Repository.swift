import Foundation

/// Repository pattern implementation for WebUI data layer
///
/// `Repository` provides a clean abstraction layer between the business logic
/// and data access concerns. It coordinates between multiple data sources,
/// handles caching strategies, and provides a unified API for data operations.
///
/// ## Key Features
///
/// - **Multi-source coordination**: Primary and fallback data sources
/// - **Intelligent caching**: Configurable cache strategies and TTL
/// - **Offline support**: Graceful handling of network unavailability
/// - **State integration**: Automatic updates to reactive state
/// - **Error recovery**: Retry logic and fallback mechanisms
///
/// ## Usage
///
/// ```swift
/// let userRepo = Repository(
///     primarySource: UserAPIDataSource(),
///     cache: InMemoryCache<User>(),
///     strategy: .cacheFirst
/// )
///
/// // Fetch with automatic caching
/// let user = try await userRepo.get(id: "123")
///
/// // Subscribe to changes
/// for await user in userRepo.observe(id: "123") {
///     // Handle user updates
/// }
/// ```
@MainActor
public final class Repository<DataType: Codable & Sendable & Identifiable>: ObservableObject, Sendable {
    
    // MARK: - Configuration
    
    /// Strategy for coordinating between cache and data sources
    public enum CacheStrategy: Sendable {
        /// Check cache first, fallback to source if miss
        case cacheFirst
        /// Always fetch from source, update cache with result
        case sourceFirst
        /// Return cache immediately, fetch from source in background
        case cacheWithBackgroundRefresh
        /// Cache only, never hit the source
        case cacheOnly
        /// Source only, never use cache
        case sourceOnly
    }
    
    /// Configuration for retry behavior
    public struct RetryConfiguration: Sendable {
        public let maxAttempts: Int
        public let baseDelay: TimeInterval
        public let maxDelay: TimeInterval
        public let backoffMultiplier: Double
        
        public init(
            maxAttempts: Int = 3,
            baseDelay: TimeInterval = 1.0,
            maxDelay: TimeInterval = 30.0,
            backoffMultiplier: Double = 2.0
        ) {
            self.maxAttempts = maxAttempts
            self.baseDelay = baseDelay
            self.maxDelay = maxDelay
            self.backoffMultiplier = backoffMultiplier
        }
        
    }
    
    // MARK: - Dependencies
    
    private let primarySource: any DataSource where any DataSource.DataType == DataType
    private let fallbackSource: (any DataSource<DataType>)?
    private let cache: (any DataCache<DataType>)?
    private let strategy: CacheStrategy
    private let retryConfig: RetryConfiguration
    
    // MARK: - State
    
    private var observationTasks: [DataType.ID: Task<Void, Never>] = [:]
    private let changeSubject = AsyncStream<RepositoryChange<DataType>>.makeStream()
    
    // MARK: - Initialization
    
    public init(
        primarySource: any DataSource<DataType>,
        fallbackSource: (any DataSource<DataType>)? = nil,
        cache: (any DataCache<DataType>)? = nil,
        strategy: CacheStrategy = .cacheFirst,
        retryConfig: RetryConfiguration = .default
    ) {
        self.primarySource = primarySource
        self.fallbackSource = fallbackSource
        self.cache = cache
        self.strategy = strategy
        self.retryConfig = retryConfig
    }
    
    // MARK: - Core Operations
    
    /// Retrieves an item by ID using the configured cache strategy
    /// - Parameter id: The unique identifier for the item
    /// - Returns: The requested item
    /// - Throws: RepositoryError if the item cannot be retrieved
    public func get(id: DataType.ID) async throws -> DataType {
        switch strategy {
        case .cacheFirst:
            return try await getCacheFirst(id: id)
        case .sourceFirst:
            return try await getSourceFirst(id: id)
        case .cacheWithBackgroundRefresh:
            return try await getCacheWithBackgroundRefresh(id: id)
        case .cacheOnly:
            return try await getCacheOnly(id: id)
        case .sourceOnly:
            return try await getSourceOnly(id: id)
        }
    }
    
    /// Retrieves all items using the configured cache strategy
    /// - Returns: Array of all items
    /// - Throws: RepositoryError if items cannot be retrieved
    public func getAll() async throws -> [DataType] {
        switch strategy {
        case .cacheFirst, .cacheWithBackgroundRefresh:
            if let cached = await cache?.getAll(), !cached.isEmpty {
                if strategy == .cacheWithBackgroundRefresh {
                    Task { [weak self] in
                        await self?.refreshAllInBackground()
                    }
                }
                return cached
            }
            fallthrough
        case .sourceFirst, .sourceOnly:
            return try await getAllFromSource()
        case .cacheOnly:
            return await cache?.getAll() ?? []
        }
    }
    
    /// Creates a new item
    /// - Parameter item: The item to create
    /// - Returns: The created item (may include server-generated fields)
    /// - Throws: RepositoryError if the item cannot be created
    public func create(_ item: DataType) async throws -> DataType {
        let created = try await withRetry {
            try await self.primarySource.create(item)
        }
        
        await cache?.set(created)
        await notifyChange(.created(created))
        
        return created
    }
    
    /// Updates an existing item
    /// - Parameter item: The item to update
    /// - Returns: The updated item
    /// - Throws: RepositoryError if the item cannot be updated
    public func update(_ item: DataType) async throws -> DataType {
        let updated = try await withRetry {
            try await self.primarySource.update(item)
        }
        
        await cache?.set(updated)
        await notifyChange(.updated(updated))
        
        return updated
    }
    
    /// Deletes an item
    /// - Parameter id: The identifier of the item to delete
    /// - Throws: RepositoryError if the item cannot be deleted
    public func delete(id: DataType.ID) async throws {
        try await withRetry {
            try await self.primarySource.delete(id: id)
        }
        
        await cache?.remove(id: id)
        await notifyChange(.deleted(id))
    }
    
    // MARK: - Observation
    
    /// Observes changes to a specific item
    /// - Parameter id: The identifier of the item to observe
    /// - Returns: AsyncSequence of updated items
    public func observe(id: DataType.ID) -> AsyncStream<DataType> {
        let (stream, continuation) = AsyncStream<DataType>.makeStream()
        
        let task = Task { [weak self] in
            guard let self = self else { return }
            
            // Start with current value if available
            if let current = try? await self.get(id: id) {
                continuation.yield(current)
            }
            
            // Subscribe to changes
            for await change in self.changeSubject.stream {
                switch change {
                case .created(let item), .updated(let item):
                    if item.id == id {
                        continuation.yield(item)
                    }
                case .deleted(let deletedId):
                    if deletedId == id {
                        continuation.finish()
                        return
                    }
                }
            }
        }
        
        observationTasks[id] = task
        
        continuation.onTermination = { [weak self] _ in
            self?.observationTasks.removeValue(forKey: id)?.cancel()
        }
        
        return stream
    }
    
    /// Observes all repository changes
    /// - Returns: AsyncSequence of change events
    public func observeAll() -> AsyncStream<RepositoryChange<DataType>> {
        return changeSubject.stream
    }
    
    // MARK: - Cache Management
    
    /// Invalidates cached data for a specific item
    /// - Parameter id: The identifier of the item to invalidate
    public func invalidate(id: DataType.ID) async {
        await cache?.remove(id: id)
    }
    
    /// Invalidates all cached data
    public func invalidateAll() async {
        await cache?.clear()
    }
    
    /// Forces a refresh of a specific item from the primary source
    /// - Parameter id: The identifier of the item to refresh
    /// - Returns: The refreshed item
    /// - Throws: RepositoryError if the item cannot be refreshed
    public func refresh(id: DataType.ID) async throws -> DataType {
        let item = try await withRetry {
            try await self.primarySource.fetch(id: id)
        }
        
        await cache?.set(item)
        await notifyChange(.updated(item))
        
        return item
    }
    
    /// Forces a refresh of all items from the primary source
    /// - Returns: Array of refreshed items
    /// - Throws: RepositoryError if items cannot be refreshed
    public func refreshAll() async throws -> [DataType] {
        let items = try await withRetry {
            try await self.primarySource.fetchAll()
        }
        
        await cache?.setAll(items)
        
        for item in items {
            await notifyChange(.updated(item))
        }
        
        return items
    }
}

// MARK: - Private Implementation

extension Repository {
    
    private func getCacheFirst(id: DataType.ID) async throws -> DataType {
        if let cached = await cache?.get(id: id) {
            return cached
        }
        
        return try await getSourceOnly(id: id)
    }
    
    private func getSourceFirst(id: DataType.ID) async throws -> DataType {
        do {
            let item = try await withRetry {
                try await self.primarySource.fetch(id: id)
            }
            await cache?.set(item)
            return item
        } catch {
            if let cached = await cache?.get(id: id) {
                return cached
            }
            throw error
        }
    }
    
    private func getCacheWithBackgroundRefresh(id: DataType.ID) async throws -> DataType {
        if let cached = await cache?.get(id: id) {
            // Start background refresh
            Task { [weak self] in
                try? await self?.refresh(id: id)
            }
            return cached
        }
        
        return try await getSourceOnly(id: id)
    }
    
    private func getCacheOnly(id: DataType.ID) async throws -> DataType {
        guard let cached = await cache?.get(id: id) else {
            throw RepositoryError.itemNotFound(String(describing: id))
        }
        return cached
    }
    
    private func getSourceOnly(id: DataType.ID) async throws -> DataType {
        let item = try await withRetry {
            try await self.primarySource.fetch(id: id)
        }
        await cache?.set(item)
        return item
    }
    
    private func getAllFromSource() async throws -> [DataType] {
        let items = try await withRetry {
            try await self.primarySource.fetchAll()
        }
        await cache?.setAll(items)
        return items
    }
    
    private func refreshAllInBackground() async {
        do {
            _ = try await getAllFromSource()
        } catch {
            // Silent failure for background refresh
        }
    }
    
    private func withRetry<T>(
        operation: @escaping () async throws -> T
    ) async throws -> T {
        var lastError: Error?
        var delay = retryConfig.baseDelay
        
        for attempt in 1...retryConfig.maxAttempts {
            do {
                return try await operation()
            } catch {
                lastError = error
                
                // Don't retry on certain errors
                if case DataSourceError.authenticationRequired = error {
                    throw error
                }
                
                if attempt < retryConfig.maxAttempts {
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    delay = min(delay * retryConfig.backoffMultiplier, retryConfig.maxDelay)
                }
            }
        }
        
        throw lastError ?? RepositoryError.unknown("All retry attempts failed")
    }
    
    private func notifyChange(_ change: RepositoryChange<DataType>) async {
        changeSubject.continuation.yield(change)
    }
}

// MARK: - Supporting Types

/// Represents a change event in a repository
public enum RepositoryChange<DataType: Identifiable & Sendable>: Sendable {
    case created(DataType)
    case updated(DataType)
    case deleted(DataType.ID)
}

/// Errors that can occur when working with repositories
public enum RepositoryError: Error, Sendable {
    case itemNotFound(String)
    case dataSourceError(DataSourceError)
    case cacheError(String)
    case concurrencyError(String)
    case unknown(String)
}

extension RepositoryError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .itemNotFound(let id):
            return "Item with ID '\(id)' was not found"
        case .dataSourceError(let error):
            return "Data source error: \(error.localizedDescription)"
        case .cacheError(let message):
            return "Cache error: \(message)"
        case .concurrencyError(let message):
            return "Concurrency error: \(message)"
        case .unknown(let message):
            return "Unknown repository error: \(message)"
        }
    }
}

// MARK: - AsyncStream Extensions

extension AsyncStream {
    static func makeStream() -> (stream: AsyncStream<Element>, continuation: AsyncStream<Element>.Continuation) {
        var continuation: AsyncStream<Element>.Continuation!
        let stream = AsyncStream<Element> { cont in
            continuation = cont
        }
        return (stream, continuation)
    }
}