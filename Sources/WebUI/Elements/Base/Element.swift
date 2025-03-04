/// A base for creating any HTML element.
/// Can render any HTML tag specified by the `tag` property.
/// The semantic purpose of the HTML tag rendered depends on the specific tag name provided.
public class Element: HTML {
  let tag: String
  let id: String?
  let classes: [String]?
  let role: AriaRole?
  let contentBuilder: () -> [any HTML]?

  var content: [any HTML] {
    contentBuilder() ?? { [] }()
  }

  /// Sets up a new HTML element with specific properties and content.
  ///
  /// - Parameters:
  ///   - tag: The name of the HTML tag, such as "div" or "p", that defines what kind of element this is.
  ///   - id: An optional unique identifier for the element, like "main-section", used to reference it elsewhere.
  ///   - classes: Optional styling names, like "button" or "hidden", to control how the element looks.
  ///   - role: An optional accessibility label, like "button" or "navigation", to help screen readers understand the element’s purpose.
  ///   - content: A builder that provides the inner HTML content, such as text or other elements, to go inside the tag.
  init(
    tag: String,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]? = { [] }
  ) {
    self.tag = tag
    self.id = id
    self.classes = classes
    self.role = role
    self.contentBuilder = content
  }

  /// Generates the HTML string for this element.
  /// This combines the tag name with any ID, classes, or role as attributes, then adds the rendered content inside the
  /// opening and closing tags, producing a complete HTML snippet like "<div id=\"example\">content</div>".
  public func render() -> String {
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
