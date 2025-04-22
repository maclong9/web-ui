/// Defines ARIA roles for accessibility.
public enum AriaRole: String {
  /// Indicates a search functionality area.
  case search
  /// Provides metadata about the document.
  case contentinfo
}

/// Base class for creating HTML elements.
public class Element: HTML {
  let tag: String
  let id: String?
  let classes: [String]?
  let role: AriaRole?
  let label: String?
  let contentBuilder:  () -> [any HTML]?
  let isSelfClosing: Bool

  /// Computed inner HTML content.
  var content: [any HTML] {
    contentBuilder() ?? []
  }

  /// Creates a new HTML element.
  ///
  /// - Parameters:
  ///   - tag: HTML tag name.
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - isSelfClosing: Indicates if the tag is self-closing (e.g., <input>, <img>).
  ///   - content: Closure providing inner HTML, defaults to empty.
  public init(
    tag: String,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    isSelfClosing: Bool = false,
    @HTMLBuilder content: @escaping  () -> [any HTML]? = { [] }
  ) {
    self.tag = tag
    self.id = id
    self.classes = classes
    self.role = role
    self.label = label
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

  /// Renders the element as an HTML string.
  ///
  /// - Returns: Complete HTML element string with attributes and content.
  public func render() -> String {
    let baseAttributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("role", role?.rawValue),
      attribute("aria-label", label)
    ]
    .compactMap { $0 }

    let allAttributes = baseAttributes + additionalAttributes()
    let attributesString =
      allAttributes.isEmpty ? "" : " \(allAttributes.joined(separator: " "))"

    if isSelfClosing {
      return "<\(tag)\(attributesString)>"
    }

    let contentString = content.map { $0.render() }.joined()
    return "<\(tag)\(attributesString)>\(contentString)</\(tag)>"
  }
}
