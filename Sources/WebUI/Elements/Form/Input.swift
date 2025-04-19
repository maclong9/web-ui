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
public class Input: Element {
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
    name: String,
    type: InputType? = nil,
    value: String? = nil,
    placeholder: String? = nil,
    autofocus: Bool? = nil,
    required: Bool? = nil,
    checked: Bool? = nil,
    config: ElementConfig = .init()
  ) {
    self.name = name
    self.type = type
    self.value = value
    self.placeholder = placeholder
    self.autofocus = autofocus
    self.required = required
    self.checked = nil  // checked is not supported in this initializer
    super.init(tag: "input", config: config, isSelfClosing: true)
  }

  /// Creates a checkbox input element.
  ///
  /// - Parameters:
  ///   - name: Name for form submission.
  ///   - checked: Indicates if the checkbox is checked, optional.
  ///   - config: Configuration for element attributes, defaults to empty.
  /// - Returns: An `Input` element with type set to `checkbox`.
  public static func checkbox(
    name: String,
    checked: Bool? = nil,
    config: ElementConfig = .init()
  ) -> Input {
    var input = Input(
      name: name,
      type: .checkbox,
      config: config
    )
    input.checked = checked
    return input
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
