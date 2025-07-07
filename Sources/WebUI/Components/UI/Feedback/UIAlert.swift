import Foundation

/// A headless alert component for displaying important messages with accessibility support.
///
/// `UIAlert` provides a complete alert implementation with:
/// - Minimal structural CSS (layout, spacing, structure only)
/// - Multiple alert types (info, success, warning, error)
/// - Dismissible alerts with close button
/// - Icon support for visual context
/// - Action buttons for user interaction
/// - Accessibility support with proper ARIA attributes
/// - Custom styling through CSS classes
///
/// ## Design Philosophy
///
/// This alert follows a headless-first approach:
/// - Provides structure and behavior without visual styling
/// - No colors, fonts, or decorative elements by default
/// - Extensive customization through CSS classes and CSS variables
/// - Can be styled with any design system or custom CSS
///
/// ## Usage
///
/// ```swift
/// // Basic info alert
/// UIAlert(type: .info, title: "Information", message: "This is an informational message.")
///
/// // Success alert with dismiss button
/// UIAlert(
///     type: .success,
///     title: "Success!",
///     message: "Your changes have been saved.",
///     dismissible: true
/// )
///
/// // Error alert with action button
/// UIAlert(
///     type: .error,
///     title: "Error",
///     message: "Something went wrong.",
///     actions: [
///         AlertAction(label: "Retry", style: .primary, action: "retry"),
///         AlertAction(label: "Cancel", style: .secondary, action: "cancel")
///     ]
/// )
/// ```
public struct UIAlert: ComponentBase {
    // MARK: - Properties
    
    /// Alert type/severity level
    public let alertType: AlertType
    
    /// Alert title
    public let title: String?
    
    /// Alert message content
    public let message: String
    
    /// Whether the alert can be dismissed
    public let dismissible: Bool
    
    /// Action buttons
    public let actions: [AlertAction]
    
    /// Custom icon (overrides default type icon)
    public let customIcon: LucideIcon?
    
    /// Whether to show the default type icon
    public let showIcon: Bool
    
    /// Alert role for accessibility
    public let alertRole: AlertRole
    
    /// Component base properties
    public var variant: ComponentVariant
    public var size: ComponentSize
    public var disabled: Bool
    public var customClasses: [String]
    public var accessibilityRole: AriaRole?
    
    // MARK: - Initialization
    
    /// Creates a new UI alert with the specified configuration.
    ///
    /// - Parameters:
    ///   - type: Alert type (default: .info)
    ///   - title: Alert title (default: nil)
    ///   - message: Alert message
    ///   - dismissible: Whether alert can be dismissed (default: false)
    ///   - actions: Action buttons (default: [])
    ///   - customIcon: Custom icon override (default: nil)
    ///   - showIcon: Whether to show type icon (default: true)
    ///   - alertRole: Accessibility role (default: .alert)
    ///   - size: Alert size (default: .medium)
    ///   - customClasses: Additional CSS classes (default: [])
    public init(
        type: AlertType = .info,
        title: String? = nil,
        message: String,
        dismissible: Bool = false,
        actions: [AlertAction] = [],
        customIcon: LucideIcon? = nil,
        showIcon: Bool = true,
        alertRole: AlertRole = .alert,
        size: ComponentSize = .medium,
        customClasses: [String] = []
    ) {
        self.alertType = type
        self.title = title
        self.message = message
        self.dismissible = dismissible
        self.actions = actions
        self.customIcon = customIcon
        self.showIcon = showIcon
        self.alertRole = alertRole
        self.size = size
        self.customClasses = customClasses
        self.variant = .default
        self.disabled = false
        self.accessibilityRole = alertRole.ariaRole
    }
    
    // MARK: - Element Implementation
    
    public var body: some Markup {
        let allClasses = baseStyles.classes + 
                        typeClasses +
                        (sizeStyles[size] ?? .empty).classes +
                        customClasses
        
        let allData = buildDataAttributes()
        
        return ElementBuilder.section(
            classes: allClasses,
            role: alertRole.ariaRole,
            data: allData
        ) {
            alertContent
            
            if dismissible {
                dismissButton
            }
        }
    }
    
    private var alertContent: some Markup {
        ElementBuilder.section(
            classes: ["alert-content"]
        ) {
            if showIcon {
                alertIcon
            }
            
            alertText
            
            if !actions.isEmpty {
                alertActions
            }
        }
    }
    
    private var alertIcon: some Markup {
        let icon = customIcon ?? alertType.defaultIcon
        
        return Icon(
            icon,
            size: iconSizeForAlertSize,
            classes: ["alert-icon", "alert-icon-\(alertType.rawValue)"]
        )
    }
    
    private var alertText: some Markup {
        ElementBuilder.section(
            classes: ["alert-text"]
        ) {
            if let title = title {
                alertTitle(title)
            }
            
            alertMessage(message)
        }
    }
    
    private func alertTitle(_ title: String) -> some Markup {
        Heading(.subheadline, title, classes: ["alert-title"])
    }
    
    private func alertMessage(_ message: String) -> some Markup {
        ElementBuilder.text(message, classes: ["alert-message"])
    }
    
    private var alertActions: some Markup {
        ElementBuilder.section(
            classes: ["alert-actions"]
        ) {
            for action in actions {
                alertActionButton(action)
            }
        }
    }
    
    private func alertActionButton(_ action: AlertAction) -> some Markup {
        let buttonClasses = ["alert-action", "alert-action-\(action.style.rawValue)"]
        
        return ElementBuilder.button(
            action.label,
            type: .button,
            disabled: action.disabled,
            classes: buttonClasses,
            data: [
                "action": action.action,
                "style": action.style.rawValue
            ]
        )
    }
    
    private var dismissButton: some Markup {
        Button(
            type: .button,
            classes: ["alert-dismiss"],
            data: [
                "alert-dismiss": "true",
                "aria-label": "Dismiss alert"
            ]
        ) {
            Icon(.x, size: .small, classes: ["alert-dismiss-icon"])
        }
    }
    
    private var typeClasses: [String] {
        return ["alert-\(alertType.rawValue)"]
    }
    
    private var iconSizeForAlertSize: Icon.IconSize {
        switch size {
        case .extraSmall: return .small
        case .small: return .small
        case .medium: return .medium
        case .large: return .medium
        case .extraLarge: return .large
        }
    }
    
    private func buildDataAttributes() -> [String: String] {
        var attributes: [String: String] = [:]
        
        attributes["alert-type"] = alertType.rawValue
        attributes["size"] = size.rawValue
        attributes["role"] = alertRole.rawValue
        
        if dismissible {
            attributes["dismissible"] = "true"
        }
        
        if showIcon {
            attributes["show-icon"] = "true"
        }
        
        if !actions.isEmpty {
            attributes["has-actions"] = "true"
        }
        
        if let customIcon = customIcon {
            attributes["custom-icon"] = customIcon.rawValue
        }
        
        return attributes
    }
    
    // MARK: - Component Styles
    
    public var baseStyles: ComponentStyles {
        return ComponentStyles(
            classes: ["alert"],
            properties: [:],
            dataAttributes: [:]
        )
    }
    
    public var variantStyles: [ComponentVariant: ComponentStyles] {
        return [:] // Alerts use type-based styling instead
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

/// Alert types with semantic meaning
public enum AlertType: String, CaseIterable {
    case info = "info"
    case success = "success"
    case warning = "warning"
    case error = "error"
    
    /// Default icon for each alert type
    var defaultIcon: LucideIcon {
        switch self {
        case .info:
            return .info
        case .success:
            return .checkCircle
        case .warning:
            return .alertTriangle
        case .error:
            return .xCircle
        }
    }
}

/// Alert action button configuration
public struct AlertAction: Identifiable, Sendable {
    public let id = UUID()
    public let label: String
    public let action: String
    public let style: ActionStyle
    public let disabled: Bool
    
    public init(
        label: String,
        action: String,
        style: ActionStyle = .secondary,
        disabled: Bool = false
    ) {
        self.label = label
        self.action = action
        self.style = style
        self.disabled = disabled
    }
}

/// Alert action button styles
public enum ActionStyle: String, CaseIterable, Sendable {
    case primary = "primary"
    case secondary = "secondary"
    case destructive = "destructive"
    case ghost = "ghost"
}

/// Alert accessibility roles
public enum AlertRole: String, CaseIterable {
    case alert = "alert"
    case alertdialog = "alertdialog"
    case status = "status"
    
    var ariaRole: AriaRole {
        switch self {
        case .alert:
            return .alert
        case .alertdialog:
            return .alertdialog
        case .status:
            return .status
        }
    }
}

// MARK: - Convenience Initializers

extension UIAlert {
    /// Creates an info alert.
    ///
    /// - Parameters:
    ///   - title: Alert title
    ///   - message: Alert message
    ///   - dismissible: Whether alert can be dismissed
    /// - Returns: Info alert
    public static func info(
        title: String? = nil,
        message: String,
        dismissible: Bool = false
    ) -> UIAlert {
        return UIAlert(
            type: .info,
            title: title,
            message: message,
            dismissible: dismissible
        )
    }
    
    /// Creates a success alert.
    ///
    /// - Parameters:
    ///   - title: Alert title
    ///   - message: Alert message
    ///   - dismissible: Whether alert can be dismissed
    /// - Returns: Success alert
    public static func success(
        title: String? = nil,
        message: String,
        dismissible: Bool = false
    ) -> UIAlert {
        return UIAlert(
            type: .success,
            title: title,
            message: message,
            dismissible: dismissible
        )
    }
    
    /// Creates a warning alert.
    ///
    /// - Parameters:
    ///   - title: Alert title
    ///   - message: Alert message
    ///   - dismissible: Whether alert can be dismissed
    /// - Returns: Warning alert
    public static func warning(
        title: String? = nil,
        message: String,
        dismissible: Bool = false
    ) -> UIAlert {
        return UIAlert(
            type: .warning,
            title: title,
            message: message,
            dismissible: dismissible
        )
    }
    
    /// Creates an error alert.
    ///
    /// - Parameters:
    ///   - title: Alert title
    ///   - message: Alert message
    ///   - dismissible: Whether alert can be dismissed
    /// - Returns: Error alert
    public static func error(
        title: String? = nil,
        message: String,
        dismissible: Bool = false
    ) -> UIAlert {
        return UIAlert(
            type: .error,
            title: title,
            message: message,
            dismissible: dismissible
        )
    }
    
    /// Creates an alert with action buttons.
    ///
    /// - Parameters:
    ///   - type: Alert type
    ///   - title: Alert title
    ///   - message: Alert message
    ///   - actions: Action buttons
    /// - Returns: Alert with actions
    public static func withActions(
        type: AlertType,
        title: String? = nil,
        message: String,
        actions: [AlertAction]
    ) -> UIAlert {
        return UIAlert(
            type: type,
            title: title,
            message: message,
            actions: actions
        )
    }
    
    /// Creates a dismissible alert.
    ///
    /// - Parameters:
    ///   - type: Alert type
    ///   - title: Alert title
    ///   - message: Alert message
    /// - Returns: Dismissible alert
    public static func dismissible(
        type: AlertType,
        title: String? = nil,
        message: String
    ) -> UIAlert {
        return UIAlert(
            type: type,
            title: title,
            message: message,
            dismissible: true
        )
    }
}