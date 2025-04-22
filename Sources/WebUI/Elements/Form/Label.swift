/// Generates an HTML label element.
///
/// Associates descriptive text with a form field for accessibility.
public final class Label: Element {
  let `for`: String

  /// Creates a new HTML label element.
  ///
  /// - Parameters:
  ///   - for: ID of the associated input element.
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  ///   - content: Closure providing label content, defaults to empty.
  public init(
    `for`: String,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    self.for = `for`
    var customAttributes: [String] = []
    if !`for`.isEmpty {
      customAttributes.append("for=\"\(`for`)\"")
    }
    super.init(
      tag: "label",
      id: id,
      classes: classes,
      role: role,
      label: label,
      customAttributes: customAttributes.isEmpty ? nil : customAttributes,
      content: content
    )
  }
}
