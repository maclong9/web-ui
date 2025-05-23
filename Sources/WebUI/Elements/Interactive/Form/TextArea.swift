import Foundation

/// Generates an HTML textarea element for multi-line text input.
///
/// Provides a resizable, multi-line text input control for collecting longer text content
/// such as comments, messages, or descriptions. Unlike single-line input elements,
/// textareas can contain line breaks and are suitable for paragraph-length content.
///
/// ## Example
/// ```swift
/// TextArea(name: "comments", placeholder: "Share your thoughts...")
/// // Renders: <textarea name="comments" placeholder="Share your thoughts..."></textarea>
/// ```
public struct TextArea: Element {
    private let name: String
    private let type: InputType?
    private let value: String?
    private let placeholder: String?
    private let autofocus: Bool?
    private let required: Bool?
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?

    /// Creates a new HTML textarea element for multi-line text input.
    ///
    /// - Parameters:
    ///   - name: Name attribute used for form data submission, identifying the field in the submitted data.
    ///   - type: Input type, optional (primarily included for API consistency with Input).
    ///   - value: Initial text content for the textarea, optional.
    ///   - placeholder: Hint text displayed when the textarea is empty, optional.
    ///   - autofocus: When true, automatically focuses this element when the page loads, optional.
    ///   - required: When true, indicates the textarea must be filled before form submission, optional.
    ///   - id: Unique identifier for the HTML element, useful for labels and script interaction.
    ///   - classes: An array of CSS classnames for styling the textarea.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element for screen readers.
    ///   - data: Dictionary of `data-*` attributes for storing custom data related to the textarea.
    ///
    /// ## Example
    /// ```swift
    /// TextArea(
    ///   name: "bio",
    ///   value: existingBio,
    ///   placeholder: "Tell us about yourself...",
    ///   required: true,
    ///   id: "user-bio",
    ///   classes: ["form-control", "bio-input"]
    /// )
    /// ```
    public init(
        name: String,
        type: InputType? = nil,
        value: String? = nil,
        placeholder: String? = nil,
        autofocus: Bool? = nil,
        required: Bool? = nil,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil
    ) {
        self.name = name
        self.type = type
        self.value = value
        self.placeholder = placeholder
        self.autofocus = autofocus
        self.required = required
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
    }
    
    public var body: some HTML {
        HTMLString(content: renderTag())
    }
    
    private func renderTag() -> String {
        let attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            additional: [
                Attribute.string("name", name),
                Attribute.typed("type", type),
                Attribute.string("placeholder", placeholder),
                Attribute.bool("autofocus", autofocus),
                Attribute.bool("required", required)
            ].compactMap { $0 }
        )
        let content = value ?? ""
        return AttributeBuilder.renderTag("textarea", attributes: attributes, content: content)
    }
}