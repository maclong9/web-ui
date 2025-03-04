/// Creates HTML article elements.
/// This renders a `<article>` tag, which is used to represent a self-contained piece of content, such as a blog post, news article, or forum post.
public class Article: Element {
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
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "section", id: id, classes: classes, role: role, content: content)
  }
}

/// Creates HTML division elements.
/// This renders a `<div>` tag, which is a generic container used to group other HTML elements for styling or other purposes without adding specific semantic meaning.
public class Stack: Element {
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "div", id: id, classes: classes, role: role, content: content)
  }
}

/// Creates HTML button elements.
/// This renders a `<button>` tag, which is used to create a clickable button that can be used to trigger an action or submit a form.
public class Button: Element {
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "button", id: id, classes: classes, role: role, content: content)
  }
}
