import Foundation

/// Generates an HTML abbreviation element (`<abbr>`) for displaying abbreviations or acronyms.
///
/// The abbreviation element allows you to define the full term for an abbreviation or acronym,
/// which helps with accessibility and provides a visual indication to users (typically shown
/// with a dotted underline). When users hover over the abbreviation, browsers typically
/// display the full term as a tooltip.
///
/// ## Example
/// ```swift
/// Abbreviation(title: "Hypertext Markup Language") { "HTML" }
/// // Renders: <abbr title="Hypertext Markup Language">HTML</abbr>
/// ```
public final class Abbreviation: Element {
    let fullTitle: String

    /// Creates a new HTML abbreviation element.
    ///
    /// - Parameters:
    ///   - title: The full term or explanation of the abbreviation.
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of CSS classnames for styling the abbreviation.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element for screen readers.
    ///   - data: Dictionary of `data-*` attributes for storing element-specific data.
    ///   - content: Closure providing the content (typically the abbreviated term).
    ///
    /// ## Example
    /// ```swift
    /// Abbreviation(
    ///   title: "World Health Organization",
    ///   classes: ["term"]
    /// ) {
    ///   "WHO"
    /// }
    /// ```
    public init(
        title: String,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        self.fullTitle = title
        let customAttributes = [Attribute.string("title", title)].compactMap { $0 }

        super.init(
            tag: "abbr",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            customAttributes: customAttributes.isEmpty ? nil : customAttributes,
            content: content
        )
    }
}
