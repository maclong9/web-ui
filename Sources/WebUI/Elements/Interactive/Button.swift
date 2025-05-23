import Foundation

/// Defines types of HTML button elements.
///
/// Specifies the purpose and behavior of buttons within forms.
public enum ButtonType: String {
    /// Submits the form data to the server.
    case submit

    /// Resets all form controls to their initial values.
    case reset
}

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
    private let contentBuilder: () -> [any HTML]

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
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
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
        let attributes = buildAttributes()
        let content = contentBuilder().map { $0.render() }.joined()

        return "<button \(attributes.joined(separator: " "))>\(content)</button>"
    }

    private func buildAttributes() -> [String] {
        var attributes: [String] = []

        if let type = type {
            attributes.append(Attribute.typed("type", type)!)
        }

        if let autofocus = autofocus, autofocus {
            attributes.append("autofocus")
        }

        if let id = id {
            attributes.append(Attribute.string("id", id)!)
        }

        if let classes = classes, !classes.isEmpty {
            attributes.append(Attribute.string("class", classes.joined(separator: " "))!)
        }

        if let role = role {
            attributes.append(Attribute.typed("role", role)!)
        }

        if let label = label {
            attributes.append(Attribute.string("aria-label", label)!)
        }

        if let data = data {
            for (key, value) in data {
                attributes.append(Attribute.string("data-\(key)", value)!)
            }
        }

        return attributes
    }
}
