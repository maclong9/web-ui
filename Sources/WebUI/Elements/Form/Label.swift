/// Generates an HTML label element.
///
/// Associates descriptive text with a form field for accessibility.
public final class Label: Element {
  let `for`: String

  /// Creates a new HTML label element.
  ///
  /// - Parameters:
  ///   - tag: HTML tag, defaults to "label".
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - for: ID of the associated input element.
  ///   - content: Closure providing label content, defaults to empty.
  public init(
    tag: String = "label",
    `for`: String,
    config: ElementConfig = .init(),
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    self.for = `for`
    super.init(tag: tag, config: config, content: content)
  }

  /// Provides label-specific attributes.
  public override func additionalAttributes() -> [String] {
    [
      attribute("for", `for`)
    ]
    .compactMap { $0 }
  }
}
