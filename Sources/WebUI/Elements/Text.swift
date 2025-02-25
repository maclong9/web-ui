import Foundation

/// Possible target values for HTML anchor tags
enum LinkTarget {
  case blank
  case parent
  case top

  var value: String {
    switch self {
    case .blank: return "_blank"
    case .parent: return "_parent"
    case .top: return "_top"
    }
  }
}

/// Possible heading levels for HTML heading tags
enum HeadingLevel {
  case h1, h2, h3, h4, h5, h6

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

/// A text element that can be rendered as various HTML text-related tags
class Text: Element {
  private let href: String?
  private let target: LinkTarget?

  /// Creates a new text element with optional attributes and content
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
