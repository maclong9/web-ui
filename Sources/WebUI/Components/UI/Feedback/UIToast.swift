import Foundation

/// A headless toast notification component for temporary messages with accessibility support.
///
/// `UIToast` provides a complete toast implementation with:
/// - Minimal structural CSS (layout, spacing, structure only)
/// - Multiple toast types (info, success, warning, error)
/// - Auto-dismiss with configurable duration
/// - Manual dismiss with close button
/// - Position and animation support
/// - Progress indicator for auto-dismiss
/// - Accessibility support with proper ARIA attributes
/// - Custom styling through CSS classes
///
/// ## Design Philosophy
///
/// This toast follows a headless-first approach:
/// - Provides structure and behavior without visual styling
/// - No colors, fonts, or decorative elements by default
/// - Extensive customization through CSS classes and CSS variables
/// - Can be styled with any design system or custom CSS
///
/// ## Usage
///
/// ```swift
/// // Basic success toast
/// UIToast(
///     id: "save-success",
///     type: .success,
///     title: "Saved!",
///     message: "Your changes have been saved.",
///     visible: true
/// )
///
/// // Auto-dismiss toast with progress
/// UIToast(
///     id: "info-toast",
///     type: .info,
///     title: "Information",
///     message: "This toast will auto-dismiss in 5 seconds.",
///     visible: true,
///     autoDismiss: true,
///     duration: 5000,
///     showProgress: true
/// )
///
/// // Toast with action button
/// UIToast(
///     id: "undo-toast",
///     type: .warning,
///     title: "Item Deleted",
///     message: "The item has been deleted.",
///     visible: true,
///     action: ToastAction(label: "Undo", action: "undo")
/// )
/// ```
public struct UIToast: ComponentBase {
    // MARK: - Properties
    
    /// Unique identifier for the toast
    public let id: String
    
    /// Toast type
    public let toastType: ToastType
    
    /// Toast title
    public let title: String?
    
    /// Toast message
    public let message: String
    
    /// Whether the toast is visible
    public let visible: Bool
    
    /// Whether to auto-dismiss the toast
    public let autoDismiss: Bool
    
    /// Auto-dismiss duration in milliseconds
    public let duration: Int
    
    /// Whether to show dismiss button
    public let dismissible: Bool
    
    /// Whether to show progress indicator
    public let showProgress: Bool
    
    /// Toast position
    public let position: ToastPosition
    
    /// Optional action button
    public let action: ToastAction?
    
    /// Custom icon (overrides default type icon)
    public let customIcon: LucideIcon?
    
    /// Whether to show the default type icon
    public let showIcon: Bool
    
    /// Component base properties
    public var variant: ComponentVariant
    public var size: ComponentSize
    public var disabled: Bool
    public var customClasses: [String]
    public var accessibilityRole: AriaRole?
    
    // MARK: - Initialization
    
    /// Creates a new UI toast with the specified configuration.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the toast
    ///   - type: Toast type (default: .info)
    ///   - title: Toast title (default: nil)
    ///   - message: Toast message
    ///   - visible: Whether toast is visible (default: false)
    ///   - autoDismiss: Whether to auto-dismiss (default: true)
    ///   - duration: Auto-dismiss duration in ms (default: 4000)
    ///   - dismissible: Whether to show dismiss button (default: true)
    ///   - showProgress: Whether to show progress indicator (default: false)
    ///   - position: Toast position (default: .topRight)
    ///   - action: Optional action button (default: nil)
    ///   - customIcon: Custom icon override (default: nil)
    ///   - showIcon: Whether to show type icon (default: true)
    ///   - size: Toast size (default: .medium)
    ///   - customClasses: Additional CSS classes (default: [])
    public init(
        id: String,
        type: ToastType = .info,
        title: String? = nil,
        message: String,
        visible: Bool = false,
        autoDismiss: Bool = true,
        duration: Int = 4000,
        dismissible: Bool = true,
        showProgress: Bool = false,
        position: ToastPosition = .topRight,
        action: ToastAction? = nil,
        customIcon: LucideIcon? = nil,
        showIcon: Bool = true,
        size: ComponentSize = .medium,
        customClasses: [String] = []
    ) {
        self.id = id
        self.toastType = type
        self.title = title
        self.message = message
        self.visible = visible
        self.autoDismiss = autoDismiss
        self.duration = duration
        self.dismissible = dismissible
        self.showProgress = showProgress
        self.position = position
        self.action = action
        self.customIcon = customIcon
        self.showIcon = showIcon
        self.size = size
        self.customClasses = customClasses
        self.variant = .default
        self.disabled = false
        self.accessibilityRole = .status
    }
    
    // MARK: - Element Implementation
    
    public var body: MarkupString {
        if !visible {
            return MarkupString(content: "")
        }
        
        let allClasses = baseStyles.classes + 
                        typeClasses +
                        positionClasses +
                        (sizeStyles[size] ?? .empty).classes +
                        customClasses
        
        let allData = buildDataAttributes()
        
        return MarkupString(content: ElementBuilder.section(
            classes: allClasses,
            role: .status,
            data: allData
        ) {
            toastContent
            
            if showProgress && autoDismiss {
                progressIndicator
            }
        }.render())
    }
    
    private var toastContent: MarkupString {
        MarkupString(content: ElementBuilder.section(
            classes: ["toast-content"]
        ) {
            if showIcon {
                toastIcon
            }
            
            toastText
            
            if let action = action {
                toastActionButton(action)
            }
            
            if dismissible {
                dismissButton
            }
        }.render())
    }
    
    private var toastIcon: MarkupString {
        let icon = customIcon ?? toastType.defaultIcon
        
        return MarkupString(content: Icon(
            icon,
            size: iconSizeForToastSize,
            classes: ["toast-icon", "toast-icon-\(toastType.rawValue)"]
        ).render())
    }
    
    private var toastText: MarkupString {
        MarkupString(content: ElementBuilder.section(
            classes: ["toast-text"]
        ) {
            if let title = title {
                toastTitle(title)
            }
            
            toastMessage(message)
        }.render())
    }
    
    private func toastTitle(_ title: String) -> MarkupString {
        MarkupString(content: Heading(.subheadline, title, classes: ["toast-title"]).render())
    }
    
    private func toastMessage(_ message: String) -> MarkupString {
        MarkupString(content: ElementBuilder.text(message, classes: ["toast-message"]).render())
    }
    
    private func toastActionButton(_ action: ToastAction) -> MarkupString {
        let buttonClasses = ["toast-action", "toast-action-\(action.style.rawValue)"]
        
        return MarkupString(content: ElementBuilder.button(
            action.label,
            type: .button,
            disabled: action.disabled,
            classes: buttonClasses,
            data: [
                "action": action.action,
                "toast-action": "true"
            ]
        ).render())
    }
    
    private var dismissButton: MarkupString {
        let iconContent = Icon(.x, size: .small, classes: ["toast-dismiss-icon"]).render()
        let buttonContent = ElementBuilder.button(
            iconContent,
            type: .button,
            classes: ["toast-dismiss"],
            data: [
                "toast-dismiss": "true",
                "aria-label": "Dismiss notification"
            ]
        ).render()
        return MarkupString(content: buttonContent)
    }
    
    private var progressIndicator: MarkupString {
        MarkupString(content: ElementBuilder.section(
            classes: ["toast-progress"]
        ) {
            ElementBuilder.section(
                classes: ["toast-progress-bar"],
                data: [
                    "progress-duration": String(duration)
                ]
            ) {
                ""
            }
        }.render())
    }
    
    private var typeClasses: [String] {
        return ["toast-\(toastType.rawValue)"]
    }
    
    private var positionClasses: [String] {
        return ["toast-position-\(position.rawValue)"]
    }
    
    private var iconSizeForToastSize: Icon.IconSize {
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
        
        attributes["toast-id"] = id
        attributes["toast-type"] = toastType.rawValue
        attributes["position"] = position.rawValue
        attributes["size"] = size.rawValue
        attributes["visible"] = visible ? "true" : "false"
        
        if autoDismiss {
            attributes["auto-dismiss"] = "true"
            attributes["duration"] = String(duration)
        }
        
        if dismissible {
            attributes["dismissible"] = "true"
        }
        
        if showProgress {
            attributes["show-progress"] = "true"
        }
        
        if showIcon {
            attributes["show-icon"] = "true"
        }
        
        if let customIcon = customIcon {
            attributes["custom-icon"] = customIcon.rawValue
        }
        
        if action != nil {
            attributes["has-action"] = "true"
        }
        
        return attributes
    }
    
    // MARK: - Component Styles
    
    public var baseStyles: ComponentStyles {
        return ComponentStyles(
            classes: ["toast"],
            properties: [:],
            dataAttributes: [:]
        )
    }
    
    public var variantStyles: [ComponentVariant: ComponentStyles] {
        return [:] // Toasts use type-based styling instead
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

/// Toast types with semantic meaning
public enum ToastType: String, CaseIterable {
    case info = "info"
    case success = "success"
    case warning = "warning"
    case error = "error"
    case loading = "loading"
    
    /// Default icon for each toast type
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
        case .loading:
            return .loader2
        }
    }
}

/// Toast position options
public enum ToastPosition: String, CaseIterable {
    case topLeft = "top-left"
    case topCenter = "top-center"
    case topRight = "top-right"
    case bottomLeft = "bottom-left"
    case bottomCenter = "bottom-center"
    case bottomRight = "bottom-right"
}

/// Toast action button configuration
public struct ToastAction: Sendable {
    public let label: String
    public let action: String
    public let style: ToastActionStyle
    public let disabled: Bool
    
    public init(
        label: String,
        action: String,
        style: ToastActionStyle = .primary,
        disabled: Bool = false
    ) {
        self.label = label
        self.action = action
        self.style = style
        self.disabled = disabled
    }
}

/// Toast action button styles
public enum ToastActionStyle: String, CaseIterable, Sendable {
    case primary = "primary"
    case secondary = "secondary"
    case ghost = "ghost"
}

// MARK: - Convenience Initializers

extension UIToast {
    /// Creates an info toast.
    ///
    /// - Parameters:
    ///   - id: Toast identifier
    ///   - title: Toast title
    ///   - message: Toast message
    ///   - visible: Whether toast is visible
    ///   - autoDismiss: Whether to auto-dismiss
    /// - Returns: Info toast
    public static func info(
        id: String,
        title: String? = nil,
        message: String,
        visible: Bool = false,
        autoDismiss: Bool = true
    ) -> UIToast {
        return UIToast(
            id: id,
            type: .info,
            title: title,
            message: message,
            visible: visible,
            autoDismiss: autoDismiss
        )
    }
    
    /// Creates a success toast.
    ///
    /// - Parameters:
    ///   - id: Toast identifier
    ///   - title: Toast title
    ///   - message: Toast message
    ///   - visible: Whether toast is visible
    ///   - autoDismiss: Whether to auto-dismiss
    /// - Returns: Success toast
    public static func success(
        id: String,
        title: String? = nil,
        message: String,
        visible: Bool = false,
        autoDismiss: Bool = true
    ) -> UIToast {
        return UIToast(
            id: id,
            type: .success,
            title: title,
            message: message,
            visible: visible,
            autoDismiss: autoDismiss
        )
    }
    
    /// Creates a warning toast.
    ///
    /// - Parameters:
    ///   - id: Toast identifier
    ///   - title: Toast title
    ///   - message: Toast message
    ///   - visible: Whether toast is visible
    ///   - autoDismiss: Whether to auto-dismiss
    /// - Returns: Warning toast
    public static func warning(
        id: String,
        title: String? = nil,
        message: String,
        visible: Bool = false,
        autoDismiss: Bool = true
    ) -> UIToast {
        return UIToast(
            id: id,
            type: .warning,
            title: title,
            message: message,
            visible: visible,
            autoDismiss: autoDismiss
        )
    }
    
    /// Creates an error toast.
    ///
    /// - Parameters:
    ///   - id: Toast identifier
    ///   - title: Toast title
    ///   - message: Toast message
    ///   - visible: Whether toast is visible
    ///   - autoDismiss: Whether to auto-dismiss
    /// - Returns: Error toast
    public static func error(
        id: String,
        title: String? = nil,
        message: String,
        visible: Bool = false,
        autoDismiss: Bool = false
    ) -> UIToast {
        return UIToast(
            id: id,
            type: .error,
            title: title,
            message: message,
            visible: visible,
            autoDismiss: autoDismiss
        )
    }
    
    /// Creates a loading toast.
    ///
    /// - Parameters:
    ///   - id: Toast identifier
    ///   - title: Toast title
    ///   - message: Toast message
    ///   - visible: Whether toast is visible
    /// - Returns: Loading toast
    public static func loading(
        id: String,
        title: String? = nil,
        message: String,
        visible: Bool = false
    ) -> UIToast {
        return UIToast(
            id: id,
            type: .loading,
            title: title,
            message: message,
            visible: visible,
            autoDismiss: false,
            dismissible: false
        )
    }
    
    /// Creates a toast with an action button.
    ///
    /// - Parameters:
    ///   - id: Toast identifier
    ///   - type: Toast type
    ///   - title: Toast title
    ///   - message: Toast message
    ///   - action: Action button
    ///   - visible: Whether toast is visible
    /// - Returns: Toast with action
    public static func withAction(
        id: String,
        type: ToastType,
        title: String? = nil,
        message: String,
        action: ToastAction,
        visible: Bool = false
    ) -> UIToast {
        return UIToast(
            id: id,
            type: type,
            title: title,
            message: message,
            visible: visible,
            autoDismiss: false,
            action: action
        )
    }
    
    /// Creates a persistent toast that doesn't auto-dismiss.
    ///
    /// - Parameters:
    ///   - id: Toast identifier
    ///   - type: Toast type
    ///   - title: Toast title
    ///   - message: Toast message
    ///   - visible: Whether toast is visible
    /// - Returns: Persistent toast
    public static func persistent(
        id: String,
        type: ToastType,
        title: String? = nil,
        message: String,
        visible: Bool = false
    ) -> UIToast {
        return UIToast(
            id: id,
            type: type,
            title: title,
            message: message,
            visible: visible,
            autoDismiss: false
        )
    }
}