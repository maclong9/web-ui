/// Generates an HTML textarea element.
///
/// Provides a multi-line text input for long-form content.
final public class Textarea: Input {
  /// Creates a new HTML textarea element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - name: Name for form submission.
  ///   - type: Input type, optional.
  ///   - value: Initial value, optional.
  ///   - placeholder: Hint text when empty, optional.
  ///   - autofocus: Focuses on page load if true, optional.
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    name: String,
    type: InputType? = nil,
    value: String? = nil,
    placeholder: String? = nil,
    autofocus: Bool? = nil
  ) {
    super.init(
      tag: "textarea",
      id: id,
      classes: classes,
      role: role,
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
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("placeholder", placeholder),
      attribute("role", role?.rawValue),
      booleanAttribute("autofocus", autofocus),
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let attributesString = attributes.isEmpty ? "" : " \(attributes)"
    return "<\(tag)\(attributesString)>\(value ?? "")</\(tag)>"
  }
}
