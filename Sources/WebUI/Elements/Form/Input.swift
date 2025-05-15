/// Defines types for HTML input elements.
///
/// Specifies the type of data to be collected by an input element, affecting both
/// appearance and validation behavior.
public enum InputType: String {
  /// Single-line text input field for general text entry.
  case text
  /// Masked password input field that hides characters for security.
  case password
  /// Email address input field with validation for email format.
  case email
  /// Numeric input field optimized for number entry, often with increment/decrement controls.
  case number
  /// Checkbox input for boolean (yes/no) selections.
  case checkbox
  /// Submit button input that triggers form submission when clicked.
  case submit
}

/// Generates an HTML input element for collecting user input, such as text or numbers.
///
/// `Input` elements are the primary way to gather user data in forms, supporting various types
/// of input from simple text to specialized formats like email addresses or numbers.
/// The appearance and behavior of an input element is determined by its type.
final public class Input: Element {
  /// The name attribute used for form submission (maps to form data field name).
  let name: String
  /// The type of input controlling its appearance and validation behavior.
  let type: InputType?
  /// The initial value of the input element.
  let value: String?
  /// Hint text displayed when the field is empty.
  let placeholder: String?
  /// Whether the input should automatically receive focus when the page loads.
  let autofocus: Bool?
  /// Whether the input must be filled out before form submission.
  let required: Bool?
  /// Whether a checkbox input is initially checked.
  var checked: Bool?

  /// Creates a new HTML input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission, used as the field name when data is submitted.
  ///   - type: Input type determining appearance and validation behavior, optional.
  ///   - value: Initial value of the input, optional.
  ///   - placeholder: Hint text displayed when the field is empty, optional.
  ///   - autofocus: Automatically focuses the input on page load if true, optional.
  ///   - required: When true, the input must be filled before form submission, optional.
  ///   - checked: For checkbox inputs, indicates if initially checked, optional.
  ///   - id: Unique identifier for the HTML element, useful for labels and JavaScript.
  ///   - classes: An array of CSS classnames for styling the input.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element for screen readers.
  ///   - data: Dictionary of `data-*` attributes for storing custom data.
  ///   - on: String? = nil,
  ///
  /// - Example:
  ///   ```swift
  ///   // Text input for a username
  ///   Input(name: "username", type: .text, placeholder: "Enter your username", required: true)
  ///
  ///   // Password input with autofocus
  ///   Input(name: "password", type: .password, placeholder: "Your password", autofocus: true)
  ///
  ///   // Email input with validation
  ///   Input(name: "email", type: .email, placeholder: "your@email.com")
  ///
  ///   // Checkbox for accepting terms
  ///   Input(name: "accept_terms", type: .checkbox, checked: false)
  ///   ```
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
    label: String? = nil,
    data: [String: String]? = nil,
    on: String? = nil,
  ) {
    self.name = name
    self.type = type
    self.value = value
    self.placeholder = placeholder
    self.autofocus = autofocus
    self.required = required
    self.checked = checked
    let customAttributes = [
      Attribute.string("name", name),
      Attribute.typed("type", type),
      Attribute.string("value", value),
      Attribute.string("placeholder", placeholder),
      Attribute.bool("autofocus", autofocus),
      Attribute.bool("required", required),
      Attribute.bool("checked", checked),
    ].compactMap { $0 }
    super.init(
      tag: "input",
      id: id,
      classes: classes,
      role: role,
      label: label,
      data: data,
      isSelfClosing: true,
      customAttributes: customAttributes.isEmpty ? nil : customAttributes
    )
  }
}
