/// Generates an HTML textarea element.
///
/// Provides a multi-line text input for long-form content.
public final class TextArea: Input {
  /// Creates a new HTML textarea element.
  ///
  /// - Parameters:
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - name: Name for form submission.
  ///   - type: Input type, optional.
  ///   - value: Initial value, optional.
  ///   - placeholder: Hint text when empty, optional.
  ///   - autofocus: Focuses on page load if true, optional.
  public init(
    config: ElementConfig = .init(),
    name: String,
    type: InputType? = nil,
    value: String? = nil,
    placeholder: String? = nil,
    autofocus: Bool? = nil
  ) {
    super.init(
      tag: "textarea",
      config: config,
      name: name,
      type: type,
      value: value,
      placeholder: placeholder,
      autofocus: autofocus
    )
  }

  /// Renders the textarea as an HTML string.
  ///
  /// - Returns: Complete `<textarea>` tag string with attributes and content.
  public override func render() -> String {
    let baseAttributes = [
      attribute("id", config.id),
      attribute("class", config.classes?.joined(separator: " ")),
      attribute("role", config.role?.rawValue),
      attribute("label", config.label),
    ]
    .compactMap { $0 }

    let allAttributes = baseAttributes + additionalAttributes()
    let attributesString = allAttributes.isEmpty ? "" : " \(allAttributes.joined(separator: " "))"
    let contentString = value ?? ""
    return "<\(tag)\(attributesString)>\(contentString)</\(tag)>"
  }
}
