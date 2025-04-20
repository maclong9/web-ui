/// Generates an HTML textarea element.
///
/// Provides a multi-line text input for long-form content.
public final class TextArea: Element {
  let name: String
  let type: InputType?
  let value: String?
  let placeholder: String?
  let autofocus: Bool?
  let required: Bool?

  /// Creates a new HTML textarea element.
  ///
  /// - Parameters:
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - name: Name for form submission.
  ///   - type: Input type, optional.
  ///   - value: Initial value, optional.
  ///   - placeholder: Hint text when empty, optional.
  ///   - autofocus: Focuses on page load if true, optional.
  public init(
    name: String,
    type: InputType? = nil,
    value: String? = nil,
    placeholder: String? = nil,
    autofocus: Bool? = nil,
    required: Bool? = nil,
    config: ElementConfig = .init(),
  ) {
    self.name = name
    self.type = type
    self.value = value
    self.placeholder = placeholder
    self.autofocus = autofocus
    self.required = required

    super.init(
      tag: "textarea",
      config: config,
    )
  }

  /// Provides textarea-specific attributes.
  public override func additionalAttributes() -> [String] {
    [
      attribute("name", name),
      attribute("type", type?.rawValue),
      attribute("value", value),
      attribute("placeholder", placeholder),
      booleanAttribute("autofocus", autofocus),
      booleanAttribute("required", required),
    ]
    .compactMap { $0 }
  }
}
