import Foundation

/// Defines HTTP methods for form submission.
///
/// Specifies how form data should be sent to the server when the form is submitted.
public enum FormMethod: String {
    /// HTTP GET request method.
    ///
    /// Appends form data to the URL as query parameters. Best for search forms or filters
    /// where the form data can be bookmarked and shared via URL.
    case get

    /// HTTP POST request method.
    ///
    /// Sends form data in the request body. Best for forms that create, update, or delete
    /// data, or contain sensitive information that shouldn't appear in URLs.
    case post
}

/// Generates an HTML form element.
///
/// Represents a container for collecting user input, typically submitted to a server.
/// Forms can contain various input elements like text fields, checkboxes, radio buttons,
/// and submit buttons, allowing users to interact with and send data to the application.
public struct Form: Element {
    private let action: String?
    private let method: FormMethod
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let contentBuilder: () -> [any HTML]

    /// Creates a new HTML form element.
    ///
    /// - Parameters:
    ///   - action: Optional URL where form data will be submitted. If nil, the form submits to the current page.
    ///   - method: HTTP method for submission (GET or POST), defaults to `.post`.
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interactions.
    ///   - classes: An array of CSS classnames for styling the form.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element for screen readers.
    ///   - data: Dictionary of `data-*` attributes for storing custom data related to the form.
    ///   - content: Closure providing form content, typically input elements, labels, and buttons.
    ///
    /// ## Example
    /// ```swift
    /// Form(action: "/submit", method: .post, id: "contact-form") {
    ///   Label(for: "name") { "Your Name:" }
    ///   Input(name: "name", type: .text, required: true)
    ///
    ///   Label(for: "message") { "Message:" }
    ///   TextArea(name: "message")
    ///
    ///   Button(type: .submit) { "Send Message" }
    /// }
    /// ```
    public init(
        action: String? = nil,
        method: FormMethod = .post,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        self.action = action
        self.method = method
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
        let attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            additional: {
                var attrs: [String] = []
                if let action = action {
                    if let attr = Attribute.string("action", action) { attrs.append(attr) }
                }
                if let attr = Attribute.typed("method", method) { attrs.append(attr) }
                return attrs
            }()
        )
        let content = contentBuilder().map { $0.render() }.joined()
        return AttributeBuilder.renderTag("form", attributes: attributes, content: content)
    }
}