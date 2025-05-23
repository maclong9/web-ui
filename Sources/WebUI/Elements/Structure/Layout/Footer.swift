/// Generates an HTML footer element for page or section footers.
///
/// The `Footer` element represents a footer for its nearest sectioning content or sectioning root
/// element. A footer typically contains information about the author, copyright data, related links,
/// legal information, and other metadata that appears at the end of a document or section.
///
/// ## Example
/// ```swift
/// Footer {
///     Text { "© 2023 My Company. All rights reserved." }
///     Link(to: "/privacy") { "Privacy Policy" }
///     Link(to: "/terms") { "Terms of Service" }
///   }
///   ```
public final class Footer: Element {
    /// Creates a new HTML footer element.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element, useful for styling and scripting.
    ///   - classes: An array of CSS classnames for styling the footer.
    ///   - role: ARIA role of the element for accessibility and screen readers.
    ///   - label: ARIA label to describe the element's purpose (e.g., "Page Footer").
    ///   - data: Dictionary of `data-*` attributes for storing custom data related to the footer.
    ///   - content: Closure providing footer content, such as copyright notices, contact information, and secondary navigation.
    ///
    /// ## Example
    /// ```swift
    /// Footer(id: "site-footer", classes: ["footer", "bg-dark"]) {
    ///     Stack(classes: ["footer-links"]) {
    ///       Link(to: "/about") { "About" }
    ///       Link(to: "/contact") { "Contact" }
    ///     }
    ///     Text { "© \(Date().formattedYear()) My Company" }
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
            tag: "footer",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}
