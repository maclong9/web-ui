/// Enables declarative construction of HTML content using Swift's result builder feature.
///
/// `HTMLBuilder` provides a domain-specific language (DSL) for creating HTML structures
/// with a SwiftUI-like syntax. It transforms Swift code written in a declarative style
/// into a collection of HTML elements, allowing for intuitive, hierarchical composition
/// of web content.
///
/// This result builder pattern simplifies the creation of complex HTML structures by handling
/// the combination of elements, conditional logic, and loops in a natural, Swift-native way.
///
/// - Example:
///   ```swift
///   @HTMLBuilder
///   func createContent() -> [any HTML] {
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
public struct HTMLBuilder {
  /// Combines multiple HTML component arrays into a single array.
  ///
  /// This method joins multiple variadic HTML component lists into a single flat array,
  /// which is essential for building nested HTML structures from multiple blocks of content.
  ///
  /// - Parameters:
  ///   - components: Variadic arrays of HTML components, each representing a block of content.
  /// - Returns: A flattened array of all provided HTML components.
  ///
  /// - Example:
  ///   ```swift
  ///   // Combines these separate arrays:
  ///   // [Heading, Text]
  ///   // [Image]
  ///   // [Button, Link]
  ///   // Into: [Heading, Text, Image, Button, Link]
  ///   ```
  public static func buildBlock(_ components: [any HTML]...) -> [any HTML] {
    components.joined().map { $0 }
  }

  /// Wraps a single HTML entity in an array.
  ///
  /// This method converts an individual HTML expression (like a Heading or Text element)
  /// into a component array, which is the standard format for all builder operations.
  ///
  /// - Parameters:
  ///   - expression: The HTML entity to include in the result.
  /// - Returns: An array containing the single HTML entity.
  ///
  /// - Example:
  ///   ```swift
  ///   // Converts: Text { "Hello" }
  ///   // Into: [Text { "Hello" }]
  ///   ```
  public static func buildExpression(_ expression: any HTML) -> [any HTML] {
    [expression]
  }

  /// Handles optional HTML components in conditional statements.
  ///
  /// This method processes the optional result of an `if` statement that doesn't have an `else` clause,
  /// returning the components if present, or an empty array if nil.
  ///
  /// - Parameters:
  ///   - component: An optional array of HTML components from the conditional.
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
  public static func buildOptional(_ component: [any HTML]?) -> [any HTML] {
    component ?? []
  }

  /// Resolves the true branch of a conditional HTML structure.
  ///
  /// This method handles the first (true) branch of an if-else statement in the builder,
  /// returning components that should be included when the condition is true.
  ///
  /// - Parameters:
  ///   - component: The HTML components from the true branch of the condition.
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
  public static func buildEither(first component: [any HTML]) -> [any HTML] {
    component
  }

  /// Resolves the false branch of a conditional HTML structure.
  ///
  /// This method handles the second (false) branch of an if-else statement in the builder,
  /// returning components that should be included when the condition is false.
  ///
  /// - Parameters:
  ///   - component: The HTML components from the false branch of the condition.
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
  public static func buildEither(second component: [any HTML]) -> [any HTML] {
    component
  }

  /// Flattens an array of HTML component arrays from loop structures.
  ///
  /// This method converts a nested array from a `for` loop or other iterable context
  /// into a single flat array of components. It's essential for building lists and
  /// other repeating structures in the HTML.
  ///
  /// - Parameters:
  ///   - components: An array of HTML component arrays, each from one iteration of the loop.
  /// - Returns: A flattened array of all HTML components from all iterations.
  ///
  /// - Example:
  ///   ```swift
  ///   // For a loop like:
  ///   for item in items {
  ///     Item { item.name }
  ///   }
  ///   // Converts [[Item1], [Item2], [Item3]] into [Item1, Item2, Item3]
  ///   ```
  public static func buildArray(_ components: [[any HTML]]) -> [any HTML] {
    components.flatMap { $0 }
  }
}

/// Type alias for a closure that builds HTML content using the HTML builder DSL.
///
/// This type is commonly used as a parameter type for component initializers,
/// allowing them to accept content-building closures with the HTMLBuilder syntax.
///
/// - Example:
///   ```swift
///   func makeSection(content: HTMLContentBuilder) -> Element {
///     return Section {
///       content()
///     }
///   }
///   ```
public typealias HTMLContentBuilder = () -> [any HTML]
