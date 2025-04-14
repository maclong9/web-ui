/// Defines types of HTML list elements.
public enum ListType: String {
  case ordered = "ol", unordered = "ul"
}

/// Generates HTML list elements.
///
/// List can be rendered as an ordered list when sequence is unimportant,
/// or as a numbered list with sequenced markings.
public final class List: Element {
  let type: ListType

  /// Creates a new HTML list.
  ///
  /// - Parameters:
  ///   - type: List type (ordered or unordered).
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - content: Closure providing list items.
  public init(
    type: ListType = .unordered,
    config: ElementConfig = .init(),
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML]
  ) {
    self.type = type
    super.init(tag: type.rawValue, config: config, content: content)
  }
}

/// Generates an HTML list item element.
public final class Item: Element {
  /// Creates a new list item.
  ///
  /// - Parameters:
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - content: Closure providing item content.
  public init(
    config: ElementConfig = .init(),
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML]
  ) {
    super.init(tag: "li", config: config, content: content)
  }
}
