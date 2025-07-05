import Foundation

/// Property wrapper for component-level state that is isolated to a specific element instance.
///
/// `@ComponentState` creates reactive state that automatically updates the UI when changed.
/// This state is scoped to the individual component and does not persist across sessions.
///
/// ## Usage
///
/// ```swift
/// struct ToggleButton: Element {
///     @ComponentState var isPressed = false
///     
///     var body: some Element {
///         button {
///             isPressed ? "Pressed" : "Not Pressed"
///         }
///         .onClick { isPressed.toggle() }
///         .class(isPressed ? "pressed" : "")
///     }
/// }
/// ```
@propertyWrapper
public struct ComponentState<Value: Codable>: @unchecked Sendable {
    private let key: String
    private let stateManager: StateManager
    private var _wrappedValue: Value
    
    /// The current value of the state
    public var wrappedValue: Value {
        get {
            return stateManager.getState(key: key, scope: .component, as: Value.self) ?? _wrappedValue
        }
        set {
            _wrappedValue = newValue
            stateManager.updateState(key: key, value: newValue, scope: .component)
        }
    }
    
    /// Provides access to the state binding for two-way data binding
    public var projectedValue: StateBinding<Value> {
        return StateBinding(
            get: { self.wrappedValue },
            set: { value in 
                // Update the state manager, which will handle the internal state
                self.stateManager.updateState(key: self.key, value: value, scope: .component)
            }
        )
    }
    
    /// Creates a new component state with the specified initial value
    ///
    /// - Parameter wrappedValue: Initial value for the state
    public init(wrappedValue: Value) {
        self.key = UUID().uuidString
        self.stateManager = StateManager.shared
        self._wrappedValue = wrappedValue
        
        // Register the initial state
        self.stateManager.registerState(key: key, initialValue: wrappedValue, scope: .component)
    }
    
    /// Creates a new component state with a custom key and initial value
    ///
    /// - Parameters:
    ///   - key: Custom key for the state (useful for debugging and persistence)
    ///   - wrappedValue: Initial value for the state
    public init(key: String, wrappedValue: Value) {
        self.key = key
        self.stateManager = StateManager.shared
        self._wrappedValue = wrappedValue
        
        // Register the initial state
        self.stateManager.registerState(key: key, initialValue: wrappedValue, scope: .component)
    }
}

/// Property wrapper for shared state that can be accessed across multiple components.
///
/// `@SharedState` creates reactive state that is shared across component instances.
/// This state can optionally persist across sessions depending on configuration.
///
/// ## Usage
///
/// ```swift
/// struct UserProfile: Element {
///     @SharedState("currentUser") var user: User?
///     @SharedState("isLoggedIn") var isLoggedIn = false
///     
///     var body: some Element {
///         if isLoggedIn, let user = user {
///             div {
///                 "Welcome, \\(user.name)!"
///             }
///         } else {
///             div {
///                 "Please log in"
///             }
///         }
///     }
/// }
/// ```
@propertyWrapper
public struct SharedState<Value: Codable>: @unchecked Sendable {
    private let key: String
    private let stateManager: StateManager
    private var _wrappedValue: Value
    
    /// The current value of the shared state
    public var wrappedValue: Value {
        get {
            return stateManager.getState(key: key, scope: .shared, as: Value.self) ?? _wrappedValue
        }
        set {
            _wrappedValue = newValue
            stateManager.updateState(key: key, value: newValue, scope: .shared)
        }
    }
    
    /// Provides access to the state binding for two-way data binding
    public var projectedValue: StateBinding<Value> {
        return StateBinding(
            get: { self.wrappedValue },
            set: { value in 
                self.stateManager.updateState(key: self.key, value: value, scope: .shared)
            }
        )
    }
    
    /// Creates a new shared state with the specified key and initial value
    ///
    /// - Parameters:
    ///   - key: Unique key for the shared state
    ///   - wrappedValue: Initial value for the state
    public init(_ key: String, wrappedValue: Value) {
        self.key = key
        self.stateManager = StateManager.shared
        self._wrappedValue = wrappedValue
        
        // Register the initial state
        self.stateManager.registerState(key: key, initialValue: wrappedValue, scope: .shared)
    }
}

/// Property wrapper for global application state.
///
/// `@GlobalState` creates reactive state that is available application-wide.
/// This state typically persists across sessions and represents core application data.
///
/// ## Usage
///
/// ```swift
/// struct AppSettings: Element {
///     @GlobalState("theme") var theme = "light"
///     @GlobalState("language") var language = "en"
///     
///     var body: some Element {
///         div {
///             "Current theme: \\(theme)"
///         }
///         .class("theme-\\(theme)")
///     }
/// }
/// ```
@propertyWrapper
public struct GlobalState<Value: Codable>: @unchecked Sendable {
    private let key: String
    private let stateManager: StateManager
    private var _wrappedValue: Value
    
    /// The current value of the global state
    public var wrappedValue: Value {
        get {
            return stateManager.getState(key: key, scope: .global, as: Value.self) ?? _wrappedValue
        }
        set {
            _wrappedValue = newValue
            stateManager.updateState(key: key, value: newValue, scope: .global)
        }
    }
    
    /// Provides access to the state binding for two-way data binding
    public var projectedValue: StateBinding<Value> {
        return StateBinding(
            get: { self.wrappedValue },
            set: { value in 
                self.stateManager.updateState(key: self.key, value: value, scope: .global)
            }
        )
    }
    
    /// Creates a new global state with the specified key and initial value
    ///
    /// - Parameters:
    ///   - key: Unique key for the global state
    ///   - wrappedValue: Initial value for the state
    public init(_ key: String, wrappedValue: Value) {
        self.key = key
        self.stateManager = StateManager.shared
        self._wrappedValue = wrappedValue
        
        // Register the initial state
        self.stateManager.registerState(key: key, initialValue: wrappedValue, scope: .global)
    }
}

/// Property wrapper for session-specific state that persists during the user session.
///
/// `@SessionState` creates reactive state that persists for the duration of the user session.
/// This state is automatically cleared when the session ends.
///
/// ## Usage
///
/// ```swift
/// struct ShoppingCart: Element {
///     @SessionState("cartItems") var items: [CartItem] = []
///     @SessionState("cartTotal") var total: Double = 0.0
///     
///     var body: some Element {
///         div {
///             "Cart Total: $\\(String(format: "%.2f", total))"
///             "Items: \\(items.count)"
///         }
///     }
/// }
/// ```
@propertyWrapper
public struct SessionState<Value: Codable>: @unchecked Sendable {
    private let key: String
    private let stateManager: StateManager
    private var _wrappedValue: Value
    
    /// The current value of the session state
    public var wrappedValue: Value {
        get {
            return stateManager.getState(key: key, scope: .session, as: Value.self) ?? _wrappedValue
        }
        set {
            _wrappedValue = newValue
            stateManager.updateState(key: key, value: newValue, scope: .session)
        }
    }
    
    /// Provides access to the state binding for two-way data binding
    public var projectedValue: StateBinding<Value> {
        return StateBinding(
            get: { self.wrappedValue },
            set: { value in 
                self.stateManager.updateState(key: self.key, value: value, scope: .session)
            }
        )
    }
    
    /// Creates a new session state with the specified key and initial value
    ///
    /// - Parameters:
    ///   - key: Unique key for the session state
    ///   - wrappedValue: Initial value for the state
    public init(_ key: String, wrappedValue: Value) {
        self.key = key
        self.stateManager = StateManager.shared
        self._wrappedValue = wrappedValue
        
        // Register the initial state
        self.stateManager.registerState(key: key, initialValue: wrappedValue, scope: .session)
    }
}

/// A binding represents a reference to a state value that can be read and written.
///
/// `StateBinding` provides two-way data binding capabilities for WebUI state management.
/// It allows components to both read and modify state values through a unified interface.
///
/// ## Usage
///
/// ```swift
/// struct TextInput: Element {
///     @ComponentState var text = ""
///     
///     var body: some Element {
///         input()
///             .type(.text)
///             .value($text) // Uses the projected value (StateBinding)
///     }
/// }
/// ```
public struct StateBinding<Value>: @unchecked Sendable {
    private let getValue: () -> Value
    private let setValue: (Value) -> Void
    
    /// The current value of the binding
    public var wrappedValue: Value {
        get { getValue() }
        nonmutating set { setValue(newValue) }
    }
    
    /// Creates a new state binding with get and set closures
    ///
    /// - Parameters:
    ///   - get: Closure to retrieve the current value
    ///   - set: Closure to update the value
    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        self.getValue = get
        self.setValue = set
    }
    
    /// Updates the bound value
    ///
    /// - Parameter newValue: The new value to set
    public func update(_ newValue: Value) {
        setValue(newValue)
    }
}

// MARK: - State Subscription Extensions

extension ComponentState {
    /// Subscribes to changes in this component state
    ///
    /// - Parameter callback: Callback to invoke when the state changes
    /// - Returns: A function to unsubscribe from changes
    @discardableResult
    public func onChange(_ callback: @escaping (Value) -> Void) -> () -> Void {
        return stateManager.subscribe(to: key, scope: .component, callback: callback)
    }
}

extension SharedState {
    /// Subscribes to changes in this shared state
    ///
    /// - Parameter callback: Callback to invoke when the state changes
    /// - Returns: A function to unsubscribe from changes
    @discardableResult
    public func onChange(_ callback: @escaping (Value) -> Void) -> () -> Void {
        return stateManager.subscribe(to: key, scope: .shared, callback: callback)
    }
}

extension GlobalState {
    /// Subscribes to changes in this global state
    ///
    /// - Parameter callback: Callback to invoke when the state changes
    /// - Returns: A function to unsubscribe from changes
    @discardableResult
    public func onChange(_ callback: @escaping (Value) -> Void) -> () -> Void {
        return stateManager.subscribe(to: key, scope: .global, callback: callback)
    }
}

extension SessionState {
    /// Subscribes to changes in this session state
    ///
    /// - Parameter callback: Callback to invoke when the state changes
    /// - Returns: A function to unsubscribe from changes
    @discardableResult
    public func onChange(_ callback: @escaping (Value) -> Void) -> () -> Void {
        return stateManager.subscribe(to: key, scope: .session, callback: callback)
    }
}