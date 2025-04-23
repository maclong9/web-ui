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
  let data: [String: String]?
  let contentBuilder: () -> [any HTML]?
  let isSelfClosing: Bool
  let customAttributes: [String]?

  /// Computed inner HTML content.
  var content: [any HTML] {
    contentBuilder() ?? []
  }

  /// Creates a new HTML element.
  ///
  /// - Parameters:
  ///   - tag: HTML tag name.
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
  ///   - isSelfClosing: Indicates if the tag is self-closing (e.g., <input>, <img>).
  ///   - customAttributes: Custom attributes specific to this element.
  ///   - content: Closure providing inner HTML, defaults to empty.
  public init(
    tag: String,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    isSelfClosing: Bool = false,
    customAttributes: [String]? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]? = { [] }
  ) {
    self.tag = tag
    self.id = id
    self.classes = classes
    self.role = role
    self.label = label
    self.data = data
    self.isSelfClosing = isSelfClosing
    self.customAttributes = customAttributes
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

  /// Renders the element as an HTML string.
  ///
  /// - Returns: Complete HTML element string with attributes and content.
  public func render() -> String {
    let baseAttributes: [String] =
      [
        attribute("id", id),
        attribute("class", classes?.joined(separator: " ")),
        attribute("role", role?.rawValue),
        attribute("aria-label", label),
      ].compactMap { $0 }
      + (data?.map { entry in
        attribute("data-\(entry.key)", entry.value)
      }.compactMap { $0 } ?? [])

    let allAttributes = baseAttributes + (customAttributes ?? [])
    let attributesString = allAttributes.isEmpty ? "" : " \(allAttributes.joined(separator: " "))"

    if isSelfClosing {
      return "<\(tag)\(attributesString)>"
    }

    let contentString = content.map { $0.render() }.joined()
    return "<\(tag)\(attributesString)>\(contentString)</\(tag)>"
  }
}
