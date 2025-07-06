import Foundation

// MARK: - State Management Extensions
//
// These extensions provide helper methods for working with state in WebUI.
// Since Element doesn't have modifiers like SwiftUI, state management will be 
// implemented through custom elements that embed the necessary attributes.

// MARK: - State-Aware Conditional Rendering

// Note: For now, conditional rendering will be handled through CSS classes and JavaScript
// rather than custom Element types, to maintain compatibility with the existing Markup protocol

// MARK: - State-Driven CSS Classes
//
// Note: CSS class manipulation will be handled by the client-side JavaScript 
// state management system rather than through Element modifiers

// MARK: - State Helper Functions

/// Helper function to create state-aware data attributes for HTML elements
public func stateDataAttributes(
    key: String,
    scope: StateScope = .component,
    bindings: [String] = []
) -> [String: String] {
    var attributes: [String: String] = [:]
    
    // Add the main state binding
    attributes["data-state"] = "\(scope.rawValue).\(key)"
    
    // Add specific event bindings
    for binding in bindings {
        switch binding {
        case "toggle":
            attributes["data-onclick"] = "\(scope.rawValue).\(key).toggle"
        case "increment":
            attributes["data-onclick"] = "\(scope.rawValue).\(key).increment"
        case "decrement":
            attributes["data-onclick"] = "\(scope.rawValue).\(key).decrement"
        case "input":
            attributes["data-oninput"] = "\(scope.rawValue).\(key).set"
        case "change":
            attributes["data-onchange"] = "\(scope.rawValue).\(key).set"
        default:
            break
        }
    }
    
    return attributes
}