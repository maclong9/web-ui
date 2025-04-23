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
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
  public init(
    value: Double? = nil,
    max: Double? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil
  ) {
    self.value = value
    self.max = max
    var customAttributes: [String] = []
    if let value = value {
      customAttributes.append("value=\"\(value.description)\"")
    }
    if let max = max {
      customAttributes.append("max=\"\(max.description)\"")
    }
    super.init(
      tag: "progress",
      id: id,
      classes: classes,
      role: role,
      label: label,
      data: data,
      customAttributes: customAttributes.isEmpty ? nil : customAttributes
    )
  }
}
