/// Generates an HTML style element.
///
/// Used to define CSS styles within the document.
public final class Style: Element {
  /// Creates a new style element.
  ///
  /// - Parameters:
  ///   - config: Configuration for element attributes, defaults to empty.
  init(
    config: ElementConfig = .init(),
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML]
  ) {
    super.init(tag: "style", config: config, content: content)
  }
}
