/// Generates a generic HTML fragment.
///
/// Groups arbirtray elements together without rendering a parent tag.
/// Use for rendering components that have no obvious root tag.
public class Fragment: HTML {
  let contentBuilder: () -> [any HTML]?

  /// Computed inner HTML content.
  var content: [any HTML] {
    contentBuilder() ?? { [] }()
  }

  /// Creates a new HTML fragment.
  ///
  /// - Parameter content: Closure providing fragment content, defaults to empty.
  public init(@HTMLBuilder content: @escaping () -> [any HTML]) {
    self.contentBuilder = content
  }

  public func render() -> String {
    content.map { $0.render() }.joined()
  }
}
