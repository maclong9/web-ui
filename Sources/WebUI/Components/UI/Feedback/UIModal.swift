import Foundation

/// A headless modal component for overlay dialogs with accessibility and focus management.
///
/// `UIModal` provides a complete modal implementation with:
/// - Minimal structural CSS (layout, spacing, structure only)
/// - Multiple modal sizes and variants
/// - Header, body, and footer sections
/// - Backdrop click and escape key handling
/// - Focus trap and accessibility support
/// - Scrollable content areas
/// - Custom styling through CSS classes
///
/// ## Design Philosophy
///
/// This modal follows a headless-first approach:
/// - Provides structure and behavior without visual styling
/// - No colors, fonts, or decorative elements by default
/// - Extensive customization through CSS classes and CSS variables
/// - Can be styled with any design system or custom CSS
///
/// ## Usage
///
/// ```swift
/// // Basic modal
/// UIModal(
///     id: "confirm-modal",
///     title: "Confirm Action",
///     open: true
/// ) {
///     Text("Are you sure you want to proceed?")
/// }
///
/// // Modal with header and footer
/// UIModal(
///     id: "user-profile",
///     title: "Edit Profile",
///     open: profileModalOpen,
///     size: .large,
///     footer: {
///         UIButton("Save", variant: .primary)
///         UIButton("Cancel", variant: .secondary)
///     }
/// ) {
///     ProfileForm()
/// }
///
/// // Fullscreen modal
/// UIModal(
///     id: "image-viewer",
///     open: imageViewerOpen,
///     size: .fullscreen,
///     showHeader: false
/// ) {
///     ImageGallery()
/// }
/// ```
public struct UIModal<Content: Markup, Footer: Markup>: ComponentBase {
    // MARK: - Properties
    
    /// Unique identifier for the modal
    public let id: String
    
    /// Modal title
    public let title: String?
    
    /// Whether the modal is open
    public let open: Bool
    
    /// Modal size
    public let modalSize: ModalSize
    
    /// Whether to show the header
    public let showHeader: Bool
    
    /// Whether to show the close button
    public let showCloseButton: Bool
    
    /// Whether clicking backdrop closes modal
    public let closeOnBackdropClick: Bool
    
    /// Whether escape key closes modal
    public let closeOnEscape: Bool
    
    /// Whether to prevent body scroll when modal is open
    public let preventBodyScroll: Bool
    
    /// Modal content
    public let content: Content
    
    /// Optional footer content
    public let footer: Footer?
    
    /// Custom header icon
    public let headerIcon: LucideIcon?
    
    /// Component base properties
    public var variant: ComponentVariant
    public var size: ComponentSize
    public var disabled: Bool
    public var customClasses: [String]
    public var accessibilityRole: AriaRole?
    
    // MARK: - Initialization
    
    /// Creates a new UI modal with the specified configuration.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the modal
    ///   - title: Modal title (default: nil)
    ///   - open: Whether modal is open (default: false)
    ///   - size: Modal size (default: .medium)
    ///   - showHeader: Whether to show header (default: true)
    ///   - showCloseButton: Whether to show close button (default: true)
    ///   - closeOnBackdropClick: Close on backdrop click (default: true)
    ///   - closeOnEscape: Close on escape key (default: true)
    ///   - preventBodyScroll: Prevent body scroll (default: true)
    ///   - headerIcon: Optional header icon (default: nil)
    ///   - variant: Modal variant (default: .default)
    ///   - customClasses: Additional CSS classes (default: [])
    ///   - footer: Footer content builder (default: nil)
    ///   - content: Modal content builder
    public init(
        id: String,
        title: String? = nil,
        open: Bool = false,
        size: ModalSize = .medium,
        showHeader: Bool = true,
        showCloseButton: Bool = true,
        closeOnBackdropClick: Bool = true,
        closeOnEscape: Bool = true,
        preventBodyScroll: Bool = true,
        headerIcon: LucideIcon? = nil,
        variant: ComponentVariant = .default,
        customClasses: [String] = [],
        footer: (() -> Footer)? = nil,
        @MarkupBuilder content: () -> Content
    ) {
        self.id = id
        self.title = title
        self.open = open
        self.modalSize = size
        self.showHeader = showHeader
        self.showCloseButton = showCloseButton
        self.closeOnBackdropClick = closeOnBackdropClick
        self.closeOnEscape = closeOnEscape
        self.preventBodyScroll = preventBodyScroll
        self.headerIcon = headerIcon
        self.variant = variant
        self.customClasses = customClasses
        self.content = content()
        self.footer = footer?()
        self.size = .medium
        self.disabled = false
        self.accessibilityRole = .dialog
    }
    
    // MARK: - Element Implementation
    
    public var body: MarkupString {
        if !open {
            return MarkupString(content: "")
        }
        
        let allClasses = baseStyles.classes + 
                        sizeClasses +
                        (variantStyles[variant] ?? .empty).classes +
                        customClasses
        
        let allData = buildDataAttributes()
        
        let modalContent = ElementBuilder.section(
            classes: ["modal-overlay"] + (open ? ["modal-open"] : []),
            data: [
                "modal-overlay": "true",
                "modal-id": id
            ]
        ) {
            // Backdrop
            ElementBuilder.section(
                classes: ["modal-backdrop"],
                data: closeOnBackdropClick ? ["modal-close": "backdrop"] : [:]
            ) {
                ""
            }
            
            // Modal container
            ElementBuilder.section(
                classes: allClasses,
                role: .dialog,
                data: allData
            ) {
                if showHeader && (title != nil || showCloseButton) {
                    modalHeader
                }
                
                modalBody
                
                if let footerContent = footer {
                    modalFooter(footerContent)
                }
            }
        }
        
        return MarkupString(content: modalContent.render())
    }
    
    private var modalHeader: some Markup {
        ElementBuilder.section(
            classes: ["modal-header"]
        ) {
            if let title = title {
                modalTitleElement(title)
            }
            
            if showCloseButton {
                closeButton
            }
        }
    }
    
    private func modalTitleElement(_ title: String) -> some Markup {
        ElementBuilder.section(
            classes: ["modal-title-container"]
        ) {
            if let icon = headerIcon {
                Icon(icon, size: .medium, classes: ["modal-title-icon"])
            }
            
            Heading(.title, title, classes: ["modal-title"])
        }
    }
    
    private var closeButton: some Markup {
        ElementBuilder.section(
            classes: ["modal-close-button"]
        ) {
            ElementBuilder.button(
                "",
                type: .button,
                classes: ["modal-close-btn"],
                data: [
                    "modal-close": "button",
                    "aria-label": "Close modal"
                ]
            )
            Icon(.x, size: .medium, classes: ["modal-close-icon"])
        }
    }
    
    private var modalBody: some Markup {
        ElementBuilder.section(
            classes: ["modal-body"]
        ) {
            content
        }
    }
    
    private func modalFooter(_ footerContent: Footer) -> some Markup {
        ElementBuilder.section(
            classes: ["modal-footer"]
        ) {
            footerContent
        }
    }
    
    private var sizeClasses: [String] {
        return ["modal-\(modalSize.rawValue)"]
    }
    
    private func buildDataAttributes() -> [String: String] {
        var attributes: [String: String] = [:]
        
        attributes["modal-id"] = id
        attributes["modal-size"] = modalSize.rawValue
        attributes["open"] = open ? "true" : "false"
        
        if closeOnBackdropClick {
            attributes["close-on-backdrop"] = "true"
        }
        
        if closeOnEscape {
            attributes["close-on-escape"] = "true"
        }
        
        if preventBodyScroll {
            attributes["prevent-body-scroll"] = "true"
        }
        
        if !showHeader {
            attributes["no-header"] = "true"
        }
        
        if let headerIcon = headerIcon {
            attributes["header-icon"] = headerIcon.rawValue
        }
        
        return attributes
    }
    
    // MARK: - Component Styles
    
    public var baseStyles: ComponentStyles {
        return ComponentStyles(
            classes: ["modal"],
            properties: [:],
            dataAttributes: [:]
        )
    }
    
    public var variantStyles: [ComponentVariant: ComponentStyles] {
        return [
            .default: ComponentStyles(classes: ["variant-default"]),
            .primary: ComponentStyles(classes: ["variant-primary"]),
            .secondary: ComponentStyles(classes: ["variant-secondary"]),
            .danger: ComponentStyles(classes: ["variant-danger"])
        ]
    }
    
    public var sizeStyles: [ComponentSize: ComponentStyles] {
        return [:] // Modal uses its own size system
    }
}

// MARK: - Supporting Types

/// Modal size options
public enum ModalSize: String, CaseIterable {
    case small = "sm"
    case medium = "md"
    case large = "lg"
    case extraLarge = "xl"
    case fullscreen = "fullscreen"
}

// MARK: - Convenience Initializers

extension UIModal where Footer == EmptyMarkup {
    /// Creates a modal without a footer.
    ///
    /// - Parameters:
    ///   - id: Unique identifier
    ///   - title: Modal title
    ///   - open: Whether modal is open
    ///   - size: Modal size
    ///   - content: Modal content
    public init(
        id: String,
        title: String? = nil,
        open: Bool = false,
        size: ModalSize = .medium,
        showHeader: Bool = true,
        showCloseButton: Bool = true,
        closeOnBackdropClick: Bool = true,
        closeOnEscape: Bool = true,
        preventBodyScroll: Bool = true,
        headerIcon: LucideIcon? = nil,
        variant: ComponentVariant = .default,
        customClasses: [String] = [],
        @MarkupBuilder content: () -> Content
    ) {
        self.id = id
        self.title = title
        self.open = open
        self.modalSize = size
        self.showHeader = showHeader
        self.showCloseButton = showCloseButton
        self.closeOnBackdropClick = closeOnBackdropClick
        self.closeOnEscape = closeOnEscape
        self.preventBodyScroll = preventBodyScroll
        self.headerIcon = headerIcon
        self.variant = variant
        self.customClasses = customClasses
        self.content = content()
        self.footer = nil
        self.size = .medium
        self.disabled = false
        self.accessibilityRole = .dialog
    }
}

extension UIModal {
    // TODO: Factory methods need proper generic type handling
    // These are commented out until the MarkupBuilder system can properly handle complex generic types
    
    /*
    /// Creates a confirmation modal.
    ///
    /// - Parameters:
    ///   - id: Unique identifier
    ///   - title: Modal title
    ///   - message: Confirmation message
    ///   - open: Whether modal is open
    ///   - confirmText: Confirm button text
    ///   - cancelText: Cancel button text
    /// - Returns: Confirmation modal
    public static func confirmation(
        id: String,
        title: String,
        message: String,
        open: Bool = false,
        confirmText: String = "Confirm",
        cancelText: String = "Cancel"
    ) -> some ComponentBase {
        return UIModal(
            id: id,
            title: title,
            open: open,
            size: .small,
            headerIcon: .alertCircle,
            variant: .danger,
            footer: {
                MarkupString(content: [
                    UIButton(
                        cancelText,
                        variant: .secondary,
                        customClasses: [],
                        clickAction: nil
                    ).render(),
                    UIButton(
                        confirmText,
                        variant: .danger,
                        customClasses: [],
                        clickAction: nil
                    ).render()
                ].joined())
            }
        ) {
            Text(message, classes: ["modal-confirmation-message"])
        }
    }
    */
    
    /*
    /// Creates an info modal.
    ///
    /// - Parameters:
    ///   - id: Unique identifier
    ///   - title: Modal title
    ///   - message: Info message
    ///   - open: Whether modal is open
    /// - Returns: Info modal
    public static func info(
        id: String,
        title: String,
        message: String,
        open: Bool = false
    ) -> UIModal<Text, EmptyMarkup> {
        return UIModal<Text, EmptyMarkup>(
            id: id,
            title: title,
            open: open,
            size: .medium,
            headerIcon: .info
        ) {
            Text(message, classes: ["modal-info-message"])
        }
    }
    
    /// Creates a loading modal.
    ///
    /// - Parameters:
    ///   - id: Unique identifier
    ///   - title: Modal title
    ///   - message: Loading message
    ///   - open: Whether modal is open
    /// - Returns: Loading modal
    public static func loading(
        id: String,
        title: String = "Loading",
        message: String,
        open: Bool = false
    ) -> UIModal<UIContainer<Group<Icon>>, EmptyMarkup> {
        return UIModal<UIContainer<Group<Icon>>, EmptyMarkup>(
            id: id,
            title: title,
            open: open,
            size: .small,
            showCloseButton: false,
            closeOnBackdropClick: false,
            closeOnEscape: false
        ) {
            UIContainer.flexColumn(alignment: .center) {
                Icon(.loader2, size: .large, classes: ["modal-loading-spinner", "animate-spin"])
                Text(message, classes: ["modal-loading-message"])
            }
        }
    }
    
    /// Creates a fullscreen modal.
    ///
    /// - Parameters:
    ///   - id: Unique identifier
    ///   - title: Modal title
    ///   - open: Whether modal is open
    ///   - content: Modal content
    /// - Returns: Fullscreen modal
    public static func fullscreen(
        id: String,
        title: String? = nil,
        open: Bool = false,
        @MarkupBuilder content: () -> Content
    ) -> UIModal<Content, EmptyMarkup> {
        return UIModal<Content, EmptyMarkup>(
            id: id,
            title: title,
            open: open,
            size: .fullscreen,
            content: content
        )
    }
    */
}