/// Generates HTML list elements (`<ul>` or `<ol>`).
///
/// `List` can be rendered as an unordered list with bullet points when sequence is unimportant,
/// or as an ordered list with numbered markings when sequence matters.
///
/// - Note: Use `Item` elements as children of a `List` to create list items.
///
/// ## Example
/// ```swift
/// List(type: .ordered) {
///   Item { "First item" }
///   Item { "Second item" }
///   Item { "Third item" }
/// }
/// // Renders: <ol><li>First item</li><li>Second item</li><li>Third item</li></ol>
/// ```
public struct List: Element {
  private let type: ListType
  private let style: ListStyle
  private let id: String?
  private let classes: [String]?
  private let role: AriaRole?
  private let label: String?
  private let data: [String: String]?
  private let contentBuilder: MarkupContentBuilder

  /// Creates a new HTML list element (`<ul>` or `<ol>`).
  ///
  /// - Parameters:
  ///   - type: List type (ordered or unordered), defaults to unordered.
  ///   - style: List style (disc, circle, or square), defaults to none.
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of stylesheet classnames for styling the list.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element for screen readers.
  ///   - data: Dictionary of `data-*` attributes for storing custom data.
  ///   - content: Closure providing list items, typically `Item` elements.
  ///
  /// ## Example
  /// ```swift
  /// List(type: .unordered, classes: ["checklist"]) {
  ///   Item { "Buy groceries" }
  ///   Item { "Clean house" }
  /// }
  /// ```
  public init(
    type: ListType = .unordered,
    style: ListStyle = .none,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @MarkupBuilder content: @escaping MarkupContentBuilder = { [] }
  ) {
    self.type = type
    self.style = style
    self.id = id
    self.classes = classes
    self.role = role
    self.label = label
    self.data = data
    self.contentBuilder = content
  }

  public var body: some Markup {
    MarkupString(content: buildMarkupTag())
  }

  private func buildMarkupTag() -> String {
    let combinedClasses =
      (classes ?? []) + (style != .none ? ["list-\(style.rawValue)"] : [])

    let attributes = AttributeBuilder.buildAttributes(
      id: id,
      classes: combinedClasses,
      role: role,
      label: label,
      data: data
    )

    let content = contentBuilder().map { $0.render() }.joined()

    return AttributeBuilder.buildMarkupTag(
      type.rawValue, attributes: attributes, content: content)
  }
}
