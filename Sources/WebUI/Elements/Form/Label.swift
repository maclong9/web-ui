/// Creates HTML label element for a form field
public class Label: Element {
  let `for`: String

  /// Creates a new HTML input element.
  /// - Parameter for: The input element that the label is describing
  ///
  /// - SeeAlso: ``Element``
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

  /// Generates the HTML string for this input element.
  /// This combines the input tag with any ID, classes, role, type, value, placeholder, and autofocus as attributes, producing a self-closing HTML snippet
  public override func render() -> String {
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("for", `for`),
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let attributesString = attributes.isEmpty ? "" : " \(attributes)"
    let contentString = content.map { $0.render() }.joined()
    return "<\(tag)\(attributesString)>\(contentString)</\(tag)>"
  }
}
