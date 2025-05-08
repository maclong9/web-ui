/// Represents a collection of HTML children, built declaratively.
public struct Children {
  private let content: [any HTML]

  /// Initializes children using an HTMLBuilder closure.
  public init(@HTMLBuilder content: HTMLContentBuilder) {
    self.content = content()
  }

  /// Renders all children as a single HTML string.
  public func render() -> String {
    content.map { $0.render() }.joined()
  }
}
