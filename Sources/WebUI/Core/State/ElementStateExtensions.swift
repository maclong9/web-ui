import Foundation

/// Extensions to Element for state-driven interactions
extension Element {
    /// Adds a state action to an element's click event
    /// - Parameter action: The state action to execute
    /// - Returns: The element with the action attached
    public func action(_ action: StateAction) -> Element {
        return self.on("click", action.jsCode)
    }
    
    /// Adds multiple state actions to an element's click event
    /// - Parameter actions: The state actions to execute
    /// - Returns: The element with the actions attached
    public func actions(_ actions: StateAction...) -> Element {
        let combined = actions.map(\.jsCode).joined(separator: "; ")
        return self.on("click", combined)
    }
    
    /// Adds multiple state actions to an element's click event
    /// - Parameter actions: Array of state actions to execute
    /// - Returns: The element with the actions attached
    public func actions(_ actions: [StateAction]) -> Element {
        let combined = actions.map(\.jsCode).joined(separator: "; ")
        return self.on("click", combined)
    }
    
    /// Shows or hides the element based on a state condition
    /// - Parameter condition: JavaScript expression that evaluates to boolean
    /// - Returns: The element with conditional visibility
    public func show(when condition: String) -> Element {
        return self.attribute("data-state-show", condition)
    }
    
    /// Hides the element when a state condition is true
    /// - Parameter condition: JavaScript expression that evaluates to boolean
    /// - Returns: The element with conditional visibility
    public func hide(when condition: String) -> Element {
        return self.attribute("data-state-show", "!(\(condition))")
    }
    
    /// Binds the element's text content to a state variable or expression
    /// - Parameter state: State variable name or JavaScript expression
    /// - Returns: The element with dynamic text content
    public func text(from state: String) -> Element {
        return self.attribute("data-state-text", state)
    }
    
    /// Binds the element's text content to a template literal with state variables
    /// - Parameter template: Template literal string with ${} placeholders
    /// - Returns: The element with dynamic text content
    public func text(template: String) -> Element {
        return self.attribute("data-state-text", template)
    }
    
    /// Binds an input element's value to a state variable
    /// - Parameter state: State variable name
    /// - Returns: The element with two-way data binding
    public func bind(to state: String) -> Element {
        return self
            .attribute("data-state-value", state)
            .on("input", "set\(state.capitalized)(event.target.value)")
    }
    
    /// Binds a number input element's value to a state variable
    /// - Parameter state: State variable name
    /// - Returns: The element with two-way data binding for numbers
    public func bindNumber(to state: String) -> Element {
        return self
            .attribute("data-state-value", state)
            .on("input", "set\(state.capitalized)(parseFloat(event.target.value) || 0)")
    }
    
    /// Binds a checkbox element's checked state to a boolean state variable
    /// - Parameter state: Boolean state variable name
    /// - Returns: The element with two-way data binding for checkbox
    public func bindChecked(to state: String) -> Element {
        return self
            .attribute("data-state-checked", state)
            .on("change", "set\(state.capitalized)(event.target.checked)")
    }
    
    /// Adds a custom event listener with state actions
    /// - Parameters:
    ///   - event: The event name (e.g., "click", "input", "change")
    ///   - actions: State actions to execute
    /// - Returns: The element with the event listener
    public func on(_ event: String, actions: StateAction...) -> Element {
        let combined = actions.map(\.jsCode).joined(separator: "; ")
        return self.on(event, combined)
    }
    
    /// Adds a custom event listener with state actions
    /// - Parameters:
    ///   - event: The event name
    ///   - actions: Array of state actions to execute
    /// - Returns: The element with the event listener
    public func on(_ event: String, actions: [StateAction]) -> Element {
        let combined = actions.map(\.jsCode).joined(separator: "; ")
        return self.on(event, combined)
    }
    
    /// Adds conditional CSS classes based on state
    /// - Parameters:
    ///   - classes: CSS classes to add
    ///   - condition: JavaScript expression that evaluates to boolean
    /// - Returns: The element with conditional classes
    public func classes(_ classes: [String], when condition: String) -> Element {
        let classString = classes.joined(separator: " ")
        return self.attribute("data-state-classes", "\(condition) ? '\(classString)' : ''")
    }
    
    /// Adds conditional CSS classes based on state
    /// - Parameters:
    ///   - className: CSS class to add
    ///   - condition: JavaScript expression that evaluates to boolean
    /// - Returns: The element with conditional classes
    public func class(_ className: String, when condition: String) -> Element {
        return self.classes([className], when: condition)
    }
    
    /// Adds conditional inline styles based on state
    /// - Parameters:
    ///   - style: CSS style property and value
    ///   - condition: JavaScript expression that evaluates to boolean
    /// - Returns: The element with conditional styles
    public func style(_ style: String, when condition: String) -> Element {
        return self.attribute("data-state-style", "\(condition) ? '\(style)' : ''")
    }
    
    /// Makes the element disabled based on a state condition
    /// - Parameter condition: JavaScript expression that evaluates to boolean
    /// - Returns: The element with conditional disabled state
    public func disabled(when condition: String) -> Element {
        return self.attribute("data-state-disabled", condition)
    }
    
    /// Makes the element enabled based on a state condition
    /// - Parameter condition: JavaScript expression that evaluates to boolean
    /// - Returns: The element with conditional enabled state
    public func enabled(when condition: String) -> Element {
        return self.attribute("data-state-disabled", "!(\(condition))")
    }
}

/// Protocol for elements that can have event handlers
public protocol EventHandleable: Element {
    /// Adds an event handler with JavaScript code
    /// - Parameters:
    ///   - event: The event name
    ///   - code: JavaScript code to execute
    /// - Returns: The element with the event handler
    func on(_ event: String, _ code: String) -> Self
    
    /// Adds an attribute to the element
    /// - Parameters:
    ///   - name: Attribute name
    ///   - value: Attribute value
    /// - Returns: The element with the attribute
    func attribute(_ name: String, _ value: String) -> Self
}

/// Default implementation requiring concrete element types to implement the base methods
extension Element {
    /// Base method for adding event handlers - must be implemented by concrete elements
    public func on(_ event: String, _ code: String) -> Element {
        // This is a base implementation that will be overridden by concrete element types
        return self
    }
    
    /// Base method for adding attributes - must be implemented by concrete elements
    public func attribute(_ name: String, _ value: String) -> Element {
        // This is a base implementation that will be overridden by concrete element types
        return self
    }
}