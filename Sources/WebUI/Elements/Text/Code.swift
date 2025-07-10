import Foundation

/// Creates HTML code elements for displaying code snippets.
///
/// Represents a fragment of computer code, typically displayed in a monospace font.
/// Code elements are useful for inline code references, syntax highlighting, and technical documentation.
public struct Code: Element {
  private let id: String?
  private let classes: [String]?
  private let role: AriaRole?
  private let label: String?
  private let data: [String: String]?
  private let contentBuilder: MarkupContentBuilder

  /// Creates a new HTML code element with string content.
  ///
  /// This is the preferred SwiftUI-like initializer for creating inline code elements.
  ///
  /// - Parameters:
  ///   - content: The code snippet to display.
  ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
  ///   - classes: An array of stylesheet classnames for styling the code element.
  ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
  ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
  ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the code element.
  ///
  /// ## Example
  /// ```swift
  /// Code("let x = 42")
  /// Code("console.log('Hello, world!')", classes: ["javascript"])
  /// ```
  public init(
    _ content: String,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil
  ) {
    self.id = id
    self.classes = classes
    self.role = role
    self.label = label
    self.data = data
    self.contentBuilder = { [content] }
  }

  /// Creates a new HTML code element using HTMLBuilder closure syntax.
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
  ///   - classes: An array of stylesheet classnames for styling the code element.
  ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
  ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
  ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the code element.
  ///   - content: Closure providing code content.
  ///
  /// ## Example
  /// ```swift
  /// Code {
  ///   "let x = 42"
  /// }
  /// ```
  @available(
    *, deprecated,
    message:
      "Use Code(_:) string initializer instead for better SwiftUI compatibility. Example: Code(\"let x = 42\")"
  )
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @MarkupBuilder content: @escaping MarkupContentBuilder = { [] }
  ) {
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
      "code", attributes: attributes, content: content)
  }
}
