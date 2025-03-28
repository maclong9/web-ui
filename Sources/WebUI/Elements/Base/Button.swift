/// Defines types of HTML button elements.
public enum ButtonType: String, Sendable {
  case submit, reset
}

/// Creates HTML button elements.
///
/// Represents a clickable element that triggers an action or event.
public final class Button: Element {
  let type: ButtonType?
  let autofocus: Bool?

  /// Creates a new HTML button.
  ///
  /// - Parameters:
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - type: Button type, optional.
  ///   - autofocus: Enables autofocus on load, optional.
  ///   - content: Closure providing button content, defaults to empty.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    type: ButtonType? = nil,
    autofocus: Bool? = nil,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    self.type = type
    self.autofocus = autofocus
    super.init(tag: "button", id: id, classes: classes, role: role, content: content)
  }

  /// Renders the button as an HTML string.
  ///
  /// - Returns: Complete HTML button string with attributes and content.
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
