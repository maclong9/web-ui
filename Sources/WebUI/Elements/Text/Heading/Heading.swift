import Foundation

/// Creates HTML heading elements from `<h1>` to `<h6>`.
///
/// Represents section headings of different levels, with `<h1>` being the highest (most important)
/// and `<h6>` the lowest. Headings provide document structure and are essential for accessibility,
/// SEO, and reader comprehension.
public struct Heading: Element {
  private let level: HeadingLevel
  private let id: String?
  private let classes: [String]?
  private let role: AriaRole?
  private let label: String?
  private let data: [String: String]?
  private let contentBuilder: MarkupContentBuilder

  /// Creates a new HTML heading element with string title.
  ///
  /// This is the preferred SwiftUI-like initializer for creating headings with text content.
  ///
  /// - Parameters:
  ///   - level: Heading level (.largeTitle, .title, .headline, .subheadline, .body, or .footnote).
  ///   - title: The heading text content.
  ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
  ///   - classes: An array of stylesheet classnames for styling the heading.
  ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
  ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
  ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the heading.
  ///
  /// ## Example
  /// ```swift
  /// Heading(.title, "Section Title")
  /// Heading(.largeTitle, "Main Page Title", id: "main-heading")
  /// Heading(.headline, "Article Headline", classes: ["article-title"])
  /// ```
  public init(
    _ level: HeadingLevel,
    _ title: String,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil
  ) {
    self.level = level
    self.id = id
    self.classes = classes
    self.role = role
    self.label = label
    self.data = data
    self.contentBuilder = { [title] }
  }

  /// Creates a new HTML heading element using HTMLBuilder closure syntax.
  ///
  /// - Parameters:
  ///   - level: Heading level (.largeTitle, .title, .headline, .subheadline, .body, or .footnote).
  ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
  ///   - classes: An array of stylesheet classnames for styling the heading.
  ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
  ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
  ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the heading.
  ///   - content: Closure providing heading content.
  ///
  /// ## Example
  /// ```swift
  /// Heading(.title) {
  ///   "Section Title"
  /// }
  /// ```
  @available(
    *, deprecated,
    message:
      "Use Heading(_:_:) string initializer instead for better SwiftUI compatibility. Example: Heading(.title, \"Section Title\")"
  )
  public init(
    _ level: HeadingLevel,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @MarkupBuilder content: @escaping MarkupContentBuilder = { [] }
  ) {
    self.level = level
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
    let attributes = AttributeBuilder.buildAttributes(
      id: id,
      classes: classes,
      role: role,
      label: label,
      data: data
    )
    let content = contentBuilder().map { $0.render() }.joined()

    return AttributeBuilder.buildMarkupTag(
      level.rawValue, attributes: attributes, content: content)
  }
}
