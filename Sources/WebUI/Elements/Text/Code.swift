import Foundation

/// Creates HTML code elements for displaying code snippets.
///
/// Represents a fragment of computer code, typically displayed in a monospace font.
/// Code elements are useful for inline code references, syntax highlighting, and technical documentation.
public final class Code: Element {
    /// Creates a new HTML code element.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of CSS classnames for styling the code element.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the code element.
    ///   - content: Closure providing code content.
    ///
    /// ## Example
    /// ```swift
    /// Code {
    ///   "let x = 42"
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
            tag: "code",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}
