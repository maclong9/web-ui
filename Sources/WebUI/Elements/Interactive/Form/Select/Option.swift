import Foundation

/// Represents an option within a Select dropdown element.
///
/// Options define the individual choices available in a dropdown menu.
/// Each option has a value (submitted with the form) and display text (shown to the user).
public struct Option: Element {
    private let value: String
    private let selected: Bool
    private let disabled: Bool
    private let label: String?

    /// Creates a new option for a select element.
    ///
    /// - Parameters:
    ///   - value: The value submitted when this option is selected.
    ///   - label: The text displayed to the user. If nil, uses the value.
    ///   - selected: Whether this option is initially selected.
    ///   - disabled: Whether this option can be selected.
    ///
    /// ## Example
    /// ```swift
    /// Option(value: "swift", label: "Swift")
    /// Option(value: "typescript", label: "TypeScript", selected: true)
    /// Option(value: "deprecated", label: "Old Language", disabled: true)
    /// ```
    public init(
        value: String,
        label: String? = nil,
        selected: Bool = false,
        disabled: Bool = false
    ) {
        self.value = value
        self.label = label
        self.selected = selected
        self.disabled = disabled
    }

    public var body: some Markup {
        MarkupString(content: buildMarkupTag())
    }

    private func buildMarkupTag() -> String {
        var attributes: [String] = []

        if let valueAttr = Attribute.string("value", value) {
            attributes.append(valueAttr)
        }

        if selected {
            attributes.append("selected")
        }

        if disabled {
            attributes.append("disabled")
        }

        let displayText = label ?? value

        return AttributeBuilder.buildMarkupTag(
            "option",
            attributes: attributes,
            content: displayText,
            escapeContent: true
        )
    }
}
