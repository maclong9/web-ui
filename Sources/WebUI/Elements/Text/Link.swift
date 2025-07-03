import Foundation

/// Creates HTML anchor elements for linking to other locations.
///
/// Represents a hyperlink that connects to another web page, file, location within the same page,
/// email address, or any other URL. Links are fundamental interactive elements that enable
/// navigation throughout a website and to external resources.
public struct Link: Element {
    private let destination: String
    private let newTab: Bool?
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let contentBuilder: MarkupContentBuilder

    /// Creates a new HTML anchor link with string title.
    ///
    /// This is the preferred SwiftUI-like initializer for creating links with text content.
    ///
    /// - Parameters:
    ///   - title: The link text content to display.
    ///   - destination: URL or path the link points to.
    ///   - newTab: Opens in a new tab if true, optional.
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of stylesheet classnames for styling the link.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when link text isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the link.
    ///
    /// ## Example
    /// ```swift
    /// Link("Visit Example Website", destination: "https://example.com")
    /// Link("Open in New Tab", destination: "https://example.com", newTab: true)
    /// Link("Contact Us", destination: "/contact", classes: ["nav-link"])
    /// ```
    public init(
        _ title: String,
        to destination: String,
        newTab: Bool? = nil,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil
    ) {
        self.destination = destination
        self.newTab = newTab
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
        self.contentBuilder = { [title] }
    }

    /// Creates a new HTML anchor link using HTMLBuilder closure syntax.
    ///
    /// This allows more complex Link generation, for example if you require
    /// an icon before or after your link text.
    ///
    /// - Parameters:
    ///   - to: URL or path the link points to.
    ///   - newTab: Opens in a new tab if true, optional.
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of stylesheet classnames for styling the link.
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
        @MarkupBuilder content: @escaping MarkupContentBuilder = { [] }
    ) {
        self.destination = destination
        self.newTab = newTab
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
        var attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data
        )
        if let hrefAttr = Attribute.string("href", destination) {
            attributes.insert(hrefAttr, at: 0)
        }
        if newTab == true {
            attributes.append("target=\"_blank\"")
            attributes.append("rel=\"noreferrer\"")
        }
        let content = contentBuilder().map { $0.render() }.joined()
        return AttributeBuilder.buildMarkupTag(
            "a", attributes: attributes, content: content)
    }
}
