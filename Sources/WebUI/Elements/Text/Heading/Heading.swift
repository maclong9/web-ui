import Foundation

/// Creates HTML heading elements from `<h1>` to `<h6>`.
///
/// Represents section headings of different levels, with `<h1>` being the highest (most important)
/// and `<h6>` the lowest. Headings provide document structure and are essential for accessibility,
/// SEO, and reader comprehension.
public final class Heading: Element {
    /// Creates a new HTML heading element.
    ///
    /// - Parameters:
    ///   - level: Heading level (.largeTitle, .title, .headline, .subheadline, .body, or .footnote).
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of CSS classnames for styling the heading.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the heading.
    ///   - content: Closure providing heading content.
    ///
    /// ## Example
    /// ```swift
    /// Heading(.title) {
    ///   "Section Title"
    /// }
    /// ```
    public init(
        _ level: HeadingLevel,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        super.init(
            tag: level.rawValue,
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}
