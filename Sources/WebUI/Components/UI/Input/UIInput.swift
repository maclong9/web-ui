import Foundation

/// A headless input component with extensive customization and state management integration.
///
/// `UIInput` provides a complete input field implementation with:
/// - Minimal structural CSS (layout, spacing, structure only)
/// - Multiple input types (text, email, password, number, etc.)
/// - Size options (sm, md, lg)
/// - State management integration for two-way binding
/// - Validation support
/// - Placeholder and label support
/// - Icon support
/// - Disabled and error states
///
/// ## Design Philosophy
///
/// This input follows a headless-first approach:
/// - Provides structure and behavior without visual styling
/// - No colors, fonts, or decorative elements by default
/// - Extensive customization through CSS classes and CSS variables
/// - Can be styled with any design system or custom CSS
///
/// ## Usage
///
/// ```swift
/// // Basic text input
/// UIInput(name: "username", placeholder: "Enter username")
///
/// // Input with state binding
/// UIInput(name: "email", type: .email)
///     .bindToState(emailState, property: .value)
///
/// // Input with validation
/// UIInput(name: "password", type: .password, required: true)
///     .validation(.minLength(8))
/// ```
public struct UIInput: ComponentBase {
    // MARK: - Properties
    
    /// Input name for form submission
    public let name: String
    
    /// Input type
    public let inputType: InputType
    
    /// Placeholder text
    public let placeholder: String?
    
    /// Initial value
    public let value: String?
    
    /// Whether the input is required
    public let required: Bool
    
    /// Whether the input should autofocus
    public let autofocus: Bool
    
    /// Maximum length for text inputs
    public let maxLength: Int?
    
    /// Minimum length for text inputs
    public let minLength: Int?
    
    /// Pattern for validation (regex)
    public let pattern: String?
    
    /// Optional icon to display
    public let icon: LucideIcon?
    
    /// Icon position
    public let iconPosition: InputIconPosition
    
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
    
    // MARK: - Initialization
    
    /// Creates a new UI input with the specified configuration.
    ///
    /// - Parameters:
    ///   - name: Input name for form submission
    ///   - type: Input type (default: .text)
    ///   - placeholder: Placeholder text (default: nil)
    ///   - value: Initial value (default: nil)
    ///   - size: Input size (default: .medium)
    ///   - required: Whether input is required (default: false)
    ///   - disabled: Whether input is disabled (default: false)
    ///   - autofocus: Whether input should autofocus (default: false)
    ///   - maxLength: Maximum length for text inputs (default: nil)
    ///   - minLength: Minimum length for text inputs (default: nil)
    ///   - pattern: Validation pattern (default: nil)
    ///   - icon: Optional icon to display (default: nil)
    ///   - iconPosition: Icon position (default: .leading)
    ///   - validationState: Validation state (default: .none)
    ///   - errorMessage: Error message (default: nil)
    ///   - customClasses: Additional CSS classes (default: [])
    public init(
        name: String,
        type: InputType = .text,
        placeholder: String? = nil,
        value: String? = nil,
        size: ComponentSize = .medium,
        required: Bool = false,
        disabled: Bool = false,
        autofocus: Bool = false,
        maxLength: Int? = nil,
        minLength: Int? = nil,
        pattern: String? = nil,
        icon: LucideIcon? = nil,
        iconPosition: InputIconPosition = .leading,
        validationState: ValidationState = .none,
        errorMessage: String? = nil,
        customClasses: [String] = []
    ) {
        self.name = name
        self.inputType = type
        self.placeholder = placeholder
        self.value = value
        self.size = size
        self.required = required
        self.disabled = disabled
        self.autofocus = autofocus
        self.maxLength = maxLength
        self.minLength = minLength
        self.pattern = pattern
        self.icon = icon
        self.iconPosition = iconPosition
        self.validationState = validationState
        self.errorMessage = errorMessage
        self.customClasses = customClasses
        self.variant = .default
        self.accessibilityRole = nil // Use default input role
    }
    
    // MARK: - Element Implementation
    
    public var body: some Markup {
        let containerClasses = ["input-container"] + baseStyles.classes + 
                              (variantStyles[variant] ?? .empty).classes +
                              (sizeStyles[size] ?? .empty).classes +
                              customClasses
        
        let containerData = buildDataAttributes()
        
        return ElementBuilder.section(
            classes: containerClasses,
            data: containerData
        ) {
            inputWrapper
            if let errorMessage = errorMessage, validationState == .error {
                errorMessageElement(errorMessage)
            }
        }
    }
    
    private var inputWrapper: some Markup {
        ElementBuilder.section(
            classes: ["input-wrapper"]
        ) {
            if let icon = icon, iconPosition == .leading {
                inputIcon(icon, position: .leading)
            }
            
            inputElement
            
            if let icon = icon, iconPosition == .trailing {
                inputIcon(icon, position: .trailing)
            }
        }
    }
    
    private var inputElement: some Markup {
        var inputData: [String: String] = [:]
        inputData["validation-state"] = validationState.rawValue
        
        if let maxLength = maxLength {
            inputData["maxlength"] = maxLength.description
        }
        if let minLength = minLength {
            inputData["minlength"] = minLength.description
        }
        if let pattern = pattern {
            inputData["pattern"] = pattern
        }
        
        return ElementBuilder.input(
            name: name,
            type: inputType,
            value: value,
            placeholder: placeholder,
            required: required,
            disabled: disabled,
            classes: ["input"],
            data: inputData
        )
    }
    
    private func inputIcon(_ icon: LucideIcon, position: InputIconPosition) -> some Markup {
        Icon(icon, size: iconSizeForInputSize, classes: ["input-icon", "input-icon-\(position.rawValue)"])
    }
    
    private func errorMessageElement(_ message: String) -> some Markup {
        ElementBuilder.section(
            classes: ["input-error-message"],
            role: .alert
        ) {
            ElementBuilder.text(message)
        }
    }
    
    private var iconSizeForInputSize: Icon.IconSize {
        switch size {
        case .extraSmall: return .small
        case .small: return .small
        case .medium: return .medium
        case .large: return .large
        case .extraLarge: return .extraLarge
        }
    }
    
    private func buildDataAttributes() -> [String: String] {
        var attributes: [String: String] = [:]
        
        attributes["size"] = size.rawValue
        attributes["type"] = inputType.rawValue
        
        if disabled {
            attributes["disabled"] = "true"
        }
        
        if required {
            attributes["required"] = "true"
        }
        
        if validationState != .none {
            attributes["validation"] = validationState.rawValue
        }
        
        if let icon = icon {
            attributes["icon"] = icon.rawValue
            attributes["icon-position"] = iconPosition.rawValue
        }
        
        return attributes
    }
    
    // MARK: - Component Styles
    
    public var baseStyles: ComponentStyles {
        return ComponentStyles(
            classes: ["input-field"],
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

/// Icon position for input fields
public enum InputIconPosition: String, CaseIterable {
    case leading = "leading"
    case trailing = "trailing"
}

/// Validation state for input fields
public enum ValidationState: String, CaseIterable {
    case none = "none"
    case success = "success"
    case warning = "warning"
    case error = "error"
}

// MARK: - State Management Extensions

extension UIInput {
    /// Creates an input bound to a string state.
    ///
    /// - Parameters:
    ///   - name: Input name
    ///   - state: String state to bind to
    ///   - placeholder: Placeholder text
    ///   - type: Input type (default: .text)
    ///   - size: Input size (default: .medium)
    /// - Returns: Input with state binding
    public static func boundToState<T: Codable & Sendable>(
        name: String,
        state: any StateProtocol<T>,
        placeholder: String? = nil,
        type: InputType = .text,
        size: ComponentSize = .medium
    ) -> StateBoundMarkup<UIInput> {
        let input = UIInput(
            name: name,
            type: type,
            placeholder: placeholder,
            size: size
        )
        return input.bindToState(state, property: .value)
    }
}

// MARK: - Validation Extensions

extension UIInput {
    /// Adds validation to the input.
    ///
    /// - Parameter rule: Validation rule to apply
    /// - Returns: Input with validation
    public func validation(_ rule: ValidationRule) -> UIInput {
        switch rule {
        case .required:
            return UIInput(
                name: name,
                type: inputType,
                placeholder: placeholder,
                value: value,
                size: size,
                required: true,
                disabled: disabled,
                autofocus: autofocus,
                maxLength: maxLength,
                minLength: minLength,
                pattern: pattern,
                icon: icon,
                iconPosition: iconPosition,
                validationState: validationState,
                errorMessage: errorMessage,
                customClasses: customClasses
            )
        case .minLength(let length):
            return UIInput(
                name: name,
                type: inputType,
                placeholder: placeholder,
                value: value,
                size: size,
                required: required,
                disabled: disabled,
                autofocus: autofocus,
                maxLength: maxLength,
                minLength: length,
                pattern: pattern,
                icon: icon,
                iconPosition: iconPosition,
                validationState: validationState,
                errorMessage: errorMessage,
                customClasses: customClasses
            )
        case .maxLength(let length):
            return UIInput(
                name: name,
                type: inputType,
                placeholder: placeholder,
                value: value,
                size: size,
                required: required,
                disabled: disabled,
                autofocus: autofocus,
                maxLength: length,
                minLength: minLength,
                pattern: pattern,
                icon: icon,
                iconPosition: iconPosition,
                validationState: validationState,
                errorMessage: errorMessage,
                customClasses: customClasses
            )
        case .pattern(let regex):
            return UIInput(
                name: name,
                type: inputType,
                placeholder: placeholder,
                value: value,
                size: size,
                required: required,
                disabled: disabled,
                autofocus: autofocus,
                maxLength: maxLength,
                minLength: minLength,
                pattern: regex,
                icon: icon,
                iconPosition: iconPosition,
                validationState: validationState,
                errorMessage: errorMessage,
                customClasses: customClasses
            )
        }
    }
    
    /// Sets the validation state and error message.
    ///
    /// - Parameters:
    ///   - state: Validation state
    ///   - message: Error message (optional)
    /// - Returns: Input with validation state
    public func validationState(_ state: ValidationState, message: String? = nil) -> UIInput {
        return UIInput(
            name: name,
            type: inputType,
            placeholder: placeholder,
            value: value,
            size: size,
            required: required,
            disabled: disabled,
            autofocus: autofocus,
            maxLength: maxLength,
            minLength: minLength,
            pattern: pattern,
            icon: icon,
            iconPosition: iconPosition,
            validationState: state,
            errorMessage: message,
            customClasses: customClasses
        )
    }
}

// MARK: - Validation Rules

/// Validation rules for input fields
public enum ValidationRule {
    case required
    case minLength(Int)
    case maxLength(Int)
    case pattern(String)
}

// Note: Markup extensions are no longer needed since we're building data attributes directly
// in the ElementBuilder approach