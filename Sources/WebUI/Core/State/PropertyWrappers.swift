import Foundation

// MARK: - @State Property Wrapper

/// A property wrapper that creates reactive state with automatic JavaScript generation.
///
/// `@State` manages local component state that can be updated from both Swift and JavaScript.
/// It automatically generates vanilla JavaScript code for two-way binding when used in elements.
///
/// ## Usage
///
/// ```swift
/// struct Counter: Element {
///     @State private var count = 0
///     
///     var body: some Markup {
///         Stack {
///             Text { "Count: \(count)" }
///             Button("Increment") {
///                 count += 1
///             }
///         }
///     }
/// }
/// ```
@propertyWrapper
public struct State<Value: Codable & Sendable>: StateProtocol, Sendable {
    
    private let storage: StateStorage<Value>
    
    /// The current value of the state
    public var wrappedValue: Value {
        get { storage.value }
        set { 
            storage.setValue(newValue)
            onChange?(newValue)
        }
    }
    
    /// Provides access to the State instance itself
    public var projectedValue: State<Value> {
        return self
    }
    
    /// Unique identifier for this state instance
    public var stateID: String? {
        get { storage.stateID }
        set { storage.stateID = newValue }
    }
    
    /// Whether this state should generate JavaScript binding code
    public let generatesJavaScript: Bool = true
    
    /// Callback triggered when the state value changes
    public var onChange: (@Sendable (Value) -> Void)? {
        get { storage.onChange }
        set { storage.onChange = newValue }
    }
    
    /// Creates a new state instance with an initial value.
    ///
    /// - Parameter wrappedValue: The initial value for the state
    public init(wrappedValue: Value) {
        self.storage = StateStorage(initialValue: wrappedValue)
        
        // Auto-register with the global state manager
        let id = StateManager.shared.registerState(self)
        self.stateID = id
    }
    
    /// Creates a new state instance with an initial value and custom ID.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value for the state
    ///   - id: Custom identifier for the state
    public init(wrappedValue: Value, id: String) {
        self.storage = StateStorage(initialValue: wrappedValue)
        self.stateID = id
        
        // Register with the global state manager using custom ID
        StateManager.shared.registerState(self, withID: id)
    }
}

// MARK: - @Binding Property Wrapper

/// A property wrapper that creates a two-way binding to external state.
///
/// `@Binding` enables child components to read and write to parent state
/// without owning the state themselves. This creates a reactive connection
/// between parent and child components.
///
/// ## Usage
///
/// ```swift
/// struct ToggleButton: Element {
///     @Binding var isEnabled: Bool
///     
///     var body: some Markup {
///         Button(isEnabled ? "Enabled" : "Disabled") {
///             isEnabled.toggle()
///         }
///     }
/// }
/// ```
@propertyWrapper
public struct Binding<Value: Codable & Sendable>: StateProtocol, Sendable {
    
    private let getter: @Sendable () -> Value
    private let setter: @Sendable (Value) -> Void
    private let storage: BindingStorage<Value>
    
    /// The current value of the binding
    public var wrappedValue: Value {
        get { getter() }
        set { 
            setter(newValue)
            onChange?(newValue)
        }
    }
    
    /// Provides access to the Binding instance itself
    public var projectedValue: Binding<Value> {
        return self
    }
    
    /// Unique identifier for this binding instance
    public var stateID: String? {
        get { storage.stateID }
        set { storage.stateID = newValue }
    }
    
    /// Whether this binding should generate JavaScript binding code
    public let generatesJavaScript: Bool = true
    
    /// Callback triggered when the binding value changes
    public var onChange: (@Sendable (Value) -> Void)? {
        get { storage.onChange }
        set { storage.onChange = newValue }
    }
    
    /// Creates a new binding with getter and setter functions.
    ///
    /// - Parameters:
    ///   - get: Function to get the current value
    ///   - set: Function to set a new value
    public init(get: @escaping @Sendable () -> Value, set: @escaping @Sendable (Value) -> Void) {
        self.getter = get
        self.setter = set
        self.storage = BindingStorage<Value>()
        
        // Auto-register with the global state manager
        let id = StateManager.shared.registerState(self)
        self.stateID = id
    }
}

// MARK: - @Published Property Wrapper

/// A property wrapper that publishes changes to subscribers.
///
/// `@Published` is similar to `@State` but designed for observable objects
/// that need to notify multiple subscribers of state changes. It's particularly
/// useful for view models and shared state objects.
///
/// ## Usage
///
/// ```swift
/// class UserViewModel: ObservableObject {
///     @Published var name: String = ""
///     @Published var email: String = ""
/// }
/// ```
@propertyWrapper
public struct Published<Value: Codable & Sendable>: StateProtocol, Sendable {
    
    private let storage: PublishedStorage<Value>
    
    /// The current value of the published property
    public var wrappedValue: Value {
        get { storage.value }
        set { 
            storage.setValue(newValue)
            onChange?(newValue)
            // Notify all subscribers
            storage.notifySubscribers(newValue)
        }
    }
    
    /// Provides access to the Published instance itself
    public var projectedValue: Published<Value> {
        return self
    }
    
    /// Unique identifier for this published property
    public var stateID: String? {
        get { storage.stateID }
        set { storage.stateID = newValue }
    }
    
    /// Whether this published property should generate JavaScript binding code
    public let generatesJavaScript: Bool = true
    
    /// Callback triggered when the published value changes
    public var onChange: (@Sendable (Value) -> Void)? {
        get { storage.onChange }
        set { storage.onChange = newValue }
    }
    
    /// Creates a new published property with an initial value.
    ///
    /// - Parameter wrappedValue: The initial value for the published property
    public init(wrappedValue: Value) {
        self.storage = PublishedStorage(initialValue: wrappedValue)
        
        // Auto-register with the global state manager
        let id = StateManager.shared.registerState(self)
        self.stateID = id
    }
    
    /// Adds a subscriber to be notified of value changes.
    ///
    /// - Parameter subscriber: Callback to be called when value changes
    public func addSubscriber(_ subscriber: @escaping @Sendable (Value) -> Void) {
        storage.addSubscriber(subscriber)
    }
    
    /// Removes all subscribers.
    public func removeAllSubscribers() {
        storage.removeAllSubscribers()
    }
}

// MARK: - Storage Implementations

/// Thread-safe storage for State values
private final class StateStorage<Value: Codable & Sendable>: @unchecked Sendable {
    private let lock = NSLock()
    private var _value: Value
    var stateID: String?
    var onChange: (@Sendable (Value) -> Void)?
    
    init(initialValue: Value) {
        self._value = initialValue
    }
    
    var value: Value {
        lock.withLock { _value }
    }
    
    func setValue(_ newValue: Value) {
        lock.withLock {
            _value = newValue
        }
    }
}

/// Thread-safe storage for Binding state
private final class BindingStorage<Value: Codable & Sendable>: @unchecked Sendable {
    var stateID: String?
    var onChange: (@Sendable (Value) -> Void)?
}

/// Thread-safe storage for Published values with subscriber management
private final class PublishedStorage<Value: Codable & Sendable>: @unchecked Sendable {
    private let lock = NSLock()
    private var _value: Value
    private var subscribers: [(@Sendable (Value) -> Void)] = []
    var stateID: String?
    var onChange: (@Sendable (Value) -> Void)?
    
    init(initialValue: Value) {
        self._value = initialValue
    }
    
    var value: Value {
        lock.withLock { _value }
    }
    
    func setValue(_ newValue: Value) {
        lock.withLock {
            _value = newValue
        }
    }
    
    func addSubscriber(_ subscriber: @escaping @Sendable (Value) -> Void) {
        lock.withLock {
            subscribers.append(subscriber)
        }
    }
    
    func removeAllSubscribers() {
        lock.withLock {
            subscribers.removeAll()
        }
    }
    
    func notifySubscribers(_ value: Value) {
        let currentSubscribers = lock.withLock { subscribers }
        for subscriber in currentSubscribers {
            subscriber(value)
        }
    }
}

// MARK: - Convenience Extensions

extension State {
    /// Creates a binding to this state.
    ///
    /// - Returns: A Binding that reads and writes to this state
    public func binding() -> Binding<Value> {
        return Binding(
            get: { [storage] in storage.value },
            set: { [storage] newValue in 
                storage.setValue(newValue)
                storage.onChange?(newValue)
            }
        )
    }
}

extension Binding {
    /// Creates a constant binding with a fixed value.
    ///
    /// - Parameter value: The constant value
    /// - Returns: A binding that always returns the same value
    public static func constant(_ value: Value) -> Binding<Value> {
        return Binding(
            get: { value },
            set: { _ in } // No-op setter for constant bindings
        )
    }
}

// MARK: - @ComponentState Property Wrapper

/// A property wrapper for component-scoped state management.
///
/// `@ComponentState` is similar to `@State` but allows for optional key-based registration
/// and is explicitly scoped to component-level state management.
///
/// ## Usage
///
/// ```swift
/// struct MyComponent: Element {
///     @ComponentState var count = 0
///     @ComponentState(key: "customKey") var value = "hello"
///     
///     var body: some Markup {
///         // Component implementation
///     }
/// }
/// ```
@propertyWrapper
public struct ComponentState<Value: Codable & Sendable>: StateProtocol, Sendable {
    
    private let storage: StateStorage<Value>
    private let key: String?
    
    /// The current value of the state
    public var wrappedValue: Value {
        get { storage.value }
        set { 
            storage.setValue(newValue)
            onChange?(newValue)
        }
    }
    
    /// Provides access to the ComponentState instance itself with binding functionality
    public var projectedValue: ComponentState<Value> {
        return self
    }
    
    /// Updates the value using the wrapped value setter
    ///
    /// - Parameter newValue: The new value to set
    public mutating func update(_ newValue: Value) {
        self.wrappedValue = newValue
    }
    
    /// Unique identifier for this state instance
    public var stateID: String? {
        get { storage.stateID }
        set { storage.stateID = newValue }
    }
    
    /// Whether this state should generate JavaScript binding code
    public let generatesJavaScript: Bool = true
    
    /// Callback triggered when the state value changes
    public var onChange: (@Sendable (Value) -> Void)? {
        get { storage.onChange }
        set { storage.onChange = newValue }
    }
    
    /// Creates a new component state with an initial value.
    ///
    /// - Parameter wrappedValue: The initial value for the state
    public init(wrappedValue: Value) {
        self.storage = StateStorage(initialValue: wrappedValue)
        self.key = nil
        
        // Auto-register with the global state manager
        let id = StateManager.shared.registerState(self)
        self.stateID = id
    }
    
    /// Creates a new component state with a custom key and initial value.
    ///
    /// - Parameters:
    ///   - key: Custom key for the state
    ///   - wrappedValue: The initial value for the state
    public init(key: String, wrappedValue: Value) {
        self.storage = StateStorage(initialValue: wrappedValue)
        self.key = key
        self.stateID = key
        
        // Register with the global state manager using custom key
        StateManager.shared.registerState(self, withID: key)
    }
}

// MARK: - @SharedState Property Wrapper

/// A property wrapper for shared state management across multiple components.
///
/// `@SharedState` creates state that can be accessed and modified by multiple components
/// within the same scope, enabling data sharing and synchronization.
///
/// ## Usage
///
/// ```swift
/// struct ComponentA: Element {
///     @SharedState("userProfile") var profile: UserProfile = UserProfile()
/// }
///
/// struct ComponentB: Element {
///     @SharedState("userProfile") var profile: UserProfile = UserProfile()
/// }
/// ```
@propertyWrapper
public struct SharedState<Value: Codable & Sendable>: StateProtocol, Sendable {
    
    private let storage: SharedStateStorage<Value>
    private let key: String
    
    /// The current value of the state
    public var wrappedValue: Value {
        get { storage.value }
        set { 
            storage.setValue(newValue)
            onChange?(newValue)
        }
    }
    
    /// Provides access to the SharedState instance itself with binding functionality
    public var projectedValue: SharedState<Value> {
        return self
    }
    
    /// Updates the value using the wrapped value setter
    ///
    /// - Parameter newValue: The new value to set
    public mutating func update(_ newValue: Value) {
        self.wrappedValue = newValue
    }
    
    /// Unique identifier for this state instance
    public var stateID: String? {
        get { storage.stateID }
        set { storage.stateID = newValue }
    }
    
    /// Whether this state should generate JavaScript binding code
    public let generatesJavaScript: Bool = true
    
    /// Callback triggered when the state value changes
    public var onChange: (@Sendable (Value) -> Void)? {
        get { storage.onChange }
        set { storage.onChange = newValue }
    }
    
    /// Creates a new shared state with a key and initial value.
    ///
    /// - Parameters:
    ///   - key: Unique key for shared state access
    ///   - wrappedValue: The initial value for the state
    public init(_ key: String, wrappedValue: Value) {
        self.key = key
        self.storage = ScopedStateContainers.shared.getOrCreate(key: key, initialValue: wrappedValue)
        self.stateID = "shared.\(key)"
        
        // Register with the global state manager
        StateManager.shared.registerState(self, withID: self.stateID!)
    }
}

// MARK: - @GlobalState Property Wrapper

/// A property wrapper for application-wide global state management.
///
/// `@GlobalState` creates state that persists across the entire application lifecycle
/// and can be accessed from any component.
///
/// ## Usage
///
/// ```swift
/// struct AppSettings: Element {
///     @GlobalState("darkMode") var isDarkMode: Bool = false
///     @GlobalState("appLanguage") var language: String = "en"
/// }
/// ```
@propertyWrapper
public struct GlobalState<Value: Codable & Sendable>: StateProtocol, Sendable {
    
    private let storage: GlobalStateStorage<Value>
    private let key: String
    
    /// The current value of the state
    public var wrappedValue: Value {
        get { storage.value }
        set { 
            storage.setValue(newValue)
            onChange?(newValue)
        }
    }
    
    /// Provides access to the GlobalState instance itself
    public var projectedValue: GlobalState<Value> {
        return self
    }
    
    /// Unique identifier for this state instance
    public var stateID: String? {
        get { storage.stateID }
        set { storage.stateID = newValue }
    }
    
    /// Whether this state should generate JavaScript binding code
    public let generatesJavaScript: Bool = true
    
    /// Callback triggered when the state value changes
    public var onChange: (@Sendable (Value) -> Void)? {
        get { storage.onChange }
        set { storage.onChange = newValue }
    }
    
    /// Creates a new global state with a key and initial value.
    ///
    /// - Parameters:
    ///   - key: Unique key for global state access
    ///   - wrappedValue: The initial value for the state
    public init(_ key: String, wrappedValue: Value) {
        self.key = key
        self.storage = ScopedStateContainers.global.getOrCreate(key: key, initialValue: wrappedValue)
        self.stateID = "global.\(key)"
        
        // Register with the global state manager
        StateManager.shared.registerState(self, withID: self.stateID!)
    }
}

// MARK: - @SessionState Property Wrapper

/// A property wrapper for session-scoped state management.
///
/// `@SessionState` creates state that persists for the duration of a user session
/// and is automatically cleared when the session ends.
///
/// ## Usage
///
/// ```swift
/// struct ShoppingCart: Element {
///     @SessionState("cartItems") var items: [CartItem] = []
///     @SessionState("cartTotal") var total: Double = 0.0
/// }
/// ```
@propertyWrapper
public struct SessionState<Value: Codable & Sendable>: StateProtocol, Sendable {
    
    private let storage: SessionStateStorage<Value>
    private let key: String
    
    /// The current value of the state
    public var wrappedValue: Value {
        get { storage.value }
        set { 
            storage.setValue(newValue)
            onChange?(newValue)
        }
    }
    
    /// Provides access to the SessionState instance itself
    public var projectedValue: SessionState<Value> {
        return self
    }
    
    /// Unique identifier for this state instance
    public var stateID: String? {
        get { storage.stateID }
        set { storage.stateID = newValue }
    }
    
    /// Whether this state should generate JavaScript binding code
    public let generatesJavaScript: Bool = true
    
    /// Callback triggered when the state value changes
    public var onChange: (@Sendable (Value) -> Void)? {
        get { storage.onChange }
        set { storage.onChange = newValue }
    }
    
    /// Creates a new session state with a key and initial value.
    ///
    /// - Parameters:
    ///   - key: Unique key for session state access
    ///   - wrappedValue: The initial value for the state
    public init(_ key: String, wrappedValue: Value) {
        self.key = key
        self.storage = ScopedStateContainers.session.getOrCreate(key: key, initialValue: wrappedValue)
        self.stateID = "session.\(key)"
        
        // Register with the global state manager
        StateManager.shared.registerState(self, withID: self.stateID!)
    }
}

// MARK: - StateBinding

/// A specialized binding for state management that provides get/set functionality.
///
/// `StateBinding` is similar to `Binding` but designed specifically for state management
/// scenarios where you need explicit control over getting and setting values.
///
/// ## Usage
///
/// ```swift
/// var backingValue = "initial"
/// let binding = StateBinding<String>(
///     get: { backingValue },
///     set: { backingValue = $0 }
/// )
/// ```
public struct StateBinding<Value: Codable & Sendable>: Sendable {
    
    private let getter: @Sendable () -> Value
    private let setter: @Sendable (Value) -> Void
    
    /// The current value of the binding
    public var wrappedValue: Value {
        get { getter() }
        set { setter(newValue) }
    }
    
    /// Creates a new state binding with getter and setter functions.
    ///
    /// - Parameters:
    ///   - get: Function to get the current value
    ///   - set: Function to set a new value
    public init(get: @escaping @Sendable () -> Value, set: @escaping @Sendable (Value) -> Void) {
        self.getter = get
        self.setter = set
    }
    
    /// Updates the value using the setter function.
    ///
    /// - Parameter newValue: The new value to set
    public func update(_ newValue: Value) {
        setter(newValue)
    }
}

// MARK: - Scoped Storage Implementations

/// Shared instance containers for scoped state management
private enum ScopedStateContainers {
    static let shared = SharedStateContainer()
    static let global = GlobalStateContainer()
    static let session = SessionStateContainer()
}

/// Thread-safe storage for shared state values
private final class SharedStateStorage<Value: Codable & Sendable>: @unchecked Sendable {
    private let lock = NSLock()
    private var _value: Value
    var stateID: String?
    var onChange: (@Sendable (Value) -> Void)?
    private let key: String
    
    init(key: String, initialValue: Value) {
        self.key = key
        self._value = initialValue
        self.stateID = "shared.\(key)"
    }
    
    var value: Value {
        lock.withLock { _value }
    }
    
    func setValue(_ newValue: Value) {
        lock.withLock {
            _value = newValue
        }
    }
}

/// Container for managing shared state instances
private final class SharedStateContainer: @unchecked Sendable {
    private let lock = NSLock()
    private var storages: [String: Any] = [:]
    
    func getOrCreate<Value: Codable & Sendable>(key: String, initialValue: Value) -> SharedStateStorage<Value> {
        return lock.withLock {
            if let existing = storages[key] as? SharedStateStorage<Value> {
                return existing
            } else {
                let storage = SharedStateStorage(key: key, initialValue: initialValue)
                storages[key] = storage
                return storage
            }
        }
    }
}

/// Thread-safe storage for global state values
private final class GlobalStateStorage<Value: Codable & Sendable>: @unchecked Sendable {
    private let lock = NSLock()
    private var _value: Value
    var stateID: String?
    var onChange: (@Sendable (Value) -> Void)?
    private let key: String
    
    init(key: String, initialValue: Value) {
        self.key = key
        self._value = initialValue
        self.stateID = "global.\(key)"
    }
    
    var value: Value {
        lock.withLock { _value }
    }
    
    func setValue(_ newValue: Value) {
        lock.withLock {
            _value = newValue
        }
    }
}

/// Container for managing global state instances
private final class GlobalStateContainer: @unchecked Sendable {
    private let lock = NSLock()
    private var storages: [String: Any] = [:]
    
    func getOrCreate<Value: Codable & Sendable>(key: String, initialValue: Value) -> GlobalStateStorage<Value> {
        return lock.withLock {
            if let existing = storages[key] as? GlobalStateStorage<Value> {
                return existing
            } else {
                let storage = GlobalStateStorage(key: key, initialValue: initialValue)
                storages[key] = storage
                return storage
            }
        }
    }
}

/// Thread-safe storage for session state values
private final class SessionStateStorage<Value: Codable & Sendable>: @unchecked Sendable {
    private let lock = NSLock()
    private var _value: Value
    var stateID: String?
    var onChange: (@Sendable (Value) -> Void)?
    private let key: String
    
    init(key: String, initialValue: Value) {
        self.key = key
        self._value = initialValue
        self.stateID = "session.\(key)"
    }
    
    var value: Value {
        lock.withLock { _value }
    }
    
    func setValue(_ newValue: Value) {
        lock.withLock {
            _value = newValue
        }
    }
}

/// Container for managing session state instances
private final class SessionStateContainer: @unchecked Sendable {
    private let lock = NSLock()
    private var storages: [String: Any] = [:]
    
    func getOrCreate<Value: Codable & Sendable>(key: String, initialValue: Value) -> SessionStateStorage<Value> {
        return lock.withLock {
            if let existing = storages[key] as? SessionStateStorage<Value> {
                return existing
            } else {
                let storage = SessionStateStorage(key: key, initialValue: initialValue)
                storages[key] = storage
                return storage
            }
        }
    }
}