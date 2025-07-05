import Foundation

/// A headless button component with extensive customization options and built-in accessibility.
///
/// `UIButton` provides a complete button implementation with:
/// - Minimal structural CSS (layout, spacing, structure only)
/// - Multiple variants (default, primary, secondary, outline, ghost, link)
/// - Size options (xs, sm, md, lg, xl)
/// - State management integration
/// - Full accessibility support
/// - Icon support with flexible positioning
/// - Loading states
/// - Disabled states
///
/// ## Design Philosophy
///
/// This button follows a headless-first approach:
/// - Provides structure and behavior without visual styling
/// - No colors, fonts, or decorative elements by default
/// - Extensive customization through CSS classes and CSS variables
/// - Can be styled with any design system or custom CSS
///
/// ## Usage
///
/// ```swift
/// // Basic button
/// UIButton("Click me")
///
/// // Primary button with icon
/// UIButton("Save", variant: .primary, size: .lg, icon: .save)
///
/// // Button with state management
/// UIButton("Toggle", variant: .secondary)
///     .onClick(toggleState, action: .toggle)
///
/// // Custom styled button
/// UIButton("Custom", customClasses: ["my-custom-btn"])
/// ```
public struct UIButton: ComponentBase {
    // MARK: - Properties
    
    /// Button text content
    public let text: String
    
    /// Optional icon to display
    public let icon: LucideIcon?
    
    /// Icon position relative to text
    public let iconPosition: IconPosition
    
    /// Whether the button is in a loading state
    public let loading: Bool
    
    /// Button type for form submission
    public let type: ButtonType
    
    /// Component base properties
    public var variant: ComponentVariant
    public var size: ComponentSize
    public var disabled: Bool
    public var customClasses: [String]
    public var accessibilityRole: AriaRole?
    
    /// Optional click handler action
    public let clickAction: ButtonClickAction?
    
    // MARK: - Initialization
    
    /// Creates a new UI button with the specified configuration.
    ///
    /// - Parameters:
    ///   - text: Button text content
    ///   - variant: Button variant style (default: .default)
    ///   - size: Button size (default: .medium)
    ///   - icon: Optional icon to display (default: nil)
    ///   - iconPosition: Position of icon relative to text (default: .leading)
    ///   - loading: Whether button is in loading state (default: false)
    ///   - disabled: Whether button is disabled (default: false)
    ///   - type: HTML button type (default: .button)
    ///   - customClasses: Additional CSS classes (default: [])
    ///   - clickAction: Optional click action for state management (default: nil)
    public init(
        _ text: String,
        variant: ComponentVariant = .default,
        size: ComponentSize = .medium,
        icon: LucideIcon? = nil,
        iconPosition: IconPosition = .leading,
        loading: Bool = false,
        disabled: Bool = false,
        type: ButtonType = .button,
        customClasses: [String] = [],
        clickAction: ButtonClickAction? = nil
    ) {
        self.text = text
        self.variant = variant
        self.size = size
        self.icon = icon
        self.iconPosition = iconPosition
        self.loading = loading
        self.disabled = disabled
        self.type = type
        self.customClasses = customClasses
        self.accessibilityRole = .button
        self.clickAction = clickAction
    }
    
    // MARK: - Element Implementation
    
    public var body: some Markup {
        let allClasses = baseStyles.classes + 
                        (variantStyles[variant] ?? .empty).classes +
                        (sizeStyles[size] ?? .empty).classes +
                        customClasses
        
        let allData = buildDataAttributes()
        
        return ElementBuilder.button(
            buttonText,
            type: type,
            disabled: disabled || loading,
            classes: allClasses,
            data: allData,
            onClick: nil // Can be added when needed
        )
    }
    
    // MARK: - Private Implementation
    
    private var buttonText: String {
        // For now, we'll handle icons through CSS classes and data attributes
        // The button text will be enhanced by CSS based on data attributes
        if loading {
            return text.isEmpty ? "" : text
        } else {
            return text
        }
    }
    
    private var iconSizeForButtonSize: Icon.IconSize {
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
        
        attributes["variant"] = variant.rawValue
        attributes["size"] = size.rawValue
        
        if loading {
            attributes["loading"] = "true"
        }
        
        if disabled {
            attributes["disabled"] = "true"
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
            classes: ["btn"],
            properties: [:],
            dataAttributes: [:]
        )
    }
    
    public var variantStyles: [ComponentVariant: ComponentStyles] {
        return [
            .default: ComponentStyles(classes: ["variant-default"]),
            .primary: ComponentStyles(classes: ["variant-primary"]),
            .secondary: ComponentStyles(classes: ["variant-secondary"]),
            .success: ComponentStyles(classes: ["variant-success"]),
            .warning: ComponentStyles(classes: ["variant-warning"]),
            .danger: ComponentStyles(classes: ["variant-danger"]),
            .ghost: ComponentStyles(classes: ["variant-ghost"]),
            .link: ComponentStyles(classes: ["variant-link"]),
            .outline: ComponentStyles(classes: ["variant-outline"])
        ]
    }
    
    public var sizeStyles: [ComponentSize: ComponentStyles] {
        return [
            .extraSmall: ComponentStyles(classes: ["size-xs"]),
            .small: ComponentStyles(classes: ["size-sm"]),
            .medium: ComponentStyles(classes: ["size-md"]),
            .large: ComponentStyles(classes: ["size-lg"]),
            .extraLarge: ComponentStyles(classes: ["size-xl"])
        ]
    }
}

// MARK: - Supporting Types

/// Icon position relative to button text
public enum IconPosition: String, CaseIterable {
    case leading = "leading"
    case trailing = "trailing"
    case only = "only"
}

/// Button click action for state management integration
public enum ButtonClickAction {
    case toggle
    case increment
    case decrement
    case custom(String)
    
    var actionName: String {
        switch self {
        case .toggle: return "toggle"
        case .increment: return "increment"
        case .decrement: return "decrement"
        case .custom(let action): return action
        }
    }
}

// MARK: - State Management Extensions

extension UIButton {
    /// Creates a button that toggles a boolean state when clicked.
    ///
    /// - Parameters:
    ///   - text: Button text
    ///   - state: Boolean state to toggle
    ///   - variant: Button variant (default: .default)
    ///   - size: Button size (default: .medium)
    /// - Returns: Button with toggle functionality
    public static func toggle(
        _ text: String,
        state: any StateProtocol<Bool>,
        variant: ComponentVariant = .default,
        size: ComponentSize = .medium
    ) -> ClickHandlerMarkup<UIButton> {
        let button = UIButton(
            text,
            variant: variant,
            size: size,
            clickAction: .toggle
        )
        return button.onClick(state, action: .toggle)
    }
    
    /// Creates a button that increments a numeric state when clicked.
    ///
    /// - Parameters:
    ///   - text: Button text
    ///   - state: Numeric state to increment
    ///   - variant: Button variant (default: .default)
    ///   - size: Button size (default: .medium)
    /// - Returns: Button with increment functionality
    public static func increment<T: Numeric & Codable & Sendable>(
        _ text: String,
        state: any StateProtocol<T>,
        variant: ComponentVariant = .default,
        size: ComponentSize = .medium
    ) -> ClickHandlerMarkup<UIButton> {
        let button = UIButton(
            text,
            variant: variant,
            size: size,
            clickAction: .increment
        )
        return button.onClick(state, action: .increment)
    }
}

// MARK: - Convenience Initializers

extension UIButton {
    /// Creates an icon-only button.
    ///
    /// - Parameters:
    ///   - icon: Icon to display
    ///   - variant: Button variant (default: .default)
    ///   - size: Button size (default: .medium)
    ///   - disabled: Whether button is disabled (default: false)
    ///   - customClasses: Additional CSS classes (default: [])
    /// - Returns: Icon-only button
    public static func icon(
        _ icon: LucideIcon,
        variant: ComponentVariant = .default,
        size: ComponentSize = .medium,
        disabled: Bool = false,
        customClasses: [String] = []
    ) -> UIButton {
        return UIButton(
            "",
            variant: variant,
            size: size,
            icon: icon,
            iconPosition: .only,
            disabled: disabled,
            customClasses: customClasses
        )
    }
    
    /// Creates a loading button.
    ///
    /// - Parameters:
    ///   - text: Button text (shown alongside loading spinner)
    ///   - variant: Button variant (default: .primary)
    ///   - size: Button size (default: .medium)
    ///   - customClasses: Additional CSS classes (default: [])
    /// - Returns: Button in loading state
    public static func loading(
        _ text: String,
        variant: ComponentVariant = .primary,
        size: ComponentSize = .medium,
        customClasses: [String] = []
    ) -> UIButton {
        return UIButton(
            text,
            variant: variant,
            size: size,
            loading: true,
            disabled: true,
            customClasses: customClasses
        )
    }
}