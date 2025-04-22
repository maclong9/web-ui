/// Defines types for HTML input elements.
public enum InputType: String {
  /// Single-line text input field.
  case text
  /// Masked password input field.
  case password
  /// Email address input field.
  case email
  /// Numeric input field.
  case number
  /// Checkbox input.
  case checkbox
  /// Submit button input.
  case submit
}

/// Generates an HTML input element for collecting user input, such as text or numbers.
final public class Input: Element {
  let name: String
  let type: InputType?
  let value: String?
  let placeholder: String?
  let autofocus: Bool?
  let required: Bool?
  var checked: Bool?

  /// Creates a new HTML input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission.
  ///   - type: Input type, optional.
  ///   - value: Initial value, optional.
  ///   - placeholder: Hint text displayed when the field is empty, optional.
  ///   - autofocus: Automatically focuses the input on page load if true, optional.
  ///   - required: Indicates the input is required for form submission, optional.
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  public init(
    name: String,
    type: InputType? = nil,
    value: String? = nil,
    placeholder: String? = nil,
    autofocus: Bool? = nil,
    required: Bool? = nil,
    checked: Bool? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil
  ) {
    self.name = name
    self.type = type
    self.value = value
    self.placeholder = placeholder
    self.autofocus = autofocus
    self.required = required
    self.checked = checked
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
    if checked == true {
      customAttributes.append("checked")
    }
    super.init(
      tag: "input",
      id: id,
      classes: classes,
      role: role,
      label: label,
      isSelfClosing: true,
      customAttributes: customAttributes.isEmpty ? nil : customAttributes
    )
  }
}
