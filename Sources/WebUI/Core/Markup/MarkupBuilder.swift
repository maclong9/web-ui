/// Enables declarative construction of markup content using Swift's result builder feature.
///
/// `MarkupBuilder` provides a domain-specific language (DSL) for creating markup structures
/// with a SwiftUI-like syntax. It transforms Swift code written in a declarative style
/// into a collection of markup elements, allowing for intuitive, hierarchical composition
/// of web content.
///
/// This result builder pattern simplifies the creation of complex markup structures by handling
/// the combination of elements, conditional logic, and loops in a natural, Swift-native way.
///
/// - Example:
///   ```swift
///   @MarkupBuilder
///   func createContent() -> [any Markup] {
///     Heading(.one) { "Welcome" }
///     Text { "This is a paragraph" }
///     if isLoggedIn {
///       Link(to: "/dashboard") { "Go to Dashboard" }
///     } else {
///       Link(to: "/login") { "Sign In" }
///     }
///   }
///   ```
@resultBuilder
public struct MarkupBuilder {
  /// Combines multiple markup component arrays into a single array.
  ///
  /// This method joins multiple variadic markup component lists into a single flat array,
  /// which is essential for building nested markup structures from multiple blocks of content.
  ///
  /// - Parameters:
  ///   - components: Variadic arrays of markup components, each representing a block of content.
  /// - Returns: A flattened array of all provided markup components.
  ///
  /// - Example:
  ///   ```swift
  ///   // Combines these separate arrays:
  ///   // [Heading, Text]
  ///   // [Image]
  ///   // [Button, Link]
  ///   // Into: [Heading, Text, Image, Button, Link]
  ///   ```
  public static func buildBlock(_ components: [any Markup]...) -> [any Markup] {
    components.joined().map { $0 }
  }

  /// Wraps a single markup entity in an array.
  ///
  /// This method converts an individual markup expression (like a Heading or Text element)
  /// into a component array, which is the standard format for all builder operations.
  ///
  /// - Parameters:
  ///   - expression: The markup entity to include in the result.
  /// - Returns: An array containing the single markup entity.
  ///
  /// - Example:
  ///   ```swift
  ///   // Converts: Text { "Hello" }
  ///   // Into: [Text { "Hello" }]
  ///   ```
  public static func buildExpression(_ expression: any Markup) -> [any Markup] {
    [expression]
  }

  /// Handles optional markup components in conditional statements.
  ///
  /// This method processes the optional result of an `if` statement that doesn't have an `else` clause,
  /// returning the components if present, or an empty array if nil.
  ///
  /// - Parameters:
  ///   - component: An optional array of markup components from the conditional.
  /// - Returns: The components or an empty array if nil.
  ///
  /// - Example:
  ///   ```swift
  ///   // For code like:
  ///   if showWelcome {
  ///     Heading(.one) { "Welcome" }
  ///   }
  ///   // Returns [Heading] if showWelcome is true, or [] if false
  ///   ```
  public static func buildOptional(_ component: [any Markup]?) -> [any Markup] {
    component ?? []
  }

  /// Resolves the true branch of a conditional markup structure.
  ///
  /// This method handles the first (true) branch of an if-else statement in the builder,
  /// returning components that should be included when the condition is true.
  ///
  /// - Parameters:
  ///   - component: The markup components from the true branch of the condition.
  /// - Returns: The components from the first branch, unchanged.
  ///
  /// - Example:
  ///   ```swift
  ///   // For the 'if' part of:
  ///   if isAdmin {
  ///     Button { "Admin Controls" }
  ///   } else {
  ///     Text { "Login required" }
  ///   }
  ///   ```
  public static func buildEither(first component: [any Markup]) -> [any Markup] {
    component
  }

  /// Resolves the false branch of a conditional markup structure.
  ///
  /// This method handles the second (false) branch of an if-else statement in the builder,
  /// returning components that should be included when the condition is false.
  ///
  /// - Parameters:
  ///   - component: The markup components from the false branch of the condition.
  /// - Returns: The components from the second branch, unchanged.
  ///
  /// - Example:
  ///   ```swift
  ///   // For the 'else' part of:
  ///   if isAdmin {
  ///     Button { "Admin Controls" }
  ///   } else {
  ///     Text { "Login required" }
  ///   }
  ///   ```
  public static func buildEither(second component: [any Markup]) -> [any Markup] {
    component
  }

  /// Flattens an array of markup component arrays from loop structures.
  ///
  /// This method converts a nested array from a `for` loop or other iterable context
  /// into a single flat array of components. It's essential for building lists and
  /// other repeating structures in the markup.
  ///
  /// - Parameters:
  ///   - components: An array of markup component arrays, each from one iteration of the loop.
  /// - Returns: A flattened array of all markup components from all iterations.
  ///
  /// - Example:
  ///   ```swift
  ///   // For a loop like:
  ///   for item in items {
  ///     Item { item.name }
  ///   }
  ///   // Converts [[Item1], [Item2], [Item3]] into [Item1, Item2, Item3]
  ///   ```
  public static func buildArray(_ components: [[any Markup]]) -> [any Markup] {
    components.flatMap { $0 }
  }
}

/// Type alias for a closure that builds markup content using the markup builder DSL.
///
/// This type is commonly used as a parameter type for component initializers,
/// allowing them to accept content-building closures with the MarkupBuilder syntax.
///
/// - Example:
///   ```swift
///   func makeSection(content: MarkupContentBuilder) -> Element {
///     return Section {
///       content()
///     }
///   }
///   ```
public typealias MarkupContentBuilder = () -> [any Markup]
