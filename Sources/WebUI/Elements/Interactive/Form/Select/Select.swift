import Foundation

/// Creates an HTML select (dropdown) element for choosing from predefined options.
///
/// Select elements present a collapsible list of options from which users can choose one or more values.
/// They're ideal for scenarios where space is limited and you want to show multiple choices
/// without cluttering the interface.
public struct Select: Element {
    private let name: String
    private let multiple: Bool
    private let required: Bool
    private let autofocus: Bool
    private let disabled: Bool
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let onChange: String?
    private let optionsBuilder: MarkupContentBuilder

    /// Creates a new select element with options.
    ///
    /// - Parameters:
    ///   - name: Name attribute for form submission.
    ///   - multiple: Whether multiple options can be selected simultaneously.
    ///   - required: Whether a selection is required before form submission.
    ///   - autofocus: Whether to automatically focus this element on page load.
    ///   - disabled: Whether the select is disabled.
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: CSS classes for styling.
    ///   - role: ARIA role for accessibility.
    ///   - label: ARIA label for accessibility.
    ///   - data: Dictionary of data-* attributes.
    ///   - onChange: JavaScript to execute when selection changes.
    ///   - options: Closure building the option elements.
    ///
    /// ## Example
    /// ```swift
    /// Select(name: "language", id: "lang-select") {
    ///     Option(value: "swift", label: "Swift", selected: true)
    ///     Option(value: "typescript", label: "TypeScript")
    ///     Option(value: "python", label: "Python")
    /// }
    ///
    /// // With change handler
    /// Select(name: "filter", onChange: "applyFilter(this.value)") {
    ///     Option(value: "all", label: "All Items")
    ///     Option(value: "active", label: "Active Only")
    /// }
    /// ```
    public init(
        name: String,
        multiple: Bool = false,
        required: Bool = false,
        autofocus: Bool = false,
        disabled: Bool = false,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        onChange: String? = nil,
        @MarkupBuilder options: @escaping MarkupContentBuilder
    ) {
        self.name = name
        self.multiple = multiple
        self.required = required
        self.autofocus = autofocus
        self.disabled = disabled
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
        self.onChange = onChange
        self.optionsBuilder = options
    }

    /// Creates a select element from an array of value-label pairs.
    ///
    /// This convenience initializer simplifies creation when you have data in array form.
    ///
    /// - Parameters:
    ///   - name: Name attribute for form submission.
    ///   - options: Array of (value, label) tuples.
    ///   - selected: The value that should be initially selected.
    ///   - required: Whether a selection is required before form submission.
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: CSS classes for styling.
    ///   - onChange: JavaScript to execute when selection changes.
    ///
    /// ## Example
    /// ```swift
    /// Select(
    ///     name: "country",
    ///     options: [
    ///         ("us", "United States"),
    ///         ("uk", "United Kingdom"),
    ///         ("ca", "Canada")
    ///     ],
    ///     selected: "uk",
    ///     id: "country-select"
    /// )
    /// ```
    public init(
        name: String,
        options: [(value: String, label: String)],
        selected: String? = nil,
        required: Bool = false,
        id: String? = nil,
        classes: [String]? = nil,
        onChange: String? = nil
    ) {
        self.name = name
        self.multiple = false
        self.required = required
        self.autofocus = false
        self.disabled = false
        self.id = id
        self.classes = classes
        self.role = nil
        self.label = nil
        self.data = nil
        self.onChange = onChange
        self.optionsBuilder = {
            options.map { option in
                Option(
                    value: option.value,
                    label: option.label,
                    selected: option.value == selected
                )
            }
        }
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

        if multiple {
            attributes.append("multiple")
        }

        if required {
            attributes.append("required")
        }

        if autofocus {
            attributes.append("autofocus")
        }

        if disabled {
            attributes.append("disabled")
        }

        if let onChange, let onChangeAttr = Attribute.string("onchange", onChange) {
            attributes.append(onChangeAttr)
        }

        let optionsContent = optionsBuilder().map { $0.render() }.joined()

        return AttributeBuilder.buildMarkupTag(
            "select",
            attributes: attributes,
            content: optionsContent,
            escapeContent: false  // Options are already rendered markup
        )
    }
}
