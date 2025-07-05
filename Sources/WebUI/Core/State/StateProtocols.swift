import Foundation

// MARK: - Core State Protocols

/// Protocol that all state types must conform to for JavaScript generation and state management.
///
/// This protocol provides the foundation for reactive state management in WebUI,
/// enabling automatic JavaScript generation and two-way data binding.
public protocol StateProtocol<Value>: Sendable {
    associatedtype Value: Codable & Sendable
    
    /// The current value of the state
    var wrappedValue: Value { get set }
    
    /// Unique identifier for this state instance
    var stateID: String? { get set }
    
    /// Whether this state should generate JavaScript binding code
    var generatesJavaScript: Bool { get }
    
    /// Callback triggered when the state value changes
    var onChange: (@Sendable (Value) -> Void)? { get set }
}

/// Type-erased protocol for storing different state types
public protocol StateProtocolErased: Sendable {
    var currentValue: Any { get }
    var stateID: String? { get }
}

/// Type-erased wrapper for StateProtocol instances
public struct AnyStateProtocol<T>: StateProtocolErased {
    private let wrappedState: any StateProtocol<T>
    
    public init<S: StateProtocol<T>>(_ state: S) {
        self.wrappedState = state
    }
    
    public var currentValue: Any {
        return wrappedState.wrappedValue
    }
    
    public var stateID: String? {
        return wrappedState.stateID
    }
}