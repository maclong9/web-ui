import Foundation

/// Defines valid heading levels for HTML heading tags (`<h1>` through `<h6>`).
enum HeadingLevel: String {
  case h1, h2, h3, h4, h5, h6
}

/// A basic text element that renders as either a `<p>` or `<span>` HTML tag based on content.
///
/// The `<p>` tag represents a paragraph and is used when the content contains multiple sentences,
/// adding appropriate spacing in HTML rendering.
///
/// The `<span>` tag is an inline container used
/// for single-sentence or phrase-level content, with no additional spacing.
public class Text: Element {
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

/// A text element that renders as an HTML heading tag (`<h1>` through `<h6>`).
///
/// Heading tags are used to define section titles and establish content hierarchy in HTML documents.
/// The specific tag (`<h1>` to `<h6>`) is determined by the `level` parameter.
///
///  `<h1>` is usually used for the main page title, with `<h2>` being for section titles. You can then
///  use the others to denote subcontent for these sections.
public class Heading: Element {
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

/// A text element that renders as an HTML hyperlink (`<a>` tag).
///
/// The `<a>` tag creates a clickable link to another webpage or resource, defined by the `href` attribute.
/// This element is inline by default and can contain text or other inline elements.
///
/// - SeeAlso: `Button` for user interactivity instead of page linking.
public class Link: Element {
  private let href: String
  private let newTab: Bool?

  /// Creates a new anchor element
  /// - Parameters:
  ///   - href: The path to direct the browser to.
  ///   - newTab: Indicates if a new tab should be created.
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

  override func render() -> String {
    let attributes = [
      id.map { "id=\"\($0)\"" },
      classes?.isEmpty == false ? "class=\"\(classes!.joined(separator: " "))\"" : nil,
      "href=\"\(href)\"",
      newTab == true ? "target=\"_blank\"" : nil,
      role.map { "role=\"\($0.rawValue)\"" },
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let contentString = content.map { $0.render() }.joined()
    return "<\(tag) \(attributes)>\(contentString)</\(tag)>"
  }
}

/// A text element that renders as emphasized text using the `<em>` HTML tag.
/// The `<em>` tag indicates text with stress emphasis (typically italicized by default in browsers),
/// used to denote importance or a change in tone within surrounding content. It’s an inline element.
public class Emphasis: Element {
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    super.init(tag: "em", id: id, classes: classes, role: role, content: content)
  }
}

/// A text element that renders as strong text using the `<strong>` HTML tag.
/// The `<strong>` tag indicates text of strong importance (typically bolded by default in browsers),
/// used to highlight critical information or key terms. It’s an inline element.
public class Strong: Element {
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    super.init(tag: "strong", id: id, classes: classes, role: role, content: content)
  }
}
