/// Defines HTTP methods for form submission.
public enum FormMethod: String {
  /// HTTP GET request method.
  case get
  /// HTTP POST request method.
  case post
}

/// Generates an HTML form element.
///
/// Represents a container for collecting user input, typically submitted to a server.
public final class Form: Element {
  let action: String?
  let method: FormMethod

  /// Creates a new HTML form element.
  ///
  /// - Parameters:
  ///   - action: Optional URL for form data submission.
  ///   - method: HTTP method for submission, defaults to `.post`.
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - content: Closure providing form content.
  public init(
    action: String? = nil,
    method: FormMethod = .post,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    @HTMLBuilder content: @escaping  () -> [any HTML] = { [] }
  ) {
    self.action = action
    self.method = method
    super.init(
      tag: "form", id: id, classes: classes, role: role, label: label,
      content: content)
  }

  /// Provides form-specific attributes.
  public override func additionalAttributes() -> [String] {
    [
      attribute("action", action),
      attribute("method", method.rawValue),
    ]
    .compactMap { $0 }
  }
}
