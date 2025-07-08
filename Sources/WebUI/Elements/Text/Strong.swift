import Foundation

/// Creates markup strong emphasis elements.
///
/// Represents text with strong emphasis or importance, typically displayed in bold by browsers.
/// The `<strong>` element indicates content with high importance, seriousness, or urgency.
/// It differs from `<b>` (bold) which stylistically offsets text without implying importance,
/// and from `<em>` which indicates stress emphasis.
///
/// ## Example
/// ```swift
/// Strong { "Warning: This action cannot be undone!" }
/// ```
public struct Strong: Element {
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let contentBuilder: MarkupContentBuilder

    /// Creates a new markup strong element with string content.
    ///
    /// This is the preferred SwiftUI-like initializer for creating strongly emphasized text.
    ///
    /// - Parameters:
    ///   - content: The text content to be strongly emphasized.
    ///   - id: Unique identifier for the markup element, useful for JavaScript interaction and styling.
    ///   - classes: An array of stylesheet classnames for styling the emphasized text.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the element.
    ///
    /// ## Example
    /// ```swift
    /// Strong("Important security notice")
    /// Strong("Warning: This action cannot be undone!", classes: ["alert", "critical"])
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

    /// Creates a new markup strong element using MarkupBuilder closure syntax.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the markup element, useful for JavaScript interaction and styling.
    ///   - classes: An array of stylesheet classnames for styling the emphasized text.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the element.
    ///   - content: Closure providing the content to be strongly emphasized.
    ///
    /// ## Example
    /// ```swift
    /// Strong(
    ///   classes: ["alert", "critical"]
    /// ) {
    ///   "Important security notice"
    /// }
    /// ```
    @available(
        *, deprecated,
        message:
            "Use Strong(_:) string initializer instead for better SwiftUI compatibility. Example: Strong(\"Important text\")"
    )
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
            "strong", attributes: attributes, content: content)
    }
}
