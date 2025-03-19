/// Generates an HTML label element.
///
/// Associates descriptive text with a form field for accessibility.
public class Label: Element {
  let `for`: String

  /// Creates a new HTML label element.
  ///
  /// - Parameters:
  ///   - tag: HTML tag, defaults to "label".
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - for: ID of the associated input element.
  ///   - content: Closure providing label content, defaults to empty.
  init(
    tag: String = "label",
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    `for`: String,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    self.for = `for`
    super.init(tag: tag, id: id, classes: classes, role: role, content: content)
  }

  /// Renders the label as an HTML string.
  ///
  /// - Returns: Complete `<label>` tag string with attributes and content.
  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("for", `for`),
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let contentString = content.map { $0.render() }.joined()
    return "<\(tag) \(attributes)>\(contentString)</\(tag)>"
  }
}
