/// Defines ARIA roles for accessibility.
public enum AriaRole: String, Sendable {
  /// Indicates a search functionality area.
  case search
  /// Provides metadata about the document.
  case contentinfo
}

/// Configuration for HTML element attributes.
public struct ElementConfig {
  var id: String?
  var classes: [String]?
  var role: AriaRole?
  var label: String?

  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil
  ) {
    self.id = id
    self.classes = classes
    self.role = role
    self.label = label
  }
}

/// Base class for creating HTML elements.
public class Element: HTML, @unchecked Sendable {
  let tag: String
  let config: ElementConfig
  let contentBuilder: @Sendable () -> [any HTML]?
  let isSelfClosing: Bool

  /// Computed inner HTML content.
  var content: [any HTML] {
    contentBuilder() ?? []
  }

  /// Creates a new HTML element.
  ///
  /// - Parameters:
  ///   - tag: HTML tag name.
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - isSelfClosing: Indicates if the tag is self-closing (e.g., <input>, <img>).
  ///   - content: Closure providing inner HTML, defaults to empty.
  public init(
    tag: String,
    config: ElementConfig = .init(),
    isSelfClosing: Bool = false,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML]? = { [] }
  ) {
    self.tag = tag
    self.config = config
    self.isSelfClosing = isSelfClosing
    self.contentBuilder = content
  }

  /// Builds an HTML attribute string if the value exists.
  ///
  /// - Parameters:
  ///   - name: Attribute name.
  ///   - value: Attribute value, optional.
  /// - Returns: Formatted attribute string or nil if value is empty.
  func attribute(_ name: String, _ value: String?) -> String? {
    value?.isEmpty == false ? "\(name)=\"\(value!)\"" : nil
  }

  /// Builds a boolean HTML attribute if enabled.
  ///
  /// - Parameters:
  ///   - name: Attribute name.
  ///   - enabled: Boolean enabling the attribute, optional.
  /// - Returns: Attribute name if true, nil otherwise.
  func booleanAttribute(_ name: String, _ enabled: Bool?) -> String? {
    enabled == true ? name : nil
  }

  /// Provides additional attributes specific to subclasses.
  ///
  /// - Returns: Array of attribute strings, or empty if none.
  open func additionalAttributes() -> [String] {
    []
  }

  /// Provides custom content to prepend to the standard content.
  ///
  /// - Returns: Optional string to include before contentBuilder output.
  open func customContent() -> String? {
    nil
  }

  /// Renders the element as an HTML string.
  ///
  /// - Returns: Complete HTML element string with attributes and content.
  public func render() -> String {
    let baseAttributes = [
      attribute("id", config.id),
      attribute("class", config.classes?.joined(separator: " ")),
      attribute("role", config.role?.rawValue),
      attribute("aria-label", config.label),
    ]
    .compactMap { $0 }

    let allAttributes = baseAttributes + additionalAttributes()
    let attributesString = allAttributes.isEmpty ? "" : " \(allAttributes.joined(separator: " "))"

    if isSelfClosing {
      return "<\(tag)\(attributesString)>"
    }

    let customContentString = customContent() ?? ""
    let contentString = content.map { $0.render() }.joined()
    return "<\(tag)\(attributesString)>\(customContentString)\(contentString)</\(tag)>"
  }
}
