/// Enables declarative construction of HTML content.
///
/// Provides a result builder for creating HTML structures with a SwiftUI-like syntax.
@resultBuilder
public struct HTMLBuilder {
  /// Combines multiple HTML component arrays into a single array.
  ///
  /// Joins variadic HTML component lists into a flat array.
  ///
  /// - Parameters:
  ///   - components: Variadic arrays of HTML components.
  /// - Returns: A flattened array of all provided HTML components.
  public static func buildBlock(_ components: [any HTML]...) -> [any HTML] {
    components.joined().map { $0 }
  }

  /// Wraps a single HTML entity in an array.
  ///
  /// Converts an individual HTML expression into a component array.
  ///
  /// - Parameters:
  ///   - expression: The HTML entity to include.
  /// - Returns: An array containing the single HTML entity.
  public static func buildExpression(_ expression: any HTML) -> [any HTML] {
    [expression]
  }

  /// Handles optional HTML components.
  ///
  /// Returns the components if present, or an empty array if nil.
  ///
  /// - Parameters:
  ///   - component: An optional array of HTML components.
  /// - Returns: The components or an empty array if nil.
  public static func buildOptional(_ component: [any HTML]?) -> [any HTML] {
    component ?? []
  }

  /// Resolves the true branch of a conditional HTML structure.
  ///
  /// Returns components from the first branch of an if-else statement.
  ///
  /// - Parameters:
  ///   - component: The HTML components from the true branch.
  /// - Returns: The components from the first branch.
  public static func buildEither(first component: [any HTML]) -> [any HTML] {
    component
  }

  /// Resolves the false branch of a conditional HTML structure.
  ///
  /// Returns components from the second branch of an if-else statement.
  ///
  /// - Parameters:
  ///   - component: The HTML components from the false branch.
  /// - Returns: The components from the second branch.
  public static func buildEither(second component: [any HTML]) -> [any HTML] {
    component
  }

  /// Flattens an array of HTML component arrays.
  ///
  /// Converts a nested array from a loop into a single array of components.
  ///
  /// - Parameters:
  ///   - components: An array of HTML component arrays.
  /// - Returns: A flattened array of all HTML components.
  public static func buildArray(_ components: [[any HTML]]) -> [any HTML] {
    components.flatMap { $0 }
  }
}

/// Type alias for a closure that builds HTML content.
public typealias HTMLContentBuilder = () -> [any HTML]
