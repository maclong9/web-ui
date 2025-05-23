/// Generates an HTML aside element for tangentially related content.
///
/// The `Aside` element represents a section of content that is indirectly related to the
/// main content but could be considered separate. Asides are typically displayed as
/// sidebars or call-out boxes, containing content like related articles, glossary terms,
/// advertisements, or author biographies.
///
/// ## Example
/// ```swift
/// Aside(classes: ["sidebar"]) {
///     Heading(.title) { "Related Articles" }
///     List {
///       Item { Link(to: "/article1") { "Article 1" } }
///       Item { Link(to: "/article2") { "Article 2" } }
///     }
///   }
///   ```
public final class Aside: Element {
    /// Creates a new HTML aside element.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element, useful for styling and scripting.
    ///   - classes: An array of CSS classnames for styling the aside container.
    ///   - role: ARIA role of the element for accessibility and screen readers.
    ///   - label: ARIA label to describe the element's purpose (e.g., "Related Content").
    ///   - data: Dictionary of `data-*` attributes for storing custom data related to the aside.
    ///   - content: Closure providing aside content, such as related links, footnotes, or supplementary information.
    ///
    /// ## Example
    /// ```swift
    /// Aside(id: "glossary", classes: ["note", "bordered"], label: "Term Definition") {
    ///     Heading(.headline) { "Definition" }
    ///     Text { "A detailed explanation of the term..." }
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
            tag: "aside",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}
