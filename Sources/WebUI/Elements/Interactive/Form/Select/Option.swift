/// Generates an HTML option element (`<option>`).
///
/// `Option` creates an option item within a `Select` element. Options can be
/// disabled, selected, and can have different values from their display text.
///
/// ## Example
/// ```swift
/// Option(value: "us", selected: true) { "United States" }
/// // Renders: <option value="us" selected>United States</option>
/// ```
public struct Option: Element {
    private let value: String
    private let selected: Bool?
    private let disabled: Bool?
    private let label: String?
    private let id: String?
    private let classes: [String]?
    private let data: [String: String]?
    private let contentBuilder: MarkupContentBuilder

    /// Creates a new HTML option element.
    ///
    /// - Parameters:
    ///   - value: The value attribute sent with form submission.
    ///   - selected: Whether this option is initially selected.
    ///   - disabled: Whether this option is disabled.
    ///   - label: Alternative label for the option (if different from content).
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of stylesheet classnames for styling the option.
    ///   - data: Dictionary of `data-*` attributes for storing custom data.
    ///   - content: Closure providing the option's display text.
    public init(
        value: String,
        selected: Bool? = nil,
        disabled: Bool? = nil,
        label: String? = nil,
        id: String? = nil,
        classes: [String]? = nil,
        data: [String: String]? = nil,
        @MarkupBuilder content: @escaping MarkupContentBuilder
    ) {
        self.value = value
        self.selected = selected
        self.disabled = disabled
        self.label = label
        self.id = id
        self.classes = classes
        self.data = data
        self.contentBuilder = content
    }

    public var body: MarkupString {
        var attributes: [String] = []
        
        attributes.append("value=\"\(value)\"")
        
        if let selected = selected, selected {
            attributes.append("selected")
        }
        
        if let disabled = disabled, disabled {
            attributes.append("disabled")
        }
        
        if let label = label {
            attributes.append("label=\"\(label)\"")
        }
        
        if let id = id {
            attributes.append("id=\"\(id)\"")
        }
        
        if let classes = classes, !classes.isEmpty {
            attributes.append("class=\"\(classes.joined(separator: " "))\"")
        }
        
        if let data = data {
            for (key, value) in data {
                attributes.append("data-\(key)=\"\(value)\"")
            }
        }
        
        let attributeString = attributes.isEmpty ? "" : " " + attributes.joined(separator: " ")
        let content = contentBuilder().map { $0.render() }.joined()
        
        return MarkupString(content: "<option\(attributeString)>\(content)</option>")
    }
}