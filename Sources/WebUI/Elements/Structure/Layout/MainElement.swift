/// Generates an HTML main element for the primary content of a page.
///
/// The `Main` element represents the dominant content of the document body. It contains content
/// that is directly related to or expands upon the central topic of the document. Each page
/// should have only one `main` element, which helps assistive technologies navigate to the
/// primary content.
///
/// ## Example
/// ```swift
/// Main {
///     Heading(.largeTitle) { "Welcome to Our Website" }
///     Text { "This is the main content of our heomepage." }
///     Article {
///       // Article content
///     }
///   }
///   ```
public struct Main: Element {
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let contentBuilder: MarkupContentBuilder

    /// Creates a new HTML main element.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element, useful for styling and scripting.
    ///   - classes: An array of stylesheet classnames for styling the main content area.
    ///   - role: ARIA role of the element for accessibility and screen readers.
    ///   - label: ARIA label to describe the element's purpose (e.g., "Main Content").
    ///   - data: Dictionary of `data-*` attributes for storing custom data related to the main content.
    ///   - content: Closure providing the primary content of the page, typically including articles, sections, and other content elements.
    ///
    /// ## Example
    /// ```swift
    /// Main(classes: ["site-main"]) {
    ///     Article {
    ///         Heading(.title) { "Welcome" }
    ///         Text { "This is the main content of the page." }
    ///     }
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
        let content = contentBuilder().map { $0.render() }.joined()

        return AttributeBuilder.buildMarkupTag(
            "main", attributes: attributes, content: content)
    }
}
