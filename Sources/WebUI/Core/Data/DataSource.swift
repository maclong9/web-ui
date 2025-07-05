import Foundation

/// Core protocol for data sources in the WebUI data layer
///
/// `DataSource` provides a unified interface for different data providers,
/// whether they're REST APIs, GraphQL endpoints, local files, or in-memory stores.
/// This abstraction enables consistent data access patterns throughout the application.
///
/// ## Usage
///
/// ```swift
/// struct UserAPIDataSource: DataSource {
///     typealias DataType = User
///     
///     func fetch(id: String) async throws -> User {
///         // API implementation
///     }
///     
///     func fetchAll() async throws -> [User] {
///         // Fetch all users
///     }
/// }
/// ```
public protocol DataSource: Sendable {
    associatedtype DataType: Codable & Sendable & Identifiable where DataType.ID: Sendable
    
    /// Fetches a single item by its identifier
    /// - Parameter id: The unique identifier for the item
    /// - Returns: The requested item
    /// - Throws: DataSourceError if the item cannot be fetched
    func fetch(id: DataType.ID) async throws -> DataType
    
    /// Fetches all items from the data source
    /// - Returns: Array of all items
    /// - Throws: DataSourceError if items cannot be fetched
    func fetchAll() async throws -> [DataType]
    
    /// Creates a new item in the data source
    /// - Parameter item: The item to create
    /// - Returns: The created item (may include server-generated fields)
    /// - Throws: DataSourceError if the item cannot be created
    func create(_ item: DataType) async throws -> DataType
    
    /// Updates an existing item in the data source
    /// - Parameter item: The item to update
    /// - Returns: The updated item
    /// - Throws: DataSourceError if the item cannot be updated
    func update(_ item: DataType) async throws -> DataType
    
    /// Deletes an item from the data source
    /// - Parameter id: The identifier of the item to delete
    /// - Throws: DataSourceError if the item cannot be deleted
    func delete(id: DataType.ID) async throws
}

// MARK: - Default Implementations

extension DataSource {
    /// Default implementation for data sources that don't support creation
    public func create(_ item: DataType) async throws -> DataType {
        throw DataSourceError.operationNotSupported(.create)
    }
    
    /// Default implementation for data sources that don't support updates
    public func update(_ item: DataType) async throws -> DataType {
        throw DataSourceError.operationNotSupported(.update)
    }
    
    /// Default implementation for data sources that don't support deletion
    public func delete(id: DataType.ID) async throws {
        throw DataSourceError.operationNotSupported(.delete)
    }
}

// MARK: - Batch Operations

extension DataSource {
    /// Fetches multiple items by their identifiers
    /// - Parameter ids: Array of identifiers to fetch
    /// - Returns: Dictionary mapping IDs to items (missing items are omitted)
    public func fetchBatch(ids: [DataType.ID]) async throws -> [DataType.ID: DataType] {
        var results: [DataType.ID: DataType] = [:]
        
        await withThrowingTaskGroup(of: (DataType.ID, DataType?).self) { group in
            for id in ids {
                group.addTask {
                    do {
                        let item = try await self.fetch(id: id)
                        return (id, item)
                    } catch {
                        return (id, nil)
                    }
                }
            }
            
            for await (id, item) in group {
                if let item = item {
                    results[id] = item
                }
            }
        }
        
        return results
    }
    
    /// Creates multiple items in the data source
    /// - Parameter items: Array of items to create
    /// - Returns: Array of created items
    /// - Throws: DataSourceError if any item cannot be created
    public func createBatch(_ items: [DataType]) async throws -> [DataType] {
        var results: [DataType] = []
        
        for item in items {
            let created = try await create(item)
            results.append(created)
        }
        
        return results
    }
}

// MARK: - Query Support

/// Protocol for data sources that support querying
public protocol QueryableDataSource: DataSource {
    /// Query parameters for filtering and sorting
    associatedtype QueryType: Sendable
    
    /// Fetches items based on query parameters
    /// - Parameter query: The query parameters
    /// - Returns: Array of items matching the query
    /// - Throws: DataSourceError if the query cannot be executed
    func fetch(query: QueryType) async throws -> [DataType]
}

// MARK: - Subscription Support

/// Protocol for data sources that support real-time updates
public protocol ObservableDataSource: DataSource {
    /// Observes changes to a specific item
    /// - Parameter id: The identifier of the item to observe
    /// - Returns: AsyncSequence of updated items
    func observe(id: DataType.ID) -> AsyncStream<DataType>
    
    /// Observes changes to all items
    /// - Returns: AsyncSequence of change events
    func observeAll() -> AsyncStream<DataSourceChange<DataType>>
}

/// Represents a change event in an observable data source
public enum DataSourceChange<DataType: Identifiable & Sendable>: Sendable {
    case created(DataType)
    case updated(DataType)
    case deleted(DataType.ID)
}

// MARK: - Error Handling

/// Errors that can occur when working with data sources
public enum DataSourceError: Error, Sendable {
    case itemNotFound(String)
    case networkError(String)
    case authenticationRequired
    case operationNotSupported(DataSourceOperation)
    case invalidData(String)
    case timeout
    case rateLimited
    case serverError(Int, String)
    case unknown(String)
}

/// Operations that a data source may or may not support
public enum DataSourceOperation: String, Sendable {
    case create
    case update
    case delete
    case query
    case observe
}

extension DataSourceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .itemNotFound(let id):
            return "Item with ID '\(id)' was not found"
        case .networkError(let message):
            return "Network error: \(message)"
        case .authenticationRequired:
            return "Authentication is required to access this resource"
        case .operationNotSupported(let operation):
            return "Operation '\(operation.rawValue)' is not supported by this data source"
        case .invalidData(let message):
            return "Invalid data: \(message)"
        case .timeout:
            return "Request timed out"
        case .rateLimited:
            return "Rate limit exceeded. Please try again later"
        case .serverError(let code, let message):
            return "Server error (\(code)): \(message)"
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }
}