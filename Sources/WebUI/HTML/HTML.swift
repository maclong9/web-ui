/// A protocol that represents an HTML-renderable entity.
/// - Any type conforming to this protocol can be rendered as an HTML string.
protocol HTML {
  /// Renders the HTML entity as a string.
  /// - Returns: A string representation of the HTML entity.
  func render() -> String
}
