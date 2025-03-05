/// Creates HTML article elements.
/// This renders a `<article>` tag, which is used to represent a self-contained piece of content, such as a blog post, news article, or forum post.
public class Article: Element {
  /// - SeeAlso: ``Element``
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "article", id: id, classes: classes, role: role, content: content)
  }
}

/// Creates HTML section elements.
/// This renders a `<section>` tag, which is used to define a section in a document, such as a chapter, an introduction, or a group of related content.
public class Section: Element {
  /// - SeeAlso: ``Element``
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "section", id: id, classes: classes, role: role, content: content)
  }
}

/// Creates standard HTML grouping elements.
///
/// This renders a `<div>` tag, which is a generic container used to group other HTML elements
/// for styling or other purposes without adding specific semantic meaning.
public class Stack: Element {
  /// - SeeAlso: ``Element``
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "div", id: id, classes: classes, role: role, content: content)
  }
}
