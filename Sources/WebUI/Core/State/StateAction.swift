import Foundation

/// Represents actions that can be performed on state properties
public enum StateAction {
    case toggle(String)
    case update(String, Any)
    case increment(String, Double = 1)
    case decrement(String, Double = 1)
    case expression(String, String) // variable name, expression
    case addToArray(String, Any)
    case removeFromArray(String, Int)
    case updateObject(String, String, Any)
    case deleteFromObject(String, String)
    case custom(String) // custom JavaScript code
    
    /// Generates JavaScript code for the action
    public var jsCode: String {
        switch self {
        case .toggle(let name):
            return "toggle\(name.capitalized)()"
            
        case .update(let name, let value):
            if let stringValue = value as? String {
                return "set\(name.capitalized)('\(stringValue.escapedForJavaScript)')"
            } else if let numberValue = value as? Double {
                return "set\(name.capitalized)(\(numberValue))"
            } else if let boolValue = value as? Bool {
                return "set\(name.capitalized)(\(boolValue ? "true" : "false"))"
            } else {
                return "set\(name.capitalized)(\(value))"
            }
            
        case .increment(let name, let by):
            if by == 1 {
                return "increment\(name.capitalized)()"
            } else {
                return "increment\(name.capitalized)(\(by))"
            }
            
        case .decrement(let name, let by):
            if by == 1 {
                return "decrement\(name.capitalized)()"
            } else {
                return "decrement\(name.capitalized)(\(by))"
            }
            
        case .expression(let name, let expr):
            return "set\(name.capitalized)(\(expr))"
            
        case .addToArray(let name, let item):
            if let stringValue = item as? String {
                return "add\(name.capitalized)('\(stringValue.escapedForJavaScript)')"
            } else if let numberValue = item as? Double {
                return "add\(name.capitalized)(\(numberValue))"
            } else if let boolValue = item as? Bool {
                return "add\(name.capitalized)(\(boolValue ? "true" : "false"))"
            } else {
                return "add\(name.capitalized)(\(item))"
            }
            
        case .removeFromArray(let name, let index):
            return "remove\(name.capitalized)(\(index))"
            
        case .updateObject(let name, let key, let value):
            if let stringValue = value as? String {
                return "update\(name.capitalized)('\(key)', '\(stringValue.escapedForJavaScript)')"
            } else if let numberValue = value as? Double {
                return "update\(name.capitalized)('\(key)', \(numberValue))"
            } else if let boolValue = value as? Bool {
                return "update\(name.capitalized)('\(key)', \(boolValue ? "true" : "false"))"
            } else {
                return "update\(name.capitalized)('\(key)', \(value))"
            }
            
        case .deleteFromObject(let name, let key):
            return "delete\(name.capitalized)('\(key)')"
            
        case .custom(let code):
            return code
        }
    }
    
    /// Convenience method for chaining multiple actions
    public static func chain(_ actions: StateAction...) -> String {
        return actions.map(\.jsCode).joined(separator: "; ")
    }
}

/// Extension to combine multiple actions into a single JavaScript expression
public extension Array where Element == StateAction {
    var jsCode: String {
        return self.map(\.jsCode).joined(separator: "; ")
    }
}