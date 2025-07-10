/// Defines styles for HTML list elements.
///
/// HTML supports various styles for list elements, such as disc, circle, or square.
/// This enum provides a type-safe way to specify which style to use.
public enum ListStyle: String {
  /// Creates a list with no bullets or numbers.
  case none = ""

  /// Creates a list with bullets shaped like discs.
  case disc

  /// Creates a list with bullets shaped like circles.
  case circle

  /// Creates a list with bullets shaped like squares.
  case square = "[square]"
}
