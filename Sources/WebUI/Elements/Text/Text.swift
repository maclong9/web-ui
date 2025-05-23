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
    private let contentBuilder: () -> [any HTML]

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
        @HTMLBuilder content: @escaping () -> [any HTML]
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
        let attributes = buildAttributes()

        return "<\(tag) \(attributes.joined(separator: " "))>\(renderedContent)</\(tag)>"
    }

    private func buildAttributes() -> [String] {
        var attributes: [String] = []

        if let id, let idAttr = Attribute.string("id", id) {
            attributes.append(idAttr)
        }

        if let classes, !classes.isEmpty, let classAttr = Attribute.string("class", classes.joined(separator: " ")) {
            attributes.append(classAttr)
        }

        if let role, let roleAttr = Attribute.typed("role", role) {
            attributes.append(roleAttr)
        }

        if let label, let labelAttr = Attribute.string("aria-label", label) {
            attributes.append(labelAttr)
        }

        if let data {
            for (key, value) in data {
                if let dataAttr = Attribute.string("data-\(key)", value) {
                    attributes.append(dataAttr)
                }
            }
        }

        return attributes
    }
}
