/// Generates an HTML label element.
///
/// Associates descriptive text with a form field for accessibility.
public final class Label: Element {
  let `for`: String

  /// Creates a new HTML label element.
  ///
  /// - Parameters:
  ///   - for: ID of the associated input element.
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - content: Closure providing label content, defaults to empty.
  public init(
    `for`: String,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    self.for = `for`
    super.init(
      tag: "label", id: id, classes: classes, role: role, label: label,
      content: content)
  }

  /// Provides label-specific attributes.
  public override func additionalAttributes() -> [String] {
    [
      attribute("for", `for`)
    ]
    .compactMap { $0 }
  }
}
