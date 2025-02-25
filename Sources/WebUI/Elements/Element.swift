/// A base class representing an HTML element with a tag name, optional attributes, and nested content.
///
/// This class serves as the foundation for all HTML elements in the DSL.
class Element: HTML {
  var tag: String
  var id: String?
  var classes: [String]?
  private let contentBuilder: () -> [any HTML]

  /// The computed property that evaluates the content builder to get the nested HTML components.
  var content: [any HTML] {
    get { contentBuilder() }
  }

  /// Creates a new HTML element with the specified tag, attributes, and content.
  /// - Parameters:
  ///   - tag: The HTML tag name for this element.
  ///   - id: An optional ID attribute for the element.
  ///   - classes: Optional CSS classes to apply to the element.
  ///   - content: A result builder closure that defines the nested content.
  /// - Note: The content is captured as a closure and only evaluated when rendering.
  init(tag: String, id: String? = nil, classes: [String]? = nil, @HTMLBuilder content: @escaping () -> [any HTML]) {
    self.tag = tag
    self.id = id
    self.classes = classes
    self.contentBuilder = content
  }

  /// Constructs attributes  and renders the element and its content as an HTML string.
  /// - Returns: A string containing the complete HTML representation of this element and its content.
  func render() -> String {
    let classAttribute = classes?.isEmpty == false ? " class=\"\(classes!.joined(separator: " "))\"" : ""
    let idAttribute = id?.isEmpty == false ? " id=\"\(id!)\"" : ""
    let renderedContent = content.map { $0.render() }.joined()
    return "<\(tag)\(idAttribute)\(classAttribute)>\(renderedContent)</\(tag)>"
  }
}
