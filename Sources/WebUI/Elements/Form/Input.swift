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

  /// Creates a new HTML input element.
  ///
  /// - Parameters:
  ///   - tag: HTML tag, defaults to "input".
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - name: Name for form submission.
  ///   - type: Input type, optional.
  ///   - value: Initial value, optional.
  ///   - placeholder: Hint text when empty, optional.
  ///   - autofocus: Focuses on page load if true, optional.
  init(
    tag: String = "input",
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    name: String,
    type: InputType? = nil,
    value: String? = nil,
    placeholder: String? = nil,
    autofocus: Bool? = nil
  ) {
    self.name = name
    self.type = type
    self.value = value
    self.placeholder = placeholder
    self.autofocus = autofocus
    super.init(tag: tag, id: id, classes: classes, role: role)
  }

  /// Renders the input as an HTML string.
  ///
  /// - Returns: Complete self-closing `<input>` tag string.
  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("name", name),
      attribute("type", type?.rawValue),
      attribute("value", value),
      attribute("placeholder", placeholder),
      booleanAttribute("autofocus", autofocus),
    ]
    .compactMap { $0 }
    .joined(separator: " ")
    return "<\(tag) \(attributes)>"
  }
}
