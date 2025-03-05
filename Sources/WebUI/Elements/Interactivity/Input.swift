/// Represents the type of an input element.
public enum InputType: String {
  /// Represents a single-line text input field
  case text
  /// Represents a masked password input field
  case password
  /// Represents an email address input field
  case email
  /// Represents a numeric input field
  case number
  /// Represents a submit button input
  case submit
}

/// Creates HTML input elements.
/// This renders an `<input>` tag, which is used to collect user input, such as text, numbers, or form submissions.
public class Input: Element {

  let type: InputType?
  let value: String?
  let placeholder: String?
  let autofocus: Bool?

  /// Sets up a new HTML input element.
  ///
  /// This prepares an input field with options for its type, initial value, placeholder text, and focus behavior.
  /// - Parameters:
  ///   - type: The kind of input, like "text" or "email", to define what data it accepts.
  ///   - value: An optional starting value, like "user@example.com", shown in the input when it loads.
  ///   - placeholder: An optional hint, like "Enter your email", displayed when the input is empty.
  ///   - autofocus: Whether the input should be automatically focused when the page loads.
  init(
    tag: String = "input",
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    type: InputType? = nil,
    value: String? = nil,
    placeholder: String? = nil,
    autofocus: Bool? = nil
  ) {
    self.type = type
    self.value = value
    self.placeholder = placeholder
    self.autofocus = autofocus
    super.init(tag: tag, id: id, classes: classes, role: role)
  }

  /// Generates the HTML string for this input element.
  /// This combines the input tag with any ID, classes, role, type, value, placeholder, and autofocus as attributes, producing a self-closing HTML snippet like "<input type=\"text\" placeholder=\"Name\" autofocus>".
  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("type", type?.rawValue),
      attribute("value", value),
      attribute("placeholder", placeholder),
      booleanAttribute("autofocus", autofocus)
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let attributesString = attributes.isEmpty ? "" : " \(attributes)"
    return "<\(tag)\(attributesString)>"
  }
}
