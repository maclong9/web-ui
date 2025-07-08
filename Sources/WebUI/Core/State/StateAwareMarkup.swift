import Foundation

// MARK: - State-Aware Markup Extensions

/// Extension to Markup protocol that adds state management capabilities.
///
/// This extension enables any Markup element to include JavaScript generation
/// and state binding attributes in the rendered output.
extension Markup {
    
    /// Binds this markup element to a state instance for automatic updates.
    ///
    /// This method adds the necessary data attributes to enable JavaScript
    /// two-way binding with the specified state.
    ///
    /// - Parameters:
    ///   - state: The state instance to bind to
    ///   - property: The DOM property to bind (textContent, value, checked, etc.)
    /// - Returns: Modified markup with state binding attributes
    public func bindToState<T: Codable & Sendable>(
        _ state: any StateProtocol<T>, 
        property: DOMProperty = .textContent
    ) -> StateBoundMarkup<Self> {
        let stateID = state.stateID ?? "uninitialized_state"
        
        return StateBoundMarkup(
            content: self,
            stateID: stateID,
            property: property
        )
    }
    
    /// Adds a click handler that updates the specified state.
    ///
    /// This method generates JavaScript that will execute when the element
    /// is clicked, updating the state with the specified action.
    ///
    /// - Parameters:
    ///   - state: The state to update on click
    ///   - action: The action to perform
    /// - Returns: Modified markup with click handler
    public func onClick<T: Codable & Sendable>(
        _ state: any StateProtocol<T>,
        action: ButtonAction
    ) -> ClickHandlerMarkup<Self> {
        let stateID = state.stateID ?? "uninitialized_state"
        
        return ClickHandlerMarkup(
            content: self,
            stateID: stateID,
            action: action
        )
    }
    
    /// Includes JavaScript state management code in the rendered output.
    ///
    /// This method adds a script tag containing the generated JavaScript
    /// for all registered states. Typically used once per page.
    ///
    /// - Returns: Modified markup with embedded JavaScript
    public func includeStateManagement() -> StateManagementMarkup<Self> {
        return StateManagementMarkup(content: self)
    }
}

// MARK: - DOM Property Enum

/// Represents different DOM properties that can be bound to state.
public enum DOMProperty: String, CaseIterable {
    case textContent = "textContent"
    case innerHTML = "innerHTML"
    case value = "value"
    case checked = "checked"
    case disabled = "disabled"
    case placeholder = "placeholder"
    case title = "title"
    case className = "className"
    case style = "style"
}

// MARK: - State-Bound Markup Container

/// A markup container that adds state binding attributes to its content.
public struct StateBoundMarkup<Content: Markup>: Markup {
    private let content: Content
    private let stateID: String
    private let property: DOMProperty
    
    public init(content: Content, stateID: String, property: DOMProperty) {
        self.content = content
        self.stateID = stateID
        self.property = property
    }
    
    public var body: MarkupString {
        let renderedContent = content.render()
        let enhancedContent = addStateAttributes(to: renderedContent)
        return MarkupString(content: enhancedContent)
    }
    
    private func addStateAttributes(to html: String) -> String {
        // Find the first opening tag
        guard let tagRange = html.range(of: "<[^>]+>", options: .regularExpression) else {
            // If no tag found, wrap in a span
            return "<span data-webui-state=\"\(stateID)\" data-webui-property=\"\(property.rawValue)\">\(html)</span>"
        }
        
        let tag = html[tagRange]
        let stateAttributes = " data-webui-state=\"\(stateID)\" data-webui-property=\"\(property.rawValue)\""
        
        // Insert state attributes before the closing >
        let modifiedTag = String(tag).replacingOccurrences(
            of: ">$",
            with: "\(stateAttributes)>",
            options: .regularExpression
        )
        
        return html.replacingCharacters(in: tagRange, with: modifiedTag)
    }
}

// MARK: - Click Handler Markup Container

/// A markup container that adds click event handling to its content.
public struct ClickHandlerMarkup<Content: Markup>: Markup {
    private let content: Content
    private let stateID: String
    private let action: ButtonAction
    
    public init(content: Content, stateID: String, action: ButtonAction) {
        self.content = content
        self.stateID = stateID
        self.action = action
    }
    
    public var body: MarkupString {
        let renderedContent = content.render()
        let enhancedContent = addClickHandler(to: renderedContent)
        return MarkupString(content: enhancedContent)
    }
    
    private func addClickHandler(to html: String) -> String {
        // Find the first opening tag
        guard let tagRange = html.range(of: "<[^>]+>", options: .regularExpression) else {
            return html // Return original if no tag found
        }
        
        let tag = html[tagRange]
        var modifiedTag = String(tag)
        var actualElementID: String
        
        // Extract existing ID or generate new one
        if let idMatch = modifiedTag.range(of: "id=\"([^\"]+)\"", options: .regularExpression) {
            let idString = String(modifiedTag[idMatch])
            actualElementID = String(idString.dropFirst(4).dropLast(1)) // Remove id=" and "
        } else {
            // Generate unique ID for the element if it doesn't have one
            actualElementID = "webui-element-\(UUID().uuidString.prefix(8))"
            modifiedTag = modifiedTag.replacingOccurrences(
                of: ">$",
                with: " id=\"\(actualElementID)\">",
                options: .regularExpression
            )
        }
        
        let htmlWithID = html.replacingCharacters(in: tagRange, with: modifiedTag)
        
        // Generate the click handler script
        let generator = JavaScriptGenerator()
        let clickScript = generator.generateButtonHandler(
            buttonID: actualElementID,
            stateID: stateID,
            action: action
        )
        
        // Append the script after the element
        return "\(htmlWithID)\n<script>\n\(clickScript)\n</script>"
    }
}

// MARK: - State Management Script Container

/// A markup container that includes the complete state management JavaScript.
public struct StateManagementMarkup<Content: Markup>: Markup {
    private let content: Content
    
    public init(content: Content) {
        self.content = content
    }
    
    public var body: MarkupString {
        let renderedContent = content.render()
        let stateScript = generateStateScript()
        
        // Insert the script before the closing </body> tag if present
        if let bodyEndRange = renderedContent.range(of: "</body>", options: [.caseInsensitive, .backwards]) {
            let contentWithScript = renderedContent.replacingCharacters(
                in: bodyEndRange,
                with: "\(stateScript)\n</body>"
            )
            return MarkupString(content: contentWithScript)
        } else {
            // If no </body> tag, append at the end
            return MarkupString(content: "\(renderedContent)\n\(stateScript)")
        }
    }
    
    private func generateStateScript() -> String {
        let generator = JavaScriptGenerator()
        let stateManager = StateManager.shared
        let allStates = stateManager.getAllStateIDs()
        
        // Get all registered states for JavaScript generation
        var stateData: [String: any StateProtocolErased] = [:]
        for stateID in allStates {
            if let state = stateManager.getStateValue(withID: stateID) as? any StateProtocolErased {
                stateData[stateID] = state
            }
        }
        
        let script = generator.generateCompleteScript(for: stateData)
        return "<script>\n\(script)\n</script>"
    }
}

// MARK: - State-Aware Element Extensions

/// Extensions to common Element types for convenient state integration.
extension Element {
    
    /// Creates a button that increments a numeric state when clicked.
    ///
    /// - Parameters:
    ///   - text: Button text
    ///   - state: Numeric state to increment
    /// - Returns: Button element with increment functionality
    public static func incrementButton<T: Numeric & Codable & Sendable>(
        _ text: String,
        state: any StateProtocol<T>
    ) -> ClickHandlerMarkup<Button> {
        return Button(text)
            .onClick(state, action: .increment)
    }
    
    /// Creates a button that toggles a boolean state when clicked.
    ///
    /// - Parameters:
    ///   - text: Button text
    ///   - state: Boolean state to toggle
    /// - Returns: Button element with toggle functionality
    public static func toggleButton(
        _ text: String,
        state: any StateProtocol<Bool>
    ) -> ClickHandlerMarkup<Button> {
        return Button(text)
            .onClick(state, action: .toggle)
    }
}

// MARK: - Convenience Functions

/// Creates a text element that displays the current value of a state.
///
/// - Parameter state: State to display
/// - Returns: Text element bound to the state
public func StateText<T: Codable & Sendable>(_ state: any StateProtocol<T>) -> StateBoundMarkup<Text> {
    let stateID = state.stateID ?? "uninitialized_state"
    
    // Get current value for initial display
    let currentValue = StateManager.shared.getStateValue(withID: stateID) ?? ""
    
    return Text(String(describing: currentValue))
        .bindToState(state, property: .textContent)
}

/// Creates an input element that is bound to a state for two-way data binding.
///
/// - Parameters:
///   - state: State to bind to
///   - placeholder: Optional placeholder text
/// - Returns: Input element with two-way binding
public func StateInput<T: Codable & Sendable>(
    _ state: any StateProtocol<T>,
    name: String? = nil,
    placeholder: String? = nil
) -> StateBoundMarkup<Input> {
    let inputName = name ?? (state.stateID ?? "state_input")
    return Input(
        name: inputName,
        type: .text,
        placeholder: placeholder
    ).bindToState(state, property: .value)
}

/// Creates a checkbox element that is bound to a boolean state.
///
/// - Parameter state: Boolean state to bind to
/// - Returns: Checkbox element with two-way binding
public func StateCheckbox(
    _ state: any StateProtocol<Bool>,
    name: String? = nil
) -> StateBoundMarkup<Input> {
    let inputName = name ?? (state.stateID ?? "state_checkbox")
    return Input(
        name: inputName,
        type: .checkbox
    ).bindToState(state, property: .checked)
}

// MARK: - Type Constraints

/// Protocol constraint for numeric types that can be incremented/decremented.
public protocol Numeric: Codable, Sendable {
    static func + (lhs: Self, rhs: Self) -> Self
    static func - (lhs: Self, rhs: Self) -> Self
}

extension Int: Numeric {}
extension Double: Numeric {}
extension Float: Numeric {}
extension Int8: Numeric {}
extension Int16: Numeric {}
extension Int32: Numeric {}
extension Int64: Numeric {}
extension UInt: Numeric {}
extension UInt8: Numeric {}
extension UInt16: Numeric {}
extension UInt32: Numeric {}
extension UInt64: Numeric {}

// MARK: - Type Aliases for Backward Compatibility

/// Type alias for ButtonAction to support StateAction naming in tests
public typealias StateAction = ButtonAction