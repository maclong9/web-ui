import Foundation

/// A headless breadcrumb component for hierarchical navigation with accessibility support.
///
/// `UIBreadcrumb` provides a complete breadcrumb implementation with:
/// - Minimal structural CSS (layout, spacing, structure only)
/// - Accessibility support with proper ARIA attributes and structured data
/// - Customizable separators
/// - Link and text items
/// - Schema.org structured data support
/// - Custom styling through CSS classes
///
/// ## Design Philosophy
///
/// This breadcrumb follows a headless-first approach:
/// - Provides structure and behavior without visual styling
/// - No colors, fonts, or decorative elements by default
/// - Extensive customization through CSS classes and CSS variables
/// - Can be styled with any design system or custom CSS
///
/// ## Usage
///
/// ```swift
/// // Basic breadcrumb
/// UIBreadcrumb(items: [
///     BreadcrumbItem.link(href: "/", label: "Home"),
///     BreadcrumbItem.link(href: "/products", label: "Products"),
///     BreadcrumbItem.text("iPhone 15")
/// ])
///
/// // Breadcrumb with custom separator
/// UIBreadcrumb(
///     items: breadcrumbItems,
///     separator: .icon(.chevronRight),
///     showStructuredData: true
/// )
///
/// // Breadcrumb with home icon
/// UIBreadcrumb(
///     items: breadcrumbItems,
///     showHomeIcon: true,
///     separator: .text("/")
/// )
/// ```
public struct UIBreadcrumb: ComponentBase {
    // MARK: - Properties
    
    /// Breadcrumb items
    public let items: [BreadcrumbItem]
    
    /// Separator between items
    public let separator: BreadcrumbSeparator
    
    /// Whether to show structured data for SEO
    public let showStructuredData: Bool
    
    /// Whether to show home icon for first item
    public let showHomeIcon: Bool
    
    /// Maximum number of items to show before collapsing
    public let maxItems: Int?
    
    /// Component base properties
    public var variant: ComponentVariant
    public var size: ComponentSize
    public var disabled: Bool
    public var customClasses: [String]
    public var accessibilityRole: AriaRole?
    
    // MARK: - Initialization
    
    /// Creates a new UI breadcrumb with the specified configuration.
    ///
    /// - Parameters:
    ///   - items: Breadcrumb items
    ///   - separator: Separator between items (default: .icon(.chevronRight))
    ///   - showStructuredData: Whether to include structured data (default: true)
    ///   - showHomeIcon: Whether to show home icon (default: false)
    ///   - maxItems: Maximum items before collapsing (default: nil)
    ///   - variant: Breadcrumb variant (default: .default)
    ///   - size: Breadcrumb size (default: .medium)
    ///   - customClasses: Additional CSS classes (default: [])
    public init(
        items: [BreadcrumbItem],
        separator: BreadcrumbSeparator = .icon(.chevronRight),
        showStructuredData: Bool = true,
        showHomeIcon: Bool = false,
        maxItems: Int? = nil,
        variant: ComponentVariant = .default,
        size: ComponentSize = .medium,
        customClasses: [String] = []
    ) {
        self.items = items
        self.separator = separator
        self.showStructuredData = showStructuredData
        self.showHomeIcon = showHomeIcon
        self.maxItems = maxItems
        self.variant = variant
        self.size = size
        self.customClasses = customClasses
        self.disabled = false
        self.accessibilityRole = .navigation
    }
    
    // MARK: - Element Implementation
    
    public var body: some Markup {
        let allClasses = baseStyles.classes + 
                        (variantStyles[variant] ?? .empty).classes +
                        (sizeStyles[size] ?? .empty).classes +
                        customClasses
        
        let allData = buildDataAttributes()
        
        return Nav(
            classes: allClasses.isEmpty ? nil : allClasses,
            role: .navigation,
            data: allData.isEmpty ? nil : allData
        ) {
            if showStructuredData {
                structuredDataScript
            }
            
            breadcrumbList
        }
    }
    
    private var breadcrumbList: some Markup {
        let displayItems = processItems()
        
        return OrderedList(
            classes: ["breadcrumb-list"],
            data: ["breadcrumb": "true"]
        ) {
            let breadcrumbElements: [any Markup] = displayItems.enumerated().map { (index, item) in
                breadcrumbItemElement(item, index: index, isLast: index == displayItems.count - 1)
            }
            
            MarkupString(content: breadcrumbElements.map { $0.render() }.joined())
        }
    }
    
    private func breadcrumbItemElement(_ item: BreadcrumbItem, index: Int, isLast: Bool) -> ListItem {
        let itemClasses = ["breadcrumb-item"] + (isLast ? ["breadcrumb-item-current"] : [])
        
        return ListItem(
            classes: itemClasses.isEmpty ? nil : itemClasses,
            data: [
                "breadcrumb-position": String(index + 1),
                "breadcrumb-current": isLast ? "true" : "false"
            ]
        ) {
            switch item.type {
            case .link(let href, let external):
                breadcrumbLinkElement(item, href: href, index: index, external: external)
            case .text:
                breadcrumbTextElement(item, index: index, isLast: isLast)
            case .ellipsis:
                breadcrumbEllipsisElement()
            }
            
            if !isLast {
                separatorElement
            }
        }
    }
    
    private func breadcrumbLinkElement(_ item: BreadcrumbItem, href: String, index: Int, external: Bool) -> some Markup {
        let linkClasses = ["breadcrumb-link"]
        var linkData: [String: String] = [:]
        
        if external {
            linkData["external"] = "true"
        }
        
        return Link(
            to: href,
            classes: linkClasses.isEmpty ? nil : linkClasses,
            data: linkData.isEmpty ? nil : linkData
        ) {
            if showHomeIcon && index == 0 {
                Icon(.home, size: iconSizeForBreadcrumbSize, classes: ["breadcrumb-home-icon"])
            } else if let icon = item.icon {
                Icon(icon, size: iconSizeForBreadcrumbSize, classes: ["breadcrumb-icon"])
            }
            
            ElementBuilder.text(item.label)
        }
    }
    
    private func breadcrumbTextElement(_ item: BreadcrumbItem, index: Int, isLast: Bool) -> some Markup {
        let textClasses = ["breadcrumb-text"] + (isLast ? ["breadcrumb-current"] : [])
        
        return ElementBuilder.section(
            classes: textClasses
        ) {
            if showHomeIcon && index == 0 {
                Icon(.home, size: iconSizeForBreadcrumbSize, classes: ["breadcrumb-home-icon"])
            } else if let icon = item.icon {
                Icon(icon, size: iconSizeForBreadcrumbSize, classes: ["breadcrumb-icon"])
            }
            
            if isLast {
                ElementBuilder.text(item.label, classes: ["breadcrumb-current-text"])
            } else {
                ElementBuilder.text(item.label)
            }
        }
    }
    
    private func breadcrumbEllipsisElement() -> some Markup {
        ElementBuilder.section(
            classes: ["breadcrumb-ellipsis"],
            role: .button,
            data: ["breadcrumb-expand": "true"]
        ) {
            Icon(.moreHorizontal, size: iconSizeForBreadcrumbSize, classes: ["breadcrumb-ellipsis-icon"])
        }
    }
    
    private var separatorElement: some Markup {
        ElementBuilder.section(
            classes: ["breadcrumb-separator"],
            role: .separator
        ) {
            switch separator {
            case .text(let text):
                ElementBuilder.text(text)
            case .icon(let icon):
                Icon(icon, size: iconSizeForBreadcrumbSize, classes: ["breadcrumb-separator-icon"])
            case .custom(let markup):
                markup
            }
        }
    }
    
    private var structuredDataScript: some Markup {
        let structuredData = generateStructuredData()
        
        return Script {
            structuredData
        }
    }
    
    private var iconSizeForBreadcrumbSize: Icon.IconSize {
        switch size {
        case .extraSmall: return .small
        case .small: return .small
        case .medium: return .medium
        case .large: return .medium
        case .extraLarge: return .large
        }
    }
    
    private func processItems() -> [BreadcrumbItem] {
        guard let maxItems = maxItems, items.count > maxItems else {
            return items
        }
        
        // Keep first item, last few items, and add ellipsis in between
        let keepLast = max(1, maxItems - 2) // Reserve space for first item and ellipsis
        let firstItem = [items.first!]
        let ellipsis = [BreadcrumbItem.ellipsis]
        let lastItems = Array(items.suffix(keepLast))
        
        return firstItem + ellipsis + lastItems
    }
    
    private func generateStructuredData() -> String {
        let breadcrumbListItems = items.enumerated().compactMap { index, item -> String? in
            switch item.type {
            case .link(let href, _):
                return """
                {
                    "@type": "ListItem",
                    "position": \(index + 1),
                    "name": "\(item.label.replacingOccurrences(of: "\"", with: "\\\""))",
                    "item": "\(href)"
                }
                """
            case .text:
                return """
                {
                    "@type": "ListItem",
                    "position": \(index + 1),
                    "name": "\(item.label.replacingOccurrences(of: "\"", with: "\\\""))"
                }
                """
            case .ellipsis:
                return nil
            }
        }
        
        return """
        {
            "@context": "https://schema.org",
            "@type": "BreadcrumbList",
            "itemListElement": [
                \(breadcrumbListItems.joined(separator: ",\n        "))
            ]
        }
        """
    }
    
    private func buildDataAttributes() -> [String: String] {
        var attributes: [String: String] = [:]
        
        attributes["separator"] = separator.dataValue
        attributes["size"] = size.rawValue
        
        if showStructuredData {
            attributes["structured-data"] = "true"
        }
        
        if showHomeIcon {
            attributes["home-icon"] = "true"
        }
        
        if let maxItems = maxItems {
            attributes["max-items"] = String(maxItems)
        }
        
        return attributes
    }
    
    // MARK: - Component Styles
    
    public var baseStyles: ComponentStyles {
        return ComponentStyles(
            classes: ["breadcrumb"],
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
            .extraSmall: ComponentStyles(classes: ["size-xs"]),
            .small: ComponentStyles(classes: ["size-sm"]),
            .medium: ComponentStyles(classes: ["size-md"]),
            .large: ComponentStyles(classes: ["size-lg"]),
            .extraLarge: ComponentStyles(classes: ["size-xl"])
        ]
    }
}

// MARK: - Supporting Types

/// Breadcrumb item configuration
public struct BreadcrumbItem: Identifiable {
    public let id = UUID()
    public let label: String
    public let icon: LucideIcon?
    public let type: BreadcrumbItemType
    
    public init(
        label: String,
        icon: LucideIcon? = nil,
        type: BreadcrumbItemType
    ) {
        self.label = label
        self.icon = icon
        self.type = type
    }
}

/// Breadcrumb item types
public enum BreadcrumbItemType {
    case link(href: String, external: Bool = false)
    case text
    case ellipsis
}

/// Breadcrumb separators
public enum BreadcrumbSeparator {
    case text(String)
    case icon(LucideIcon)
    case custom(any Markup)
    
    var dataValue: String {
        switch self {
        case .text(let text):
            return "text:\(text)"
        case .icon(let icon):
            return "icon:\(icon.rawValue)"
        case .custom:
            return "custom"
        }
    }
}

// MARK: - BreadcrumbItem Convenience Initializers

extension BreadcrumbItem {
    /// Creates a link breadcrumb item.
    ///
    /// - Parameters:
    ///   - href: Link URL
    ///   - label: Link text
    ///   - icon: Optional icon
    ///   - external: Whether link is external
    /// - Returns: Link breadcrumb item
    public static func link(
        href: String,
        label: String,
        icon: LucideIcon? = nil,
        external: Bool = false
    ) -> BreadcrumbItem {
        return BreadcrumbItem(
            label: label,
            icon: icon,
            type: .link(href: href, external: external)
        )
    }
    
    /// Creates a text breadcrumb item.
    ///
    /// - Parameters:
    ///   - label: Text content
    ///   - icon: Optional icon
    /// - Returns: Text breadcrumb item
    public static func text(
        _ label: String,
        icon: LucideIcon? = nil
    ) -> BreadcrumbItem {
        return BreadcrumbItem(
            label: label,
            icon: icon,
            type: .text
        )
    }
    
    /// Creates an ellipsis breadcrumb item for collapsed navigation.
    ///
    /// - Returns: Ellipsis breadcrumb item
    public static var ellipsis: BreadcrumbItem {
        return BreadcrumbItem(
            label: "...",
            type: .ellipsis
        )
    }
}

// MARK: - Convenience Initializers

extension UIBreadcrumb {
    /// Creates a simple breadcrumb with text separators.
    ///
    /// - Parameters:
    ///   - items: Breadcrumb items
    ///   - separator: Text separator (default: "/")
    /// - Returns: Simple breadcrumb
    public static func simple(
        items: [BreadcrumbItem],
        separator: String = "/"
    ) -> UIBreadcrumb {
        return UIBreadcrumb(
            items: items,
            separator: .text(separator)
        )
    }
    
    /// Creates a breadcrumb with home icon.
    ///
    /// - Parameters:
    ///   - items: Breadcrumb items
    ///   - separator: Separator (default: chevron right icon)
    /// - Returns: Breadcrumb with home icon
    public static func withHomeIcon(
        items: [BreadcrumbItem],
        separator: BreadcrumbSeparator = .icon(.chevronRight)
    ) -> UIBreadcrumb {
        return UIBreadcrumb(
            items: items,
            separator: separator,
            showHomeIcon: true
        )
    }
    
    /// Creates a compact breadcrumb that collapses when too many items.
    ///
    /// - Parameters:
    ///   - items: Breadcrumb items
    ///   - maxItems: Maximum items to show before collapsing
    ///   - separator: Separator (default: chevron right icon)
    /// - Returns: Compact breadcrumb
    public static func compact(
        items: [BreadcrumbItem],
        maxItems: Int = 5,
        separator: BreadcrumbSeparator = .icon(.chevronRight)
    ) -> UIBreadcrumb {
        return UIBreadcrumb(
            items: items,
            separator: separator,
            maxItems: maxItems
        )
    }
}