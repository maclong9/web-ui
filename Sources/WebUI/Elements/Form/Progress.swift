/// Creates an HTML progress element.
/// This renders a `<progress>` tag, used to display the progress of a task, such as a download or form completion.
public class Progress: Element { 
  let value: Double?
  let max: Double?

  /// Creates a new HTML progress element.
  ///
  /// - Parameters:
  ///   - value: The current value of the progress bar.
  ///   - max: The maximum value the progress bar can reach.
  ///   
  /// - SeeAlso: ``Element``
  init(
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

    let attributesString = attributes.isEmpty ? "" : " \(attributes)"
    return "<\(tag)\(attributesString)>"
  }
}
