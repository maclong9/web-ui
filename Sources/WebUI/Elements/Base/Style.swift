/// Generates an HTML style element.
///
/// Used to define CSS styles within the document.
public final class Style: Element {
  /// Creates a new style element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "style", id: id, classes: classes, role: role, label: label, content: content)
  }
}
