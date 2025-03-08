/// Represents the type of a list element.
public enum ListType: String {
  /// Represents an ordered list such as a numbered list
  case ordered = "ol"
  /// Represents an unordered list such as one with bullets
  case unordered = "ul"
}

/// Creates an HTML list element.
/// This renders either an `<ol>` or `<ul>` tag based on the specified type, used for ordered or unordered lists.
public class List: Element {
  let type: ListType

  init(
    type: ListType,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    self.type = type
    super.init(tag: type.rawValue, id: id, classes: classes, role: role, content: content)
  }
}

/// Creates an HTML list item element.
/// This renders an `<li>` tag, used as an item within a `<ul>` or `<ol>` list.
public class ListItem: Element {
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    super.init(tag: "li", id: id, classes: classes, role: role, content: content)
  }
}
