/// Defines ARIA roles for accessibility.
///
/// ARIA roles help communicate the purpose of elements to assistive technologies,
/// enhancing the accessibility of web content for users with disabilities.
public enum AriaRole: String {
  /// Indicates a search functionality area.
  ///
  /// Use this role for search forms or search input containers.
  case search
  
  /// Provides metadata about the document.
  ///
  /// Typically used for page footers containing copyright information, privacy statements, etc.
  case contentinfo
}

/// Base class for creating HTML elements.
///
/// `Element` provides the foundation for all HTML elements in the WebUI framework,
/// handling common attributes, content, and rendering functionality. This class
/// can be extended to create specific element types with specialized behavior.
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
  /// This initializer provides a flexible way to create any HTML element with standard
  /// and custom attributes, supporting both self-closing tags and elements with content.
  ///
  /// - Parameters:
  ///   - tag: HTML tag name (e.g., "div", "span", "input").
  ///   - id: Unique identifier for the HTML element, maps to the `id` attribute.
  ///   - classes: An array of CSS classnames, maps to the `class` attribute.
  ///   - role: ARIA role of the element for accessibility, maps to the `role` attribute.
  ///   - label: ARIA label to describe the element, maps to the `aria-label` attribute.
  ///   - data: Dictionary of `data-*` attributes for storing element-relevant data.
  ///   - isSelfClosing: Indicates if the tag is self-closing (e.g., <input>, <img>) and doesn't need a closing tag.
  ///   - customAttributes: Custom attributes specific to this element, provided as an array of attribute strings.
  ///   - content: Closure providing inner HTML content, defaults to empty.
  ///
  /// - Example:
  ///   ```swift
  ///   let customDiv = Element(
  ///     tag: "div",
  ///     id: "profile-card",
  ///     classes: ["card", "shadow"],
  ///     data: ["user-id": "12345"],
  ///     content: {
  ///       Heading(.two) { "User Profile" }
  ///       Text { "Welcome back!" }
  ///     }
  ///   )
  ///   ```
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
  /// This utility method creates an HTML attribute string in the format `name="value"`,
  /// but only if the value is non-nil and non-empty. This helps avoid generating
  /// empty attributes.
  ///
  /// - Parameters:
  ///   - name: Attribute name (e.g., "id", "class", "src").
  ///   - value: Attribute value, optional.
  /// - Returns: Formatted attribute string (e.g., `id="main"`) or nil if value is empty.
  ///
  /// - Example:
  ///   ```swift
  ///   let idAttr = attribute("id", "header") // Returns `id="header"`
  ///   let emptyAttr = attribute("data-empty", "") // Returns nil
  ///   ```
  func attribute(_ name: String, _ value: String?) -> String? {
    value?.isEmpty == false ? "\(name)=\"\(value!)\"" : nil
  }

  /// Builds a boolean HTML attribute if enabled.
  ///
  /// This utility method handles boolean HTML attributes, which are either present
  /// or absent in the element, without an explicit value (e.g., `disabled`, `checked`).
  ///
  /// - Parameters:
  ///   - name: Attribute name (e.g., "disabled", "checked", "required").
  ///   - enabled: Boolean enabling the attribute, optional.
  /// - Returns: Attribute name if true, nil otherwise.
  ///
  /// - Example:
  ///   ```swift
  ///   let disabledAttr = booleanAttribute("disabled", true) // Returns "disabled"
  ///   let checkedAttr = booleanAttribute("checked", false) // Returns nil
  ///   ```
  func booleanAttribute(_ name: String, _ enabled: Bool?) -> String? {
    enabled == true ? name : nil
  }

  /// Renders the element as an HTML string.
  ///
  /// This method generates the complete HTML representation of the element,
  /// including its opening tag, attributes, content, and closing tag. For self-closing
  /// elements, only the opening tag with attributes is generated.
  ///
  /// - Returns: Complete HTML element string with attributes and content.
  ///
  /// - Example:
  ///   ```swift
  ///   let div = Element(tag: "div", id: "content", content: { "Hello" })
  ///   let html = div.render() // Returns `<div id="content">Hello</div>`
  ///   
  ///   let img = Element(tag: "img", customAttributes: ["src=\"image.jpg\""], isSelfClosing: true)
  ///   let imgHtml = img.render() // Returns `<img src="image.jpg">`
  ///   ```
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
