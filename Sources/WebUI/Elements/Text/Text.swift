import Foundation

/// Generates markup text elements as `<p>` or `<span>` based on content.
///
/// Paragraphs are for long form content with multiple sentences and
/// a `<span>` tag is used for a single sentence of text and grouping inline content.
public struct Text: Element {
  private let id: String?
  private let classes: [String]?
  private let role: AriaRole?
  private let label: String?
  private let data: [String: String]?
  private let contentBuilder: MarkupContentBuilder

  /// Creates a new text element with string content.
  ///
  /// This is the preferred SwiftUI-like initializer for creating text elements.
  /// Uses `<p>` for multiple sentences, `<span>` for one or fewer.
  ///
  /// The content string is automatically checked for localization keys. If the string
  /// appears to be a localization key (e.g., "welcome_message", "app.title"), it will
  /// be resolved using the current localization settings.
  ///
  /// - Parameters:
  ///   - content: The text content to display or localization key to resolve.
  ///   - id: Unique identifier for the markup element.
  ///   - classes: An array of stylesheet classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
  ///
  /// ## Example
  /// ```swift
  /// Text("Hello, world!")  // Regular text
  /// Text("welcome_message")  // Localization key (resolved automatically)
  /// Text("Multi-line text with multiple sentences. This will render as a paragraph.", classes: ["intro"])
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

    // Resolve localization if the content appears to be a localization key
    let resolvedContent = LocalizationManager.shared.resolveIfLocalizationKey(content)
    self.contentBuilder = { [resolvedContent] }
  }

  /// Creates a new text element with explicit localization key support.
  ///
  /// This initializer provides explicit control over localization, allowing you to
  /// specify localization parameters directly. Use this when you need more control
  /// over the localization process than the automatic detection provides.
  ///
  /// - Parameters:
  ///   - localizationKey: The localization key to resolve.
  ///   - id: Unique identifier for the markup element.
  ///   - classes: An array of stylesheet classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
  ///
  /// ## Example
  /// ```swift
  /// Text(localizationKey: LocalizationKey("welcome_message"))
  /// Text(localizationKey: LocalizationKey.interpolated("user_count", arguments: ["5"]))
  /// Text(localizationKey: LocalizationKey.fromTable("greeting", tableName: "Common"))
  /// ```
  public init(
    localizationKey: LocalizationKey,
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

    // Resolve the localization key explicitly
    let resolvedContent = LocalizationManager.shared.resolveKey(localizationKey)
    self.contentBuilder = { [resolvedContent] }
  }

  /// Creates a new text element using MarkupBuilder closure syntax.
  ///
  /// Uses `<p>` for multiple sentences, `<span>` for one or fewer.
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the markup element.
  ///   - classes: An array of stylesheet classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
  ///   - content: Closure providing text content.
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @MarkupBuilder content: @escaping MarkupContentBuilder
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
    let renderedContent = contentBuilder().map { $0.render() }.joined()
    let sentenceCount = renderedContent.components(
      separatedBy: CharacterSet(charactersIn: ".!?")
    )
    .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    .count

    let tag = sentenceCount > 1 ? "p" : "span"
    let attributes = AttributeBuilder.buildAttributes(
      id: id,
      classes: classes,
      role: role,
      label: label,
      data: data
    )

    return
      "<\(tag)\(attributes.count > 0 ? " " : "")\(attributes.joined(separator: " "))>\(HTMLEscaper.escape(renderedContent))</\(tag)>"
  }
}
