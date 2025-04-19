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
  /// Submit button input.
  case submit
}

/// Generates an HTML input element.
///
/// Collects user input like text or numbers.
public class Input: Element {
  let name: String
  let type: InputType?
  let value: String?
  let placeholder: String?
  let autofocus: Bool?
  let required: Bool?

  /// Creates a new HTML input element.
  ///
  /// - Parameters:
  ///   - tag: HTML tag, defaults to "input".
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
    super.init(tag: "input", config: config, isSelfClosing: true)
  }

  /// Provides input-specific attributes.
  public override func additionalAttributes() -> [String] {
    [
      attribute("name", name),
      attribute("type", type?.rawValue),
      attribute("value", value),
      attribute("placeholder", placeholder),
      booleanAttribute("autofocus", autofocus),
      booleanAttribute("required", required)
    ]
    .compactMap { $0 }
  }
}
