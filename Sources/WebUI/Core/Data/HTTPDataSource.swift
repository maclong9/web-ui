import Foundation

/// HTTP-based data source implementation for RESTful APIs
///
/// `HTTPDataSource` provides a robust implementation of the DataSource protocol
/// for HTTP/REST APIs. It includes request/response mapping, authentication,
/// error handling, and request customization.
///
/// ## Features
///
/// - **RESTful conventions**: Automatic URL construction following REST patterns
/// - **Authentication**: Flexible authentication mechanism support
/// - **Request customization**: Headers, parameters, body transformation
/// - **Response mapping**: JSON decoding with error handling
/// - **Network resilience**: Timeout, retry, and error recovery
///
/// ## Usage
///
/// ```swift
/// struct User: Codable, Identifiable {
///     let id: String
///     let name: String
///     let email: String
/// }
///
/// let userDataSource = HTTPDataSource<User>(
///     baseURL: URL(string: "https://api.example.com/users")!,
///     session: URLSession.shared
/// )
///
/// let user = try await userDataSource.fetch(id: "123")
/// ```
public struct HTTPDataSource<DataType: Codable & Sendable & Identifiable>: DataSource {
    
    // MARK: - Configuration
    
    /// Configuration for HTTP requests
    public struct Configuration: Sendable {
        public let timeout: TimeInterval
        public let retryCount: Int
        public let retryDelay: TimeInterval
        public let allowsCellularAccess: Bool
        
        public init(
            timeout: TimeInterval = 30.0,
            retryCount: Int = 3,
            retryDelay: TimeInterval = 1.0,
            allowsCellularAccess: Bool = true
        ) {
            self.timeout = timeout
            self.retryCount = retryCount
            self.retryDelay = retryDelay
            self.allowsCellularAccess = allowsCellularAccess
        }
        
        public static let `default` = Configuration()
    }
    
    /// Authentication provider protocol
    public protocol AuthenticationProvider: Sendable {
        func authenticate(_ request: inout URLRequest) async throws
    }
    
    /// Request interceptor for customizing requests
    public protocol RequestInterceptor: Sendable {
        func intercept(_ request: inout URLRequest) async throws
    }
    
    /// Response interceptor for processing responses
    public protocol ResponseInterceptor: Sendable {
        func intercept(_ response: URLResponse, data: Data) async throws -> Data
    }
    
    // MARK: - Dependencies
    
    private let baseURL: URL
    private let session: URLSession
    private let configuration: Configuration
    private let authProvider: (any AuthenticationProvider)?
    private let requestInterceptors: [any RequestInterceptor]
    private let responseInterceptors: [any ResponseInterceptor]
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder
    
    // MARK: - Initialization
    
    public init(
        baseURL: URL,
        session: URLSession = .shared,
        configuration: Configuration = .default,
        authProvider: (any AuthenticationProvider)? = nil,
        requestInterceptors: [any RequestInterceptor] = [],
        responseInterceptors: [any ResponseInterceptor] = [],
        jsonDecoder: JSONDecoder = JSONDecoder(),
        jsonEncoder: JSONEncoder = JSONEncoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.configuration = configuration
        self.authProvider = authProvider
        self.requestInterceptors = requestInterceptors
        self.responseInterceptors = responseInterceptors
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder
        
        // Configure JSON decoder for common date formats
        // Configure JSON decoder
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        // Configure JSON encoder for consistent output
        jsonEncoder.dateEncodingStrategy = .iso8601
    }
    
    // MARK: - DataSource Implementation
    
    public func fetch(id: DataType.ID) async throws -> DataType {
        let url = baseURL.appendingPathComponent(String(describing: id))
        let request = try await buildRequest(url: url, method: .GET)
        
        return try await performRequest(request)
    }
    
    public func fetchAll() async throws -> [DataType] {
        let request = try await buildRequest(url: baseURL, method: .GET)
        
        return try await performRequest(request)
    }
    
    public func create(_ item: DataType) async throws -> DataType {
        let request = try await buildRequest(
            url: baseURL,
            method: .POST,
            body: try jsonEncoder.encode(item)
        )
        
        return try await performRequest(request)
    }
    
    public func update(_ item: DataType) async throws -> DataType {
        let url = baseURL.appendingPathComponent(String(describing: item.id))
        let request = try await buildRequest(
            url: url,
            method: .PUT,
            body: try jsonEncoder.encode(item)
        )
        
        return try await performRequest(request)
    }
    
    public func delete(id: DataType.ID) async throws {
        let url = baseURL.appendingPathComponent(String(describing: id))
        let request = try await buildRequest(url: url, method: .DELETE)
        
        let _: EmptyResponse = try await performRequest(request)
    }
    
    // MARK: - Private Implementation
    
    private func buildRequest(
        url: URL,
        method: HTTPMethod,
        body: Data? = nil,
        headers: [String: String] = [:]
    ) async throws -> URLRequest {
        var request = URLRequest(
            url: url,
            timeoutInterval: configuration.timeout
        )
        
        request.httpMethod = method.rawValue
        request.allowsCellularAccess = configuration.allowsCellularAccess
        
        // Set content type for requests with body
        if body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // Set accept header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add custom headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Set body
        request.httpBody = body
        
        // Apply authentication
        if let authProvider = authProvider {
            try await authProvider.authenticate(&request)
        }
        
        // Apply request interceptors
        for interceptor in requestInterceptors {
            try await interceptor.intercept(&request)
        }
        
        return request
    }
    
    private func performRequest<T: Codable>(_ request: URLRequest) async throws -> T {
        var lastError: Error?
        
        for attempt in 1...configuration.retryCount {
            do {
                let (data, response) = try await session.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw DataSourceError.networkError("Invalid response type")
                }
                
                // Handle HTTP status codes
                switch httpResponse.statusCode {
                case 200...299:
                    break
                case 401:
                    throw DataSourceError.authenticationRequired
                case 404:
                    throw DataSourceError.itemNotFound("Resource not found")
                case 429:
                    throw DataSourceError.rateLimited
                case 500...599:
                    throw DataSourceError.serverError(
                        httpResponse.statusCode,
                        HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    )
                default:
                    throw DataSourceError.serverError(
                        httpResponse.statusCode,
                        HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    )
                }
                
                // Apply response interceptors
                var processedData = data
                for interceptor in responseInterceptors {
                    processedData = try await interceptor.intercept(response, data: processedData)
                }
                
                // Handle empty responses
                if T.self == EmptyResponse.self {
                    return EmptyResponse() as! T
                }
                
                // Decode response
                do {
                    return try jsonDecoder.decode(T.self, from: processedData)
                } catch {
                    throw DataSourceError.invalidData("Failed to decode response: \(error.localizedDescription)")
                }
                
            } catch {
                lastError = error
                
                // Don't retry certain errors
                if case DataSourceError.authenticationRequired = error {
                    throw error
                }
                
                // Wait before retry
                if attempt < configuration.retryCount {
                    try await Task.sleep(nanoseconds: UInt64(configuration.retryDelay * 1_000_000_000))
                }
            }
        }
        
        throw lastError ?? DataSourceError.unknown("All retry attempts failed")
    }
}

// MARK: - Supporting Types

/// HTTP methods supported by the data source
public enum HTTPMethod: String, Sendable {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

/// Empty response for operations that don't return data
private struct EmptyResponse: Codable {}

// MARK: - Common Authentication Providers

extension HTTPDataSource {
    
    /// Bearer token authentication provider
    public struct BearerTokenAuth: AuthenticationProvider {
        private let tokenProvider: () async throws -> String
        
        public init(token: String) {
            self.tokenProvider = { token }
        }
        
        public init(tokenProvider: @escaping () async throws -> String) {
            self.tokenProvider = tokenProvider
        }
        
        public func authenticate(_ request: inout URLRequest) async throws {
            let token = try await tokenProvider()
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }
    
    /// API key authentication provider
    public struct APIKeyAuth: AuthenticationProvider {
        private let apiKey: String
        private let headerName: String
        
        public init(apiKey: String, headerName: String = "X-API-Key") {
            self.apiKey = apiKey
            self.headerName = headerName
        }
        
        public func authenticate(_ request: inout URLRequest) async throws {
            request.setValue(apiKey, forHTTPHeaderField: headerName)
        }
    }
    
    /// Basic authentication provider
    public struct BasicAuth: AuthenticationProvider {
        private let username: String
        private let password: String
        
        public init(username: String, password: String) {
            self.username = username
            self.password = password
        }
        
        public func authenticate(_ request: inout URLRequest) async throws {
            let credentials = "\(username):\(password)"
            let encodedCredentials = Data(credentials.utf8).base64EncodedString()
            request.setValue("Basic \(encodedCredentials)", forHTTPHeaderField: "Authorization")
        }
    }
}

// MARK: - Common Request Interceptors

extension HTTPDataSource {
    
    /// Request interceptor that adds custom headers
    public struct HeaderInterceptor: RequestInterceptor {
        private let headers: [String: String]
        
        public init(headers: [String: String]) {
            self.headers = headers
        }
        
        public func intercept(_ request: inout URLRequest) async throws {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
    }
    
    /// Request interceptor that adds query parameters
    public struct QueryParameterInterceptor: RequestInterceptor {
        private let parameters: [String: String]
        
        public init(parameters: [String: String]) {
            self.parameters = parameters
        }
        
        public func intercept(_ request: inout URLRequest) async throws {
            guard let url = request.url,
                  var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return
            }
            
            var queryItems = components.queryItems ?? []
            
            for (key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            
            components.queryItems = queryItems
            request.url = components.url
        }
    }
}

// MARK: - Common Response Interceptors

extension HTTPDataSource {
    
    /// Response interceptor that logs responses for debugging
    public struct LoggingInterceptor: ResponseInterceptor {
        private let logger: (String) -> Void
        
        public init(logger: @escaping (String) -> Void = { print($0) }) {
            self.logger = logger
        }
        
        public func intercept(_ response: URLResponse, data: Data) async throws -> Data {
            if let httpResponse = response as? HTTPURLResponse {
                logger("HTTP \(httpResponse.statusCode) - \(httpResponse.url?.absoluteString ?? "unknown")")
                
                if let responseString = String(data: data, encoding: .utf8) {
                    logger("Response: \(responseString)")
                }
            }
            
            return data
        }
    }
}