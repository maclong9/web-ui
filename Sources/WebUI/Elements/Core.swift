/// An HTML article element.
/// - Article elements represent self-contained compositions in a document, such as a blog post or news story.
class Article: Element {
  /// Creates a new HTML article element with optional attributes and content.
  /// - Parameters:
  ///   - id: An optional ID attribute for the element.
  ///   - classes: Optional CSS classes to apply to the element.
  ///   - content: A result builder closure that defines the nested content.
  init(id: String? = nil, classes: [String]? = nil, @HTMLBuilder content: @escaping () -> [any HTML]) {
    super.init(tag: "article", id: id, classes: classes, content: content)
  }
}

/// An HTML section element.
/// - Section elements represent a standalone section of content within a document,
///   typically with its own heading.
class Section: Element {
  /// Creates a new HTML section element with optional attributes and content.
  /// - Parameters:
  ///   - id: An optional ID attribute for the element.
  ///   - classes: Optional CSS classes to apply to the element.
  ///   - content: A result builder closure that defines the nested content.
  init(id: String? = nil, classes: [String]? = nil, @HTMLBuilder content: @escaping () -> [any HTML]) {
    super.init(tag: "section", id: id, classes: classes, content: content)
  }
}

/// A container element implemented as an HTML div.
/// - This is a generic container element useful for grouping and styling content.
class Stack: Element {
  /// Creates a new HTML div element with optional attributes and content.
  /// - Parameters:
  ///   - id: An optional ID attribute for the element.
  ///   - classes: Optional CSS classes to apply to the element.
  ///   - content: A result builder closure that defines the nested content.
  init(id: String? = nil, classes: [String]? = nil, @HTMLBuilder content: @escaping () -> [any HTML]) {
    super.init(tag: "div", id: id, classes: classes, content: content)
  }
}
