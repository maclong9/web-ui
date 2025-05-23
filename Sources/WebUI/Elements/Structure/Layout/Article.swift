/// Generates an HTML article element for self-contained content sections.
///
/// Represents a self-contained, independently distributable composition like a blog post,
/// news story, forum post, or any content that could stand alone. Articles are ideal for
/// content that could be syndicated or reused elsewhere.
///
/// ## Example
/// ```swift
/// Article {
///   Heading(.largeTitle) { "Blog Post Title" }
///   Text { "Published on May 15, 2023" }
///   Text { "This is the content of the blog post..." }
/// }
/// ```
public final class Article: Element {
    /// Creates a new HTML article element for self-contained content.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element, useful for linking and scripting.
    ///   - classes: An array of CSS classnames for styling the article.
    ///   - role: ARIA role of the element for accessibility and screen readers.
    ///   - label: ARIA label to describe the element for screen readers.
    ///   - data: Dictionary of `data-*` attributes for storing custom data related to the article.
    ///   - content: Closure providing article content such as headings, paragraphs, and media.
    ///
    /// ## Example
    /// ```swift
    /// Article(id: "post-123", classes: ["blog-post", "featured"]) {
    ///   Heading(.largeTitle) { "Getting Started with WebUI" }
    ///   Text { "Learn how to build static websites using Swift..." }
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
            tag: "article",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}
