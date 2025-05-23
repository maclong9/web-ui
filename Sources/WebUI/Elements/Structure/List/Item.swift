/// Generates an HTML list item element (`<li>`).
///
/// `Item` elements should be used as children of a `List` element to represent
/// individual entries in a list. Each item can contain any HTML content.
///
/// ## Example
/// ```swift
/// Item {
///   Text { "This is a list item with " }
///   Strong { "bold text" }
/// }
/// // Renders: <li><span>This is a list item with </span><strong>bold text</strong></li>
/// ```
public struct Item: Element {
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let contentBuilder: () -> [any HTML]

    /// Creates a new HTML list item element.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of CSS classnames for styling the list item.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element for screen readers.
    ///   - data: Dictionary of `data-*` attributes for storing custom data.
    ///   - content: Closure providing the list item's content (text or other HTML elements).
    ///
    /// ## Example
    /// ```swift
    /// Item {
    ///   "List item content"
    /// }
    /// ```
    public init(
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
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

        return AttributeBuilder.renderTag("li", attributes: attributes, content: content)
    }
}
