/// Generates an HTML select element (`<select>`).
///
/// `Select` creates a dropdown selection input that allows users to choose
/// from a list of options. It should contain `Option` elements as children.
///
/// ## Example
/// ```swift
/// Select(name: "country", required: true) {
///   Option(value: "", disabled: true) { "Choose a country" }
///   Option(value: "us") { "United States" }
///   Option(value: "ca") { "Canada" }
/// }
/// // Renders: <select name="country" required><option value="" disabled>Choose a country</option>...</select>
/// ```
public struct Select: Element {
  private let name: String
  private let required: Bool?
  private let disabled: Bool?
  private let multiple: Bool?
  private let size: Int?
  private let id: String?
  private let classes: [String]?
  private let role: AriaRole?
  private let label: String?
  private let data: [String: String]?
  private let contentBuilder: MarkupContentBuilder

  /// Creates a new HTML select element.
  ///
  /// - Parameters:
  ///   - name: The name attribute for form submission.
  ///   - required: Whether the select is required for form submission.
  ///   - disabled: Whether the select is disabled.
  ///   - multiple: Whether multiple selections are allowed.
  ///   - size: Number of visible options (for multiple selects).
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of stylesheet classnames for styling the select.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element for screen readers.
  ///   - data: Dictionary of `data-*` attributes for storing custom data.
  ///   - content: Closure providing the select's options (typically `Option` elements).
  public init(
    name: String,
    required: Bool? = nil,
    disabled: Bool? = nil,
    multiple: Bool? = nil,
    size: Int? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @MarkupBuilder content: @escaping MarkupContentBuilder
  ) {
    self.name = name
    self.required = required
    self.disabled = disabled
    self.multiple = multiple
    self.size = size
    self.id = id
    self.classes = classes
    self.role = role
    self.label = label
    self.data = data
    self.contentBuilder = content
  }

  public var body: MarkupString {
    var attributes: [String] = []

    attributes.append("name=\"\(name)\"")

    if let required = required, required {
      attributes.append("required")
    }

    if let disabled = disabled, disabled {
      attributes.append("disabled")
    }

    if let multiple = multiple, multiple {
      attributes.append("multiple")
    }

    if let size = size {
      attributes.append("size=\"\(size)\"")
    }

    if let id = id {
      attributes.append("id=\"\(id)\"")
    }

    if let classes = classes, !classes.isEmpty {
      attributes.append("class=\"\(classes.joined(separator: " "))\"")
    }

    if let role = role {
      attributes.append("role=\"\(role.rawValue)\"")
    }

    if let label = label {
      attributes.append("aria-label=\"\(label)\"")
    }

    if let data = data {
      for (key, value) in data {
        attributes.append("data-\(key)=\"\(value)\"")
      }
    }

    let attributeString = attributes.isEmpty ? "" : " " + attributes.joined(separator: " ")
    let content = contentBuilder().map { $0.render() }.joined()

    return MarkupString(content: "<select\(attributeString)>\(content)</select>")
  }
}
