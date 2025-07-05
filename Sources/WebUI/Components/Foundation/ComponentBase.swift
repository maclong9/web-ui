import Foundation

/// Base protocol for all component library elements providing consistent theming and behavior.
///
/// `ComponentBase` establishes the foundation for the WebUI component library with:
/// - Consistent styling architecture
/// - Theme integration
/// - Accessibility standards
/// - Customization patterns
/// - State management integration
///
/// ## Design Philosophy
///
/// Components follow a headless-first approach with minimal structural CSS:
/// - Structure and layout are provided
/// - No colors, fonts, or decorative styling
/// - Extensive customization through variants and modifiers
/// - Full accessibility support built-in
/// - State management ready
///
/// ## Usage
///
/// ```swift
/// struct MyComponent: ComponentBase {
///     var variant: ComponentVariant = .default
///     var size: ComponentSize = .medium
///     
///     var body: some Markup {
///         div {
///             // Component content
///         }
///         .applyComponentStyles(
///             base: baseStyles,
///             variant: variantStyles,
///             size: sizeStyles
///         )
///     }
/// }
/// ```
public protocol ComponentBase: Element {
    /// The variant style for this component (default, primary, secondary, etc.)
    var variant: ComponentVariant { get set }
    
    /// The size of this component (small, medium, large, etc.)
    var size: ComponentSize { get set }
    
    /// Whether this component is disabled
    var disabled: Bool { get set }
    
    /// Custom CSS classes to apply
    var customClasses: [String] { get set }
    
    /// Accessibility role override
    var accessibilityRole: AriaRole? { get set }
    
    /// Base structural styles that provide layout and positioning
    var baseStyles: ComponentStyles { get }
    
    /// Variant-specific styles for different visual treatments
    var variantStyles: [ComponentVariant: ComponentStyles] { get }
    
    /// Size-specific styles for different component scales
    var sizeStyles: [ComponentSize: ComponentStyles] { get }
}

// MARK: - Default Implementations

extension ComponentBase {
    /// Default variant is `.default`
    public var variant: ComponentVariant {
        get { .default }
        set { /* Override in implementation if needed */ }
    }
    
    /// Default size is `.medium`
    public var size: ComponentSize {
        get { .medium }
        set { /* Override in implementation if needed */ }
    }
    
    /// Default disabled state is `false`
    public var disabled: Bool {
        get { false }
        set { /* Override in implementation if needed */ }
    }
    
    /// Default custom classes is empty
    public var customClasses: [String] {
        get { [] }
        set { /* Override in implementation if needed */ }
    }
    
    /// Default accessibility role is `nil`
    public var accessibilityRole: AriaRole? {
        get { nil }
        set { /* Override in implementation if needed */ }
    }
    
    /// Default variant styles - override in implementation
    public var variantStyles: [ComponentVariant: ComponentStyles] {
        return [:]
    }
    
    /// Default size styles - override in implementation
    public var sizeStyles: [ComponentSize: ComponentStyles] {
        return [:]
    }
}

// MARK: - Component Variants

/// Standard component variants for consistent theming across the library
public enum ComponentVariant: String, CaseIterable {
    case `default` = "default"
    case primary = "primary"
    case secondary = "secondary"
    case success = "success"
    case warning = "warning"
    case danger = "danger"
    case ghost = "ghost"
    case link = "link"
    case outline = "outline"
    
    /// CSS class name for this variant
    public var className: String {
        return "variant-\(rawValue)"
    }
}

// MARK: - Component Sizes

/// Standard component sizes for consistent scaling across the library
public enum ComponentSize: String, CaseIterable {
    case extraSmall = "xs"
    case small = "sm"
    case medium = "md"
    case large = "lg"
    case extraLarge = "xl"
    
    /// CSS class name for this size
    public var className: String {
        return "size-\(rawValue)"
    }
}

// MARK: - Component Styles

/// Container for CSS styles applied to components
public struct ComponentStyles: Sendable {
    /// CSS classes to apply
    public let classes: [String]
    
    /// Inline CSS properties
    public let properties: [String: String]
    
    /// Data attributes
    public let dataAttributes: [String: String]
    
    public init(
        classes: [String] = [],
        properties: [String: String] = [:],
        dataAttributes: [String: String] = [:]
    ) {
        self.classes = classes
        self.properties = properties
        self.dataAttributes = dataAttributes
    }
    
    /// Combines this style with another, with the other taking precedence
    public func combined(with other: ComponentStyles) -> ComponentStyles {
        return ComponentStyles(
            classes: classes + other.classes,
            properties: properties.merging(other.properties) { _, new in new },
            dataAttributes: dataAttributes.merging(other.dataAttributes) { _, new in new }
        )
    }
    
    /// Creates an empty style
    public static let empty = ComponentStyles()
}

// MARK: - Markup Extensions

extension Markup {
    /// Applies component styles to this markup element
    ///
    /// This method combines base, variant, and size styles and applies them
    /// to the markup element as CSS classes and data attributes.
    ///
    /// - Parameters:
    ///   - base: Base structural styles
    ///   - variant: Variant-specific styles (optional)
    ///   - size: Size-specific styles (optional)
    ///   - custom: Additional custom styles (optional)
    /// - Returns: Modified markup with applied styles
    public func applyComponentStyles(
        base: ComponentStyles,
        variant: ComponentStyles = .empty,
        size: ComponentStyles = .empty,
        custom: ComponentStyles = .empty
    ) -> some Markup {
        let combinedStyles = base
            .combined(with: variant)
            .combined(with: size)
            .combined(with: custom)
        
        return ComponentStyledMarkup(
            content: self,
            styles: combinedStyles
        )
    }
}

// MARK: - Component Styled Markup Container

/// A markup container that applies component styles to its content
public struct ComponentStyledMarkup<Content: Markup>: Markup {
    private let content: Content
    private let styles: ComponentStyles
    
    public init(content: Content, styles: ComponentStyles) {
        self.content = content
        self.styles = styles
    }
    
    public var body: MarkupString {
        let renderedContent = content.render()
        let styledContent = applyStylesToHTML(renderedContent)
        return MarkupString(content: styledContent)
    }
    
    private func applyStylesToHTML(_ html: String) -> String {
        // Find the first opening tag
        guard let tagRange = html.range(of: "<[^>]+>", options: .regularExpression) else {
            // If no tag found, wrap in a div
            return createWrapperElement(content: html)
        }
        
        let tag = html[tagRange]
        let modifiedTag = addStylesToTag(String(tag))
        
        return html.replacingCharacters(in: tagRange, with: modifiedTag)
    }
    
    private func addStylesToTag(_ tag: String) -> String {
        var result = tag
        
        // Add CSS classes
        if !styles.classes.isEmpty {
            let classAttribute = " class=\"\(styles.classes.joined(separator: " "))\""
            
            if result.contains(" class=\"") {
                // Merge with existing classes
                result = result.replacingOccurrences(
                    of: " class=\"([^\"]*)",
                    with: " class=\"$1 \(styles.classes.joined(separator: " "))",
                    options: .regularExpression
                )
            } else {
                // Add new class attribute
                result = result.replacingOccurrences(
                    of: ">$",
                    with: "\(classAttribute)>",
                    options: .regularExpression
                )
            }
        }
        
        // Add data attributes
        for (key, value) in styles.dataAttributes {
            let dataAttribute = " data-\(key)=\"\(value)\""
            result = result.replacingOccurrences(
                of: ">$",
                with: "\(dataAttribute)>",
                options: .regularExpression
            )
        }
        
        // Add inline styles
        if !styles.properties.isEmpty {
            let styleValue = styles.properties.map { "\($0.key): \($0.value)" }.joined(separator: "; ")
            let styleAttribute = " style=\"\(styleValue)\""
            
            if result.contains(" style=\"") {
                // Merge with existing styles
                result = result.replacingOccurrences(
                    of: " style=\"([^\"]*)",
                    with: " style=\"$1; \(styleValue)",
                    options: .regularExpression
                )
            } else {
                // Add new style attribute
                result = result.replacingOccurrences(
                    of: ">$",
                    with: "\(styleAttribute)>",
                    options: .regularExpression
                )
            }
        }
        
        return result
    }
    
    private func createWrapperElement(content: String) -> String {
        var attributes: [String] = []
        
        if !styles.classes.isEmpty {
            attributes.append("class=\"\(styles.classes.joined(separator: " "))\"")
        }
        
        for (key, value) in styles.dataAttributes {
            attributes.append("data-\(key)=\"\(value)\"")
        }
        
        if !styles.properties.isEmpty {
            let styleValue = styles.properties.map { "\($0.key): \($0.value)" }.joined(separator: "; ")
            attributes.append("style=\"\(styleValue)\"")
        }
        
        let attributeString = attributes.isEmpty ? "" : " " + attributes.joined(separator: " ")
        return "<div\(attributeString)>\(content)</div>"
    }
}