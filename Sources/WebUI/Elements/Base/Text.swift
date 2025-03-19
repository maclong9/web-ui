import Foundation

/// Generates HTML text elements as `<p>` or `<span>` based on content.
///
/// Paragraphs are for long form content with multiple sentences and
/// a `<span>` tag is used for a single sentences of text and grouping inline content.
class Text: Element {
  /// Creates a new text element.
  ///
  /// Uses `<p>` for multiple sentences, `<span>` for one or fewer.
  ///
  /// - Parameters:
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - content: Closure providing text content.
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    let renderedContent = content().map { $0.render() }.joined()
    let sentenceCount = renderedContent.components(separatedBy: CharacterSet(charactersIn: ".!?"))
      .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
      .count
    let tag = sentenceCount > 1 ? "p" : "span"
    super.init(tag: tag, id: id, classes: classes, role: role, content: content)
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

/// Generates a HTML heading elements from `<h1>` to `<h6>`.
///
/// The level of the heading should descend through the document,
/// with the main page title being 1 and then section headings being 2.
public class Heading: Element {
  /// Creates a new heading.
  ///
  /// - Parameters:
  ///   - level: Heading level (h1 to h6).
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - content: Closure providing heading content.
  init(
    level: HeadingLevel,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    super.init(tag: level.rawValue, id: id, classes: classes, role: role, content: content)
  }
}

/// Generates an HTML anchor element; for linking to other locations.
public class Link: Element {
  private let href: String
  private let newTab: Bool?

  /// Creates a new anchor link.
  ///
  /// - Parameters:
  ///   - destination: URL or path the link points to.
  ///   - newTab: Opens in a new tab if true, optional.
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - content: Closure providing link content.
  init(
    to destination: String,
    newTab: Bool? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    self.href = destination
    self.newTab = newTab
    super.init(tag: "a", id: id, classes: classes, role: role, content: content)
  }

  /// Renders the anchor as an HTML string.
  ///
  /// - Returns: Complete `<a>` tag string with attributes and content.
  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("href", href),
      attribute("target", newTab == true ? "_blank" : nil),
      attribute("rel", newTab == true ? "noreferrer" : nil),
      attribute("role", role?.rawValue),
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let contentString = content.map { $0.render() }.joined()
    return "<\(tag) \(attributes)>\(contentString)</\(tag)>"
  }
}

/// Generates an HTML emphasis element.
///
/// To be used to draw attention to text within another body of text.
public class Emphasis: Element {
  /// Creates a new emphasis element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - content: Closure providing emphasized content.
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    super.init(tag: "em", id: id, classes: classes, role: role, content: content)
  }
}

/// Generates an HTML strong importance element.
///
/// To be used for drawing strong attention to text within another body of text.
public class Strong: Element {
  /// Creates a new strong element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - content: Closure providing strong content.
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    super.init(tag: "strong", id: id, classes: classes, role: role, content: content)
  }
}
