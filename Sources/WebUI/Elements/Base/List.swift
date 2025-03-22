/// Defines types of HTML list elements.
public enum ListType: String {
  case ordered = "ol", unordered = "ul"
}

/// Generates HTML list elements.
///
/// List can be rendered as an ordered list when sequence is unimportant,
/// or as a numbered list with sequenced markings.
public class List: Element {
  let type: ListType

  /// Creates a new HTML list.
  ///
  /// - Parameters:
  ///   - type: List type (ordered or unordered).
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - content: Closure providing list items.
  public init(
    type: ListType = .unordered,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    self.type = type
    super.init(tag: type.rawValue, id: id, classes: classes, role: role, content: content)
  }
}

/// Generates an HTML list item element.
public class Item: Element {
  /// Creates a new list item.
  ///
  /// - Parameters:
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - content: Closure providing item content.
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    super.init(tag: "li", id: id, classes: classes, role: role, content: content)
  }
}
