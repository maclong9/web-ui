/// Creates HTML header elements.
/// This renders a `<header>` tag, which is used to contain introductory content or a set of navigational links for a document or section.
public class Header: Element {
  /// - SeeAlso: ``Element``
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "header", id: id, classes: classes, role: role, content: content)
  }
}

/// Creates HTML header elements.
/// This renders a `<header>` tag, which is used to render a set of navigational links for a document or section.
public class Navigation: Element {
  /// - SeeAlso: ``Element``
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "nav", id: id, classes: classes, role: role, content: content)
  }
}

/// Creates the main content area of an HTML document.
/// This renders a `<main>` tag, which contains the primary content of the page that is unique to that page and should be relevant to the page's purpose.
public class Main: Element {
  /// - SeeAlso: ``Element``
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "main", id: id, classes: classes, role: role, content: content)
  }
}

/// Creates HTML footer elements.
/// This renders a `<footer>` tag, which typically contains information about the author, copyright, links to terms of use, etc., and is placed at the bottom of a web page or section.
public class Footer: Element {
  /// - SeeAlso: ``Element``
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "footer", id: id, classes: classes, role: role, content: content)
  }
}
