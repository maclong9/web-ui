/// Generates an HTML style element for defining inline CSS styles.
///
/// The `Style` element allows embedding CSS directly in an HTML document rather than
/// loading it from an external stylesheet. This can be useful for component-specific
/// styles or critical styling that needs to be applied immediately.
///
/// - Note: For larger applications, consider using external stylesheets for better
///   caching and separation of concerns.
///
/// ## Example
/// ```swift
/// Style {
///   """
///   .custom-heading {
///     color: blue;
///     font-size: 24px;
///     margin-bottom: 16px;
///   }
///   """
/// }
/// // Renders: <style>.custom-heading { color: blue; font-size: 24px; margin-bottom: 16px; }</style>
/// ```
public final class Style: Element {
  /// Creates a new HTML style element.
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames for the style element itself.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element for screen readers.
  ///   - data: Dictionary of `data-*` attributes for storing custom data.
  ///   - content: Closure providing the CSS content as strings.
  ///
  /// ## Example
  /// ```swift
  /// Style(id: "theme-styles") {
  ///   "body { background-color: #f5f5f5; }"
  ///   "header { font-weight: bold; }"
  /// }
  /// ```
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(
      tag: "style", id: id, classes: classes, role: role, label: label, data: data, content: content
    )
  }
}
