/// Generates an HTML article element.
///
/// Represents a self-contained piece of content like a blog post.
public final class Article: Element {
  /// Defines the article as long form text content for styling
  let isProse: Bool
  
  /// Creates a new HTML article element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - content: Closure providing article content, defaults to empty.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    isProse: Bool = false,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    self.isProse = isProse
    super.init(tag: "article", id: id, classes: classes, role: role, content: content)
  }
}

/// Generates an HTML section element.
///
/// Defines a thematic grouping of content, like a chapter.
public final class Section: Element {
  /// Creates a new HTML section element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - content: Closure providing section content, defaults to empty.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    super.init(tag: "section", id: id, classes: classes, role: role, content: content)
  }
}

/// Generates an HTML div element.
///
/// Groups elements for styling or layout without specific meaning.
public final class Stack: Element {
  /// Creates a new HTML div element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - content: Closure providing div content, defaults to empty.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    super.init(tag: "div", id: id, classes: classes, role: role, content: content)
  }
}
