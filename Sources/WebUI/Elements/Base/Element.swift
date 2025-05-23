public enum Attribute {
    /// Builds an HTML attribute string if the value exists.
    ///
    /// - Parameters:
    ///   - name: Attribute name (e.g., "id", "class", "src").
    ///   - value: Attribute value, optional.
    /// - Returns: Formatted attribute string (e.g., `id="header"`) or nil if value is empty.
    public static func string(_ name: String, _ value: String?) -> String? {
        value?.isEmpty == false ? "\(name)=\"\(value!)\"" : nil
    }

    /// Builds a boolean HTML attribute if enabled.
    ///
    /// - Parameters:
    ///   - name: Attribute name (e.g., "disabled", "checked", "required").
    ///   - enabled: Boolean enabling the attribute, optional.
    /// - Returns: Attribute name if true, nil otherwise.
    public static func bool(_ name: String, _ enabled: Bool?) -> String? {
        enabled == true ? name : nil
    }

    /// Builds an HTML attribute string from a typed enum value.
    ///
    /// - Parameters:
    ///   - name: Attribute name (e.g., "type", "role").
    ///   - value: Enum value with String rawValue, optional.
    /// - Returns: Formatted attribute string (e.g., `type="submit"`) or nil if value is nil or empty.
    public static func typed<T: RawRepresentable>(_ name: String, _ value: T?) -> String?
    where T.RawValue == String {
        guard let stringValue = value?.rawValue, !stringValue.isEmpty else { return nil }
        return "\(name)=\"\(stringValue)\""
    }
}

/// Defines ARIA roles for accessibility.
///
/// ARIA roles help communicate the purpose of elements to assistive technologies,
/// enhancing the accessibility of web content for users with disabilities.
public enum AriaRole: String {
    // Landmark Roles
    /// Indicates a search functionality area.
    ///
    /// Use this role for search forms or search input containers.
    case search

    /// Provides metadata about the document.
    ///
    /// Typically used for page footers containing copyright information, privacy statements, etc.
    case contentinfo

    /// Identifies the main content area of the document.
    ///
    /// There should be only one main role per page.
    case main

    /// Identifies a major section of navigation links.
    ///
    /// Use for primary navigation menus.
    case navigation

    /// Identifies a section containing complementary content.
    ///
    /// Content that supplements the main content but remains meaningful on its own.
    case complementary

    /// Identifies the page banner, typically containing site branding and navigation.
    ///
    /// Usually corresponds to the page header.
    case banner

    // Widget Roles
    /// Identifies an element as a button control.
    ///
    /// Use when a non-button element needs to behave as a button.
    case button

    /// Identifies a checkbox control.
    ///
    /// Use when a custom checkbox element is created.
    case checkbox

    /// Identifies an element that displays a dialog or alert window.
    ///
    /// Modal or non-modal interactive components.
    case dialog

    /// Identifies a link that hasn't been coded as an anchor.
    ///
    /// Use when a non-anchor element needs to behave as a link.
    case link

    /// Identifies an expandable/collapsible section.
    ///
    /// Used for disclosure widgets like accordions.
    case tab

    /// Identifies a container for tab elements.
    case tablist

    /// Identifies the content panel of a tab interface.
    case tabpanel

    // Document Structure Roles
    /// Identifies an article or complete, self-contained composition.
    ///
    /// Used for blog posts, news stories, etc.
    case article

    /// Identifies a region containing the primary heading for a document.
    case heading

    /// Identifies a list of items.
    case list

    /// Identifies an individual list item.
    case listitem

    // Live Region Roles
    /// Identifies a section whose content will be updated.
    ///
    /// Used for dynamic content that should be announced by screen readers.
    case alert

    /// Identifies a status message.
    ///
    /// Used for non-critical updates and status information.
    case status
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
    let ariaAttributes: [String: String]?

    /// Computed inner HTML content.
    var content: [any HTML] {
        contentBuilder() ?? []
    }
    
    /// The body of this HTML element.
    ///
    /// For the base Element class, the body is a string representation
    /// of the rendered element to avoid infinite recursion.
    public var body: HTMLString {
        HTMLString(content: renderElementContent())
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
    ///   - ariaAttributes: Dictionary of additional ARIA attributes beyond role and label (e.g., aria-expanded, aria-required).
    ///   - content: Closure providing inner HTML content, defaults to empty.
    ///
    /// ## Example
    /// ```swift
    /// let customDiv = Element(
    ///     tag: "div",
    ///     id: "profile-card",
    ///     classes: ["card", "shadow"],
    ///     data: ["user-id": "12345"],
    ///     content: {
    ///       Heading(.title) { "User Profile" }
    ///       Text { "Welcome back!" }
    ///     }
    ///   )
    ///   ````
    public init(
        tag: String,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        isSelfClosing: Bool = false,
        customAttributes: [String]? = nil,
        ariaAttributes: [String: String]? = nil,
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
        self.ariaAttributes = ariaAttributes
        self.contentBuilder = content
    }

    /// Renders the element as an HTML string.
    ///
    /// This method generates the complete HTML representation of the element,
    /// including its opening tag, attributes, content, and closing tag. For self-closing
    /// elements, only the opening tag with attributes is generated.
    ///
    /// - Returns: Complete HTML element string with attributes and content.
    ///
    /// ## Example
    /// ```swift
    /// let div = Element(tag: "div", id: "content", content: { "Hello" })
    ///   let html = div.render() // Returns `<div id="content">Hello</div>`
    ///
    ///   let img = Element(tag: "img", customAttributes: ["src=\"image.jpg\""], isSelfClosing: true)
    ///   let imgHtml = img.render() // Returns `<img src="image.jpg">`
    ///   ```
    public func render() -> String {
        renderElementContent()
    }
    
    /// Internal method to render element content without recursion.
    private func renderElementContent() -> String {
        // Standard attributes
        var baseAttributes: [String] = [
            Attribute.string("id", id),
            Attribute.string("class", classes?.joined(separator: " ")),
            Attribute.string("role", role?.rawValue),
            Attribute.string("aria-label", label),
        ].compactMap { $0 }

        // Add data attributes
        if let data = data {
            baseAttributes += data.map { entry in
                Attribute.string("data-\(entry.key)", entry.value)
            }.compactMap { $0 }
        }

        // Add additional ARIA attributes
        if let ariaAttributes = ariaAttributes {
            baseAttributes += ariaAttributes.map { key, value in
                Attribute.string("aria-\(key)", value)
            }.compactMap { $0 }
        }

        let allAttributes = baseAttributes + (customAttributes ?? [])
        let attributesString = allAttributes.isEmpty ? "" : " \(allAttributes.joined(separator: " "))"

        if isSelfClosing {
            return "<\(tag)\(attributesString)>"
        }

        let contentString = content.map { $0.render() }.joined()
        return "<\(tag)\(attributesString)>\(contentString)</\(tag)>"
    }
    
    /// Backwards compatibility method for existing toString() calls
    internal func renderElement() -> String {
        renderElementContent()
    }
}
