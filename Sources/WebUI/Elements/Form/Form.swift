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
  ///   - action: URL for form data submission.
  ///   - method: HTTP method for submission, defaults to `.post`.
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - enctype: Encoding type for form data, optional.
  ///   - content: Closure providing form content.
  public init(
    action: String? = nil,
    method: FormMethod = .post,
    config: ElementConfig = .init(),
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    self.action = action
    self.method = method
    super.init(tag: "form", config: config, content: content)
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
