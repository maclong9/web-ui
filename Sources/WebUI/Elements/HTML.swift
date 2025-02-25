/// A protocol that represents an HTML-renderable entity.
/// - Any type conforming to this protocol can be rendered as an HTML string.
protocol HTML {
  /// Renders the HTML entity as a string.
  /// - Returns: A string representation of the HTML entity.
  func render() -> String
}

extension String: HTML {
  /// Renders the string as HTML content directly.
  /// - This allows strings to be seamlessly used within the HTML builder DSL.
  /// - Returns: The string itself, as it's already valid content.
  func render() -> String { self }
}

/// A result builder for creating HTML content in a declarative syntax.
/// - This enables a SwiftUI-like syntax for building HTML structures.
@resultBuilder
struct HTMLBuilder {
  /// Builds a block of HTML components into an array.
  /// - Parameter components: A variadic list of HTML components.
  /// - Returns: An array containing all the provided HTML components.
  static func buildBlock(_ components: any HTML...) -> [any HTML] { components }
}
