/// Represents the HTTP method for form submission.
public enum FormMethod: String {
  /// Represents an HTTP GET request method
  case get
  /// Represents an HTTP POST request method
  case post
}

/// Creates an HTML form element.
/// This renders a `<form>` tag, which is a block-level container used to group input elements (like text fields, checkboxes, or buttons) for collecting user data, typically for submission to a server.
///
/// The `<form>` tag is semantically meaningful as it defines a section of the document intended for user interaction and data submission. It can include attributes such as:
/// - `action`: The URL where the form data is sent.
/// - `method`: The HTTP method for submission, typically "get" or "post".
/// - `enctype`: The encoding type for form data, used when the method is "post".
public class Form: Element {
  /// Represents the encoding type for form data submission.
  public enum EncodingType: String {
    case applicationXWWWFormUrlencoded = "application/x-www-form-urlencoded"
    case multipartFormData = "multipart/form-data"
    case textPlain = "text/plain"
  }

  let action: String
  let method: FormMethod
  let enctype: EncodingType?

  /// Creates a new HTML form element.
  ///
  /// - Parameters:
  ///   - action: The URL where the form data will be submitted
  ///   - method: The HTTP method to use for submission, either "get" (data in URL) or "post" (data in request body).
  ///   - enctype: An optional encoding type for form data, required for file uploads with "multipart/form-data".
  ///
  /// - SeeAlso: ``Element``
  init(
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

  /// Generates the HTML string for this form element.
  /// This combines the form tag with attributes like action, method, id, classes, role, and enctype, then includes the rendered content inside the opening and closing tags.
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
