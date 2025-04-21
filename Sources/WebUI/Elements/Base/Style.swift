/// Generates an HTML style element.
///
/// Used to define CSS styles within the document.
public final class Style: Element {
  /// Creates a new style element.
  ///
  /// - Parameters:
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    @HTMLBuilder content: @escaping  () -> [any HTML] = { [] }
  ) {
    super.init(
      tag: "style", id: id, classes: classes, role: role, label: label,
      content: content)
  }
}
