/// Represents the type of a list element.
public enum ListType: String {
  /// Represents an ordered list such as a numbered list
  case ordered = "ol"
  /// Represents an unordered list such as one with bullets
  case unordered = "ul"
}

/// Represents an HTML list element (`<ul>` or `<ol>`).
///
/// This class creates either an unordered list (`<ul>`) for items without a specific sequence,
/// or an ordered list (`<ol>`) for items with a defined order. Semantically, `<ul>` is used
/// for collections where order doesn't matter, while `<ol>` is used
/// for sequences
public class List: Element {
  let type: ListType
  /// Creates a new HTML list element.
  ///
  /// - Parameter type: Whether to render an ordered or unordered list.
  ///
  /// - SeeAlso: ``Element``
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

/// Represents an HTML list item element (`<li>`).
///
/// This class creates an `<li>` tag, used as a child of `<ul>` or `<ol>` elements to represent
/// individual items in a list. Semantically, it defines a single entry within a list,
/// whether ordered (numbered) or unordered (bulleted), and can contain text, elements,
/// or nested lists for complex structures.
public class ListItem: Element {
  /// - SeeAlso: ``Element``
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    super.init(tag: "li", id: id, classes: classes, role: role, content: content)
  }
}
