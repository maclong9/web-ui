import Foundation

/// Creates HTML emphasis elements for highlighting important text.
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
    private let contentBuilder: HTMLContentBuilder

    /// Creates a new HTML emphasis element with string content.
    ///
    /// This is the preferred SwiftUI-like initializer for creating emphasized text.
    ///
    /// - Parameters:
    ///   - content: The text content to be emphasized.
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of CSS classnames for styling the emphasized text.
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

    /// Creates a new HTML emphasis element using HTMLBuilder closure syntax.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of CSS classnames for styling the emphasized text.
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
        @HTMLBuilder content: @escaping HTMLContentBuilder = { [] }
    ) {
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

        return AttributeBuilder.renderTag(
            "em", attributes: attributes, content: content)
    }
}
