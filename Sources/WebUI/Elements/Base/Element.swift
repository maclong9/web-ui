/// Defines CSS breakpoints for responsive design.
public enum Breakpoint: String {
  /// Extra small breakpoint at 480px min-width.
  case extraSmall = "xs:"
  /// Small breakpoint at 640px min-width.
  case small = "sm:"
  /// Medium breakpoint at 768px min-width.
  case medium = "md:"
  /// Large breakpoint at 1024px min-width.
  case large = "lg:"
  /// Extra-large breakpoint at 1280px min-width.
  case extraLarge = "xl:"
  /// 2x extra-large breakpoint at 1536px min-width.
  case extraLarge2 = "2xl:"
}

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
  let contentBuilder: () -> [any HTML]?

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
  ///   - content: Closure providing inner HTML, defaults to empty.
  init(
    tag: String,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]? = { [] }
  ) {
    self.tag = tag
    self.id = id
    self.classes = classes
    self.role = role
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
    ]
    .compactMap { $0 }
    .joined(separator: " ")

    let attributesString = attributes.isEmpty ? "" : " \(attributes)"
    let contentString = content.map { $0.render() }.joined()
    return "<\(tag)\(attributesString)>\(contentString)</\(tag)>"
  }
}
