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
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  public init(
    value: Double? = nil,
    max: Double? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
  ) {
    self.value = value
    self.max = max
    super.init(
      tag: "progress", id: id, classes: classes, role: role, label: label)
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
