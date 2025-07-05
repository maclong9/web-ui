import Foundation

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
/// let userState = State(initialValue: "John Doe")
/// stateManager.registerState(userState, withID: "userName")
/// ```
public final class StateManager: @unchecked Sendable {
    
    /// Shared singleton instance for global state coordination
    public static let shared = StateManager()
    
    /// Thread-safe storage for all registered states
    private let stateStorage = StateStorage()
    
    /// Counter for generating unique state IDs
    private let idCounter = AtomicCounter()
    
    /// Thread-safe storage for JavaScript generation setting
    private let lock = NSLock()
    private var _isJavaScriptGenerationEnabled: Bool = true
    
    /// Whether JavaScript generation is enabled
    public var isJavaScriptGenerationEnabled: Bool {
        get { lock.withLock { _isJavaScriptGenerationEnabled } }
        set { lock.withLock { _isJavaScriptGenerationEnabled = newValue } }
    }
    
    private init() {}
    
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
        return generator.generateCompleteScript(for: stateStorage.getAllStates())
    }
    
    /// Generates JavaScript for a specific state instance.
    ///
    /// - Parameter id: The ID of the state to generate JavaScript for
    /// - Returns: JavaScript code for the specific state, or empty string if not found
    public func generateJavaScript(for id: String) -> String {
        guard isJavaScriptGenerationEnabled,
              let state = stateStorage.getState(withID: id) else {
            return ""
        }
        
        let generator = JavaScriptGenerator()
        return generator.generateStateScript(for: state, withID: id)
    }
    
    // MARK: - State Inspection
    
    /// Returns all registered state IDs.
    ///
    /// - Returns: Array of state IDs currently registered
    public func getAllStateIDs() -> [String] {
        return stateStorage.getAllStateIDs()
    }
    
    /// Gets the current value of a registered state.
    ///
    /// - Parameter id: The ID of the state to inspect
    /// - Returns: The current state value, or nil if not found
    public func getStateValue(withID id: String) -> Any? {
        return stateStorage.getState(withID: id)?.currentValue
    }
    
    // MARK: - Private Utilities
    
    private func generateUniqueID() -> String {
        return "state_\(idCounter.increment())"
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
            return states[id]
        }
    }
    
    func getAllStates() -> [String: any StateProtocolErased] {
        lock.withLock {
            return states
        }
    }
    
    func getAllStateIDs() -> [String] {
        lock.withLock {
            return Array(states.keys)
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