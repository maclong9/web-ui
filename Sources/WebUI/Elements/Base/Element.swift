/// Represents CSS breakpoints for responsive design.
public enum Breakpoint: String {
  /// Small breakpoint (min-width: 640px)
  case small = "sm:"
  /// Medium breakpoint (min-width: 768px)
  case medium = "md:"
  /// Large breakpoint (min-width: 1024px)
  case large = "lg:"
  /// Extra-large breakpoint (min-width: 1280px)
  case extraLarge = "xl:"
  /// 2x extra-large breakpoint (min-width: 1536px)
  case extraLarge2 = "2xl:"
}

/// Represents different ARIA roles for accessibility.
public enum AriaRole: String {
  /// Designates an area containing search functionality
  case search
  /// Represents a widget with a list of selectable options
  case listbox
  /// Indicates a set of user-selectable options
  case menu
  /// Defines metadata about the document (e.g., footer)
  case contentinfo
  /// Represents a dialog box or subwindow
  case dialog
  /// Identifies content that complements the main content
  case complementary
}

/// A base for creating any HTML element.
/// Can render any HTML tag specified by the `tag` property.
/// The semantic purpose of the HTML tag rendered depends on the specific tag name provided.
public class Element: HTML {
  let tag: String
  let id: String?
  let classes: [String]?
  let role: AriaRole?
  let contentBuilder: () -> [any HTML]?

  var content: [any HTML] {
    contentBuilder() ?? { [] }()
  }

  /// Sets up a new HTML element with specific properties and content.
  ///
  /// - Parameters:
  ///   - tag: The name of the HTML tag, such as "div" or "p", that defines what kind of element this is.
  ///   - id: An optional unique identifier for the element, like "main-section", used to reference it elsewhere.
  ///   - classes: Optional styling names, like "button" or "hidden", to control how the element looks.
  ///   - role: An optional accessibility label, like "button" or "navigation", to help screen readers understand the element’s purpose.
  ///   - content: A builder that provides the inner HTML content, such as text or other elements, to go inside the tag.
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

  /// Creates a formatted HTML attribute string if the value is non-empty.
  ///
  /// - Parameters:
  ///   - name: The name of the attribute (e.g., "id", "class", "role").
  ///   - value: An optional string value for the attribute.
  /// - Returns: A string in the format `name="value"` if the value is non-empty, or `nil` if the value is `nil` or empty.
  func attribute(_ name: String, _ value: String?) -> String? {
    value?.isEmpty == false ? "\(name)=\"\(value!)\"" : nil
  }

  /// Returns the attribute name if the condition is true, for boolean HTML attributes.
  ///
  /// - Parameters:
  ///   - name: The name of the attribute (e.g., "id", "class", "role").
  ///   - enabled: A boolean stating whether this attriute is enabled or disabled
  public func booleanAttribute(_ name: String, _ enabled: Bool?) -> String? {
    enabled == true ? name : nil
  }

  /// Renders an HTML element as a string with its tag, attributes, and content.
  ///
  /// This function constructs a properly formatted HTML string representation of an element,
  /// including optional attributes like `id`, `class`, and `role`, and nested content.
  /// Attributes are only included if they have non-empty values, and the resulting string
  /// is formatted with proper spacing.
  ///
  /// - Returns: A string representing the complete HTML element, e.g., `<div id="main" class="container">Content</div>`.
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
