import Foundation

/// Generates an HTML body element for page wrappign.
///
/// The `Body` element (which renders as a body) groups the entier page together
///
/// ## Example
/// ```swift
/// Body {
///   Stack(classes: ["card"]) { "Card 1 content" }
///   Stack(classes: ["card"]) { "Card 2 content" }
/// }
/// ```
public struct BodyWrapper: Element {
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let contentBuilder: MarkupContentBuilder

    /// Creates a new HTML div element for generic content grouping.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element, useful for styling and scripting.
    ///   - classes: An array of stylesheet classnames for styling the div container.
    ///   - role: ARIA role of the element for accessibility and screen readers.
    ///   - label: ARIA label to describe the element's purpose for screen readers.
    ///   - data: Dictionary of `data-*` attributes for storing custom data related to the container.
    ///   - content: Closure providing the container's content elements.
    ///
    /// ## Example
    /// ```swift
    /// Body(classes: ["flex"], data: ["user-id": "123"]) {
    ///   Image(source: "/avatar.jpg", description: "User Avatar")
    ///   Heading(.headline) { "Jane Doe" }
    ///   Text { "Software Engineer" }
    /// }
    /// ```
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
        let content = contentBuilder().map { $0.render() }.joined().render()

        return AttributeBuilder.buildMarkupTag("body", attributes: attributes, content: content)
    }
}
