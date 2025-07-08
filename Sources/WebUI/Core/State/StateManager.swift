import Foundation

/// State scope for organizing state by lifecycle and visibility
public enum StateScope: String, CaseIterable, Codable, Sendable {
    case component = "component"
    case shared = "shared"
    case global = "global"
    case session = "session"
}

/// A global state manager that coordinates state changes and JavaScript generation.
///
/// The `StateManager` is responsible for:
/// - Tracking all state instances in the application
/// - Generating JavaScript code for state synchronization
/// - Managing client-server state communication
/// - Providing utilities for state debugging and inspection
///
/// ## Usage
///
/// ```swift
/// let stateManager = StateManager.shared
/// let userState = State(initialValue: "Jane Doe")
/// stateManager.registerState(userState, withID: "userName")
/// ```
public final class StateManager: @unchecked Sendable {

    /// Configuration for state manager behavior
    public struct StateConfiguration {
        let enablePersistence: Bool
        let storageType: StorageType
        let enableDebugging: Bool
        let maxDebugHistory: Int

        public enum StorageType: String, Codable {
            case localStorage = "localStorage"
            case sessionStorage = "sessionStorage"
            case memory = "memory"
        }

        public init(
            enablePersistence: Bool = false,
            storageType: StorageType = .memory,
            enableDebugging: Bool = true,
            maxDebugHistory: Int = 100
        ) {
            self.enablePersistence = enablePersistence
            self.storageType = storageType
            self.enableDebugging = enableDebugging
            self.maxDebugHistory = maxDebugHistory
        }
    }

    /// Shared singleton instance for global state coordination
    public static let shared = StateManager()

    /// Thread-safe storage for all registered states
    private let stateStorage = StateStorage()

    /// Scoped state storage for key-value based state management
    private let scopedStorage = ScopedStateStorage()

    /// Counter for generating unique state IDs
    private let idCounter = AtomicCounter()

    /// Thread-safe storage for JavaScript generation setting
    private let lock = NSLock()
    private var _isJavaScriptGenerationEnabled: Bool = true
    private var _configuration: StateConfiguration

    /// Whether JavaScript generation is enabled
    public var isJavaScriptGenerationEnabled: Bool {
        get { lock.withLock { _isJavaScriptGenerationEnabled } }
        set { lock.withLock { _isJavaScriptGenerationEnabled = newValue } }
    }

    /// Configuration for this state manager instance
    public var configuration: StateConfiguration {
        lock.withLock { _configuration }
    }

    private init() {
        self._configuration = StateConfiguration()
    }

    /// Creates a new state manager with the specified configuration
    public init(configuration: StateConfiguration) {
        self._configuration = configuration
    }

    // MARK: - State Registration

    /// Registers a state instance with the global state manager.
    ///
    /// - Parameters:
    ///   - state: The state instance to register
    ///   - id: Optional custom ID. If nil, a unique ID will be generated
    /// - Returns: The assigned state ID
    @discardableResult
    public func registerState<T>(_ state: any StateProtocol<T>, withID id: String? = nil) -> String {
        let stateID = id ?? generateUniqueID()
        stateStorage.store(state: state, withID: stateID)
        return stateID
    }

    /// Unregisters a state instance from the global manager.
    ///
    /// - Parameter id: The ID of the state to unregister
    public func unregisterState(withID id: String) {
        stateStorage.removeState(withID: id)
    }

    // MARK: - Scoped State Management

    /// Registers a state value with a key and scope
    ///
    /// - Parameters:
    ///   - key: The key for the state
    ///   - initialValue: The initial value for the state
    ///   - scope: The scope for state organization
    public func registerState<T: Codable & Sendable>(key: String, initialValue: T, scope: StateScope) {
        scopedStorage.registerState(key: key, initialValue: initialValue, scope: scope)
    }

    /// Gets the current value of a scoped state
    ///
    /// - Parameters:
    ///   - key: The key for the state
    ///   - scope: The scope for state organization
    ///   - type: The expected type of the state value
    /// - Returns: The current state value, or nil if not found
    public func getState<T: Codable & Sendable>(key: String, scope: StateScope, as type: T.Type) -> T? {
        scopedStorage.getState(key: key, scope: scope, as: type)
    }

    /// Updates the value of a scoped state
    ///
    /// - Parameters:
    ///   - key: The key for the state
    ///   - value: The new value for the state
    ///   - scope: The scope for state organization
    public func updateState<T: Codable & Sendable>(key: String, value: T, scope: StateScope) {
        scopedStorage.updateState(key: key, value: value, scope: scope)
    }

    /// Subscribes to changes in a scoped state
    ///
    /// - Parameters:
    ///   - key: The key for the state
    ///   - scope: The scope for state organization
    ///   - callback: The callback to be called when the state changes
    /// - Returns: A subscription token that can be used to unsubscribe
    public func subscribe<T: Codable & Sendable>(to key: String, scope: StateScope, callback: @escaping (T) -> Void)
        -> StateSubscriptionToken
    {
        scopedStorage.subscribe(to: key, scope: scope, callback: callback)
    }

    /// Clears all state for a given scope
    ///
    /// - Parameter scope: The scope to clear
    public func clearState(scope: StateScope) {
        scopedStorage.clearState(scope: scope)
    }

    /// Gets the debug history of state changes
    ///
    /// - Returns: Array of debug history entries
    public func getDebugHistory() -> [DebugHistoryEntry] {
        scopedStorage.getDebugHistory()
    }

    /// Exports all scoped state as JSON
    ///
    /// - Returns: JSON representation of all state
    public func exportStateJSON() -> String {
        scopedStorage.exportStateJSON()
    }

    /// Imports state from JSON
    ///
    /// - Parameter json: JSON string containing state data
    public func importStateJSON(_ json: String) {
        scopedStorage.importStateJSON(json)
    }

    // MARK: - JavaScript Generation

    /// Generates vanilla JavaScript code for all registered states.
    ///
    /// This method produces clean ES6+ JavaScript that:
    /// - Creates reactive state objects
    /// - Sets up event listeners for state changes
    /// - Provides update functions for two-way binding
    ///
    /// - Returns: Complete JavaScript code as a string
    public func generateJavaScript() -> String {
        guard isJavaScriptGenerationEnabled else { return "" }

        let generator = JavaScriptGenerator()
        return generator.generateCompleteScript(for: stateStorage.getAllStates(), configuration: configuration)
    }

    /// Generates JavaScript for a specific state instance.
    ///
    /// - Parameter id: The ID of the state to generate JavaScript for
    /// - Returns: JavaScript code for the specific state, or empty string if not found
    public func generateJavaScript(for id: String) -> String {
        guard isJavaScriptGenerationEnabled,
            let state = stateStorage.getState(withID: id)
        else {
            return ""
        }

        let generator = JavaScriptGenerator()
        return generator.generateStateScript(for: state, withID: id, configuration: configuration)
    }

    // MARK: - State Inspection

    /// Returns all registered state IDs.
    ///
    /// - Returns: Array of state IDs currently registered
    public func getAllStateIDs() -> [String] {
        stateStorage.getAllStateIDs()
    }

    /// Gets the current value of a registered state.
    ///
    /// - Parameter id: The ID of the state to inspect
    /// - Returns: The current state value, or nil if not found
    public func getStateValue(withID id: String) -> Any? {
        stateStorage.getState(withID: id)?.currentValue
    }

    // MARK: - Private Utilities

    private func generateUniqueID() -> String {
        "state_\(idCounter.increment())"
    }
}

// MARK: - Supporting Types

/// Thread-safe storage for state instances
private final class StateStorage: @unchecked Sendable {
    private let lock = NSLock()
    private var states: [String: any StateProtocolErased] = [:]

    func store<T>(state: any StateProtocol<T>, withID id: String) {
        lock.withLock {
            states[id] = AnyStateProtocol(state)
        }
    }

    func removeState(withID id: String) {
        lock.withLock {
            _ = states.removeValue(forKey: id)
        }
    }

    func getState(withID id: String) -> (any StateProtocolErased)? {
        lock.withLock {
            states[id]
        }
    }

    func getAllStates() -> [String: any StateProtocolErased] {
        lock.withLock {
            states
        }
    }

    func getAllStateIDs() -> [String] {
        lock.withLock {
            Array(states.keys)
        }
    }
}

/// Thread-safe atomic counter for generating unique IDs
private final class AtomicCounter: @unchecked Sendable {
    private let lock = NSLock()
    private var value = 0

    func increment() -> Int {
        lock.withLock {
            value += 1
            return value
        }
    }
}

/// Subscription token for state change notifications
public struct StateSubscriptionToken: Sendable, Hashable {
    let id: String
    let scope: StateScope
    let key: String

    init(id: String, scope: StateScope, key: String) {
        self.id = id
        self.scope = scope
        self.key = key
    }
}

/// Debug history entry for state changes
public struct DebugHistoryEntry: @unchecked Sendable {
    let timestamp: Date
    let key: String
    let oldValue: Any?
    let newValue: Any
    let scope: StateScope

    init(key: String, oldValue: Any?, newValue: Any, scope: StateScope) {
        self.timestamp = Date()
        self.key = "\(scope.rawValue).\(key)"
        self.oldValue = oldValue
        self.newValue = newValue
        self.scope = scope
    }
}

/// Thread-safe storage for scoped state management
private final class ScopedStateStorage: @unchecked Sendable {
    private let lock = NSLock()
    private var statesByScope: [StateScope: [String: Any]] = [:]
    private var subscriptions: [StateScope: [String: [StateSubscriptionToken: Any]]] = [:]
    private var debugHistory: [DebugHistoryEntry] = []
    private let subscriptionCounter = AtomicCounter()

    init() {
        // Initialize all scopes with empty dictionaries
        for scope in StateScope.allCases {
            statesByScope[scope] = [:]
            subscriptions[scope] = [:]
        }
    }

    func registerState<T: Codable & Sendable>(key: String, initialValue: T, scope: StateScope) {
        lock.withLock {
            statesByScope[scope]?[key] = initialValue
            debugHistory.append(DebugHistoryEntry(key: key, oldValue: nil, newValue: initialValue, scope: scope))
        }
    }

    func getState<T: Codable & Sendable>(key: String, scope: StateScope, as type: T.Type) -> T? {
        lock.withLock {
            statesByScope[scope]?[key] as? T
        }
    }

    func updateState<T: Codable & Sendable>(key: String, value: T, scope: StateScope) {
        lock.withLock {
            let oldValue = statesByScope[scope]?[key]
            statesByScope[scope]?[key] = value
            debugHistory.append(DebugHistoryEntry(key: key, oldValue: oldValue, newValue: value, scope: scope))

            // Notify subscribers
            if let scopeSubscriptions = subscriptions[scope]?[key] {
                for (_, callback) in scopeSubscriptions {
                    if let typedCallback = callback as? (T) -> Void {
                        typedCallback(value)
                    }
                }
            }
        }
    }

    func subscribe<T: Codable & Sendable>(to key: String, scope: StateScope, callback: @escaping (T) -> Void)
        -> StateSubscriptionToken
    {
        lock.withLock {
            let subscriptionId = "sub_\(subscriptionCounter.increment())"
            let token = StateSubscriptionToken(id: subscriptionId, scope: scope, key: key)

            if subscriptions[scope]?[key] == nil {
                subscriptions[scope]?[key] = [:]
            }
            subscriptions[scope]?[key]?[token] = callback

            return token
        }
    }

    func clearState(scope: StateScope) {
        lock.withLock {
            statesByScope[scope] = [:]
            subscriptions[scope] = [:]
        }
    }

    func getDebugHistory() -> [DebugHistoryEntry] {
        lock.withLock {
            debugHistory
        }
    }

    func exportStateJSON() -> String {
        lock.withLock {
            var exportData: [String: [String: Any]] = [:]

            for scope in StateScope.allCases {
                exportData[scope.rawValue] = statesByScope[scope] ?? [:]
            }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: exportData, options: .prettyPrinted)
                return String(data: jsonData, encoding: .utf8) ?? "{}"
            } catch {
                return "{}"
            }
        }
    }

    func importStateJSON(_ json: String) {
        lock.withLock {
            guard let data = json.data(using: .utf8),
                let importData = try? JSONSerialization.jsonObject(with: data) as? [String: [String: Any]]
            else {
                return
            }

            for scope in StateScope.allCases {
                if let scopeData = importData[scope.rawValue] {
                    statesByScope[scope] = scopeData
                }
            }
        }
    }
}
