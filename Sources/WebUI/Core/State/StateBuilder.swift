import Foundation

/// Result builder for creating state property collections
@resultBuilder
public struct StateBuilder {
    public static func buildBlock(_ states: StateProperty...) -> [StateProperty] {
        states
    }
    
    public static func buildArray(_ states: [StateProperty]) -> [StateProperty] {
        states
    }
    
    public static func buildOptional(_ state: StateProperty?) -> [StateProperty] {
        if let state = state {
            return [state]
        }
        return []
    }
    
    public static func buildEither(first state: StateProperty) -> [StateProperty] {
        [state]
    }
    
    public static func buildEither(second state: StateProperty) -> [StateProperty] {
        [state]
    }
}