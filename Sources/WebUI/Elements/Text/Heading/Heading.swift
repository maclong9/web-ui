import Foundation

/// Creates HTML heading elements from `<h1>` to `<h6>`.
///
/// Represents section headings of different levels, with `<h1>` being the highest (most important)
/// and `<h6>` the lowest. Headings provide document structure and are essential for accessibility,
/// SEO, and reader comprehension.
public struct Heading: Element {
    private let level: HeadingLevel
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let contentBuilder: () -> [any HTML]
    
    /// Creates a new HTML heading element.
    ///
    /// - Parameters:
    ///   - level: Heading level (.largeTitle, .title, .headline, .subheadline, .body, or .footnote).
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of CSS classnames for styling the heading.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the heading.
    ///   - content: Closure providing heading content.
    ///
    /// ## Example
    /// ```swift
    /// Heading(.title) {
    ///   "Section Title"
    /// }
    /// ```
    public init(
        _ level: HeadingLevel,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        self.level = level
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
        self.contentBuilder = content
    }
    
    public var body: some HTML {
        HTMLString(content: renderTag())
    }
    
    private func renderTag() -> String {
        let attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data
        )
        let content = contentBuilder().map { $0.render() }.joined()
        
        return AttributeBuilder.renderTag(level.rawValue, attributes: attributes, content: content)
    }
}
