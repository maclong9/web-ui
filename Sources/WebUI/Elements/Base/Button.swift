/// Represents the type of a button element.
public enum ButtonType: String {
  /// Indicates a button that submits form data
  case submit
  /// Indicates a button that resets form data
  case reset
}

/// Creates HTML button elements.
/// This renders a `<button>` tag, which is used to create a clickable button that can be used to trigger an action or submit a form.
public class Button: Element { 
  let type: ButtonType?
  let autofocus: Bool?

  /// Creates a new HTML button element.
  ///
  /// - Parameters:
  ///   - type: The kind of button to render, for example submit for triggering a form submit action
  ///   - autofocus: Whether or not the button should be automatically focused on page load
  ///
  /// - SeeAlso: ``Element``
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    type: ButtonType? = nil,
    autofocus: Bool? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    self.type = type
    self.autofocus = autofocus
    super.init(tag: "button", id: id, classes: classes, role: role, content: content)
  }

  /// Generates the HTML string for this button element.
  /// This combines the button tag with any ID, classes, role, type, and autofocus as attributes, then adds the rendered content inside the opening and closing tags, producing a complete HTML snippet like "<button type=\"submit\" autofocus>Submit</button>".
  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("type", type?.rawValue),
      attribute("role", role?.rawValue),
      booleanAttribute("autofocus", autofocus),
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let attributesString = attributes.isEmpty ? "" : " \(attributes)"
    let contentString = content.map { $0.render() }.joined()
    return "<\(tag)\(attributesString)>\(contentString)</\(tag)>"
  }
}
