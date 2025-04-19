/// Generates an HTML textarea element.
///
/// Provides a multi-line text input for long-form content.
public final class TextArea: Element {
  let name: String
  let type: InputType?
  let value: String?
  let placeholder: String?
  let autofocus: Bool?
  let required: Bool?

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
    autofocus: Bool? = nil,
    required: Bool? = nil
  ) {
    self.name = name
    self.type = type
    self.value = value
    self.placeholder = placeholder
    self.autofocus = autofocus
    self.required = required

    super.init(
      tag: "textarea",
      config: config,
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
