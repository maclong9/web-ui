import Foundation

// MARK: - Typography Type Definitions

/// Text size options for typography
public enum TextSize: Hashable {
    case caption2
    case caption
    case footnote
    case subheadline
    case callout
    case body
    case headline
    case title3
    case title2
    case title
    case large
    case extraLarge
    case custom(Double)
    
    /// Medium is an alias for body
    public static let medium: TextSize = .body
}

/// Font weight options
public enum Weight: Hashable {
    case ultraLight
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black
}

/// Text alignment options
public enum Alignment: Hashable {
    case leading
    case center
    case trailing
    case justified
}

/// Line height options
public enum Leading: Hashable {
    case tight
    case snug
    case normal
    case relaxed
    case loose
}

/// Letter spacing options
public enum Tracking: Hashable {
    case tighter
    case tight
    case normal
    case wide
    case wider
    case widest
}

/// Text decoration options
public enum Decoration: Hashable {
    case none
    case underline
    case strikethrough
}

/// A comprehensive typography system for configuring the visual appearance of markdown elements.
///
/// The `MarkdownTypography` system provides declarative, composable typography configuration
/// that integrates seamlessly with the WebUI styling framework. It allows you to define
/// consistent typographic styles across all markdown elements while maintaining flexibility
/// for custom styling needs.
///
/// ## Usage
///
/// ```swift
/// let typography = MarkdownTypography {
///     heading(.h1) {
///         font(size: .extraLarge, weight: .bold)
///         spacing(bottom: .large)
///     }
///     
///     body {
///         font(family: "system-ui", size: .medium)
///         spacing(bottom: .medium)
///     }
///     
///     code {
///         font(family: "monospace")
///         background(color: .gray(._100))
///         padding(.small)
///     }
/// }
/// ```
public struct MarkdownTypography {
    
    // MARK: - Typography Style Definitions
    
    /// A typography style that can be applied to markdown elements.
    public struct TypographyStyle {
        /// Font styling properties
        public var font: FontProperties?
        
        /// Background styling properties
        public var background: BackgroundProperties?
        
        /// Padding properties
        public var padding: PaddingProperties?
        
        /// Margin properties
        public var margins: MarginProperties?
        
        /// Border properties
        public var border: BorderProperties?
        
        /// Additional CSS classes to apply
        public var cssClasses: Set<String>
        
        /// Additional CSS properties as key-value pairs
        public var customProperties: [String: String]
        
        /// Initialize a typography style
        public init(
            font: FontProperties? = nil,
            background: BackgroundProperties? = nil,
            padding: PaddingProperties? = nil,
            margins: MarginProperties? = nil,
            border: BorderProperties? = nil,
            cssClasses: Set<String> = [],
            customProperties: [String: String] = [:]
        ) {
            self.font = font
            self.background = background
            self.padding = padding
            self.margins = margins
            self.border = border
            self.cssClasses = cssClasses
            self.customProperties = customProperties
        }
        
        /// Merge this style with another style, with the other style taking precedence
        public func merged(with other: TypographyStyle) -> TypographyStyle {
            return TypographyStyle(
                font: other.font ?? self.font,
                background: other.background ?? self.background,
                padding: other.padding ?? self.padding,
                margins: other.margins ?? self.margins,
                border: other.border ?? self.border,
                cssClasses: self.cssClasses.union(other.cssClasses),
                customProperties: self.customProperties.merging(other.customProperties) { _, new in new }
            )
        }
    }
    
    // MARK: - Style Property Types
    
    /// Font properties for typography styling
    public struct FontProperties {
        public let family: String?
        public let size: TextSize?
        public let weight: Weight?
        public let alignment: Alignment?
        public let color: String?
        public let lineHeight: Leading?
        public let letterSpacing: Tracking?
        public let textDecoration: Decoration?
        public let textTransform: String?
        
        public init(
            family: String? = nil,
            size: TextSize? = nil,
            weight: Weight? = nil,
            alignment: Alignment? = nil,
            color: String? = nil,
            lineHeight: Leading? = nil,
            letterSpacing: Tracking? = nil,
            textDecoration: Decoration? = nil,
            textTransform: String? = nil
        ) {
            self.family = family
            self.size = size
            self.weight = weight
            self.alignment = alignment
            self.color = color
            self.lineHeight = lineHeight
            self.letterSpacing = letterSpacing
            self.textDecoration = textDecoration
            self.textTransform = textTransform
        }
    }
    
    /// Background properties for styling
    public struct BackgroundProperties {
        public let color: String?
        public let opacity: Double?
        
        public init(color: String? = nil, opacity: Double? = nil) {
            self.color = color
            self.opacity = opacity
        }
    }
    
    /// Padding properties
    public struct PaddingProperties {
        public let top: String?
        public let right: String?
        public let bottom: String?
        public let left: String?
        
        public init(top: String? = nil, right: String? = nil, bottom: String? = nil, left: String? = nil) {
            self.top = top
            self.right = right
            self.bottom = bottom
            self.left = left
        }
        
        public init(all: String) {
            self.top = all
            self.right = all
            self.bottom = all
            self.left = all
        }
        
        public init(vertical: String, horizontal: String) {
            self.top = vertical
            self.bottom = vertical
            self.left = horizontal
            self.right = horizontal
        }
    }
    
    /// Margin properties
    public struct MarginProperties {
        public let top: String?
        public let right: String?
        public let bottom: String?
        public let left: String?
        
        public init(top: String? = nil, right: String? = nil, bottom: String? = nil, left: String? = nil) {
            self.top = top
            self.right = right
            self.bottom = bottom
            self.left = left
        }
        
        public init(all: String) {
            self.top = all
            self.right = all
            self.bottom = all
            self.left = all
        }
        
        public init(vertical: String, horizontal: String) {
            self.top = vertical
            self.bottom = vertical
            self.left = horizontal
            self.right = horizontal
        }
    }
    
    /// Border properties
    public struct BorderProperties {
        public let width: String?
        public let style: String?
        public let color: String?
        public let radius: String?
        
        public init(width: String? = nil, style: String? = nil, color: String? = nil, radius: String? = nil) {
            self.width = width
            self.style = style
            self.color = color
            self.radius = radius
        }
    }
    
    // MARK: - Element Types
    
    /// Heading levels for typography configuration
    public enum HeadingLevel: Int, CaseIterable {
        case h1 = 1, h2 = 2, h3 = 3, h4 = 4, h5 = 5, h6 = 6
        
        /// HTML tag name for the heading level
        public var tagName: String {
            return "h\(self.rawValue)"
        }
        
        /// CSS class name for the heading level
        public var cssClassName: String {
            return "markdown-heading-\(self.rawValue)"
        }
    }
    
    /// Markdown element types for styling
    public enum ElementType: String, CaseIterable {
        case paragraph = "p"
        case emphasis = "em"
        case strong = "strong"
        case code = "code"
        case inlineCode = "code"
        case codeBlock = "pre"
        case blockquote = "blockquote"
        case orderedList = "ol"
        case unorderedList = "ul"
        case listItem = "li"
        case link = "a"
        case image = "img"
        case table = "table"
        case tableHeader = "th"
        case tableCell = "td"
        case tableRow = "tr"
        case horizontalRule = "hr"
        
        /// CSS class name for the element type
        public var cssClassName: String {
            return "markdown-\(self.rawValue)"
        }
    }
    
    // MARK: - Configuration Properties
    
    /// Typography styles for different heading levels
    public var headings: [HeadingLevel: TypographyStyle]
    
    /// Typography styles for different element types
    public var elements: [ElementType: TypographyStyle]
    
    /// Typography styles for specific CSS selectors (IDs and classes)
    public var selectors: [String: TypographyStyle]
    
    /// Default font family to use as fallback
    public var defaultFontFamily: String
    
    /// Default font size to use as fallback
    public var defaultFontSize: TextSize
    
    /// Whether to include responsive typography adjustments
    public var enableResponsiveTypography: Bool
    
    // MARK: - Initialization
    
    /// Initialize typography configuration
    public init(
        headings: [HeadingLevel: TypographyStyle] = [:],
        elements: [ElementType: TypographyStyle] = [:],
        selectors: [String: TypographyStyle] = [:],
        defaultFontFamily: String = "system-ui, -apple-system, sans-serif",
        defaultFontSize: TextSize = .medium,
        enableResponsiveTypography: Bool = true
    ) {
        self.headings = headings
        self.elements = elements
        self.selectors = selectors
        self.defaultFontFamily = defaultFontFamily
        self.defaultFontSize = defaultFontSize
        self.enableResponsiveTypography = enableResponsiveTypography
    }
    
    // MARK: - Builder Methods
    
    /// Set typography style for a specific heading level
    public mutating func heading(_ level: HeadingLevel, style: TypographyStyle) {
        headings[level] = style
    }
    
    /// Set typography style for a specific element type
    public mutating func element(_ type: ElementType, style: TypographyStyle) {
        elements[type] = style
    }
    
    /// Set typography style for a specific CSS selector
    public mutating func selector(_ selector: String, style: TypographyStyle) {
        selectors[selector] = style
    }
    
    // MARK: - Style Retrieval
    
    /// Get the typography style for a heading level
    public func style(for heading: HeadingLevel) -> TypographyStyle? {
        return headings[heading]
    }
    
    /// Get the typography style for an element type
    public func style(for element: ElementType) -> TypographyStyle? {
        return elements[element]
    }
    
    /// Get the typography style for a CSS selector
    public func style(for selector: String) -> TypographyStyle? {
        return selectors[selector]
    }
    
    // MARK: - Preset Configurations
    
    /// Default typography configuration with sensible defaults
    public static let `default` = MarkdownTypography(
        headings: [
            .h1: TypographyStyle(
                font: FontProperties(size: .extraLarge, weight: .bold),
                margins: MarginProperties(bottom: "1.5rem")
            ),
            .h2: TypographyStyle(
                font: FontProperties(size: .large, weight: .bold),
                margins: MarginProperties(bottom: "1.25rem")
            ),
            .h3: TypographyStyle(
                font: FontProperties(size: .title, weight: .semibold),
                margins: MarginProperties(bottom: "1rem")
            ),
            .h4: TypographyStyle(
                font: FontProperties(size: .headline, weight: .semibold),
                margins: MarginProperties(bottom: "0.75rem")
            ),
            .h5: TypographyStyle(
                font: FontProperties(size: .subheadline, weight: .medium),
                margins: MarginProperties(bottom: "0.5rem")
            ),
            .h6: TypographyStyle(
                font: FontProperties(size: .footnote, weight: .medium),
                margins: MarginProperties(bottom: "0.5rem")
            )
        ],
        elements: [
            .paragraph: TypographyStyle(
                margins: MarginProperties(bottom: "1rem")
            ),
            .code: TypographyStyle(
                font: FontProperties(family: "ui-monospace, Menlo, Monaco, monospace"),
                background: BackgroundProperties(color: "rgb(248 250 252)"),
                padding: PaddingProperties(vertical: "0.125rem", horizontal: "0.25rem"),
                border: BorderProperties(radius: "0.25rem")
            ),
            .codeBlock: TypographyStyle(
                font: FontProperties(family: "ui-monospace, Menlo, Monaco, monospace"),
                background: BackgroundProperties(color: "rgb(248 250 252)"),
                padding: PaddingProperties(all: "1rem"),
                border: BorderProperties(radius: "0.5rem"),
                margins: MarginProperties(bottom: "1rem")
            ),
            .blockquote: TypographyStyle(
                padding: PaddingProperties(left: "1rem"),
                border: BorderProperties(width: "0", style: "solid", color: "rgb(229 231 235)"),
                margins: MarginProperties(bottom: "1rem"),
                customProperties: ["border-left-width": "4px"]
            ),
            .link: TypographyStyle(
                font: FontProperties(color: "rgb(59 130 246)", textDecoration: .underline)
            )
        ]
    )
    
    /// Clean, minimal typography suitable for documentation
    public static let documentation = MarkdownTypography(
        headings: [
            .h1: TypographyStyle(
                font: FontProperties(size: .extraLarge, weight: .bold, lineHeight: .tight),
                margins: MarginProperties(bottom: "2rem"),
                border: BorderProperties(width: "0", style: "solid", color: "rgb(229 231 235)"),
                customProperties: ["border-bottom-width": "1px", "padding-bottom": "0.5rem"]
            ),
            .h2: TypographyStyle(
                font: FontProperties(size: .large, weight: .semibold, lineHeight: .tight),
                margins: MarginProperties(top: "2rem", bottom: "1rem")
            ),
            .h3: TypographyStyle(
                font: FontProperties(size: .title, weight: .semibold),
                margins: MarginProperties(top: "1.5rem", bottom: "0.75rem")
            )
        ],
        elements: [
            .paragraph: TypographyStyle(
                font: FontProperties(lineHeight: .relaxed),
                margins: MarginProperties(bottom: "1rem")
            ),
            .code: TypographyStyle(
                font: FontProperties(family: "ui-monospace, Menlo, Monaco, monospace", size: .footnote),
                background: BackgroundProperties(color: "rgb(248 250 252)"),
                padding: PaddingProperties(vertical: "0.125rem", horizontal: "0.375rem"),
                border: BorderProperties(radius: "0.25rem", width: "1px", style: "solid", color: "rgb(229 231 235)")
            )
        ],
        defaultFontFamily: "ui-sans-serif, system-ui, sans-serif"
    )
    
    /// Bold, high-contrast typography suitable for marketing content
    public static let marketing = MarkdownTypography(
        headings: [
            .h1: TypographyStyle(
                font: FontProperties(size: .extraLarge, weight: .black, lineHeight: .tight),
                margins: MarginProperties(bottom: "1.5rem")
            ),
            .h2: TypographyStyle(
                font: FontProperties(size: .large, weight: .bold, lineHeight: .tight),
                margins: MarginProperties(top: "2rem", bottom: "1rem")
            )
        ],
        elements: [
            .paragraph: TypographyStyle(
                font: FontProperties(size: .headline, lineHeight: .relaxed),
                margins: MarginProperties(bottom: "1.25rem")
            ),
            .strong: TypographyStyle(
                font: FontProperties(weight: .bold, color: "rgb(16 185 129)")
            )
        ]
    )
    
    // MARK: - CSS Generation
    
    /// Generate CSS rules for the typography configuration
    public func generateCSS() -> String {
        var css: [String] = []
        
        // Generate heading styles
        for (level, style) in headings {
            let selector = ".markdown-content \(level.tagName), .\(level.cssClassName)"
            css.append(generateCSSRule(selector: selector, style: style))
        }
        
        // Generate element styles
        for (element, style) in elements {
            let selector = ".markdown-content \(element.rawValue), .\(element.cssClassName)"
            css.append(generateCSSRule(selector: selector, style: style))
        }
        
        // Generate custom selector styles
        for (selector, style) in selectors {
            let fullSelector = selector.hasPrefix(".") || selector.hasPrefix("#") 
                ? ".markdown-content \(selector)" 
                : ".markdown-content .\(selector)"
            css.append(generateCSSRule(selector: fullSelector, style: style))
        }
        
        return css.joined(separator: "\n\n")
    }
    
    /// Generate a CSS rule for a specific selector and style
    private func generateCSSRule(selector: String, style: TypographyStyle) -> String {
        var properties: [String] = []
        
        // Font properties
        if let font = style.font {
            if let family = font.family {
                properties.append("font-family: \(family);")
            }
            if let size = font.size {
                properties.append("font-size: \(size.cssValue);")
            }
            if let weight = font.weight {
                properties.append("font-weight: \(weight.cssValue);")
            }
            if let alignment = font.alignment {
                properties.append("text-align: \(alignment.cssValue);")
            }
            if let color = font.color {
                properties.append("color: \(color);")
            }
            if let lineHeight = font.lineHeight {
                properties.append("line-height: \(lineHeight.cssValue);")
            }
            if let letterSpacing = font.letterSpacing {
                properties.append("letter-spacing: \(letterSpacing.cssValue);")
            }
            if let decoration = font.textDecoration {
                properties.append("text-decoration: \(decoration.cssValue);")
            }
            if let transform = font.textTransform {
                properties.append("text-transform: \(transform);")
            }
        }
        
        // Background properties
        if let background = style.background {
            if let color = background.color {
                properties.append("background-color: \(color);")
            }
            if let opacity = background.opacity {
                properties.append("opacity: \(opacity);")
            }
        }
        
        // Padding properties
        if let padding = style.padding {
            if let top = padding.top { properties.append("padding-top: \(top);") }
            if let right = padding.right { properties.append("padding-right: \(right);") }
            if let bottom = padding.bottom { properties.append("padding-bottom: \(bottom);") }
            if let left = padding.left { properties.append("padding-left: \(left);") }
        }
        
        // Margin properties
        if let margins = style.margins {
            if let top = margins.top { properties.append("margin-top: \(top);") }
            if let right = margins.right { properties.append("margin-right: \(right);") }
            if let bottom = margins.bottom { properties.append("margin-bottom: \(bottom);") }
            if let left = margins.left { properties.append("margin-left: \(left);") }
        }
        
        // Border properties
        if let border = style.border {
            if let width = border.width { properties.append("border-width: \(width);") }
            if let borderStyle = border.style { properties.append("border-style: \(borderStyle);") }
            if let color = border.color { properties.append("border-color: \(color);") }
            if let radius = border.radius { properties.append("border-radius: \(radius);") }
        }
        
        // Custom properties
        for (property, value) in style.customProperties {
            properties.append("\(property): \(value);")
        }
        
        let indentedProperties = properties.map { "  \($0)" }.joined(separator: "\n")
        return "\(selector) {\n\(indentedProperties)\n}"
    }
}

// MARK: - Type Extensions for CSS Values

extension TextSize {
    var cssValue: String {
        switch self {
        case .caption2: return "0.6875rem"
        case .caption: return "0.75rem"
        case .footnote: return "0.8125rem"
        case .subheadline: return "0.9375rem"
        case .callout: return "1rem"
        case .body: return "1rem"
        case .headline: return "1.0625rem"
        case .title3: return "1.1875rem"
        case .title2: return "1.375rem"
        case .title: return "1.75rem"
        case .large: return "2.125rem"
        case .extraLarge: return "2.25rem"
        case .custom(let size): return "\(size)rem"
        }
    }
}

extension Weight {
    var cssValue: String {
        switch self {
        case .ultraLight: return "100"
        case .thin: return "200"
        case .light: return "300"
        case .regular: return "400"
        case .medium: return "500"
        case .semibold: return "600"
        case .bold: return "700"
        case .heavy: return "800"
        case .black: return "900"
        }
    }
}

extension Alignment {
    var cssValue: String {
        switch self {
        case .leading: return "left"
        case .center: return "center"
        case .trailing: return "right"
        case .justified: return "justify"
        }
    }
}

extension Leading {
    var cssValue: String {
        switch self {
        case .tight: return "1.25"
        case .snug: return "1.375"
        case .normal: return "1.5"
        case .relaxed: return "1.625"
        case .loose: return "2"
        }
    }
}

extension Tracking {
    var cssValue: String {
        switch self {
        case .tighter: return "-0.05em"
        case .tight: return "-0.025em"
        case .normal: return "0"
        case .wide: return "0.025em"
        case .wider: return "0.05em"
        case .widest: return "0.1em"
        }
    }
}

extension Decoration {
    var cssValue: String {
        switch self {
        case .none: return "none"
        case .underline: return "underline"
        case .strikethrough: return "line-through"
        }
    }
}