import Foundation

/// Creates HTML strong emphasis elements.
///
/// Represents text with strong emphasis or importance, typically displayed in bold by browsers.
/// The `<strong>` element indicates content with high importance, seriousness, or urgency.
/// It differs from `<b>` (bold) which stylistically offsets text without implying importance,
/// and from `<em>` which indicates stress emphasis.
///
/// ## Example
/// ```swift
/// Strong { "Warning: This action cannot be undone!" }
/// ```
public final class Strong: Element {
    /// Creates a new HTML strong element.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of CSS classnames for styling the emphasized text.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the element.
    ///   - content: Closure providing the content to be strongly emphasized.
    ///
    /// ## Example
    /// ```swift
    /// Strong(
    ///   classes: ["alert", "critical"]
    /// ) {
    ///   "Important security notice"
    /// }
    /// ```
    public init(
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        super.init(
            tag: "strong",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}
