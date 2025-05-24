/// Generates an HTML section element for thematic content grouping.
///
/// Defines a thematic grouping of content, such as a chapter, tab panel, or any content
/// that forms a distinct section of a document. Sections typically have their own heading
/// and represent a logical grouping of related content.
///
/// ## Example
/// ```swift
/// Section(id: "features") {
///   Heading(.title) { "Key Features" }
///   List {
///     Item { "Simple API" }
///     Item { "Type-safe HTML generation" }
///     Item { "Responsive design" }
///   }
/// }
/// ```
public struct Section: Element {
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let contentBuilder: HTMLContentBuilder

    /// Creates a new HTML section element for thematic content grouping.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element, useful for navigation and linking.
    ///   - classes: An array of CSS classnames for styling the section.
    ///   - role: ARIA role of the element for accessibility and screen readers.
    ///   - label: ARIA label to describe the element's purpose for screen readers.
    ///   - data: Dictionary of `data-*` attributes for storing custom data related to the section.
    ///   - content: Closure providing section content such as headings, paragraphs, and other elements.
    ///
    /// ## Example
    /// ```swift
    /// Section(id: "about", classes: ["content-section"]) {
    ///   Heading(.title) { "About Us" }
    ///   Text { "Our company was founded in 2020..." }
    /// }
    /// ```
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

        return AttributeBuilder.renderTag("section", attributes: attributes, content: content)
    }
}
