/// Defines types of HTML button elements.
///
/// Specifies the purpose and behavior of buttons within forms.
public enum ButtonType: String {
  /// Submits the form data to the server.
  case submit

  /// Resets all form controls to their initial values.
  case reset
}

/// Creates HTML button elements.
///
/// Represents a clickable element that triggers an action or event when pressed.
/// Buttons are fundamental interactive elements in forms and user interfaces.
public final class Button: Element {
  let type: ButtonType?
  let autofocus: Bool?

  /// Creates a new HTML button.
  ///
  /// - Parameters:
  ///   - type: Button type (submit or reset), optional. If nil, the button will be a standard button without a specific form role.
  ///   - autofocus: When true, automatically focuses the button when the page loads, optional.
  ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
  ///   - classes: An array of CSS classnames for styling the button.
  ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
  ///   - label: ARIA label to describe the element for accessibility when button text isn't sufficient.
  ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the button.
  ///   - content: Closure providing button content (text or other HTML elements), defaults to empty.
  ///
  /// - Example:
  ///   ```swift
  ///   Button(type: .submit, id: "save-button") {
  ///     "Save Changes"
  ///   }
  ///   .background(color: .blue(.600))
  ///   .padding(.all, length: 2)
  ///   ```
  public init(
    type: ButtonType? = nil,
    autofocus: Bool? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    self.type = type
    self.autofocus = autofocus
    var customAttributes: [String] = []
    if let typeValue = type?.rawValue, !typeValue.isEmpty {
      customAttributes.append("type=\"\(typeValue)\"")
    }
    if autofocus == true {
      customAttributes.append("autofocus")
    }
    super.init(
      tag: "button",
      id: id,
      classes: classes,
      role: role,
      label: label,
      data: data,
      customAttributes: customAttributes.isEmpty ? nil : customAttributes,
      content: content
    )
  }
}
