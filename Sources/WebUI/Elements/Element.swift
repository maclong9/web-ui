/// A base class representing an HTML element with a tag name, optional attributes, styling possibility and nested content.
public class Element: HTML {
  let tag: String
  let id: String?
  let classes: [String]?
  let role: AriaRole?
  private let contentBuilder: () -> [any HTML]

  /// The computed property that evaluates the content builder to get the nested HTML components.
  var content: [any HTML] {
    contentBuilder()
  }

  /// Creates a new HTML element with the specified tag, attributes, and content.
  /// - Parameters:
  ///   - tag: The HTML tag name for this element.
  ///   - id: An optional ID attribute for the element.
  ///   - classes: Optional CSS classes to apply to the element.
  ///   - role: Optional AriaRole for accessibility.
  ///   - content: A result builder closure that defines the nested content.
  /// - Note: The content is captured as a closure and only evaluated when rendering.
  init(
    tag: String,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    self.tag = tag
    self.id = id
    self.classes = classes
    self.role = role
    self.contentBuilder = content
  }

  /// Constructs attributes and renders the element and its content as an HTML string.
  /// - Returns: A string containing the complete HTML representation of this element and its content.
  func render() -> String {
    let attributes = [
      id.map { "id=\"\($0)\"" },
      classes?.isEmpty == false ? "class=\"\(classes!.joined(separator: " "))\"" : nil,
      role.map { "role=\"\($0)\"" },
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let attributesString = attributes.isEmpty ? "" : " \(attributes)"
    let contentString = content.map { $0.render() }.joined()
    return "<\(tag)\(attributesString)>\(contentString)</\(tag)>"
  }
}
