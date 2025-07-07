import Foundation

/// A headless container component for layout composition and content organization.
///
/// `UIContainer` provides a flexible layout container with:
/// - Minimal structural CSS (layout, spacing, structure only)
/// - Responsive layout options (flex, grid, stack)
/// - Content alignment and distribution controls
/// - Padding and spacing management
/// - Accessibility support with semantic HTML elements
/// - Custom styling through CSS classes
///
/// ## Design Philosophy
///
/// This container follows a headless-first approach:
/// - Provides structure and layout without visual styling
/// - No colors, borders, or decorative elements by default
/// - Extensive customization through CSS classes and CSS variables
/// - Can be styled with any design system or custom CSS
///
/// ## Usage
///
/// ```swift
/// // Basic flex container
/// UIContainer(layout: .flex(.row)) {
///     UIButton("Button 1")
///     UIButton("Button 2")
/// }
///
/// // Grid container with responsive columns
/// UIContainer(layout: .grid(columns: 3, gap: .medium)) {
///     UICard { "Card 1" }
///     UICard { "Card 2" }
///     UICard { "Card 3" }
/// }
///
/// // Stack container with spacing
/// UIContainer(layout: .stack(.vertical, spacing: .large)) {
///     Text("Header")
///     Text("Content")
///     UIButton("Action")
/// }
/// ```
public struct UIContainer<Content: Markup>: ComponentBase {
    // MARK: - Properties
    
    /// Container content
    public let content: Content
    
    /// Layout configuration
    public let layout: ContainerLayout
    
    /// Content alignment
    public let alignment: ContentAlignment
    
    /// Padding configuration
    public let padding: PaddingConfiguration
    
    /// Maximum width constraint
    public let maxWidth: MaxWidth?
    
    /// Whether the container should be centered
    public let centered: Bool
    
    /// Semantic HTML element to use
    public let semanticElement: SemanticElement
    
    /// Component base properties
    public var variant: ComponentVariant
    public var size: ComponentSize
    public var disabled: Bool
    public var customClasses: [String]
    public var accessibilityRole: AriaRole?
    
    // MARK: - Initialization
    
    /// Creates a new UI container with the specified configuration.
    ///
    /// - Parameters:
    ///   - layout: Layout configuration (default: .flex(.column))
    ///   - alignment: Content alignment (default: .start)
    ///   - padding: Padding configuration (default: .none)
    ///   - maxWidth: Maximum width constraint (default: nil)
    ///   - centered: Whether container should be centered (default: false)
    ///   - semanticElement: Semantic HTML element (default: .div)
    ///   - customClasses: Additional CSS classes (default: [])
    ///   - content: Container content
    public init(
        layout: ContainerLayout = .flex(.column),
        alignment: ContentAlignment = .start,
        padding: PaddingConfiguration = .none,
        maxWidth: MaxWidth? = nil,
        centered: Bool = false,
        semanticElement: SemanticElement = .div,
        customClasses: [String] = [],
        @MarkupBuilder content: () -> Content
    ) {
        self.layout = layout
        self.alignment = alignment
        self.padding = padding
        self.maxWidth = maxWidth
        self.centered = centered
        self.semanticElement = semanticElement
        self.customClasses = customClasses
        self.content = content()
        self.variant = .default
        self.size = .medium
        self.disabled = false
        self.accessibilityRole = nil
    }
    
    // MARK: - Element Implementation
    
    public var body: MarkupString {
        let allClasses = baseStyles.classes + 
                        layoutClasses +
                        alignmentClasses +
                        paddingClasses +
                        maxWidthClasses +
                        centeredClasses +
                        customClasses
        
        let allData = buildDataAttributes()
        
        let element: any Markup = switch semanticElement {
        case .div:
            ElementBuilder.section(
                classes: allClasses,
                data: allData
            ) {
                content
            }
        case .main:
            Main(
                classes: allClasses.isEmpty ? nil : allClasses,
                data: allData.isEmpty ? nil : allData
            ) {
                content
            }
        case .section:
            Section(
                classes: allClasses.isEmpty ? nil : allClasses,
                data: allData.isEmpty ? nil : allData
            ) {
                content
            }
        case .article:
            Article(
                classes: allClasses.isEmpty ? nil : allClasses,
                data: allData.isEmpty ? nil : allData
            ) {
                content
            }
        case .header:
            Header(
                classes: allClasses.isEmpty ? nil : allClasses,
                data: allData.isEmpty ? nil : allData
            ) {
                content
            }
        case .footer:
            Footer(
                classes: allClasses.isEmpty ? nil : allClasses,
                data: allData.isEmpty ? nil : allData
            ) {
                content
            }
        case .aside:
            Aside(
                classes: allClasses.isEmpty ? nil : allClasses,
                data: allData.isEmpty ? nil : allData
            ) {
                content
            }
        case .nav:
            Nav(
                classes: allClasses.isEmpty ? nil : allClasses,
                data: allData.isEmpty ? nil : allData
            ) {
                content
            }
        }
        
        return MarkupString(content: element.render())
    }
    
    // MARK: - Style Classes
    
    private var layoutClasses: [String] {
        switch layout {
        case .flex(let direction):
            return ["layout-flex", "flex-\(direction.rawValue)"]
        case .grid(let columns, let gap):
            var classes = ["layout-grid", "grid-cols-\(columns)"]
            if let gap = gap {
                classes.append("gap-\(gap.rawValue)")
            }
            return classes
        case .stack(let direction, let spacing):
            var classes = ["layout-stack", "stack-\(direction.rawValue)"]
            if let spacing = spacing {
                classes.append("stack-spacing-\(spacing.rawValue)")
            }
            return classes
        case .block:
            return ["layout-block"]
        case .inline:
            return ["layout-inline"]
        }
    }
    
    private var alignmentClasses: [String] {
        switch alignment {
        case .start:
            return ["align-start"]
        case .center:
            return ["align-center"]
        case .end:
            return ["align-end"]
        case .stretch:
            return ["align-stretch"]
        case .spaceBetween:
            return ["align-space-between"]
        case .spaceAround:
            return ["align-space-around"]
        case .spaceEvenly:
            return ["align-space-evenly"]
        }
    }
    
    private var paddingClasses: [String] {
        switch padding {
        case .none:
            return []
        case .uniform(let size):
            return ["p-\(size.rawValue)"]
        case .horizontal(let size):
            return ["px-\(size.rawValue)"]
        case .vertical(let size):
            return ["py-\(size.rawValue)"]
        case .custom(let top, let right, let bottom, let left):
            var classes: [String] = []
            if let top = top { classes.append("pt-\(top.rawValue)") }
            if let right = right { classes.append("pr-\(right.rawValue)") }
            if let bottom = bottom { classes.append("pb-\(bottom.rawValue)") }
            if let left = left { classes.append("pl-\(left.rawValue)") }
            return classes
        }
    }
    
    private var maxWidthClasses: [String] {
        guard let maxWidth = maxWidth else { return [] }
        return ["max-w-\(maxWidth.rawValue)"]
    }
    
    private var centeredClasses: [String] {
        return centered ? ["mx-auto"] : []
    }
    
    private func buildDataAttributes() -> [String: String] {
        var attributes: [String: String] = [:]
        
        attributes["layout"] = layout.dataValue
        attributes["alignment"] = alignment.rawValue
        attributes["semantic"] = semanticElement.rawValue
        
        if centered {
            attributes["centered"] = "true"
        }
        
        if let maxWidth = maxWidth {
            attributes["max-width"] = maxWidth.rawValue
        }
        
        return attributes
    }
    
    // MARK: - Component Styles
    
    public var baseStyles: ComponentStyles {
        return ComponentStyles(
            classes: ["container"],
            properties: [:],
            dataAttributes: [:]
        )
    }
    
    public var variantStyles: [ComponentVariant: ComponentStyles] {
        return [:] // Containers don't typically have variants
    }
    
    public var sizeStyles: [ComponentSize: ComponentStyles] {
        return [:] // Containers don't typically have size variants
    }
}

// MARK: - Supporting Types

/// Layout configurations for containers
public enum ContainerLayout {
    case flex(ContainerFlexDirection)
    case grid(columns: Int, gap: SpacingSize?)
    case stack(StackDirection, spacing: SpacingSize?)
    case block
    case inline
    
    var dataValue: String {
        switch self {
        case .flex(let direction):
            return "flex-\(direction.rawValue)"
        case .grid(let columns, _):
            return "grid-\(columns)"
        case .stack(let direction, _):
            return "stack-\(direction.rawValue)"
        case .block:
            return "block"
        case .inline:
            return "inline"
        }
    }
}

/// Flex direction options for containers
public enum ContainerFlexDirection: String, CaseIterable {
    case row = "row"
    case column = "column"
    case rowReverse = "row-reverse"
    case columnReverse = "column-reverse"
}

/// Stack direction options
public enum StackDirection: String, CaseIterable {
    case vertical = "vertical"
    case horizontal = "horizontal"
}

/// Content alignment options
public enum ContentAlignment: String, CaseIterable {
    case start = "start"
    case center = "center"
    case end = "end"
    case stretch = "stretch"
    case spaceBetween = "space-between"
    case spaceAround = "space-around"
    case spaceEvenly = "space-evenly"
}

/// Padding configuration options
public enum PaddingConfiguration {
    case none
    case uniform(SpacingSize)
    case horizontal(SpacingSize)
    case vertical(SpacingSize)
    case custom(top: SpacingSize?, right: SpacingSize?, bottom: SpacingSize?, left: SpacingSize?)
}

/// Spacing size options
public enum SpacingSize: String, CaseIterable {
    case none = "0"
    case xs = "1"
    case sm = "2"
    case md = "4"
    case lg = "6"
    case xl = "8"
    case xl2 = "12"
    case xl3 = "16"
    case xl4 = "20"
    case xl5 = "24"
    case xl6 = "32"
}

/// Maximum width constraints
public enum MaxWidth: String, CaseIterable {
    case xs = "xs"
    case sm = "sm"
    case md = "md"
    case lg = "lg"
    case xl = "xl"
    case xl2 = "2xl"
    case xl3 = "3xl"
    case xl4 = "4xl"
    case xl5 = "5xl"
    case xl6 = "6xl"
    case xl7 = "7xl"
    case full = "full"
    case screen = "screen"
}

/// Semantic HTML elements
public enum SemanticElement: String, CaseIterable {
    case div = "div"
    case main = "main"
    case section = "section"
    case article = "article"
    case header = "header"
    case footer = "footer"
    case aside = "aside"
    case nav = "nav"
}

// MARK: - Convenience Initializers

extension UIContainer {
    /// Creates a flex container with row layout.
    ///
    /// - Parameters:
    ///   - alignment: Content alignment (default: .start)
    ///   - padding: Padding configuration (default: .none)
    ///   - content: Container content
    /// - Returns: Flex row container
    public static func flexRow(
        alignment: ContentAlignment = .start,
        padding: PaddingConfiguration = .none,
        @MarkupBuilder content: () -> Content
    ) -> UIContainer<Content> {
        return UIContainer(
            layout: .flex(.row),
            alignment: alignment,
            padding: padding,
            content: content
        )
    }
    
    /// Creates a flex container with column layout.
    ///
    /// - Parameters:
    ///   - alignment: Content alignment (default: .start)
    ///   - padding: Padding configuration (default: .none)
    ///   - content: Container content
    /// - Returns: Flex column container
    public static func flexColumn(
        alignment: ContentAlignment = .start,
        padding: PaddingConfiguration = .none,
        @MarkupBuilder content: () -> Content
    ) -> UIContainer<Content> {
        return UIContainer(
            layout: .flex(.column),
            alignment: alignment,
            padding: padding,
            content: content
        )
    }
    
    /// Creates a grid container.
    ///
    /// - Parameters:
    ///   - columns: Number of grid columns
    ///   - gap: Gap size between grid items (default: .md)
    ///   - padding: Padding configuration (default: .none)
    ///   - content: Container content
    /// - Returns: Grid container
    public static func grid(
        columns: Int,
        gap: SpacingSize = .md,
        padding: PaddingConfiguration = .none,
        @MarkupBuilder content: () -> Content
    ) -> UIContainer<Content> {
        return UIContainer(
            layout: .grid(columns: columns, gap: gap),
            padding: padding,
            content: content
        )
    }
    
    /// Creates a vertical stack container.
    ///
    /// - Parameters:
    ///   - spacing: Spacing between stack items (default: .md)
    ///   - alignment: Content alignment (default: .start)
    ///   - padding: Padding configuration (default: .none)
    ///   - content: Container content
    /// - Returns: Vertical stack container
    public static func vStack(
        spacing: SpacingSize = .md,
        alignment: ContentAlignment = .start,
        padding: PaddingConfiguration = .none,
        @MarkupBuilder content: () -> Content
    ) -> UIContainer<Content> {
        return UIContainer(
            layout: .stack(.vertical, spacing: spacing),
            alignment: alignment,
            padding: padding,
            content: content
        )
    }
    
    /// Creates a horizontal stack container.
    ///
    /// - Parameters:
    ///   - spacing: Spacing between stack items (default: .md)
    ///   - alignment: Content alignment (default: .start)
    ///   - padding: Padding configuration (default: .none)
    ///   - content: Container content
    /// - Returns: Horizontal stack container
    public static func hStack(
        spacing: SpacingSize = .md,
        alignment: ContentAlignment = .start,
        padding: PaddingConfiguration = .none,
        @MarkupBuilder content: () -> Content
    ) -> UIContainer<Content> {
        return UIContainer(
            layout: .stack(.horizontal, spacing: spacing),
            alignment: alignment,
            padding: padding,
            content: content
        )
    }
    
    /// Creates a centered container with maximum width.
    ///
    /// - Parameters:
    ///   - maxWidth: Maximum width constraint (default: .lg)
    ///   - padding: Padding configuration (default: .horizontal(.lg))
    ///   - content: Container content
    /// - Returns: Centered container
    public static func centered(
        maxWidth: MaxWidth = .lg,
        padding: PaddingConfiguration = .horizontal(.lg),
        @MarkupBuilder content: () -> Content
    ) -> UIContainer<Content> {
        return UIContainer(
            padding: padding,
            maxWidth: maxWidth,
            centered: true,
            content: content
        )
    }
}