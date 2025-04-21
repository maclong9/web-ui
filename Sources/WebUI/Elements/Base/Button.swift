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
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - type: Button type, optional.
  ///   - autofocus: Enables autofocus on load, optional.
  ///   - content: Closure providing button content, defaults to empty.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    type: ButtonType? = nil,
    autofocus: Bool? = nil,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    self.type = type
    self.autofocus = autofocus
    super.init(tag: "button", id: id, classes: classes, role: role, label: label, content: content)
  }

  /// Provides button-specific attributes.
  public override func additionalAttributes() -> [String] {
    [
      attribute("type", type?.rawValue),
      booleanAttribute("autofocus", autofocus),
    ]
    .compactMap { $0 }
  }
}
