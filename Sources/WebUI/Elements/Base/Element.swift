/// Defines ARIA roles for accessibility.
public enum AriaRole: String, Sendable {
  /// Indicates a search functionality area.
  case search
  /// Provides metadata about the document.
  case contentinfo
}

/// Base class for creating HTML elements.
public class Element: HTML, @unchecked Sendable {
  let tag: String
  let id: String?
  let classes: [String]?
  let role: AriaRole?
  let label: String?
  let contentBuilder: @Sendable () -> [any HTML]?

  /// Computed inner HTML content.
  var content: [any HTML] {
    contentBuilder() ?? { [] }()
  }

  /// Creates a new HTML element.
  ///
  /// - Parameters:
  ///   - tag: HTML tag name.
  ///   - id: Unique identifier, optional.
  ///   - classes: Class names for styling, optional.
  ///   - role: Accessibility role, optional.
  ///   - label: Accessibility label, optional.
  ///   - content: Closure providing inner HTML, defaults to empty.
  public init(
    tag: String,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML]? = { [] }
  ) {
    self.tag = tag
    self.id = id
    self.classes = classes
    self.role = role
    self.label = label
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
    let attributes = [
      attribute("id", id),
      attribute("class", classes?.joined(separator: " ")),
      attribute("role", role?.rawValue),
      attribute("label", label)
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let attributesString = attributes.isEmpty ? "" : " \(attributes)"
    let contentString = content.map { $0.render() }.joined()
    return "<\(tag)\(attributesString)>\(contentString)</\(tag)>"
  }
}
