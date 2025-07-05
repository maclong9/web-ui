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