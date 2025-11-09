import Foundation

/// Creates markup emphasis elements for highlighting important text.
///
/// Represents emphasized text with semantic importance, typically displayed in italics.
/// Emphasis elements are used to draw attention to text within another body of text
/// and provide semantic meaning that enhances accessibility and comprehension.
public struct Emphasis: Element {
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let contentBuilder: MarkupContentBuilder

    /// Creates a new markup emphasis element with string content.
    ///
    /// This is the preferred SwiftUI-like initializer for creating emphasized text.
    ///
    /// - Parameters:
    ///   - content: The text content to be emphasized.
    ///   - id: Unique identifier for the markup element, useful for JavaScript interaction and styling.
    ///   - classes: An array of stylesheet classnames for styling the emphasized text.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the element.
    ///
    /// ## Example
    /// ```swift
    /// Emphasis("Important information")
    /// Emphasis("Key point to remember", classes: ["highlight"])
    /// ```
    public init(
        _ content: String,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil
    ) {
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
        self.contentBuilder = { [content] }
    }

    /// Creates a new markup emphasis element using MarkupBuilder closure syntax.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the markup element, useful for JavaScript interaction and styling.
    ///   - classes: An array of stylesheet classnames for styling the emphasized text.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the element.
    ///   - content: Closure providing the text content to be emphasized.
    ///
    /// ## Example
    /// ```swift
    /// Emphasis(classes: ["highlight"]) {
    ///   "Important information"
    /// }
    /// ```
    @available(*, deprecated, message: "Use Emphasis(_:) string initializer instead for better SwiftUI compatibility. Example: Emphasis(\"Important text\")")
    public init(
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @MarkupBuilder content: @escaping MarkupContentBuilder = { [] }
    ) {
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
        self.contentBuilder = content
    }

    public var body: some Markup {
        MarkupString(content: buildMarkupTag())
    }

    private func buildMarkupTag() -> String {
        let attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data
        )
        let content = contentBuilder().map { $0.render() }.joined()

        return AttributeBuilder.buildMarkupTag(
            "em",
            attributes: attributes,
            content: content,
            escapeContent: false  // Content is already rendered markup
        )
    }
}
