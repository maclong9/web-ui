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
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - type: Button type, optional.
  ///   - autofocus: Enables autofocus on load, optional.
  ///   - content: Closure providing button content, defaults to empty.
  public init(
    config: ElementConfig = .init(),
    type: ButtonType? = nil,
    autofocus: Bool? = nil,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    self.type = type
    self.autofocus = autofocus
    super.init(tag: "button", config: config, content: content)
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
