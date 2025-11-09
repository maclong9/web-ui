/// Defines type-safe event actions for interactive elements.
///
/// Provides common DOM manipulation patterns without requiring inline JavaScript strings.
public enum EventAction {
    /// Toggle visibility of an element by ID
    case toggle(target: String, class: String = "hidden")

    /// Toggle a class on an element
    case toggleClass(target: String, class: String)

    /// Add a class to an element
    case addClass(target: String, class: String)

    /// Remove a class from an element
    case removeClass(target: String, class: String)

    /// Submit a form
    case submitForm(formId: String)

    /// Navigate to a URL
    case navigate(to: String)

    /// Call a JavaScript function by name
    case call(function: String, arguments: [String] = [])

    /// Custom JavaScript code (escape hatch for complex logic)
    case custom(String)

    /// Multiple actions in sequence
    case sequence([EventAction])

    /// Renders the event action as JavaScript code
    public var javascript: String {
        switch self {
        case .toggle(let target, let className):
            return "document.getElementById('\(target)')?.classList.toggle('\(className)')"

        case .toggleClass(let target, let className):
            return "document.getElementById('\(target)')?.classList.toggle('\(className)')"

        case .addClass(let target, let className):
            return "document.getElementById('\(target)')?.classList.add('\(className)')"

        case .removeClass(let target, let className):
            return "document.getElementById('\(target)')?.classList.remove('\(className)')"

        case .submitForm(let formId):
            return "document.getElementById('\(formId)')?.submit()"

        case .navigate(let url):
            return "window.location.href = '\(url)'"

        case .call(let function, let args):
            let argString = args.map { "'\($0)'" }.joined(separator: ", ")
            return "\(function)(\(argString))"

        case .custom(let code):
            return code

        case .sequence(let actions):
            return actions.map { $0.javascript }.joined(separator: "; ")
        }
    }
}

/// Event types for common DOM events
public enum EventType: String {
    case click
    case change
    case input
    case submit
    case focus
    case blur
    case mouseEnter = "mouseenter"
    case mouseLeave = "mouseleave"
    case keyDown = "keydown"
    case keyUp = "keyup"
}

// MARK: - Usage Examples
//
// EventAction provides type-safe JavaScript generation for use with element onClick parameters.
//
// Example with Button:
// ```swift
// Button("Toggle Menu", onClick: EventAction.toggle(target: "mobile-menu").javascript)
// Button("Close", onClick: EventAction.call(function: "closeMenu", arguments: ["main-menu"]).javascript)
// Button("Multiple", onClick: EventAction.sequence([
//     .addClass(target: "overlay", class: "active"),
//     .call(function: "startAnimation")
// ]).javascript)
// ```
//
// Example with custom Link onclick:
// ```swift
// Link("Click me", to: "#", onClick: EventAction.custom("alert('Hello!')").javascript)
// ```
