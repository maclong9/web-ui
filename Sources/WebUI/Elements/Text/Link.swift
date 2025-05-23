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
    private let contentBuilder: () -> [any HTML]
    
    /// Creates a new HTML anchor link.
    ///
    /// - Parameters:
    ///   - to: URL or path the link points to.
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
        self.destination = destination
        self.newTab = newTab
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
        var attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data
        )
        attributes.insert(Attribute.string("href", destination)!, at: 0)
        if newTab == true {
            attributes.append("target=\"_blank\"")
            attributes.append("rel=\"noreferrer\"")
        }
        let content = contentBuilder().map { $0.render() }.joined()
        return AttributeBuilder.renderTag("a", attributes: attributes, content: content)
    }
}