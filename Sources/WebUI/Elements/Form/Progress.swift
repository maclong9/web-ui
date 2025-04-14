/// Generates an HTML progress element.
///
/// Displays the progress of a task, like a download.
public final class Progress: Element {
  let value: Double?
  let max: Double?

  /// Creates a new HTML progress element.
  ///
  /// - Parameters:
  ///   - value: Current progress value, optional.
  ///   - max: Maximum progress value, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  public init(
    value: Double? = nil,
    max: Double? = nil,
    config: ElementConfig = .init()
  ) {
    self.value = value
    self.max = max
    super.init(tag: "progress", config: config, isSelfClosing: true)
  }

  /// Provides progress-specific attributes.
  public override func additionalAttributes() -> [String] {
    [
      attribute("value", value?.description),
      attribute("max", max?.description),
    ]
    .compactMap { $0 }
  }
}
