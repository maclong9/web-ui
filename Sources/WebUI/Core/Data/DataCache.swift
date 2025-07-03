import Foundation

/// Protocol for data caching implementations
///
/// `DataCache` provides a unified interface for different caching strategies,
/// from simple in-memory caches to persistent storage solutions. It supports
/// TTL (Time To Live) expiration, size limits, and batch operations.
///
/// ## Usage
///
/// ```swift
/// let cache = InMemoryCache<User>(
///     maxSize: 1000,
///     defaultTTL: .minutes(30)
/// )
///
/// await cache.set(user)
/// let cachedUser = await cache.get(id: user.id)
/// ```
public protocol DataCache<DataType>: Sendable {
    associatedtype DataType: Codable & Sendable & Identifiable where DataType.ID: Sendable
    
    /// Retrieves an item from the cache
    /// - Parameter id: The unique identifier for the item
    /// - Returns: The cached item if found and not expired, nil otherwise
    func get(id: DataType.ID) async -> DataType?
    
    /// Stores an item in the cache
    /// - Parameter item: The item to cache
    /// - Parameter ttl: Time to live override (optional)
    func set(_ item: DataType, ttl: CacheTTL?) async
    
    /// Removes an item from the cache
    /// - Parameter id: The identifier of the item to remove
    func remove(id: DataType.ID) async
    
    /// Retrieves all items from the cache
    /// - Returns: Array of all non-expired cached items
    func getAll() async -> [DataType]
    
    /// Stores multiple items in the cache
    /// - Parameter items: The items to cache
    /// - Parameter ttl: Time to live override (optional)
    func setAll(_ items: [DataType], ttl: CacheTTL?) async
    
    /// Clears all items from the cache
    func clear() async
    
    /// Returns the current size of the cache
    var size: Int { get async }
    
    /// Returns cache statistics
    var stats: CacheStats { get async }
}

// MARK: - Cache TTL

/// Time-to-live configuration for cache entries
public enum CacheTTL: Sendable {
    case never
    case seconds(TimeInterval)
    case minutes(TimeInterval)
    case hours(TimeInterval)
    case days(TimeInterval)
    case custom(TimeInterval)
    
    var timeInterval: TimeInterval? {
        switch self {
        case .never:
            return nil
        case .seconds(let value):
            return value
        case .minutes(let value):
            return value * 60
        case .hours(let value):
            return value * 3600
        case .days(let value):
            return value * 86400
        case .custom(let value):
            return value
        }
    }
}

// MARK: - Cache Statistics

/// Statistics about cache performance and usage
public struct CacheStats: Sendable {
    public let hits: Int
    public let misses: Int
    public let evictions: Int
    public let size: Int
    public let maxSize: Int?
    
    public var hitRate: Double {
        let total = hits + misses
        return total > 0 ? Double(hits) / Double(total) : 0.0
    }
    
    public init(hits: Int = 0, misses: Int = 0, evictions: Int = 0, size: Int = 0, maxSize: Int? = nil) {
        self.hits = hits
        self.misses = misses
        self.evictions = evictions
        self.size = size
        self.maxSize = maxSize
    }
}

// MARK: - In-Memory Cache Implementation

/// Thread-safe in-memory cache with LRU eviction and TTL support
public actor InMemoryCache<DataType: Codable & Sendable & Identifiable>: DataCache {
    
    // MARK: - Cache Entry
    
    private struct CacheEntry: Sendable {
        let item: DataType
        let createdAt: Date
        let expiresAt: Date?
        var lastAccessed: Date
        
        init(item: DataType, ttl: CacheTTL?) {
            self.item = item
            self.createdAt = Date()
            self.lastAccessed = createdAt
            
            if let ttl = ttl, let interval = ttl.timeInterval {
                self.expiresAt = createdAt.addingTimeInterval(interval)
            } else {
                self.expiresAt = nil
            }
        }
        
        var isExpired: Bool {
            guard let expiresAt = expiresAt else { return false }
            return Date() > expiresAt
        }
        
        mutating func updateAccess() {
            lastAccessed = Date()
        }
    }
    
    // MARK: - Configuration
    
    private let maxSize: Int?
    private let defaultTTL: CacheTTL?
    
    // MARK: - State
    
    private var entries: [DataType.ID: CacheEntry] = [:]
    private var accessOrder: [DataType.ID] = []
    private var _stats = CacheStats()
    
    // MARK: - Initialization
    
    public init(maxSize: Int? = nil, defaultTTL: CacheTTL? = nil) {
        self.maxSize = maxSize
        self.defaultTTL = defaultTTL
    }
    
    // MARK: - DataCache Implementation
    
    public func get(id: DataType.ID) async -> DataType? {
        guard var entry = entries[id] else {
            _stats = CacheStats(
                hits: _stats.hits,
                misses: _stats.misses + 1,
                evictions: _stats.evictions,
                size: _stats.size,
                maxSize: maxSize
            )
            return nil
        }
        
        if entry.isExpired {
            await remove(id: id)
            _stats = CacheStats(
                hits: _stats.hits,
                misses: _stats.misses + 1,
                evictions: _stats.evictions,
                size: _stats.size,
                maxSize: maxSize
            )
            return nil
        }
        
        // Update access time and move to end (most recently used)
        entry.updateAccess()
        entries[id] = entry
        updateAccessOrder(id: id)
        
        _stats = CacheStats(
            hits: _stats.hits + 1,
            misses: _stats.misses,
            evictions: _stats.evictions,
            size: _stats.size,
            maxSize: maxSize
        )
        
        return entry.item
    }
    
    public func set(_ item: DataType, ttl: CacheTTL? = nil) async {
        let finalTTL = ttl ?? defaultTTL
        let entry = CacheEntry(item: item, ttl: finalTTL)
        
        let wasNewEntry = entries[item.id] == nil
        entries[item.id] = entry
        updateAccessOrder(id: item.id)
        
        if wasNewEntry {
            _stats = CacheStats(
                hits: stats.hits,
                misses: stats.misses,
                evictions: stats.evictions,
                size: entries.count,
                maxSize: maxSize
            )
        }
        
        await evictIfNeeded()
    }
    
    public func remove(id: DataType.ID) async {
        entries.removeValue(forKey: id)
        accessOrder.removeAll { $0 == id }
        
        _stats = CacheStats(
            hits: _stats.hits,
            misses: _stats.misses,
            evictions: _stats.evictions,
            size: entries.count,
            maxSize: maxSize
        )
    }
    
    public func getAll() async -> [DataType] {
        _ = Date()
        var result: [DataType] = []
        var expiredIds: [DataType.ID] = []
        
        for (id, entry) in entries {
            if entry.isExpired {
                expiredIds.append(id)
            } else {
                result.append(entry.item)
            }
        }
        
        // Clean up expired entries
        for id in expiredIds {
            await remove(id: id)
        }
        
        return result
    }
    
    public func setAll(_ items: [DataType], ttl: CacheTTL? = nil) async {
        let finalTTL = ttl ?? defaultTTL
        
        for item in items {
            let entry = CacheEntry(item: item, ttl: finalTTL)
            entries[item.id] = entry
            updateAccessOrder(id: item.id)
        }
        
        _stats = CacheStats(
            hits: _stats.hits,
            misses: _stats.misses,
            evictions: _stats.evictions,
            size: entries.count,
            maxSize: maxSize
        )
        
        await evictIfNeeded()
    }
    
    public func clear() async {
        entries.removeAll()
        accessOrder.removeAll()
        
        stats = CacheStats(
            hits: stats.hits,
            misses: stats.misses,
            evictions: stats.evictions,
            size: 0,
            maxSize: maxSize
        )
    }
    
    public var size: Int {
        entries.count
    }
    
    public var stats: CacheStats {
        CacheStats(
            hits: self._stats.hits,
            misses: self._stats.misses,
            evictions: self._stats.evictions,
            size: entries.count,
            maxSize: maxSize
        )
    }
    
    // MARK: - Private Methods
    
    private func updateAccessOrder(id: DataType.ID) {
        // Remove from current position
        accessOrder.removeAll { $0 == id }
        // Add to end (most recently used)
        accessOrder.append(id)
    }
    
    private func evictIfNeeded() async {
        guard let maxSize = maxSize, entries.count > maxSize else { return }
        
        let evictCount = entries.count - maxSize
        let idsToEvict = Array(accessOrder.prefix(evictCount))
        
        for id in idsToEvict {
            entries.removeValue(forKey: id)
        }
        
        accessOrder.removeFirst(evictCount)
        
        _stats = CacheStats(
            hits: _stats.hits,
            misses: _stats.misses,
            evictions: _stats.evictions + evictCount,
            size: entries.count,
            maxSize: maxSize
        )
    }
}

// MARK: - No-Op Cache Implementation

/// A cache implementation that doesn't cache anything (useful for testing or disabling cache)
public struct NoOpCache<DataType: Codable & Sendable & Identifiable>: DataCache {
    
    public init() {}
    
    public func get(id: DataType.ID) async -> DataType? {
        return nil
    }
    
    public func set(_ item: DataType, ttl: CacheTTL? = nil) async {
        // No-op
    }
    
    public func remove(id: DataType.ID) async {
        // No-op
    }
    
    public func getAll() async -> [DataType] {
        return []
    }
    
    public func setAll(_ items: [DataType], ttl: CacheTTL? = nil) async {
        // No-op
    }
    
    public func clear() async {
        // No-op
    }
    
    public var size: Int {
        return 0
    }
    
    public var stats: CacheStats {
        return CacheStats()
    }
}

// MARK: - Default Implementations

extension DataCache {
    public func setAll(_ items: [DataType], ttl: CacheTTL?) async {
        for item in items {
            await set(item, ttl: ttl)
        }
    }
}