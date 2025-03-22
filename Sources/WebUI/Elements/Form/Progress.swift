/// Generates an HTML progress element.
///
/// Displays the progress of a task, like a download.
public class Progress: Element {
  let value: Double?
  let max: Double?

  /// Creates a new HTML progress element.
  ///
  /// - Parameters:
  ///   - value: Current progress value, optional.
  ///   - max: Maximum progress value, optional.
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  public init(
    value: Double? = nil,
    max: Double? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil
  ) {
    self.value = value
    self.max = max
    super.init(tag: "progress", id: id, classes: classes, role: role)
  }

  /// Renders the progress as an HTML string.
  ///
  /// - Returns: Complete `<progress>` tag string with attributes.
  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("value", value?.description),
      attribute("max", max?.description),
      attribute("role", role?.rawValue),
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    return "<\(tag) \(attributes)>"
  }
}
