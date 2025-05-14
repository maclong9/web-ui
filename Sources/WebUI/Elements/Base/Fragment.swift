/// Generates a generic HTML fragment without a containing element.
///
/// Groups arbitrary elements together without rendering a parent tag.
/// Unlike other elements that produce an HTML tag, `Fragment` only renders its children.
///
/// Use `Fragment` for:
/// - Rendering components that have no obvious root tag
/// - Conditional rendering of multiple elements
/// - Returning multiple elements from a component
/// - Avoiding unnecessary DOM nesting
///
/// - Note: Conceptually similar to React's Fragment or Swift UI's Group component.
public final class Fragment: HTML {
  let contentBuilder: () -> [any HTML]?

  /// Computed inner HTML content.
  var content: [any HTML] {
    contentBuilder() ?? { [] }()
  }

  /// Creates a new HTML fragment that renders only its children.
  ///
  /// - Parameter content: Closure providing fragment content, defaults to empty.
  ///
  /// - Example:
  ///   ```swift
  ///   Fragment {
  ///     Heading(.one) { "Title" }
  ///     Text { "First paragraph" }
  ///     Text { "Second paragraph" }
  ///   }
  ///   // Renders: <h1>Title</h1><p>First paragraph</p><p>Second paragraph</p>
  ///   ```
  public init(
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    self.contentBuilder = content
  }

  public func render() -> String {
    content.map { $0.render() }.joined()
  }
}
