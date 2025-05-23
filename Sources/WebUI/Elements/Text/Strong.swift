import Foundation

/// Creates HTML strong emphasis elements.
///
/// Represents text with strong emphasis or importance, typically displayed in bold by browsers.
/// The `<strong>` element indicates content with high importance, seriousness, or urgency.
/// It differs from `<b>` (bold) which stylistically offsets text without implying importance,
/// and from `<em>` which indicates stress emphasis.
///
/// ## Example
/// ```swift
/// Strong { "Warning: This action cannot be undone!" }
/// ```
public struct Strong: Element {
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let contentBuilder: () -> [any HTML]
    
    /// Creates a new HTML strong element.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of CSS classnames for styling the emphasized text.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the element.
    ///   - content: Closure providing the content to be strongly emphasized.
    ///
    /// ## Example
    /// ```swift
    /// Strong(
    ///   classes: ["alert", "critical"]
    /// ) {
    ///   "Important security notice"
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
        let attributes = buildAttributes()
        let content = contentBuilder().map { $0.render() }.joined()
        
        return "<strong \(attributes.joined(separator: " "))>\(content)</strong>"
    }
    
    private func buildAttributes() -> [String] {
        var attributes: [String] = []
        
        if let id = id {
            attributes.append(Attribute.string("id", id)!)
        }
        
        if let classes = classes, !classes.isEmpty {
            attributes.append(Attribute.string("class", classes.joined(separator: " "))!)
        }
        
        if let role = role {
            attributes.append(Attribute.typed("role", role)!)
        }
        
        if let label = label {
            attributes.append(Attribute.string("aria-label", label)!)
        }
        
        if let data = data {
            for (key, value) in data {
                attributes.append(Attribute.string("data-\(key)", value)!)
            }
        }
        
        return attributes
    }
}