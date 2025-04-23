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
  ///   - name: Name for form submission.
  ///   - type: Input type, optional.
  ///   - value: Initial value, optional.
  ///   - placeholder: Hint text when empty, optional.
  ///   - autofocus: Focuses on page load if true, optional.
  ///   - required: Indicates the input is required for form submission.
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
  public init(
    name: String,
    type: InputType? = nil,
    value: String? = nil,
    placeholder: String? = nil,
    autofocus: Bool? = nil,
    required: Bool? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil
  ) {
    self.name = name
    self.type = type
    self.value = value
    self.placeholder = placeholder
    self.autofocus = autofocus
    self.required = required
    var customAttributes: [String] = []
    if !name.isEmpty {
      customAttributes.append("name=\"\(name)\"")
    }
    if let typeValue = type?.rawValue, !typeValue.isEmpty {
      customAttributes.append("type=\"\(typeValue)\"")
    }
    if let value = value, !value.isEmpty {
      customAttributes.append("value=\"\(value)\"")
    }
    if let placeholder = placeholder, !placeholder.isEmpty {
      customAttributes.append("placeholder=\"\(placeholder)\"")
    }
    if autofocus == true {
      customAttributes.append("autofocus")
    }
    if required == true {
      customAttributes.append("required")
    }
    super.init(
      tag: "textarea",
      id: id,
      classes: classes,
      role: role,
      label: label,
      data: data,
      customAttributes: customAttributes.isEmpty ? nil : customAttributes
    )
  }
}
