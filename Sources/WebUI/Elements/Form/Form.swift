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
public class Form: Element {
  /// Defines encoding types for form data submission.
  public enum EncodingType: String {
    /// Default. All characters are encoded before sent (spaces are converted to "+" symbols, and special characters are converted to ASCII HEX values)
    case applicationXWWWFormUrlencoded = "application/x-www-form-urlencoded"
    /// This value is necessary if the user will upload a file through the form
    case multipartFormData = "multipart/form-data"
    /// Sends data without any encoding at all. Not recommended
    case textPlain = "text/plain"
  }

  let action: String
  let method: FormMethod
  let enctype: EncodingType?

  /// Creates a new HTML form element.
  ///
  /// - Parameters:
  ///   - action: URL for form data submission.
  ///   - method: HTTP method for submission, defaults to `.post`.
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - enctype: Encoding type for form data, optional.
  ///   - content: Closure providing form content.
  public init(
    action: String,
    method: FormMethod = .post,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    enctype: EncodingType? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    self.action = action
    self.method = method
    self.enctype = enctype
    super.init(tag: "form", id: id, classes: classes, role: role, content: content)
  }

  /// Renders the form as an HTML string.
  ///
  /// - Returns: Complete `<form>` tag string with attributes and content.
  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("action", action),
      attribute("method", method.rawValue),
      attribute("enctype", enctype?.rawValue),
      attribute("role", role?.rawValue),
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let contentString = content.map { $0.render() }.joined()
    return "<\(tag) \(attributes)>\(contentString)</\(tag)>"
  }
}
