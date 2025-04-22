/// Generates an HTML article element.
///
/// Represents a self-contained piece of content like a blog post.
public final class Article: Element {
  /// Creates a new HTML article element.
  ///
  /// - Parameters:
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - isProse: Indicates if the article is long-form text, adding a "prose" class if true.
  ///   - content: Closure providing article content, defaults to empty.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "article", id: id, classes: classes, role: role, label: label, content: content)
  }
}

/// Generates an HTML section element.
///
/// Defines a thematic grouping of content, like a chapter.
public final class Section: Element {
  /// Creates a new HTML section element.
  ///
  /// - Parameters:
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - content: Closure providing section content, defaults to empty.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "section", id: id, classes: classes, role: role, label: label, content: content)
  }
}

/// Generates an HTML div element.
///
/// Groups elements for styling or layout without specific meaning.
public final class Stack: Element {
  /// Creates a new HTML div element.
  ///
  /// - Parameters:
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - content: Closure providing div content, defaults to empty.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "div", id: id, classes: classes, role: role, label: label, content: content)
  }
}
