/// Generates an HTML navigation element for site navigation.
///
/// The `Navigation` element represents a section of a page intended to contain navigation
/// links to other pages or parts within the current page. It helps screen readers and
/// other assistive technologies identify the main navigation structure of the website.
///
/// ## Example
/// ```swift
/// Navigation(classes: ["main-nav"]) {
///     List {
///       Item { Link(to: "/") { "Home" } }
///       Item { Link(to: "/products") { "Products" } }
///       Item { Link(to: "/contact") { "Contact" } }
///     }
///   }
///   ```
public final class Navigation: Element {
    /// Creates a new HTML navigation element.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element, useful for styling and scripting.
    ///   - classes: An array of CSS classnames for styling the navigation container.
    ///   - role: ARIA role of the element for accessibility and screen readers.
    ///   - label: ARIA label to describe the element's purpose (e.g., "Main Navigation").
    ///   - data: Dictionary of `data-*` attributes for storing custom data related to navigation.
    ///   - content: Closure providing navigation content, typically links or lists of links.
    ///
    /// ## Example
    /// ```swift
    /// Navigation(id: "main-nav", label: "Main Navigation") {
    ///     Link(to: "/home") { "Home" }
    ///     Link(to: "/about") { "About Us" }
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
            tag: "nav",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}
