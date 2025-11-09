import Foundation

/// Generates an HTML td element for table data cells.
///
/// The `TableCell` element represents a data cell in a table row.
///
/// ## Example
/// ```swift
/// TableCell("John Doe", classes: ["px-4", "py-2"])
/// TableCell("30", classes: ["text-center"])
/// ```
public struct TableCell: Element {
    private let text: String
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?

    /// Creates a new HTML td element.
    ///
    /// - Parameters:
    ///   - text: The text content of the data cell.
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of stylesheet classnames for styling.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element for screen readers.
    ///   - data: Dictionary of `data-*` attributes for storing custom data.
    public init(
        _ text: String,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil
    ) {
        self.text = text
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
        let attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data
        )

        return AttributeBuilder.buildMarkupTag(
            "td",
            attributes: attributes,
            content: text
        )
    }
}
