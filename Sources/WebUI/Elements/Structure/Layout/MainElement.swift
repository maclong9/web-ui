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
public final class MainElement: Element {
    /// Creates a new HTML main element.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element, useful for styling and scripting.
    ///   - classes: An array of CSS classnames for styling the main content area.
    ///   - role: ARIA role of the element for accessibility and screen readers.
    ///   - label: ARIA label to describe the element's purpose (e.g., "Main Content").
    ///   - data: Dictionary of `data-*` attributes for storing custom data related to the main content.
    ///   - content: Closure providing the primary content of the page, typically including articles, sections, and other content elements.
    ///
    /// ## Example
    /// ```swift
    /// Main(id: "content", classes: ["container"]) {
    ///     Section {
    ///       Heading(.largeTitle) { "About Us" }
    ///       Text { "Learn more about our company history..." }
    ///     }
    ///   }
    ///   ```
    public init(
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        super.init(
            tag: "main",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}
