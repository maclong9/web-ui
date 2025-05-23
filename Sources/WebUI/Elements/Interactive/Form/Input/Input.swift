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
    ///   - id: Unique identifier for the HTML element, useful for labels and JavaScript.
    ///   - classes: An array of CSS classnames for styling the input.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element for screen readers.
    ///   - data: Dictionary of `data-*` attributes for storing custom data.
    ///   - on: String? = nil,
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
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        on: String? = nil
    ) {
        self.name = name
        self.type = type
        self.value = value
        self.placeholder = placeholder
        self.autofocus = autofocus
        self.required = required
        self.checked = checked
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
        self.on = on
    }
    
    public var body: some HTML {
        HTMLString(content: renderTag())
    }
    
    private func renderTag() -> String {
        let attributes = buildAttributes()
        return "<input \(attributes.joined(separator: " "))>"
    }
    
    private func buildAttributes() -> [String] {
        var attributes = [
            Attribute.string("name", name),
            Attribute.typed("type", type),
            Attribute.string("value", value),
            Attribute.string("placeholder", placeholder),
            Attribute.bool("autofocus", autofocus),
            Attribute.bool("required", required),
            Attribute.bool("checked", checked),
        ].compactMap { $0 }
        
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
        
        if let on = on {
            attributes.append(on)
        }
        
        return attributes
    }
}