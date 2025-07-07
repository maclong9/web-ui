import Foundation

/// A headless checkbox component with state management integration and accessibility support.
///
/// `UICheckbox` provides a complete checkbox implementation with:
/// - Minimal structural CSS (layout, spacing, structure only)
/// - State management integration for two-way binding
/// - Accessibility support with proper ARIA attributes
/// - Label association and positioning
/// - Custom styling through CSS classes
/// - Validation states
/// - Disabled states
///
/// ## Design Philosophy
///
/// This checkbox follows a headless-first approach:
/// - Provides structure and behavior without visual styling
/// - No colors, fonts, or decorative elements by default
/// - Extensive customization through CSS classes and CSS variables
/// - Can be styled with any design system or custom CSS
///
/// ## Usage
///
/// ```swift
/// // Basic checkbox
/// UICheckbox(name: "terms", label: "I agree to the terms")
///
/// // Checkbox with state binding
/// UICheckbox(name: "notifications", label: "Email notifications")
///     .bindToState(notificationState, property: .checked)
///
/// // Checkbox with validation
/// UICheckbox(name: "required_field", label: "Required field", required: true)
///     .validationState(.error, message: "This field is required")
/// ```
public struct UICheckbox: ComponentBase {
    // MARK: - Properties
    
    /// Checkbox name for form submission
    public let name: String
    
    /// Label text for the checkbox
    public let label: String
    
    /// Whether the checkbox is initially checked
    public let checked: Bool
    
    /// Whether the checkbox is required
    public let required: Bool
    
    /// Position of the label relative to the checkbox
    public let labelPosition: LabelPosition
    
    /// Value to submit when checked (default: "on")
    public let value: String
    
    /// Component base properties
    public var variant: ComponentVariant
    public var size: ComponentSize
    public var disabled: Bool
    public var customClasses: [String]
    public var accessibilityRole: AriaRole?
    
    /// Validation state
    public let validationState: ValidationState
    
    /// Error message
    public let errorMessage: String?
    
    /// Description text (optional help text)
    public let description: String?
    
    // MARK: - Initialization
    
    /// Creates a new UI checkbox with the specified configuration.
    ///
    /// - Parameters:
    ///   - name: Checkbox name for form submission
    ///   - label: Label text for the checkbox
    ///   - checked: Whether checkbox is initially checked (default: false)
    ///   - value: Value to submit when checked (default: "on")
    ///   - size: Checkbox size (default: .medium)
    ///   - required: Whether checkbox is required (default: false)
    ///   - disabled: Whether checkbox is disabled (default: false)
    ///   - labelPosition: Position of label relative to checkbox (default: .trailing)
    ///   - validationState: Validation state (default: .none)
    ///   - errorMessage: Error message (default: nil)
    ///   - description: Description text (default: nil)
    ///   - customClasses: Additional CSS classes (default: [])
    public init(
        name: String,
        label: String,
        checked: Bool = false,
        value: String = "on",
        size: ComponentSize = .medium,
        required: Bool = false,
        disabled: Bool = false,
        labelPosition: LabelPosition = .trailing,
        validationState: ValidationState = .none,
        errorMessage: String? = nil,
        description: String? = nil,
        customClasses: [String] = []
    ) {
        self.name = name
        self.label = label
        self.checked = checked
        self.value = value
        self.size = size
        self.required = required
        self.disabled = disabled
        self.labelPosition = labelPosition
        self.validationState = validationState
        self.errorMessage = errorMessage
        self.description = description
        self.customClasses = customClasses
        self.variant = .default
        self.accessibilityRole = nil // Use default checkbox role
    }
    
    // MARK: - Element Implementation
    
    public var body: some Markup {
        let containerClasses = ["checkbox-container"] + baseStyles.classes + 
                              (variantStyles[variant] ?? .empty).classes +
                              (sizeStyles[size] ?? .empty).classes +
                              customClasses
        
        let containerData = buildDataAttributes()
        
        return ElementBuilder.section(
            classes: containerClasses,
            data: containerData
        ) {
            checkboxWrapper
            
            if let description = description {
                descriptionElement(description)
            }
            
            if let errorMessage = errorMessage, validationState == .error {
                errorMessageElement(errorMessage)
            }
        }
    }
    
    private var checkboxWrapper: some Markup {
        ElementBuilder.section(
            classes: ["checkbox-wrapper", "checkbox-\(labelPosition.rawValue)"]
        ) {
            if labelPosition == .leading {
                labelElement
            }
            
            checkboxElement
            
            if labelPosition == .trailing {
                labelElement
            }
        }
    }
    
    private var checkboxElement: some Markup {
        var inputData: [String: String] = [:]
        inputData["validation-state"] = validationState.rawValue
        
        if checked {
            inputData["checked"] = "true"
        }
        
        return ElementBuilder.input(
            name: name,
            type: .checkbox,
            value: value,
            required: required,
            disabled: disabled,
            classes: ["checkbox-input"],
            data: inputData
        )
    }
    
    private var labelElement: some Markup {
        Label(
            for: name,
            classes: ["checkbox-label"],
            data: nil
        ) {
            ElementBuilder.text(label)
        }
    }
    
    private func descriptionElement(_ text: String) -> some Markup {
        ElementBuilder.section(
            classes: ["checkbox-description"]
        ) {
            ElementBuilder.text(text)
        }
    }
    
    private func errorMessageElement(_ message: String) -> some Markup {
        ElementBuilder.section(
            classes: ["checkbox-error-message"],
            role: .alert
        ) {
            ElementBuilder.text(message)
        }
    }
    
    private func buildDataAttributes() -> [String: String] {
        var attributes: [String: String] = [:]
        
        attributes["size"] = size.rawValue
        attributes["label-position"] = labelPosition.rawValue
        
        if disabled {
            attributes["disabled"] = "true"
        }
        
        if required {
            attributes["required"] = "true"
        }
        
        if validationState != .none {
            attributes["validation"] = validationState.rawValue
        }
        
        if checked {
            attributes["checked"] = "true"
        }
        
        return attributes
    }
    
    // MARK: - Component Styles
    
    public var baseStyles: ComponentStyles {
        return ComponentStyles(
            classes: ["checkbox"],
            properties: [:],
            dataAttributes: [:]
        )
    }
    
    public var variantStyles: [ComponentVariant: ComponentStyles] {
        return [
            .default: ComponentStyles(classes: ["variant-default"])
        ]
    }
    
    public var sizeStyles: [ComponentSize: ComponentStyles] {
        return [
            .small: ComponentStyles(classes: ["size-sm"]),
            .medium: ComponentStyles(classes: ["size-md"]),
            .large: ComponentStyles(classes: ["size-lg"])
        ]
    }
}

// MARK: - Supporting Types

/// Label position relative to checkbox
public enum LabelPosition: String, CaseIterable {
    case leading = "leading"
    case trailing = "trailing"
}

// MARK: - State Management Extensions

extension UICheckbox {
    /// Creates a checkbox bound to a boolean state.
    ///
    /// - Parameters:
    ///   - name: Checkbox name
    ///   - label: Label text
    ///   - state: Boolean state to bind to
    ///   - size: Checkbox size (default: .medium)
    /// - Returns: Checkbox with state binding
    public static func boundToState(
        name: String,
        label: String,
        state: any StateProtocol<Bool>,
        size: ComponentSize = .medium
    ) -> StateBoundMarkup<UICheckbox> {
        let checkbox = UICheckbox(
            name: name,
            label: label,
            size: size
        )
        return checkbox.bindToState(state, property: .checked)
    }
}

// MARK: - Validation Extensions

extension UICheckbox {
    /// Sets the validation state and error message.
    ///
    /// - Parameters:
    ///   - state: Validation state
    ///   - message: Error message (optional)
    /// - Returns: Checkbox with validation state
    public func validationState(_ state: ValidationState, message: String? = nil) -> UICheckbox {
        return UICheckbox(
            name: name,
            label: label,
            checked: checked,
            value: value,
            size: size,
            required: required,
            disabled: disabled,
            labelPosition: labelPosition,
            validationState: state,
            errorMessage: message,
            description: description,
            customClasses: customClasses
        )
    }
    
    /// Marks the checkbox as required.
    ///
    /// - Returns: Required checkbox
    public func required(_ isRequired: Bool = true) -> UICheckbox {
        return UICheckbox(
            name: name,
            label: label,
            checked: checked,
            value: value,
            size: size,
            required: isRequired,
            disabled: disabled,
            labelPosition: labelPosition,
            validationState: validationState,
            errorMessage: errorMessage,
            description: description,
            customClasses: customClasses
        )
    }
    
    /// Adds description text to the checkbox.
    ///
    /// - Parameter text: Description text
    /// - Returns: Checkbox with description
    public func description(_ text: String) -> UICheckbox {
        return UICheckbox(
            name: name,
            label: label,
            checked: checked,
            value: value,
            size: size,
            required: required,
            disabled: disabled,
            labelPosition: labelPosition,
            validationState: validationState,
            errorMessage: errorMessage,
            description: text,
            customClasses: customClasses
        )
    }
}

// MARK: - Convenience Initializers

extension UICheckbox {
    /// Creates a simple checkbox with minimal configuration.
    ///
    /// - Parameters:
    ///   - name: Checkbox name
    ///   - label: Label text
    ///   - checked: Initial checked state (default: false)
    /// - Returns: Basic checkbox
    public static func simple(
        name: String,
        label: String,
        checked: Bool = false
    ) -> UICheckbox {
        return UICheckbox(
            name: name,
            label: label,
            checked: checked
        )
    }
    
    /// Creates a required checkbox.
    ///
    /// - Parameters:
    ///   - name: Checkbox name
    ///   - label: Label text
    ///   - checked: Initial checked state (default: false)
    /// - Returns: Required checkbox
    public static func required(
        name: String,
        label: String,
        checked: Bool = false
    ) -> UICheckbox {
        return UICheckbox(
            name: name,
            label: label,
            checked: checked,
            required: true
        )
    }
}