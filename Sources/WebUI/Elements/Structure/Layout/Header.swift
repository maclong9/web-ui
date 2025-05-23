/// Generates an HTML header element for page or section headers.
///
/// The `Header` element represents a container for introductory content or a set of navigational links
/// at the beginning of a section or page. Typically contains elements like site logos, navigation menus,
/// and search forms.
///
/// ## Example
/// ```swift
/// Header {
///   Heading(.largeTitle) { "Site Title" }
///   Navigation {
///       Link(to: "/home") { "Home" }
///       Link(to: "/about") { "About" }
///     }
///   }
///   ```
public final class Header: Element {
    /// Creates a new HTML header element.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element, useful for styling and scripting.
    ///   - classes: An array of CSS classnames for styling the header.
    ///   - role: ARIA role of the element for accessibility and screen readers.
    ///   - label: ARIA label to describe the element for screen readers.
    ///   - data: Dictionary of `data-*` attributes for storing custom data related to the header.
    ///   - content: Closure providing header content like headings, navigation, and logos.
    ///
    /// ## Example
    /// ```swift
    /// Header(id: "main-header", classes: ["site-header", "sticky"]) {
    ///     Heading(.largeTitle) { "My Website" }
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
            tag: "header",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}
