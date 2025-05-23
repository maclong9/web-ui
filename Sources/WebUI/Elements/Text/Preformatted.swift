import Foundation

/// Creates HTML preformatted text elements.
///
/// Represents text that should be displayed exactly as written, preserving whitespace, line breaks,
/// and formatting. Commonly used for displaying code snippets, computer output, ASCII art, or any text
/// where spacing and formatting are significant. The `<pre>` element renders text in a monospaced font
/// and maintains all whitespace characters.
///
/// ## Example
/// ```swift
/// Preformatted {
///   """
///   function greet() {
///     console.log("Hello, world!");
///   }
///   """
/// }
/// ```
public final class Preformatted: Element {
    /// Creates a new HTML preformatted element.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of CSS classnames for styling the preformatted text.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the element.
    ///   - content: Closure providing the preformatted content to be displayed.
    ///
    /// ## Example
    /// ```swift
    /// Preformatted(
    ///   classes: ["code-block", "language-swift"],
    ///   role: .code
    /// ) {
    ///   """
    ///   struct Person {
    ///     let name: String
    ///     let age: Int
    ///   }
    ///   """
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
            tag: "pre",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}
