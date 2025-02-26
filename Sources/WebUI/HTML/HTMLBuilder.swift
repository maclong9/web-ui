/// A result builder for creating HTML content in a declarative syntax.
/// - This enables a SwiftUI-like syntax for building HTML structures.
@resultBuilder
struct HTMLBuilder {
  /// Builds a block of HTML components into an array.
  /// - Parameter components: A variadic list of HTML components.
  /// - Returns: An array containing all the provided HTML components.
  static func buildBlock(_ components: [any HTML]...) -> [any HTML] {
    components.joined().map { $0 }
  }

  /// Converts a single HTML expression into an array of components.
  /// - Parameter expression: An individual HTML entity to be included in the builder.
  /// - Returns: An array containing the single HTML entity.
  static func buildExpression(_ expression: any HTML) -> [any HTML] {
    [expression]
  }

  /// Handles optional HTML components in the builder.
  /// - Parameter component: An optional array of HTML components, which may be nil.
  /// - Returns: The array of components if present, or an empty array if nil.
  static func buildOptional(_ component: [any HTML]?) -> [any HTML] {
    component ?? []
  }

  /// Resolves the first branch of a conditional HTML structure.
  /// - Parameter component: An array of HTML components from the "true" branch of an if-else.
  /// - Returns: The array of components from the first branch.
  static func buildEither(first component: [any HTML]) -> [any HTML] {
    component
  }

  /// Resolves the second branch of a conditional HTML structure.
  /// - Parameter component: An array of HTML components from the "false" branch of an if-else.
  /// - Returns: The array of components from the second branch.
  static func buildEither(second component: [any HTML]) -> [any HTML] {
    component
  }

  /// Handles loops by transforming an array of HTML component arrays into a single flat array.
  /// - Parameter components: An array of HTML component arrays, typically from a `for` loop.
  /// - Returns: A flattened array of all HTML components.
  static func buildArray(_ components: [[any HTML]]) -> [any HTML] {
    components.flatMap { $0 }
  }
}
