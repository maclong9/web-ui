import Foundation

/// Generates HTML text elements as `<p>` or `<span>` based on content.
///
/// Paragraphs are for long form content with multiple sentences and
/// a `<span>` tag is used for a single sentence of text and grouping inline content.
public struct Text: Element {
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let contentBuilder: HTMLContentBuilder

    /// Creates a new text element.
    ///
    /// Uses `<p>` for multiple sentences, `<span>` for one or fewer.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of CSS classnames.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element.
    ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
    ///   - content: Closure providing text content.
    public init(
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping HTMLContentBuilder
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
        let renderedContent = contentBuilder().map { $0.render() }.joined()
        let sentenceCount = renderedContent.components(
            separatedBy: CharacterSet(charactersIn: ".!?")
        )
        .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        .count

        let tag = sentenceCount > 1 ? "p" : "span"
        let attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data
        )

        return
            "<\(tag)\(attributes.count > 0 ? " " : "")\(attributes.joined(separator: " "))>\(HTMLEscaper.escape(renderedContent))</\(tag)>"
    }
}
