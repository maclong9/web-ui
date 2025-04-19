/// Generates an HTML article element.
///
/// Represents a self-contained piece of content like a blog post.
public final class Article: Element {
  /// Creates a new HTML article element.
  ///
  /// - Parameters:
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - isProse: Indicates if the article is long-form text, adding a "prose" class if true.
  ///   - content: Closure providing article content, defaults to empty.
  public init(
    config: ElementConfig = .init(),
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    super.init(tag: "article", config: config, isSelfClosing: false, content: content)
  }
}

/// Generates an HTML section element.
///
/// Defines a thematic grouping of content, like a chapter.
public final class Section: Element {
  /// Creates a new HTML section element.
  ///
  /// - Parameters:
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - content: Closure providing section content, defaults to empty.
  public init(
    config: ElementConfig = .init(),
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    super.init(tag: "section", config: config, isSelfClosing: false, content: content)
  }
}

/// Generates an HTML div element.
///
/// Groups elements for styling or layout without specific meaning.
public final class Stack: Element {
  /// Creates a new HTML div element.
  ///
  /// - Parameters:
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - content: Closure providing div content, defaults to empty.
  public init(
    config: ElementConfig = .init(),
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    super.init(tag: "div", config: config, isSelfClosing: false, content: content)
  }
}
