/// Generates an HTML style element.
///
/// Used to define CSS styles within the document.
public final class Style: Element {
  /// Creates a new style element.
  ///
  /// - Parameters:
  ///   - config: Configuration for element attributes, defaults to empty.
  public init(
    config: ElementConfig = .init()
  ) {
    super.init(tag: "style", config: config)
  }
}
