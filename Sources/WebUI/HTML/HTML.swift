/// Defines requirements for generating HTML content.
///
/// Requires entities to provide a method for rendering HTML as a string.
public protocol HTML {
  /// Renders the entity as an HTML string.
  ///
  /// Converts the conforming type into its HTML representation.
  ///
  /// - Returns: The HTML content as a string.
  func render() -> String
}
