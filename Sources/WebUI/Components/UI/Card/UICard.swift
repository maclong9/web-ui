import Foundation

/// A headless card component for grouping related content with optional header and footer.
///
/// `UICard` provides a flexible container component with:
/// - Minimal structural CSS (layout, spacing, structure only)
/// - Optional header and footer sections
/// - Flexible content area
/// - Accessibility support
/// - Customizable styling through CSS classes
///
/// ## Design Philosophy
///
/// This card follows a headless-first approach:
/// - Provides structure and layout without visual styling
/// - No colors, shadows, or decorative elements by default
/// - Extensive customization through CSS classes and CSS variables
/// - Can be styled with any design system or custom CSS
///
/// ## Usage
///
/// ```swift
/// // Basic card with content
/// UICard {
///     Text("Card content goes here")
/// }
///
/// // Card with header and footer
/// UICard(
///     header: { Text("Card Title") },
///     footer: { UIButton("Action") }
/// ) {
///     Text("Main content area")
/// }
///
/// // Card with custom styling
/// UICard(customClasses: ["feature-card", "highlight"]) {
///     // Content
/// }
/// ```
public struct UICard<Content: Markup, Header: Markup, Footer: Markup>: ComponentBase {
    // MARK: - Properties
    
    /// Main content of the card
    public let content: Content
    
    /// Optional header content
    public let header: Header?
    
    /// Optional footer content
    public let footer: Footer?
    
    /// Whether the card is interactive (clickable)
    public let interactive: Bool
    
    /// Component base properties
    public var variant: ComponentVariant
    public var size: ComponentSize
    public var disabled: Bool
    public var customClasses: [String]
    public var accessibilityRole: AriaRole?
    
    // MARK: - Initialization
    
    /// Creates a new UI card with header, footer, and content.
    ///
    /// - Parameters:
    ///   - variant: Card variant (default: .default)
    ///   - interactive: Whether card is interactive (default: false)
    ///   - customClasses: Additional CSS classes (default: [])
    ///   - header: Header content builder
    ///   - footer: Footer content builder
    ///   - content: Main content builder
    public init(
        variant: ComponentVariant = .default,
        interactive: Bool = false,
        customClasses: [String] = [],
        @MarkupBuilder header: () -> Header,
        @MarkupBuilder footer: () -> Footer,
        @MarkupBuilder content: () -> Content
    ) {
        self.variant = variant
        self.interactive = interactive
        self.customClasses = customClasses
        self.header = header()
        self.footer = footer()
        self.content = content()
        self.size = .medium
        self.disabled = false
        self.accessibilityRole = interactive ? .button : .complementary
    }
    
    // MARK: - Element Implementation
    
    public var body: MarkupString {
        let allClasses = baseStyles.classes + 
                        (variantStyles[variant] ?? .empty).classes +
                        customClasses
        
        let allData = buildDataAttributes()
        
        if interactive {
            // Interactive cards use section with button semantics
            let interactiveData = allData.merging(["interactive": "true"]) { _, new in new }
            let element = Section(
                classes: allClasses,
                role: .button,
                data: interactiveData
            ) {
                if let headerContent = header {
                    Section(classes: ["card-header"]) {
                        headerContent
                    }
                }
                
                Section(classes: ["card-content"]) {
                    content
                }
                
                if let footerContent = footer {
                    Section(classes: ["card-footer"]) {
                        footerContent
                    }
                }
            }
            return MarkupString(content: element.render())
        } else {
            // Static cards use article semantics
            let element = Article(
                classes: allClasses,
                data: allData
            ) {
                if let headerContent = header {
                    Section(classes: ["card-header"]) {
                        headerContent
                    }
                }
                
                Section(classes: ["card-content"]) {
                    content
                }
                
                if let footerContent = footer {
                    Section(classes: ["card-footer"]) {
                        footerContent
                    }
                }
            }
            return MarkupString(content: element.render())
        }
    }
    
    // MARK: - Helper Methods
    
    private func buildDataAttributes() -> [String: String] {
        var attributes: [String: String] = [:]
        
        attributes["variant"] = variant.rawValue
        
        if interactive {
            attributes["interactive"] = "true"
        }
        
        if disabled {
            attributes["disabled"] = "true"
        }
        
        return attributes
    }
    
    // MARK: - Component Styles
    
    public var baseStyles: ComponentStyles {
        return ComponentStyles(
            classes: ["card"],
            properties: [:],
            dataAttributes: [:]
        )
    }
    
    public var variantStyles: [ComponentVariant: ComponentStyles] {
        return [
            .default: ComponentStyles(classes: ["variant-default"]),
            .primary: ComponentStyles(classes: ["variant-primary"]),
            .secondary: ComponentStyles(classes: ["variant-secondary"]),
            .outline: ComponentStyles(classes: ["variant-outline"])
        ]
    }
    
    public var sizeStyles: [ComponentSize: ComponentStyles] {
        return [:] // Cards don't typically have size variants
    }
}

// MARK: - Convenience Initializers

extension UICard where Header == EmptyMarkup {
    /// Creates a card without a header.
    ///
    /// - Parameters:
    ///   - variant: Card variant (default: .default)
    ///   - interactive: Whether card is interactive (default: false)
    ///   - customClasses: Additional CSS classes (default: [])
    ///   - footer: Footer content builder
    ///   - content: Main content builder
    public init(
        variant: ComponentVariant = .default,
        interactive: Bool = false,
        customClasses: [String] = [],
        @MarkupBuilder footer: () -> Footer,
        @MarkupBuilder content: () -> Content
    ) {
        self.variant = variant
        self.interactive = interactive
        self.customClasses = customClasses
        self.header = nil
        self.footer = footer()
        self.content = content()
        self.size = .medium
        self.disabled = false
        self.accessibilityRole = interactive ? .button : .complementary
    }
}

extension UICard where Footer == EmptyMarkup {
    /// Creates a card without a footer.
    ///
    /// - Parameters:
    ///   - variant: Card variant (default: .default)
    ///   - interactive: Whether card is interactive (default: false)
    ///   - customClasses: Additional CSS classes (default: [])
    ///   - header: Header content builder
    ///   - content: Main content builder
    public init(
        variant: ComponentVariant = .default,
        interactive: Bool = false,
        customClasses: [String] = [],
        @MarkupBuilder header: () -> Header,
        @MarkupBuilder content: () -> Content
    ) {
        self.variant = variant
        self.interactive = interactive
        self.customClasses = customClasses
        self.header = header()
        self.footer = nil
        self.content = content()
        self.size = .medium
        self.disabled = false
        self.accessibilityRole = interactive ? .button : .complementary
    }
}

extension UICard where Header == EmptyMarkup, Footer == EmptyMarkup {
    /// Creates a simple card with only content.
    ///
    /// - Parameters:
    ///   - variant: Card variant (default: .default)
    ///   - interactive: Whether card is interactive (default: false)
    ///   - customClasses: Additional CSS classes (default: [])
    ///   - content: Main content builder
    public init(
        variant: ComponentVariant = .default,
        interactive: Bool = false,
        customClasses: [String] = [],
        @MarkupBuilder content: () -> Content
    ) {
        self.variant = variant
        self.interactive = interactive
        self.customClasses = customClasses
        self.header = nil
        self.footer = nil
        self.content = content()
        self.size = .medium
        self.disabled = false
        self.accessibilityRole = interactive ? .button : .complementary
    }
}

// MARK: - Empty Markup Helper

/// Helper type for optional card sections
public struct EmptyMarkup: Markup {
    public init() {}
    
    public var body: MarkupString {
        return MarkupString(content: "")
    }
}

// MARK: - Specialized Card Types

// Note: The following factory methods are commented out due to a design issue
// with @MarkupBuilder returning [any Markup] instead of concrete types.
// This is a broader codebase issue that needs to be addressed separately.

/*
extension UICard {
    /// Creates a feature card with highlighted styling.
    ///
    /// - Parameters:
    ///   - title: Card title
    ///   - description: Card description
    /// - Returns: Feature card
    public static func feature(
        title: String,
        description: String
    ) -> UICard<MarkupString, MarkupString, EmptyMarkup> {
        return UICard<MarkupString, MarkupString, EmptyMarkup>(
            variant: .primary,
            customClasses: ["feature-card"],
            header: { MarkupString(content: Heading(.headline, classes: ["card-title"]) { title }.render()) },
            footer: { EmptyMarkup() }
        ) {
            MarkupString(content: ElementBuilder.text(description, classes: ["card-description"]).render())
        }
    }
    
    /// Creates a stats card for displaying metrics.
    ///
    /// - Parameters:
    ///   - label: Metric label
    ///   - value: Metric value
    ///   - change: Optional change indicator
    /// - Returns: Stats card
    public static func stats(
        label: String,
        value: String,
        change: String? = nil
    ) -> UICard<MarkupString, EmptyMarkup, MarkupString> {
        return UICard<MarkupString, EmptyMarkup, MarkupString>(
            variant: .default,
            customClasses: ["stats-card"],
            header: { EmptyMarkup() },
            footer: { MarkupString(content: ElementBuilder.text(change ?? "", classes: change != nil ? ["stats-change"] : []).render()) }
        ) {
            MarkupString(content: ElementBuilder.section(classes: ["stats-content"]) {
                ElementBuilder.text(value, classes: ["stats-value"])
                ElementBuilder.text(label, classes: ["stats-label"])
            }.render())
        }
    }
}
*/