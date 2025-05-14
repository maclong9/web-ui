/// Generates an HTML label element for form controls.
///
/// Associates descriptive text with a form field for accessibility and usability.
/// Labels improve form usability by:
/// - Providing clear descriptions for input fields
/// - Creating larger clickable areas for checkboxes and radio buttons
/// - Improving screen reader accessibility
///
/// - Example:
///   ```swift
///   Label(for: "email") {
///     "Email Address:"
///   }
///   // Renders: <label for="email">Email Address:</label>
///   ```
public final class Label: Element {
  let `for`: String

  /// Creates a new HTML label element associated with a form control.
  ///
  /// - Parameters:
  ///   - for: ID of the associated input element. This creates a programmatic connection between the label and the form control.
  ///   - id: Unique identifier for the HTML element itself.
  ///   - classes: An array of CSS classnames for styling the label.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element for screen readers.
  ///   - data: Dictionary of `data-*` attributes for storing custom data related to the label.
  ///   - content: Closure providing label text content, defaults to empty.
  ///
  /// - Example:
  ///   ```swift
  ///   Label(for: "terms", classes: ["checkbox-label"]) {
  ///     "I agree to the terms and conditions"
  ///   }
  ///   ```
  public init(
    `for`: String,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
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
      data: data,
      customAttributes: customAttributes.isEmpty ? nil : customAttributes,
      content: content
    )
  }
}
