/// Defines semantic levels for HTML heading tags from h1 to h6.
///
/// HTML headings provide document structure and establish content hierarchy.
/// Each level has a specific semantic meaning, with h1 being the most important
/// and h6 the least. Proper use of heading levels improves accessibility,
/// SEO, and overall document organization.
///
/// ## Example
/// ```swift
/// Heading(.largeTitle) {
///   "Main Page Title"
/// }
/// ```
public enum HeadingLevel: String {
    /// Large title, most prominent heading (h1).
    case largeTitle = "h1"
    /// Title, second most prominent heading (h2).
    case title = "h2"
    /// Headline, third most prominent heading (h3).
    case headline = "h3"
    /// Subheadline, fourth most prominent heading (h4).
    case subheadline = "h4"
    /// Body, fifth most prominent heading (h5).
    case body = "h5"
    /// Footnote, least prominent heading (h6).
    case footnote = "h6"
}
