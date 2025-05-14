/// Represents a collection of HTML children built declaratively.
///
/// The `Children` struct provides a container for a group of HTML elements that can be
/// manipulated and rendered together. This is useful for creating reusable components
/// or managing groups of elements that should be treated as a unit.
///
/// - Example:
///   ```swift
///   let navigationItems = Children {
///     Link(to: "/home") { "Home" }
///     Link(to: "/about") { "About" }
///     Link(to: "/contact") { "Contact" }
///   }
///   ```
public struct Children {
  private let content: [any HTML]

  /// Initializes children using an HTMLBuilder closure.
  ///
  /// - Parameter content: A closure that produces HTML elements using the HTMLBuilder DSL.
  ///
  /// - Example:
  ///   ```swift
  ///   let items = Children {
  ///     Text { "First item" }
  ///     Text { "Second item" }
  ///   }
  ///   ```
  public init(@HTMLBuilder content: HTMLContentBuilder) {
    self.content = content()
  }

  /// Renders all children as a single HTML string.
  ///
  /// This method concatenates the rendered HTML of all child elements into a single string,
  /// without any additional wrapper elements.
  ///
  /// - Returns: A string containing the combined HTML of all child elements.
  ///
  /// - Example:
  ///   ```swift
  ///   let html = navigationItems.render()
  ///   // html contains: <a href="/home">Home</a><a href="/about">About</a><a href="/contact">Contact</a>
  ///   ```
  public func render() -> String {
    content.map { $0.render() }.joined()
  }
}
