import Foundation

/// Creates HTML anchor elements for linking to other locations.
///
/// Represents a hyperlink that connects to another web page, file, location within the same page,
/// email address, or any other URL. Links are fundamental interactive elements that enable
/// navigation throughout a website and to external resources.
public final class Link: Element {
    private let href: String
    private let newTab: Bool?

    /// Creates a new HTML anchor link.
    ///
    /// - Parameters:
    ///   - destination: URL or path the link points to.
    ///   - newTab: Opens in a new tab if true, optional.
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of CSS classnames for styling the link.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when link text isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the link.
    ///   - content: Closure providing link content (text or other HTML elements).
    ///
    /// ## Example
    /// ```swift
    /// Link(to: "https://example.com", newTab: true) {
    ///   "Visit Example Website"
    /// }
    /// ```
    public init(
        to destination: String,
        newTab: Bool? = nil,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        self.href = destination
        self.newTab = newTab

        var attributes = [Attribute.string("href", destination)].compactMap { $0 }

        if newTab == true {
            attributes.append(contentsOf: [
                "target=\"_blank\"",
                "rel=\"noreferrer\"",
            ])
        }

        super.init(
            tag: "a",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            customAttributes: attributes.isEmpty ? nil : attributes,
            content: content
        )
    }
}
