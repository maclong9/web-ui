import Foundation

/// Creates HTML abbreviation elements for displaying abbreviations or acronyms.
///
/// Represents the full form of an abbreviation or acronym, enhancing accessibility and usability.
/// Abbreviation elements provide a visual indication to users (typically shown with a dotted underline)
/// and display the full term as a tooltip when users hover over them. This improves content comprehension
/// and assists screen reader users.
///
/// ## Example
/// ```swift
/// Abbreviation(title: "Hypertext Markup Language") { "HTML" }
/// // Renders: <abbr title="Hypertext Markup Language">HTML</abbr>
/// ```
public struct Abbreviation: Element {
  private let fullTitle: String
  private let id: String?
  private let classes: [String]?
  private let role: AriaRole?
  private let label: String?
  private let data: [String: String]?
  private let contentBuilder: MarkupContentBuilder

  /// Creates a new HTML abbreviation element.
  ///
  /// - Parameters:
  ///   - title: The full term or explanation of the abbreviation.
  ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
  ///   - classes: An array of stylesheet classnames for styling the abbreviation.
  ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
  ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
  ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the abbreviation.
  ///   - content: Closure providing the content (typically the abbreviated term).
  ///
  /// ## Example
  /// ```swift
  /// Abbreviation(
  ///   title: "World Health Organization",
  ///   classes: ["term"]
  /// ) {
  ///   "WHO"
  /// }
  /// ```
  public init(
    title: String,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @MarkupBuilder content: @escaping MarkupContentBuilder = { [] }
  ) {
    self.fullTitle = title
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
    var additional: [String] = []
    if let titleAttr = Attribute.string("title", fullTitle) {
      additional.append(titleAttr)
    }
    let attributes = AttributeBuilder.buildAttributes(
      id: id,
      classes: classes,
      role: role,
      label: label,
      data: data,
      additional: additional
    )
    let content = contentBuilder().map { $0.render() }.joined()
    return AttributeBuilder.buildMarkupTag(
      "abbr", attributes: attributes, content: content)
  }
}
