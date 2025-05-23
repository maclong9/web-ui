import Foundation

/// Generates HTML text elements as `<p>` or `<span>` based on content.
///
/// Paragraphs are for long form content with multiple sentences and
/// a `<span>` tag is used for a single sentence of text and grouping inline content.
public final class Text: Element {
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
        let renderedContent = content().map { $0.render() }.joined()
        let sentenceCount = renderedContent.components(
            separatedBy: CharacterSet(charactersIn: ".!?")
        )
        .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        .count
        let tag = sentenceCount > 1 ? "p" : "span"
        super.init(
            tag: tag,
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}
<<<<<<< Updated upstream:Sources/WebUI/Elements/Base/Text.swift

/// Defines levels for HTML heading tags from h1 to h6.
public enum HeadingLevel: String {
    /// Large title, most prominent heading (h1).
    case largeTitle = "h1"
    /// Title, second most prominent heading (h2).
    case title = "h2"
    /// Headline, third most prominent heading (h3).
    case headline = "h3"
    /// Subheadline, fourth most prominent heading (h4).
    case subheadline = "h4"
    /// Body, fifth most prominent heading (h5).
    case body = "h5"
    /// Footnote, least prominent heading (h6).
    case footnote = "h6"
}

/// Generates HTML heading elements from `<h1>` to `<h6>`.
///
/// The level of the heading should follow a semantic hierarchy through the document,
/// with `.title` for the main page title, `.section` for major sections, and
/// progressively more detailed levels (`.subsection`, `.topic`, etc.) for nested content.
public final class Heading: Element {
    /// Creates a new heading.
    ///
    /// - Parameters:
    ///   - level: Heading level (.largeTitle, .title, .headline, .subheadline, .body, or .footnote).
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of CSS classnames.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element.
    ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
    ///   - content: Closure providing heading content.
    public init(
        _ level: HeadingLevel,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        super.init(
            tag: level.rawValue,
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}

/// Generates an HTML anchor element; for linking to other locations.
public final class Link: Element {
    private let href: String
    private let newTab: Bool?

    /// Creates a new anchor link.
    ///
    /// - Parameters:
    ///   - destination: URL or path the link points to.
    ///   - newTab: Opens in a new tab if true, optional.
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of CSS classnames.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element.
    ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
    ///   - content: Closure providing link content.
    public init(
        to destination: String,
        newTab: Bool? = nil,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        self.href = destination
        self.newTab = newTab

        var attributes = [Attribute.string("href", destination)].compactMap { $0 }

        if newTab == true {
            attributes.append(contentsOf: [
                "target=\"_blank\"",
                "rel=\"noreferrer\"",
            ])
        }

        super.init(
            tag: "a",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            customAttributes: attributes.isEmpty ? nil : attributes,
            content: content
        )
    }
}

/// Generates an HTML emphasis element.
///
/// To be used to draw attention to text within another body of text.
public final class Emphasis: Element {
    /// Creates a new emphasis element.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of CSS classnames.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element.
    ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
    ///   - content: Closure providing emphasized content.
    public init(
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        super.init(
            tag: "em",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}

/// Generates an HTML strong importance element.
///
/// To be used for drawing strong attention to text within another body of text.
public final class Strong: Element {
    /// Creates a new strong element.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of CSS classnames.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element.
    ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
    ///   - content: Closure providing strong content.
    public init(
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        super.init(
            tag: "strong",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}

/// Generates an HTML time element.
///
/// Used to represent a specific date, time, or duration in a machine-readable format.
/// The datetime attribute provides the machine-readable value while the content
/// can be a human-friendly representation.
public final class Time: Element {
    private let datetime: String

    /// Creates a new time element.
    ///
    /// - Parameters:
    ///   - datetime: Machine-readable date/time in ISO 8601 format (e.g., "2025-03-22" or "2025-03-22T14:30:00Z").
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of CSS classnames.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element.
    ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
    ///   - content: Closure providing human-readable time content.
    public init(
        datetime: String,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        self.datetime = datetime
        let customAttributes = [
            Attribute.string("datetime", datetime)
        ].compactMap { $0 }
        super.init(
            tag: "time",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            customAttributes: customAttributes.isEmpty ? nil : customAttributes,
            content: content
        )
    }
}

/// Generates an HTML code block element
///
/// To be used for rendering code examples on a web page
public final class Code: Element {
    /// Creates a new code element.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of CSS classnames.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element.
    ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
    ///   - content: Closure providing code content.
    public init(
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        super.init(
            tag: "code",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}

/// Generates an HTML pre element
///
/// To be used for rendering preformatted text such as groups of code elements.
public final class Preformatted: Element {
    /// Creates a new preformatted element.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of CSS classnames.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element.
    ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
    ///   - content: Closure providing preformatted content.
    public init(
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        super.init(
            tag: "pre",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}
=======
>>>>>>> Stashed changes:Sources/WebUI/Elements/Text/Text.swift
