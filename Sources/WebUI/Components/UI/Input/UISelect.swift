import Foundation

/// A headless select dropdown component with state management integration and accessibility support.
///
/// `UISelect` provides a complete select dropdown implementation with:
/// - Minimal structural CSS (layout, spacing, structure only)
/// - State management integration for two-way binding
/// - Accessibility support with proper ARIA attributes
/// - Option groups and individual options
/// - Custom styling through CSS classes
/// - Validation states
/// - Disabled states
/// - Multiple selection support
///
/// ## Design Philosophy
///
/// This select follows a headless-first approach:
/// - Provides structure and behavior without visual styling
/// - No colors, fonts, or decorative elements by default
/// - Extensive customization through CSS classes and CSS variables
/// - Can be styled with any design system or custom CSS
///
/// ## Usage
///
/// ```swift
/// // Basic select
/// UISelect(name: "country", options: [
///     SelectOption(value: "us", label: "United States"),
///     SelectOption(value: "ca", label: "Canada")
/// ])
///
/// // Select with state binding
/// UISelect(name: "theme", options: themeOptions)
///     .bindToState(themeState, property: .value)
///
/// // Select with validation
/// UISelect(name: "category", options: categoryOptions, required: true)
///     .validationState(.error, message: "Please select a category")
/// ```
public struct UISelect: ComponentBase {
    // MARK: - Properties
    
    /// Select name for form submission
    public let name: String
    
    /// Available options
    public let options: [SelectOption]
    
    /// Optional placeholder text
    public let placeholder: String?
    
    /// Currently selected value
    public let selectedValue: String?
    
    /// Whether the select is required
    public let required: Bool
    
    /// Whether multiple selection is allowed
    public let multiple: Bool
    
    /// Maximum number of selections for multiple select
    public let maxSelections: Int?
    
    /// Optional icon to display
    public let icon: LucideIcon?
    
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
    
    /// Help text
    public let helpText: String?
    
    // MARK: - Initialization
    
    /// Creates a new UI select with the specified configuration.
    ///
    /// - Parameters:
    ///   - name: Select name for form submission
    ///   - options: Available options
    ///   - placeholder: Placeholder text (default: nil)
    ///   - selectedValue: Currently selected value (default: nil)
    ///   - size: Select size (default: .medium)
    ///   - required: Whether select is required (default: false)
    ///   - disabled: Whether select is disabled (default: false)
    ///   - multiple: Whether multiple selection is allowed (default: false)
    ///   - maxSelections: Maximum selections for multiple select (default: nil)
    ///   - icon: Optional icon to display (default: nil)
    ///   - validationState: Validation state (default: .none)
    ///   - errorMessage: Error message (default: nil)
    ///   - helpText: Help text (default: nil)
    ///   - customClasses: Additional CSS classes (default: [])
    public init(
        name: String,
        options: [SelectOption],
        placeholder: String? = nil,
        selectedValue: String? = nil,
        size: ComponentSize = .medium,
        required: Bool = false,
        disabled: Bool = false,
        multiple: Bool = false,
        maxSelections: Int? = nil,
        icon: LucideIcon? = nil,
        validationState: ValidationState = .none,
        errorMessage: String? = nil,
        helpText: String? = nil,
        customClasses: [String] = []
    ) {
        self.name = name
        self.options = options
        self.placeholder = placeholder
        self.selectedValue = selectedValue
        self.size = size
        self.required = required
        self.disabled = disabled
        self.multiple = multiple
        self.maxSelections = maxSelections
        self.icon = icon
        self.validationState = validationState
        self.errorMessage = errorMessage
        self.helpText = helpText
        self.customClasses = customClasses
        self.variant = .default
        self.accessibilityRole = nil // Use default combobox role
    }
    
    // MARK: - Element Implementation
    
    public var body: some Markup {
        let containerClasses = ["select-container"] + baseStyles.classes + 
                              (variantStyles[variant] ?? .empty).classes +
                              (sizeStyles[size] ?? .empty).classes +
                              customClasses
        
        let containerData = buildDataAttributes()
        
        return ElementBuilder.section(
            classes: containerClasses,
            data: containerData
        ) {
            selectWrapper
            
            if let helpText = helpText {
                helpTextElement(helpText)
            }
            
            if let errorMessage = errorMessage, validationState == .error {
                errorMessageElement(errorMessage)
            }
        }
    }
    
    private var selectWrapper: some Markup {
        ElementBuilder.section(
            classes: ["select-wrapper"]
        ) {
            if let icon = icon {
                selectIcon(icon)
            }
            
            selectElement
            chevronIcon
        }
    }
    
    private var selectElement: some Markup {
        var selectData: [String: String] = [:]
        selectData["validation-state"] = validationState.rawValue
        
        if multiple {
            selectData["multiple"] = "true"
        }
        
        if let maxSelections = maxSelections {
            selectData["max-selections"] = maxSelections.description
        }
        
        return Select(
            name: name,
            required: required ? true : nil,
            disabled: disabled ? true : nil,
            multiple: multiple ? true : nil,
            classes: ["select-input"],
            data: selectData.isEmpty ? nil : selectData
        ) {
            if let placeholder = placeholder {
                Option(value: "", selected: selectedValue == nil, disabled: true) {
                    placeholder
                }
            }
            
            let optionElements: [any Markup] = options.map { option in
                Option(
                    value: option.value,
                    selected: option.value == selectedValue,
                    disabled: option.disabled ? true : nil
                ) {
                    option.label
                }
            }
            
            MarkupString(content: optionElements.map { $0.render() }.joined())
        }
    }
    
    private func selectIcon(_ icon: LucideIcon) -> some Markup {
        Icon(icon, size: iconSizeForSelectSize, classes: ["select-icon"])
    }
    
    private var chevronIcon: some Markup {
        Icon(.chevronDown, size: iconSizeForSelectSize, classes: ["select-chevron"])
    }
    
    private func helpTextElement(_ text: String) -> some Markup {
        ElementBuilder.section(
            classes: ["select-help-text"]
        ) {
            ElementBuilder.text(text)
        }
    }
    
    private func errorMessageElement(_ message: String) -> some Markup {
        ElementBuilder.section(
            classes: ["select-error-message"],
            role: .alert
        ) {
            ElementBuilder.text(message)
        }
    }
    
    private var iconSizeForSelectSize: Icon.IconSize {
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
        
        if disabled {
            attributes["disabled"] = "true"
        }
        
        if required {
            attributes["required"] = "true"
        }
        
        if multiple {
            attributes["multiple"] = "true"
        }
        
        if validationState != .none {
            attributes["validation"] = validationState.rawValue
        }
        
        if let icon = icon {
            attributes["icon"] = icon.rawValue
        }
        
        return attributes
    }
    
    // MARK: - Component Styles
    
    public var baseStyles: ComponentStyles {
        return ComponentStyles(
            classes: ["select-field"],
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

/// A single option in a select dropdown
public struct SelectOption: Identifiable, Sendable {
    public let id = UUID()
    
    /// Option value for form submission
    public let value: String
    
    /// Display label for the option
    public let label: String
    
    /// Whether the option is disabled
    public let disabled: Bool
    
    /// Optional group for organizing options
    public let group: String?
    
    /// Additional metadata
    public let metadata: [String: String]
    
    public init(
        value: String,
        label: String,
        disabled: Bool = false,
        group: String? = nil,
        metadata: [String: String] = [:]
    ) {
        self.value = value
        self.label = label
        self.disabled = disabled
        self.group = group
        self.metadata = metadata
    }
}

// MARK: - State Management Extensions

extension UISelect {
    /// Creates a select bound to a string state.
    ///
    /// - Parameters:
    ///   - name: Select name
    ///   - options: Available options
    ///   - state: String state to bind to
    ///   - placeholder: Placeholder text
    ///   - size: Select size (default: .medium)
    /// - Returns: Select with state binding
    public static func boundToState<T: Codable & Sendable>(
        name: String,
        options: [SelectOption],
        state: any StateProtocol<T>,
        placeholder: String? = nil,
        size: ComponentSize = .medium
    ) -> StateBoundMarkup<UISelect> {
        let select = UISelect(
            name: name,
            options: options,
            placeholder: placeholder,
            size: size
        )
        return select.bindToState(state, property: .value)
    }
}

// MARK: - Validation Extensions

extension UISelect {
    /// Sets the validation state and error message.
    ///
    /// - Parameters:
    ///   - state: Validation state
    ///   - message: Error message (optional)
    /// - Returns: Select with validation state
    public func validationState(_ state: ValidationState, message: String? = nil) -> UISelect {
        return UISelect(
            name: name,
            options: options,
            placeholder: placeholder,
            selectedValue: selectedValue,
            size: size,
            required: required,
            disabled: disabled,
            multiple: multiple,
            maxSelections: maxSelections,
            icon: icon,
            validationState: state,
            errorMessage: message,
            helpText: helpText,
            customClasses: customClasses
        )
    }
    
    /// Marks the select as required.
    ///
    /// - Returns: Required select
    public func required(_ isRequired: Bool = true) -> UISelect {
        return UISelect(
            name: name,
            options: options,
            placeholder: placeholder,
            selectedValue: selectedValue,
            size: size,
            required: isRequired,
            disabled: disabled,
            multiple: multiple,
            maxSelections: maxSelections,
            icon: icon,
            validationState: validationState,
            errorMessage: errorMessage,
            helpText: helpText,
            customClasses: customClasses
        )
    }
    
    /// Adds help text to the select.
    ///
    /// - Parameter text: Help text
    /// - Returns: Select with help text
    public func helpText(_ text: String) -> UISelect {
        return UISelect(
            name: name,
            options: options,
            placeholder: placeholder,
            selectedValue: selectedValue,
            size: size,
            required: required,
            disabled: disabled,
            multiple: multiple,
            maxSelections: maxSelections,
            icon: icon,
            validationState: validationState,
            errorMessage: errorMessage,
            helpText: text,
            customClasses: customClasses
        )
    }
}

// MARK: - Convenience Initializers

extension UISelect {
    /// Creates a simple select with string options.
    ///
    /// - Parameters:
    ///   - name: Select name
    ///   - optionLabels: Option labels (values will be the same as labels)
    ///   - placeholder: Placeholder text
    ///   - selectedValue: Selected value
    /// - Returns: Simple select
    public static func simple(
        name: String,
        optionLabels: [String],
        placeholder: String? = nil,
        selectedValue: String? = nil
    ) -> UISelect {
        let options = optionLabels.map { label in
            SelectOption(value: label, label: label)
        }
        
        return UISelect(
            name: name,
            options: options,
            placeholder: placeholder,
            selectedValue: selectedValue
        )
    }
    
    /// Creates a multi-select dropdown.
    ///
    /// - Parameters:
    ///   - name: Select name
    ///   - options: Available options
    ///   - maxSelections: Maximum number of selections
    ///   - placeholder: Placeholder text
    /// - Returns: Multi-select dropdown
    public static func multiSelect(
        name: String,
        options: [SelectOption],
        maxSelections: Int? = nil,
        placeholder: String? = nil
    ) -> UISelect {
        return UISelect(
            name: name,
            options: options,
            placeholder: placeholder,
            multiple: true,
            maxSelections: maxSelections
        )
    }
}