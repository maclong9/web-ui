import Foundation

/// Creates HTML button elements.
///
/// Represents a clickable element that triggers an action or event when pressed.
/// Buttons are fundamental interactive elements in forms and user interfaces.
public struct Button: Element {
    private let type: ButtonType?
    private let autofocus: Bool?
    private let onClick: String?
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let contentBuilder: HTMLContentBuilder

    /// Creates a new HTML button with string title.
    ///
    /// This is the preferred SwiftUI-like initializer for creating buttons with text content.
    ///
    /// - Parameters:
    ///   - title: The button's text content.
    ///   - type: Button type (submit or reset), optional.
    ///   - autofocus: When true, automatically focuses the button when the page loads, optional.
    ///   - onClick: JavaScript function to execute when the button is clicked, optional.
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of CSS classnames for styling the button.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when button text isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the button.
    ///
    /// ## Example
    /// ```swift
    /// Button("Save Changes", type: .submit, id: "save-button")
    /// Button("Cancel", onClick: "closeDialog()")
    /// Button("Submit Form", type: .submit)
    /// ```
    public init(
        _ title: String,
        type: ButtonType? = nil,
        autofocus: Bool? = nil,
        onClick: String? = nil,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil
    ) {
        self.type = type
        self.autofocus = autofocus
        self.onClick = onClick
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
        self.contentBuilder = { [title] }
    }

    /// Creates a new HTML button with string title and optional system image.
    ///
    /// This initializer supports adding system images (icons) to buttons, following SwiftUI patterns.
    /// The image will be rendered as an inline SVG icon before the button text.
    ///
    /// - Parameters:
    ///   - title: The button's text content.
    ///   - systemImage: Name of the system image/icon to display, optional.
    ///   - type: Button type (submit or reset), optional.
    ///   - autofocus: When true, automatically focuses the button when the page loads, optional.
    ///   - onClick: JavaScript function to execute when the button is clicked, optional.
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of CSS classnames for styling the button.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when button text isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the button.
    ///
    /// ## Example
    /// ```swift
    /// Button("Save", systemImage: "checkmark", type: .submit)
    /// Button("Delete", systemImage: "trash", onClick: "confirmDelete()")
    /// Button("Download", systemImage: "arrow.down")
    /// ```
    public init(
        _ title: String,
        systemImage: String,
        type: ButtonType? = nil,
        autofocus: Bool? = nil,
        onClick: String? = nil,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil
    ) {
        self.type = type
        self.autofocus = autofocus
        self.onClick = onClick
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
        
        // Create content builder that includes both icon and text
        self.contentBuilder = {
            [
                SystemImage(systemImage, classes: ["button-icon"]),
                " \(title)"
            ]
        }
    }

    /// Creates a new HTML button using HTMLBuilder closure syntax.
    ///
    /// - Parameters:
    ///   - type: Button type (submit or reset), optional.
    ///   - autofocus: When true, automatically focuses the button when the page loads, optional.
    ///   - onClick: JavaScript function to execute when the button is clicked, optional.
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of CSS classnames for styling the button.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when button text isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the button.
    ///   - content: Closure providing button content (text or other HTML elements), defaults to empty.
    ///
    /// ## Example
    /// ```swift
    /// Button(type: .submit, id: "save-button") {
    ///   "Save Changes"
    /// }
    /// .background(color: .blue(.600))
    /// .padding(.all, length: 2)
    /// ```
    @available(*, deprecated, message: "Use Button(_:) string initializer instead for better SwiftUI compatibility. Example: Button(\"Save Changes\", type: .submit)")
    public init(
        type: ButtonType? = nil,
        autofocus: Bool? = nil,
        onClick: String? = nil,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping HTMLContentBuilder = { [] }
    ) {
        self.type = type
        self.autofocus = autofocus
        self.onClick = onClick
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
        self.contentBuilder = content
    }

    public var body: some HTML {
        HTMLString(content: renderTag())
    }

    private func renderTag() -> String {
        var additional: [String] = []
        if let type, let typeAttr = Attribute.typed("type", type) {
            additional.append(typeAttr)
        }
        if let autofocus, autofocus {
            additional.append("autofocus")
        }
        if let onClick, let clickAttr = Attribute.string("onclick", onClick) {
            additional.append(clickAttr)
        }
        let attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            additional: additional
        )
        let content = contentBuilder().map { $0.render() }.joined()
        return AttributeBuilder.renderTag(
            "button", attributes: attributes, content: content)
    }
}
