import Foundation

/// Generates markup text elements as `<p>` or `<span>` based on content.
///
/// Paragraphs are for long form content with multiple sentences and
/// a `<span>` tag is used for a single sentence of text and grouping inline content.
public struct Text: Element {
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let contentBuilder: MarkupContentBuilder

    /// Creates a new text element with string content.
    ///
    /// This is the preferred SwiftUI-like initializer for creating text elements.
    /// Uses `<p>` for multiple sentences, `<span>` for one or fewer.
    ///
    /// - Parameters:
    ///   - content: The text content to display.
    ///   - id: Unique identifier for the markup element.
    ///   - classes: An array of stylesheet classnames.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element.
    ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
    ///
    /// ## Example
    /// ```swift
    /// Text("Hello, world!")
    /// Text("Multi-line text with multiple sentences. This will render as a paragraph.", classes: ["intro"])
    /// ```
    public init(
        _ content: String,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil
    ) {
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
        self.contentBuilder = { [content] }
    }

    /// Creates a new text element using MarkupBuilder closure syntax.
    ///
    /// Uses `<p>` for multiple sentences, `<span>` for one or fewer.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the markup element.
    ///   - classes: An array of stylesheet classnames.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element.
    ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
    ///   - content: Closure providing text content.
    @available(
        *, deprecated,
        message:
            "Use Text(_:) string initializer instead for better SwiftUI compatibility. Example: Text(\"Hello, world!\")"
    )
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
