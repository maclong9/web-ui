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
  private let name: String
  private let type: InputType?
  private let value: String?
  private let placeholder: String?
  private let autofocus: Bool?
  private let required: Bool?
  private var checked: Bool?

  /// Creates a new HTML input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission.
  ///   - type: Input type, optional.
  ///   - value: Initial value, optional.
  ///   - placeholder: Hint text displayed when the field is empty, optional.
  ///   - autofocus: Automatically focuses the input on page load if true, optional.
  ///   - required: Indicates the input is required for form submission, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    name: String,
    type: InputType? = nil,
    value: String? = nil,
    placeholder: String? = nil,
    autofocus: Bool? = nil,
    required: Bool? = nil,
    checked: Bool? = nil,
  ) {
    self.name = name
    self.type = type
    self.value = value
    self.placeholder = placeholder
    self.autofocus = autofocus
    self.required = required
    self.checked = checked
    super.init(tag: "input", id: id, classes: classes, role: role, label: label, isSelfClosing: true)
  }

  /// Provides input-specific attributes for the HTML element.
  public override func additionalAttributes() -> [String] {
    [
      attribute("name", name),
      attribute("type", type?.rawValue),
      attribute("value", value),
      attribute("placeholder", placeholder),
      booleanAttribute("autofocus", autofocus),
      booleanAttribute("required", required),
      booleanAttribute("checked", checked),
    ].compactMap { $0 }
  }
}
