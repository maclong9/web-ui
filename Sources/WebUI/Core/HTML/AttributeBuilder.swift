import Foundation

/// Utility for building HTML attributes
///
/// The `AttributeBuilder` provides helper methods for generating HTML attribute strings
/// in a consistent way across all elements.
public enum AttributeBuilder {
    /// Builds a collection of HTML attributes from common parameters
    ///
    /// - Parameters:
    ///   - id: Optional unique identifier for the HTML element
    ///   - classes: Optional array of CSS class names
    ///   - role: Optional ARIA role for accessibility
    ///   - label: Optional ARIA label for accessibility
    ///   - data: Optional dictionary of data attributes
    ///   - additional: Optional array of additional attribute strings
    /// - Returns: Array of attribute strings for use in HTML tags
    public static func buildAttributes(
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        additional: [String] = []
    ) -> [String] {
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
        
        attributes.append(contentsOf: additional)
        
        return attributes
    }
    
    /// Renders a complete HTML tag with attributes and content
    ///
    /// - Parameters:
    ///   - tag: The HTML tag name
    ///   - attributes: Array of attribute strings
    ///   - content: Optional content to include between opening and closing tags
    ///   - isSelfClosing: Whether this is a self-closing tag
    /// - Returns: Complete HTML tag as a string
    public static func renderTag(
        _ tag: String,
        attributes: [String],
        content: String = "",
        isSelfClosing: Bool = false
    ) -> String {
        let attributeString = attributes.isEmpty ? "" : " " + attributes.joined(separator: " ")
        
        if isSelfClosing {
            return "<\(tag)\(attributeString) />"
        } else {
            return "<\(tag)\(attributeString)>\(content)</\(tag)>"
        }
    }
}