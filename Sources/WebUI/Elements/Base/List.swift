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
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - type: List type (ordered or unordered).
  ///   - content: Closure providing list items.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    type: ListType = .unordered,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    self.type = type
    super.init(tag: type.rawValue, id: id, classes: classes, role: role, label: label, content: content)
  }
}

/// Generates an HTML list item element.
public final class Item: Element {
  /// Creates a new list item.
  ///
  /// - Parameters:
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - type: Button type, optional.
  ///   - content: Closure providing item content.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    super.init(tag: "li", id: id, classes: classes, role: role, label: label, content: content)
  }
}
