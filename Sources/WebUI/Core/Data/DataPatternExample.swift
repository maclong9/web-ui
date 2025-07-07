import Foundation

/// Example demonstrating how to use the WebUI data patterns together
///
/// This file shows practical usage of the data layer components:
/// - DataSource implementations
/// - Repository with caching
/// - SyncEngine for multi-source coordination
/// - Integration with state management
///
/// ## Complete Data Flow Example
///
/// ```swift
/// // 1. Set up data sources
/// let apiDataSource = HTTPDataSource<User>(
///     baseURL: URL(string: "https://api.example.com/users")!,
///     authProvider: HTTPDataSource.BearerTokenAuth(token: "your-token")
/// )
///
/// let localCache = InMemoryCache<User>(
///     maxSize: 1000,
///     defaultTTL: .minutes(30)
/// )
///
/// // 2. Create repository
/// let userRepository = Repository(
///     primarySource: apiDataSource,
///     cache: localCache,
///     strategy: .cacheFirst
/// )
///
/// // 3. Set up sync engine
/// let syncEngine = SyncEngine(
///     localRepository: userRepository,
///     remoteRepository: Repository(primarySource: apiDataSource)
/// )
///
/// // 4. Use in your application
/// let users = try await userRepository.getAll()
/// await syncEngine.start()
/// ```

// MARK: - Example Data Models

/// Example user model demonstrating a typical data entity
public struct User: Codable, Sendable, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let email: String
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(id: String, name: String, email: String, createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.name = name
        self.email = email
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

/// Example post model with relationships
public struct Post: Codable, Sendable, Identifiable, Equatable {
    public let id: String
    public let title: String
    public let content: String
    public let authorId: String
    public let createdAt: Date
    public let updatedAt: Date
    public let tags: [String]
    
    public init(
        id: String,
        title: String,
        content: String,
        authorId: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        tags: [String] = []
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.authorId = authorId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tags = tags
    }
}

// MARK: - Example Data Service

/// High-level data service that coordinates multiple repositories
@MainActor
public final class DataService: ObservableObject {
    
    // MARK: - Repositories
    
    public let userRepository: Repository<User>
    public let postRepository: Repository<Post>
    
    // MARK: - Sync Engines
    
    public let userSyncEngine: SyncEngine<User>
    public let postSyncEngine: SyncEngine<Post>
    
    // MARK: - Configuration
    
    public struct Configuration {
        public let apiBaseURL: URL
        public let authToken: String
        public let cacheConfiguration: CacheConfiguration
        public let syncConfiguration: SyncEngine<User>.SyncConfiguration
        
        public init(
            apiBaseURL: URL,
            authToken: String,
            cacheConfiguration: CacheConfiguration = .default,
            syncConfiguration: SyncEngine<User>.SyncConfiguration = SyncEngine.SyncConfiguration()
        ) {
            self.apiBaseURL = apiBaseURL
            self.authToken = authToken
            self.cacheConfiguration = cacheConfiguration
            self.syncConfiguration = syncConfiguration
        }
    }
    
    public struct CacheConfiguration: Sendable {
        public let userCacheSize: Int
        public let postCacheSize: Int
        public let defaultTTL: CacheTTL
        
        public init(userCacheSize: Int = 1000, postCacheSize: Int = 2000, defaultTTL: CacheTTL = .minutes(30)) {
            self.userCacheSize = userCacheSize
            self.postCacheSize = postCacheSize
            self.defaultTTL = defaultTTL
        }
        
        public static let `default` = CacheConfiguration()
    }
    
    // MARK: - Initialization
    
    public init(configuration: Configuration) {
        // Set up authentication
        let authProvider = HTTPDataSource<User>.BearerTokenAuth(token: configuration.authToken)
        
        // Set up data sources
        let userAPISource = HTTPDataSource<User>(
            baseURL: configuration.apiBaseURL.appendingPathComponent("users"),
            authProvider: authProvider
        )
        
        let postAPISource = HTTPDataSource<Post>(
            baseURL: configuration.apiBaseURL.appendingPathComponent("posts"),
            authProvider: authProvider
        )
        
        // Set up caches
        let userCache = InMemoryCache<User>(
            maxSize: configuration.cacheConfiguration.userCacheSize,
            defaultTTL: configuration.cacheConfiguration.defaultTTL
        )
        
        let postCache = InMemoryCache<Post>(
            maxSize: configuration.cacheConfiguration.postCacheSize,
            defaultTTL: configuration.cacheConfiguration.defaultTTL
        )
        
        // Set up repositories
        self.userRepository = Repository(
            primarySource: userAPISource,
            cache: userCache,
            strategy: .cacheFirst
        )
        
        self.postRepository = Repository(
            primarySource: postAPISource,
            cache: postCache,
            strategy: .cacheFirst
        )
        
        // Set up sync engines
        let userRemoteRepository = Repository(primarySource: userAPISource)
        let postRemoteRepository = Repository(primarySource: postAPISource)
        
        self.userSyncEngine = SyncEngine(
            localRepository: userRepository,
            remoteRepository: userRemoteRepository,
            configuration: configuration.syncConfiguration
        )
        
        self.postSyncEngine = SyncEngine(
            localRepository: postRepository,
            remoteRepository: postRemoteRepository,
            configuration: configuration.syncConfiguration
        )
    }
    
    // MARK: - Lifecycle
    
    /// Starts all sync engines
    public func start() async {
        await userSyncEngine.start()
        await postSyncEngine.start()
    }
    
    /// Stops all sync engines
    public func stop() async {
        await userSyncEngine.stop()
        await postSyncEngine.stop()
    }
    
    // MARK: - High-Level Operations
    
    /// Fetches a user with their posts
    public func getUserWithPosts(userId: String) async throws -> (user: User, posts: [Post]) {
        // Fetch user and posts concurrently
        async let user = userRepository.get(id: userId)
        async let allPosts = postRepository.getAll()
        
        let fetchedUser = try await user
        let userPosts = try await allPosts.filter { $0.authorId == userId }
        
        return (fetchedUser, userPosts)
    }
    
    /// Creates a new post and updates caches
    public func createPost(
        title: String,
        content: String,
        authorId: String,
        tags: [String] = []
    ) async throws -> Post {
        let post = Post(
            id: UUID().uuidString,
            title: title,
            content: content,
            authorId: authorId,
            tags: tags
        )
        
        // Create through repository (handles caching)
        let createdPost = try await postRepository.create(post)
        
        // Queue for sync
        await postSyncEngine.queueCreate(createdPost, priority: .high)
        
        return createdPost
    }
    
    /// Performs full synchronization of all data
    public func syncAll() async -> [SyncResult] {
        async let userSyncResult = userSyncEngine.sync()
        async let postSyncResult = postSyncEngine.sync()
        
        return await [userSyncResult, postSyncResult]
    }
}

// MARK: - State Integration Example

/// Simple error wrapper that conforms to Codable
public struct ViewModelError: Error, Codable, Sendable {
    public let message: String
    
    public init(_ message: String) {
        self.message = message
    }
    
    public init(_ error: Error) {
        self.message = error.localizedDescription
    }
}

/// Example showing integration with WebUI state management
@MainActor
public final class UserListViewModel: ObservableObject {
    
    @Published public private(set) var users: [User] = []
    @Published public private(set) var isLoading = false
    @Published public private(set) var error: ViewModelError?
    
    private let dataService: DataService
    private var observationTask: Task<Void, Never>?
    
    public init(dataService: DataService) {
        self.dataService = dataService
    }
    
    public func loadUsers() async {
        isLoading = true
        error = nil
        
        do {
            users = try await dataService.userRepository.getAll()
            
            // Start observing changes
            startObserving()
            
        } catch {
            self.error = ViewModelError(error)
        }
        
        isLoading = false
    }
    
    public func createUser(name: String, email: String) async {
        do {
            let user = User(
                id: UUID().uuidString,
                name: name,
                email: email
            )
            
            let createdUser = try await dataService.userRepository.create(user)
            await dataService.userSyncEngine.queueCreate(createdUser, priority: .high)
            
        } catch {
            self.error = ViewModelError(error)
        }
    }
    
    public func deleteUser(id: String) async {
        do {
            try await dataService.userRepository.delete(id: id)
            await dataService.userSyncEngine.queueDelete(id: id, priority: .high)
            
        } catch {
            self.error = ViewModelError(error)
        }
    }
    
    private func startObserving() {
        observationTask?.cancel()
        
        observationTask = Task { [weak self] in
            for await change in await self?.dataService.userRepository.observeAll() ?? AsyncStream<RepositoryChange<User>>.never {
                await MainActor.run {
                    switch change {
                    case .created(let user):
                        self?.users.append(user)
                    case .updated(let user):
                        if let index = self?.users.firstIndex(where: { $0.id == user.id }) {
                            self?.users[index] = user
                        }
                    case .deleted(let id):
                        self?.users.removeAll { $0.id == id }
                    }
                }
            }
        }
    }
    
    deinit {
        observationTask?.cancel()
    }
}

// MARK: - AsyncStream Extensions

extension AsyncStream {
    static var never: AsyncStream<Element> {
        AsyncStream { _ in }
    }
}