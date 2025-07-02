import Foundation

/// Utility for building markup attributes
///
/// The `AttributeBuilder` provides helper methods for generating markup
/// attribute strings in a consistent way across all elements.
public enum AttributeBuilder {
    /// Builds a collection of markup attributes from common parameters
    ///
    /// - Parameters:
    ///   - id: Optional unique identifier for the markup element
    ///   - classes: Optional array of stylesheet class names
    ///   - role: Optional ARIA role for accessibility
    ///   - label: Optional ARIA label for accessibility
    ///   - data: Optional dictionary of data attributes
    ///   - additional: Optional array of additional attribute strings
    /// - Returns: Array of attribute strings for use in markup tags
    public static func buildAttributes(
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        additional: [String] = []
    ) -> [String] {
        var attributes: [String] = []

        if let id, let attr = Attribute.string("id", id) {
            attributes.append(attr)
        }

        if let classes, !classes.isEmpty {
            if let attr = Attribute.string("class", classes.joined(separator: " ")) {
                attributes.append(attr)
            }
        }

        if let role, let attr = Attribute.typed("role", role) {
            attributes.append(attr)
        }

        if let label, let attr = Attribute.string("aria-label", label) {
            attributes.append(attr)
        }

        if let data {
            for (key, value) in data {
                if let attr = Attribute.string("data-\(key)", value) {
                    attributes.append(attr)
                }
            }
        }

        attributes.append(contentsOf: additional)
        return attributes
    }

    /// Renders a complete markup tag with attributes and content
    ///
    /// - Parameters:
    ///   - tag: The markup tag name
    ///   - attributes: Array of attribute strings
    ///   - content: Optional content to include between opening and closing tags
    ///   - isSelfClosing: Whether this is a self-closing tag
    ///   - noClosingTag: Whether this should be rendered without a self-close and without a seperate close
    /// - Returns: Complete markup tag as a string
    public static func buildMarkupTag(
        _ tag: String,
        attributes: [String],
        content: String = "",
        isSelfClosing: Bool = false,
        hasNoClosingTag: Bool = false,
    ) -> String {
        let attributeString =
            attributes.isEmpty ? "" : " " + attributes.joined(separator: " ")
        if isSelfClosing {
            return "<\(tag)\(attributeString) />"
        } else if hasNoClosingTag {
            return "<\(tag)\(attributeString)>"
        } else {
            return "<\(tag)\(attributeString)>\(content)</\(tag)>"
        }
    }
}
