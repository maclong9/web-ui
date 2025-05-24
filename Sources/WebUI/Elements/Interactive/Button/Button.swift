import Foundation

/// Creates HTML button elements.
///
/// Represents a clickable element that triggers an action or event when pressed.
/// Buttons are fundamental interactive elements in forms and user interfaces.
public struct Button: Element {
    private let type: ButtonType?
    private let autofocus: Bool?
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let contentBuilder: HTMLContentBuilder

    /// Creates a new HTML button.
    ///
    /// - Parameters:
    ///   - type: Button type (submit or reset), optional. If nil, the button will be a standard button without a specific form role.
    ///   - autofocus: When true, automatically focuses the button when the page loads, optional.
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
    public init(
        type: ButtonType? = nil,
        autofocus: Bool? = nil,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping HTMLContentBuilder = { [] }
    ) {
        self.type = type
        self.autofocus = autofocus
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
        let attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            additional: additional
        )
        let content = contentBuilder().map { $0.render() }.joined()
        return AttributeBuilder.renderTag("button", attributes: attributes, content: content)
    }
}
