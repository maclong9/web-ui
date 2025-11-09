import Foundation

/// Generates an HTML input element for collecting user input, such as text or numbers.
///
/// `Input` elements are the primary way to gather user data in forms, supporting various types
/// of input from simple text to specialized formats like email addresses or numbers.
/// The appearance and behavior of an input element is determined by its type.
public struct Input: Element {
    /// The name attribute used for form submission (maps to form data field name).
    private let name: String
    /// The type of input controlling its appearance and validation behavior.
    private let type: InputType?
    /// The initial value of the input element.
    private let value: String?
    /// Hint text displayed when the field is empty.
    private let placeholder: String?
    /// Whether the input should automatically receive focus when the page loads.
    private let autofocus: Bool?
    /// Whether the input must be filled out before form submission.
    private let required: Bool?
    /// Whether a checkbox input is initially checked.
    private let checked: Bool?
    /// ID of a datalist element for autocomplete suggestions.
    private let list: String?
    /// Whether the input is read-only.
    private let readonly: Bool?
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let on: String?

    /// Creates a new HTML input element.
    ///
    /// - Parameters:
    ///   - name: Name for form submission, used as the field name when data is submitted.
    ///   - type: Input type determining appearance and validation behavior, optional.
    ///   - value: Initial value of the input, optional.
    ///   - placeholder: Hint text displayed when the field is empty, optional.
    ///   - autofocus: Automatically focuses the input on page load if true, optional.
    ///   - required: When true, the input must be filled before form submission, optional.
    ///   - checked: For checkbox inputs, indicates if initially checked, optional.
    ///   - list: ID of a datalist element providing autocomplete suggestions, optional.
    ///   - readonly: Whether the input is read-only (user cannot modify), optional.
    ///   - id: Unique identifier for the HTML element, useful for labels and JavaScript.
    ///   - classes: An array of stylesheet classnames for styling the input.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element for screen readers.
    ///   - data: Dictionary of `data-*` attributes for storing custom data.
    ///   - eventHandler: JavaScript event handler code, optional.
    ///
    /// ## Example
    /// ```swift
    /// // Text input for a username
    /// Input(name: "username", type: .text, placeholder: "Enter your username", required: true)
    ///
    /// // Password input with autofocus
    /// Input(name: "password", type: .password, placeholder: "Your password", autofocus: true)
    ///
    /// // Email input with validation
    /// Input(name: "email", type: .email, placeholder: "your@email.com")
    ///
    /// // Checkbox for accepting terms
    /// Input(name: "accept_terms", type: .checkbox, checked: false)
    /// ```
    public init(
        name: String,
        type: InputType? = nil,
        value: String? = nil,
        placeholder: String? = nil,
        autofocus: Bool? = nil,
        required: Bool? = nil,
        checked: Bool? = nil,
        list: String? = nil,
        readonly: Bool? = nil,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        eventHandler on: String? = nil
    ) {
        self.name = name
        self.type = type
        self.value = value
        self.placeholder = placeholder
        self.autofocus = autofocus
        self.required = required
        self.checked = checked
        self.list = list
        self.readonly = readonly
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
        self.on = on
    }

    public var body: some Markup {
        MarkupString(content: buildMarkupTag())
    }

    private func buildMarkupTag() -> String {
        var attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data
        )
        if let nameAttr = Attribute.string("name", name) {
            attributes.append(nameAttr)
        }
        if let type, let typeAttr = Attribute.typed("type", type) {
            attributes.append(typeAttr)
        }
        if let value, let valueAttr = Attribute.string("value", value) {
            attributes.append(valueAttr)
        }
        if let placeholder,
            let placeholderAttr = Attribute.string("placeholder", placeholder)
        {
            attributes.append(placeholderAttr)
        }
        if let autofocus, autofocus {
            attributes.append("autofocus")
        }
        if let required, required {
            attributes.append("required")
        }
        if let checked, checked {
            attributes.append("checked")
        }
        if let list, let listAttr = Attribute.string("list", list) {
            attributes.append(listAttr)
        }
        if let readonly, readonly {
            attributes.append("readonly")
        }
        if let on = on {
            attributes.append(on)
        }
        return AttributeBuilder.buildMarkupTag(
            "input", attributes: attributes, isSelfClosing: true)
    }
}
