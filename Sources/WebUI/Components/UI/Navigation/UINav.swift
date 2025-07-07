import Foundation

/// A headless navigation component for building accessible navigation menus.
///
/// `UINav` provides a complete navigation implementation with:
/// - Minimal structural CSS (layout, spacing, structure only)
/// - Flexible navigation items with links, buttons, and dropdowns
/// - Accessibility support with proper ARIA attributes and keyboard navigation
/// - Mobile-responsive hamburger menu support
/// - Breadcrumb and hierarchical navigation support
/// - Custom styling through CSS classes
///
/// ## Design Philosophy
///
/// This navigation follows a headless-first approach:
/// - Provides structure and behavior without visual styling
/// - No colors, fonts, or decorative elements by default
/// - Extensive customization through CSS classes and CSS variables
/// - Can be styled with any design system or custom CSS
///
/// ## Usage
///
/// ```swift
/// // Basic horizontal navigation
/// UINav(items: [
///     NavItem.link(href: "/", label: "Home"),
///     NavItem.link(href: "/about", label: "About"),
///     NavItem.link(href: "/contact", label: "Contact")
/// ])
///
/// // Navigation with dropdown
/// UINav(items: [
///     NavItem.link(href: "/", label: "Home"),
///     NavItem.dropdown(label: "Services", items: [
///         NavItem.link(href: "/web", label: "Web Development"),
///         NavItem.link(href: "/mobile", label: "Mobile Apps")
///     ])
/// ])
///
/// // Mobile-responsive navigation
/// UINav(
///     items: navItems,
///     layout: .horizontal,
///     mobileBreakpoint: .md,
///     showMobileToggle: true
/// )
/// ```
public struct UINav: ComponentBase {
    // MARK: - Properties
    
    /// Navigation items
    public let items: [NavItem]
    
    /// Navigation layout
    public let layout: NavLayout
    
    /// Mobile breakpoint for responsive behavior
    public let mobileBreakpoint: BreakpointSize
    
    /// Whether to show mobile hamburger toggle
    public let showMobileToggle: Bool
    
    /// Navigation label for accessibility
    public let ariaLabel: String?
    
    /// Currently active item (for highlighting)
    public let activeItem: String?
    
    /// Component base properties
    public var variant: ComponentVariant
    public var size: ComponentSize
    public var disabled: Bool
    public var customClasses: [String]
    public var accessibilityRole: AriaRole?
    
    // MARK: - Initialization
    
    /// Creates a new UI navigation with the specified configuration.
    ///
    /// - Parameters:
    ///   - items: Navigation items
    ///   - layout: Navigation layout (default: .horizontal)
    ///   - mobileBreakpoint: Mobile responsive breakpoint (default: .md)
    ///   - showMobileToggle: Whether to show mobile toggle (default: false)
    ///   - ariaLabel: Accessibility label (default: nil)
    ///   - activeItem: Currently active item ID (default: nil)
    ///   - variant: Navigation variant (default: .default)
    ///   - customClasses: Additional CSS classes (default: [])
    public init(
        items: [NavItem],
        layout: NavLayout = .horizontal,
        mobileBreakpoint: BreakpointSize = .md,
        showMobileToggle: Bool = false,
        ariaLabel: String? = nil,
        activeItem: String? = nil,
        variant: ComponentVariant = .default,
        customClasses: [String] = []
    ) {
        self.items = items
        self.layout = layout
        self.mobileBreakpoint = mobileBreakpoint
        self.showMobileToggle = showMobileToggle
        self.ariaLabel = ariaLabel
        self.activeItem = activeItem
        self.variant = variant
        self.customClasses = customClasses
        self.size = .medium
        self.disabled = false
        self.accessibilityRole = .navigation
    }
    
    // MARK: - Element Implementation
    
    public var body: some Markup {
        let allClasses = baseStyles.classes + 
                        layoutClasses +
                        (variantStyles[variant] ?? .empty).classes +
                        customClasses
        
        let allData = buildDataAttributes()
        
        return Nav(
            classes: allClasses.isEmpty ? nil : allClasses,
            role: .navigation,
            data: allData.isEmpty ? nil : allData
        ) {
            if showMobileToggle {
                mobileToggleButton
            }
            
            navItemsList
        }
    }
    
    private var mobileToggleButton: some Markup {
        ElementBuilder.button(
            "",
            type: .button,
            classes: ["nav-mobile-toggle", "\(mobileBreakpoint.rawValue):hidden"],
            data: [
                "nav-toggle": "true",
                "aria-label": "Toggle navigation menu",
                "aria-expanded": "false"
            ]
        )
    }
    
    private var navItemsList: some Markup {
        let listClasses = ["nav-items"] + (showMobileToggle ? ["hidden", "\(mobileBreakpoint.rawValue):flex"] : [])
        
        return UnorderedList(
            classes: listClasses.isEmpty ? nil : listClasses,
            data: nil
        ) {
            let navElements: [any Markup] = items.map { item in
                navItemElement(item)
            }
            
            MarkupString(content: navElements.map { $0.render() }.joined())
        }
    }
    
    private func navItemElement(_ item: NavItem) -> ListItem {
        let isActive = activeItem == item.id
        let itemClasses = ["nav-item"] + (isActive ? ["nav-item-active"] : [])
        
        return ListItem(
            classes: itemClasses.isEmpty ? nil : itemClasses,
            data: item.id != nil ? ["nav-item-id": item.id!] : nil
        ) {
            switch item.type {
            case .link(let href, let newTab, let external):
                navLinkElement(item, href: href, newTab: newTab, external: external)
            case .button(let action):
                navButtonElement(item, action: action)
            case .dropdown(let dropdownItems):
                navDropdownElement(item, items: dropdownItems)
            case .divider:
                navDividerElement()
            }
        }
    }
    
    private func navLinkElement(_ item: NavItem, href: String, newTab: Bool?, external: Bool) -> some Markup {
        let linkClasses = ["nav-link"] + (item.disabled ? ["nav-link-disabled"] : [])
        var linkData: [String: String] = [:]
        
        if external {
            linkData["external"] = "true"
        }
        
        return Link(
            to: href,
            newTab: newTab,
            classes: linkClasses.isEmpty ? nil : linkClasses,
            data: linkData.isEmpty ? nil : linkData
        ) {
            if let icon = item.icon {
                Icon(icon, size: .small, classes: ["nav-icon"])
            }
            ElementBuilder.text(item.label)
        }
    }
    
    private func navButtonElement(_ item: NavItem, action: String) -> some Markup {
        let buttonClasses = ["nav-button"] + (item.disabled ? ["nav-button-disabled"] : [])
        
        return ElementBuilder.button(
            item.label,
            type: .button,
            disabled: item.disabled,
            classes: buttonClasses,
            data: ["action": action]
        )
    }
    
    private func navDropdownElement(_ item: NavItem, items: [NavItem]) -> some Markup {
        let dropdownClasses = ["nav-dropdown"]
        
        return ElementBuilder.section(
            classes: dropdownClasses
        ) {
            // Dropdown trigger
            let buttonContent = [
                item.icon.map { Icon($0, size: .small, classes: ["nav-icon"]).render() } ?? "",
                ElementBuilder.text(item.label).render(),
                Icon(.chevronDown, size: .small, classes: ["nav-dropdown-chevron"]).render()
            ].joined()
            
            ElementBuilder.button(
                buttonContent,
                type: .button,
                classes: ["nav-dropdown-trigger"],
                data: [
                    "dropdown-toggle": "true",
                    "aria-expanded": "false",
                    "aria-haspopup": "true"
                ]
            )
            
            // Dropdown menu
            UnorderedList(
                classes: ["nav-dropdown-menu", "hidden"],
                role: .menu,
                data: ["dropdown-menu": "true"]
            ) {
                let dropdownElements: [any Markup] = items.map { dropdownItem in
                    navItemElement(dropdownItem)
                }
                
                MarkupString(content: dropdownElements.map { $0.render() }.joined())
            }
        }
    }
    
    private func navDividerElement() -> some Markup {
        ElementBuilder.section(
            classes: ["nav-divider"],
            role: .separator
        ) {
            ""
        }
    }
    
    private var layoutClasses: [String] {
        switch layout {
        case .horizontal:
            return ["nav-horizontal"]
        case .vertical:
            return ["nav-vertical"]
        case .breadcrumb:
            return ["nav-breadcrumb"]
        }
    }
    
    private func buildDataAttributes() -> [String: String] {
        var attributes: [String: String] = [:]
        
        attributes["layout"] = layout.rawValue
        attributes["mobile-breakpoint"] = mobileBreakpoint.rawValue
        
        if showMobileToggle {
            attributes["mobile-toggle"] = "true"
        }
        
        if let ariaLabel = ariaLabel {
            attributes["aria-label"] = ariaLabel
        }
        
        if let activeItem = activeItem {
            attributes["active-item"] = activeItem
        }
        
        return attributes
    }
    
    // MARK: - Component Styles
    
    public var baseStyles: ComponentStyles {
        return ComponentStyles(
            classes: ["nav"],
            properties: [:],
            dataAttributes: [:]
        )
    }
    
    public var variantStyles: [ComponentVariant: ComponentStyles] {
        return [
            .default: ComponentStyles(classes: ["variant-default"]),
            .primary: ComponentStyles(classes: ["variant-primary"]),
            .secondary: ComponentStyles(classes: ["variant-secondary"])
        ]
    }
    
    public var sizeStyles: [ComponentSize: ComponentStyles] {
        return [:] // Navigation doesn't typically have size variants
    }
}

// MARK: - Supporting Types

/// Navigation item configuration
public struct NavItem: Identifiable, Sendable {
    public let id: String?
    public let label: String
    public let icon: LucideIcon?
    public let disabled: Bool
    public let type: NavItemType
    
    public init(
        id: String? = nil,
        label: String,
        icon: LucideIcon? = nil,
        disabled: Bool = false,
        type: NavItemType
    ) {
        self.id = id
        self.label = label
        self.icon = icon
        self.disabled = disabled
        self.type = type
    }
}

/// Navigation item types
public enum NavItemType: Sendable {
    case link(href: String, newTab: Bool? = nil, external: Bool = false)
    case button(action: String)
    case dropdown(items: [NavItem])
    case divider
}

/// Navigation layouts
public enum NavLayout: String, CaseIterable {
    case horizontal = "horizontal"
    case vertical = "vertical"
    case breadcrumb = "breadcrumb"
}

/// Breakpoint sizes for responsive behavior
public enum BreakpointSize: String, CaseIterable {
    case sm = "sm"
    case md = "md"
    case lg = "lg"
    case xl = "xl"
}

// MARK: - NavItem Convenience Initializers

extension NavItem {
    /// Creates a link navigation item.
    ///
    /// - Parameters:
    ///   - href: Link URL
    ///   - label: Link text
    ///   - icon: Optional icon
    ///   - external: Whether link is external
    ///   - disabled: Whether link is disabled
    /// - Returns: Link navigation item
    public static func link(
        href: String,
        label: String,
        icon: LucideIcon? = nil,
        external: Bool = false,
        disabled: Bool = false
    ) -> NavItem {
        return NavItem(
            label: label,
            icon: icon,
            disabled: disabled,
            type: .link(href: href, external: external)
        )
    }
    
    /// Creates a button navigation item.
    ///
    /// - Parameters:
    ///   - label: Button text
    ///   - action: Button action identifier
    ///   - icon: Optional icon
    ///   - disabled: Whether button is disabled
    /// - Returns: Button navigation item
    public static func button(
        label: String,
        action: String,
        icon: LucideIcon? = nil,
        disabled: Bool = false
    ) -> NavItem {
        return NavItem(
            label: label,
            icon: icon,
            disabled: disabled,
            type: .button(action: action)
        )
    }
    
    /// Creates a dropdown navigation item.
    ///
    /// - Parameters:
    ///   - label: Dropdown label
    ///   - items: Dropdown items
    ///   - icon: Optional icon
    ///   - disabled: Whether dropdown is disabled
    /// - Returns: Dropdown navigation item
    public static func dropdown(
        label: String,
        items: [NavItem],
        icon: LucideIcon? = nil,
        disabled: Bool = false
    ) -> NavItem {
        return NavItem(
            label: label,
            icon: icon,
            disabled: disabled,
            type: .dropdown(items: items)
        )
    }
    
    /// Creates a divider navigation item.
    ///
    /// - Returns: Divider navigation item
    public static var divider: NavItem {
        return NavItem(
            label: "",
            type: .divider
        )
    }
}

// MARK: - Convenience Initializers

extension UINav {
    /// Creates a simple horizontal navigation.
    ///
    /// - Parameters:
    ///   - items: Navigation items
    ///   - activeItem: Currently active item ID
    ///   - mobileResponsive: Whether to enable mobile responsive behavior
    /// - Returns: Horizontal navigation
    public static func horizontal(
        items: [NavItem],
        activeItem: String? = nil,
        mobileResponsive: Bool = false
    ) -> UINav {
        return UINav(
            items: items,
            layout: .horizontal,
            showMobileToggle: mobileResponsive,
            activeItem: activeItem
        )
    }
    
    /// Creates a vertical sidebar navigation.
    ///
    /// - Parameters:
    ///   - items: Navigation items
    ///   - activeItem: Currently active item ID
    /// - Returns: Vertical navigation
    public static func sidebar(
        items: [NavItem],
        activeItem: String? = nil
    ) -> UINav {
        return UINav(
            items: items,
            layout: .vertical,
            activeItem: activeItem
        )
    }
    
    /// Creates a breadcrumb navigation.
    ///
    /// - Parameters:
    ///   - items: Breadcrumb items (should be link items)
    /// - Returns: Breadcrumb navigation
    public static func breadcrumb(
        items: [NavItem]
    ) -> UINav {
        return UINav(
            items: items,
            layout: .breadcrumb,
            ariaLabel: "Breadcrumb"
        )
    }
}