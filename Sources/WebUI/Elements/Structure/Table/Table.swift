import Foundation

/// Generates an HTML table element for displaying tabular data.
///
/// The `Table` element creates a structured table with support for headers, body, and footer sections.
/// Tables are ideal for presenting data in rows and columns with clear relationships.
///
/// ## Example
/// ```swift
/// Table(classes: ["w-full"]) {
///   TableHead {
///     TableRow {
///       TableHeader("Name")
///       TableHeader("Age")
///     }
///   }
///   TableBody {
///     TableRow {
///       TableCell("John")
///       TableCell("30")
///     }
///   }
/// }
/// ```
public struct Table: Element {
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let contentBuilder: MarkupContentBuilder

    /// Creates a new HTML table element.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of stylesheet classnames for styling the table.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element for screen readers.
    ///   - data: Dictionary of `data-*` attributes for storing custom data.
    ///   - content: Closure providing the table content (thead, tbody, tfoot).
    public init(
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @MarkupBuilder content: @escaping MarkupContentBuilder
    ) {
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
        let attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data
        )
        let content = contentBuilder().map { $0.render() }.joined()

        return AttributeBuilder.buildMarkupTag(
            "table",
            attributes: attributes,
            content: content
        )
    }
}
