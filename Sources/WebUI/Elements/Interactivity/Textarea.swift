final public class Textarea: Input {
  /// Sets up a new HTML textarea element.
  ///
  /// This prepares an input field with options for its type, initial value, placeholder text, and focus behavior.
  /// This input type is used for longform text over the standard input of type text
  /// - Parameters:
  ///   - type: The kind of input, like "text" or "email", to define what data it accepts.
  ///   - value: An optional starting value, like "user@example.com", shown in the input when it loads.
  ///   - placeholder: An optional hint, like "Enter your email", displayed when the input is empty.
  ///   - autofocus: Whether the input should be automatically focused when the page loads.
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    type: InputType? = nil,
    value: String? = nil,
    placeholder: String? = nil,
    autofocus: Bool? = nil
  ) {
    super.init(
      tag: "textarea", id: id, classes: classes, role: role, type: type, value: value, placeholder: placeholder,
      autofocus: autofocus)
  }

  /// Generates the HTML string for this textarea element.
  /// This combines the textarea tag with any ID, classes, role, type, value, placeholder, and autofocus as attributes, producing an HTML snippet
  public override func render() -> String {
    let attributes = [
      id.map { "id=\"\($0)\"" },
      classes?.isEmpty == false ? "class=\"\(classes!.joined(separator: " "))\"" : nil,
      role.map { "role=\"\($0.rawValue)\"" },
      placeholder.map { "placeholder=\"\($0)\"" },
      autofocus == true ? "autofocus" : nil,
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let attributesString = attributes.isEmpty ? "" : " \(attributes)"
    return "<\(tag)\(attributesString)>\(value ?? "")</\(tag)>"
  }
}
