import Foundation

/// Represents different levels of HTML heading tags, from h1 to h6.
/// Each case corresponds to a specific heading level, used to structure and organize content on a web page.
public enum HeadingLevel: String {
  /// Represents the primary title or main topic of a page (h1)
  case level1 = "h1"
  /// Represents a major section or subtopic within the page (h2)
  case level2 = "h2"
  /// Represents a subsection within a major section (h3)
  case level3 = "h3"
  /// Represents a sub-subsection or deeper detail within a subsection (h4)
  case level4 = "h4"
  /// Represents a minor detail or supporting heading within a sub-subsection (h5)
  case level5 = "h5"
  /// Represents the finest level of detail or a rare, deeply nested heading (h6)
  case level6 = "h6"
}

/// Creates HTML text elements.
/// This can render either a `<p>` (paragraph) tag or a `<span>` tag based on the content.
/// - If the content contains more than one sentence, it is rendered as a `<p>` tag.
/// - If the content contains one sentence or less, it is rendered as a `<span>` tag.
///
/// The `<p>` tag is used to represent a paragraph of text, which is a block-level element.
/// The `<span>` tag is used to group inline elements for styling or other purposes without adding semantic meaning.
class Text: Element {
  /// - SeeAlso: ``Element``
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

/// Creates HTML heading elements.
/// This can render heading tags from `<h1>` to `<h6>`, depending on the `level` parameter.
///
/// Heading tags are used to structure the content of a web page and indicate the hierarchy of sections.
/// - `<h1>` is typically used for the main heading of the page.
/// - `<h2>` to `<h6>` are used for subheadings, with `<h2>` being the next most important after `<h1>`, and so on.
public class Heading: Element {
  /// - SeeAlso: ``Element``
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

/// A class for creating HTML anchor elements.
/// This class renders an `<a>` tag, which is used to create a link to another resource, such as a web page or a file.
///
/// The `<a>` tag supports attributes like `href` for the URL and `target` to specify where to open the linked resource.
public class Link: Element {
  private let href: String
  private let newTab: Bool?

  /// Creates a new HTML anchor element
  ///
  /// - Parameters:
  ///   - href: The path or url the link should point to
  ///   - newTab: whether or not the link should open in a new browser tab
  ///
  /// - SeeAlso: ``Element``
  init(
    href: String,
    newTab: Bool? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    self.href = href
    self.newTab = newTab
    super.init(tag: "a", id: id, classes: classes, role: role, content: content)
  }

  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("href", href),
      attribute("target", newTab == true ? "_blank" : nil),
      attribute("role", role?.rawValue),
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let contentString = content.map { $0.render() }.joined()
    return "<\(tag) \(attributes)>\(contentString)</\(tag)>"
  }
}

/// Creates HTML emphasis elements.
/// This renders an `<em>` tag, which is used to indicate that its content has stress emphasis compared to the surrounding text.
///
/// The `<em>` tag is typically rendered in italic text by default in most browsers.
public class Emphasis: Element {
  /// - SeeAlso: ``Element``
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    super.init(tag: "em", id: id, classes: classes, role: role, content: content)
  }
}

/// Creates HTML strong importance elements.
/// This renders a `<strong>` tag, which is used to indicate that its content has strong importance, seriousness, or urgency.
///
/// The `<strong>` tag is typically rendered in bold text by default in most browsers.
public class Strong: Element {
  /// - SeeAlso: ``Element``
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    super.init(tag: "strong", id: id, classes: classes, role: role, content: content)
  }
}
