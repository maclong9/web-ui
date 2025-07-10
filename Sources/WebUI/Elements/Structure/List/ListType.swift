/// Defines types of HTML list elements.
///
/// HTML supports two main types of lists: ordered (numbered) lists and unordered (bulleted) lists.
/// This enum provides a type-safe way to specify which list type to create.
public enum ListType: String {
  /// Creates an ordered (numbered) list using the `<ol>` tag.
  ///
  /// Use for sequential, prioritized, or step-by-step items.
  case ordered = "ol"

  /// Creates an unordered (bulleted) list using the `<ul>` tag.
  ///
  /// Use for items where the sequence doesn't matter.
  case unordered = "ul"
}
