import Foundation

/// Represents possible target values for HTML anchor (`<a>`) tags, defining where linked content should open.
///
/// This enumeration maps to standard HTML `target` attribute values and provides a type-safe way to specify
/// link behavior in HTML generation.
enum LinkTarget {
  case blank, parent, top

  /// Returns the HTML-compatible string value for the target attribute.
  ///
  /// - Returns: A string representing the HTML `target` attribute value (e.g., "_blank").
  var value: String {
    switch self {
    case .blank: return "_blank"
    case .parent: return "_parent"
    case .top: return "_top"
    }
  }
}

/// Defines valid heading levels for HTML heading tags (`<h1>` through `<h6>`).
///
/// Use this enumeration to specify the semantic level of headings in HTML content, ensuring proper
/// document structure and accessibility.
enum HeadingLevel {
  case h1, h2, h3, h4, h5, h6

  /// Provides the corresponding HTML tag name for the heading level.
  ///
  /// - Returns: A string representing the HTML tag (e.g., "h1" for `.h1`).
  var tag: String {
    switch self {
    case .h1: return "h1"
    case .h2: return "h2"
    case .h3: return "h3"
    case .h4: return "h4"
    case .h5: return "h5"
    case .h6: return "h6"
    }
  }
}

/// A versatile text element that renders as various HTML text-related tags based on configuration.
///
/// The `Text` class dynamically generates HTML elements such as `<a>`, `<p>`, `<span>`, `<b>`, `<em>`,
/// or heading tags (`<h1>`–`<h6>`), depending on the provided parameters. It supports links, styling,
/// and semantic structure, making it a flexible building block for HTML generation.
///
/// - Note: This class assumes the existence of an `Element` superclass and an `HTMLBuilder` result builder,
/// which are not defined in this snippet.
public class Text: Element {
  private let href: String?
  private let target: LinkTarget?

  /// Initializes a new text element with customizable attributes and content.
  ///
  /// This initializer determines the appropriate HTML tag based on the provided parameters:
  /// - If `href` is provided, renders as an `<a>` tag.
  /// - If `bold` is true, renders as a `<b>` tag.
  /// - If `emphasized` is true, renders as an `<em>` tag.
  /// - If `heading` is provided, renders as the specified heading tag (`<h1>`–`<h6>`).
  /// - Otherwise, renders as a `<p>` tag for multiple sentences or `<span>` for a single sentence.
  ///
  /// - Parameters:
  ///   - id: An optional identifier for the HTML element.
  ///   - classes: An optional array of CSS class names to apply to the element.
  ///   - href: An optional URL for creating a hyperlink (triggers `<a>` tag).
  ///   - target: An optional target for the hyperlink (e.g., open in new tab).
  ///   - bold: A flag to render the text in bold using a `<b>` tag.
  ///   - emphasized: A flag to render the text as emphasized using an `<em>` tag.
  ///   - heading: An optional heading level to render as a heading tag (`<h1>`–`<h6>`).
  ///   - content: A closure providing the content of the element using an `HTMLBuilder`.
  init(
    id: String? = nil,
    classes: [String]? = nil,
    href: String? = nil,
    target: LinkTarget? = nil,
    bold: Bool = false,
    emphasized: Bool = false,
    heading: HeadingLevel? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    self.href = href
    self.target = target

    let renderedContent = content().map { $0.render() }.joined()
    let sentenceCount = renderedContent.components(separatedBy: CharacterSet(charactersIn: ".!?"))
      .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
      .count

    // Determine the appropriate tag based on provided parameters
    let tag: String
    switch (href, bold, emphasized, heading) {
    case (_?, _, _, _):
      tag = "a"
    case (_, true, _, _):
      tag = "b"
    case (_, _, true, _):
      tag = "em"
    case (_, _, _, let heading?):
      tag = heading.tag
    default:
      tag = sentenceCount > 1 ? "p" : "span"
    }

    super.init(tag: tag, id: id, classes: classes, content: content)
  }

  /// Renders the text element as an HTML string.
  ///
  /// Overrides the superclass `render()` method to provide custom rendering for anchor tags
  /// when `href` is present, including additional attributes like `target`. For all other cases,
  /// it delegates to the superclass implementation.
  ///
  /// - Returns: A string containing the fully rendered HTML element.
  override func render() -> String {
    if href != nil {
      let classAttribute = classes?.isEmpty == false ? " class=\"\(classes?.joined(separator: " ") ?? "")\"" : ""
      let idAttribute = id?.isEmpty == false ? " id=\"\(id ?? "")\"" : ""
      let targetAttribute = target != nil ? " target=\"\(target!.value)\"" : ""
      let hrefAttribute = href != nil ? " href=\"\(href!)\"" : ""
      let renderedContent = content.map { $0.render() }.joined()
      return "<\(tag)\(idAttribute)\(classAttribute)\(hrefAttribute)\(targetAttribute)>\(renderedContent)</\(tag)>"
    }
    return super.render()
  }
}
