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
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - type: Button type, optional.
  ///   - content: Closure providing text content.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML]
  ) {
    let renderedContent = content().map { $0.render() }.joined()
    let sentenceCount = renderedContent.components(separatedBy: CharacterSet(charactersIn: ".!?"))
      .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
      .count
    let tag = sentenceCount > 1 ? "p" : "span"
    super.init(tag: tag, id: id, classes: classes, role: role, label: label)
  }
}

/// Defines levels for HTML heading tags from h1 to h6.
public enum HeadingLevel: String {
  /// Primary title or main topic (h1).
  case one = "h1"
  /// Major section or subtopic (h2).
  case two = "h2"
  /// Subsection within a major section (h3).
  case three = "h3"
  /// Sub-subsection or deeper detail (h4).
  case four = "h4"
  /// Minor detail or supporting heading (h5).
  case five = "h5"
  /// Finest level of detail (h6).
  case six = "h6"
}

/// Generates HTML heading elements from `<h1>` to `<h6>`.
///
/// The level of the heading should descend through the document,
/// with the main page title being 1 and then section headings being 2.
public final class Heading: Element {
  /// Creates a new heading.
  ///
  /// - Parameters:
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - level: Heading level (h1 to h6).
  ///   - content: Closure providing heading content.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    level: HeadingLevel,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    super.init(tag: level.rawValue, id: id, classes: classes, role: role, label: label, content: content)
  }
}

/// Generates an HTML anchor element; for linking to other locations.
public final class Link: Element {
  private let href: String
  private let newTab: Bool?

  /// Creates a new anchor link.
  ///
  /// - Parameters:
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - level: Heading level (h1 to h6).
  ///   - destination: URL or path the link points to.
  ///   - newTab: Opens in a new tab if true, optional.
  ///   - content: Closure providing link content.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    to destination: String,
    newTab: Bool? = nil,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    self.href = destination
    self.newTab = newTab
    super.init(tag: "a", id: id, classes: classes, role: role, label: label)
  }

  /// Provides anchor-specific attributes.
  public override func additionalAttributes() -> [String] {
    [
      attribute("href", href),
      attribute("target", newTab == true ? "_blank" : nil),
      attribute("rel", newTab == true ? "noreferrer" : nil),
    ]
    .compactMap { $0 }
  }
}

/// Generates an HTML emphasis element.
///
/// To be used to draw attention to text within another body of text.
public final class Emphasis: Element {
  /// Creates a new emphasis element.
  ///
  /// - Parameters:
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - level: Heading level (h1 to h6).
  ///   - content: Closure providing emphasized content.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    super.init(tag: "em", id: id, classes: classes, role: role, label: label, content: content)
  }
}

/// Generates an HTML strong importance element.
///
/// To be used for drawing strong attention to text within another body of text.
public final class Strong: Element {
  /// Creates a new strong element.
  ///
  /// - Parameters:
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - level: Heading level (h1 to h6).
  ///   - content: Closure providing strong content.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    super.init(tag: "strong", id: id, classes: classes, role: role, label: label, content: content)
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
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - level: Heading level (h1 to h6).
  ///   - datetime: Machine-readable date/time in ISO 8601 format (e.g., "2025-03-22" or "2025-03-22T14:30:00Z").
  ///   - content: Closure providing human-readable time content.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    datetime: String,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    self.datetime = datetime
    super.init(tag: "time", id: id, classes: classes, role: role, label: label, content: content)
  }

  /// Provides time-specific attributes.
  public override func additionalAttributes() -> [String] {
    [
      attribute("datetime", datetime)
    ]
    .compactMap { $0 }
  }
}

/// Generates an HTML code block element
///
/// To be used for rendering code examples on a web page
public final class Code: Element {
  /// Creates a new code element.
  ///
  /// - Parameters:
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - level: Heading level (h1 to h6).
  ///   - content: Closure providing code content.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    super.init(tag: "code", id: id, classes: classes, role: role, label: label, content: content)
  }
}

/// Generates an HTML pre element
///
/// To be used for rendering preformatted text such as groups of code elements.
public final class Preformatted: Element {
  /// Creates a new preformatted element.
  ///
  /// - Parameters:
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - content: Closure providing preformatted content.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    super.init(tag: "pre", id: id, classes: classes, role: role, label: label, content: content)
  }
}
