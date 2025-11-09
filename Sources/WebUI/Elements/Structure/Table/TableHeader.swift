import Foundation

/// Generates an HTML th element for table header cells.
///
/// The `TableHeader` element represents a header cell in a table, providing labels for columns or rows.
///
/// ## Example
/// ```swift
/// TableHeader("Name", classes: ["text-left", "font-bold"])
/// TableHeader("Age", classes: ["text-center"])
/// ```
public struct TableHeader: Element {
    private let text: String
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let scope: String?

    /// Creates a new HTML th element.
    ///
    /// - Parameters:
    ///   - text: The text content of the header cell.
    ///   - scope: Defines the cells that the header relates to (col, row, colgroup, rowgroup).
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of stylesheet classnames for styling.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element for screen readers.
    ///   - data: Dictionary of `data-*` attributes for storing custom data.
    public init(
        _ text: String,
        scope: String? = nil,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil
    ) {
        self.text = text
        self.scope = scope
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
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
        if let scope, let scopeAttr = Attribute.string("scope", scope) {
            attributes.append(scopeAttr)
        }

        return AttributeBuilder.buildMarkupTag(
            "th",
            attributes: attributes,
            content: text
        )
    }
}
