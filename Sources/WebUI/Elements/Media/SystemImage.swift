import Foundation

/// Creates HTML elements for system images/icons using SVG or icon fonts.
///
/// Represents system icons that can be used in buttons, labels, and other UI elements.
/// This component provides a simple way to include common icons in web interfaces.
///
/// ## Example
/// ```swift
/// SystemImage("checkmark")
/// SystemImage("trash", classes: ["icon-danger"])
/// SystemImage("arrow.down", classes: ["download-icon"])
/// ```
public struct SystemImage: Element {
    private let name: String
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?

    /// Creates a new system image element.
    ///
    /// - Parameters:
    ///   - name: The name of the system image/icon.
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of CSS classnames for styling the icon.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the icon for accessibility.
    ///   - data: Dictionary of `data-*` attributes for storing custom data.
    public init(
        _ name: String,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil
    ) {
        self.name = name
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
    }

    public var body: some HTML {
        HTMLString(content: renderTag())
    }

    private func renderTag() -> String {
        // Combine base icon classes with custom classes
        var allClasses = ["system-image", "icon-\(name.replacingOccurrences(of: ".", with: "-"))"]
        if let classes = classes {
            allClasses.append(contentsOf: classes)
        }
        
        let attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: allClasses,
            role: role,
            label: label ?? name,
            data: data
        )
        
        // Render as a span with CSS classes for icon fonts/CSS icons
        // This allows flexibility for different icon systems (Font Awesome, Feather, etc.)
        return AttributeBuilder.renderTag(
            "span", attributes: attributes, content: ""
        )
    }
}