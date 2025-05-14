/// Generates an HTML article element for self-contained content sections.
///
/// Represents a self-contained, independently distributable composition like a blog post,
/// news story, forum post, or any content that could stand alone. Articles are ideal for
/// content that could be syndicated or reused elsewhere.
///
/// - Example:
///   ```swift
///   Article {
///     Heading(.one) { "Blog Post Title" }
///     Text { "Published on May 15, 2023" }
///     Text { "This is the content of the blog post..." }
///   }
///   ```
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
  /// - Example:
  ///   ```swift
  ///   Article(id: "post-123", classes: ["blog-post", "featured"]) {
  ///     Heading(.one) { "Getting Started with WebUI" }
  ///     Text { "Learn how to build static websites using Swift..." }
  ///   }
  ///   ```
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(
      tag: "article", id: id, classes: classes, role: role, label: label, data: data,
      content: content)
  }
}

/// Generates an HTML section element for thematic content grouping.
///
/// Defines a thematic grouping of content, such as a chapter, tab panel, or any content
/// that forms a distinct section of a document. Sections typically have their own heading
/// and represent a logical grouping of related content.
///
/// - Example:
///   ```swift
///   Section(id: "features") {
///     Heading(.two) { "Key Features" }
///     List {
///       Item { "Simple API" }
///       Item { "Type-safe HTML generation" }
///       Item { "Responsive design" }
///     }
///   }
///   ```
public final class Section: Element {
  /// Creates a new HTML section element for thematic content grouping.
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the HTML element, useful for navigation and linking.
  ///   - classes: An array of CSS classnames for styling the section.
  ///   - role: ARIA role of the element for accessibility and screen readers.
  ///   - label: ARIA label to describe the element's purpose for screen readers.
  ///   - data: Dictionary of `data-*` attributes for storing custom data related to the section.
  ///   - content: Closure providing section content such as headings, paragraphs, and other elements.
  ///
  /// - Example:
  ///   ```swift
  ///   Section(id: "about", classes: ["content-section"]) {
  ///     Heading(.two) { "About Us" }
  ///     Text { "Our company was founded in 2020..." }
  ///   }
  ///   ```
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(
      tag: "section", id: id, classes: classes, role: role, label: label, data: data,
      content: content)
  }
}

/// Generates an HTML div element for generic content grouping.
///
/// The `Stack` element (which renders as a div) groups elements for styling or layout
/// without conveying any specific semantic meaning. It's a versatile container used
/// for creating layout structures, applying styles to groups, or providing hooks for
/// JavaScript functionality.
///
/// - Note: Use semantic elements like `Article`, `Section`, or `Aside` when possible,
///   and reserve `Stack` for purely presentational grouping.
///
/// - Example:
///   ```swift
///   Stack(classes: ["flex-container"]) {
///     Stack(classes: ["card"]) { "Card 1 content" }
///     Stack(classes: ["card"]) { "Card 2 content" }
///   }
///   ```
public final class Stack: Element {
  /// Creates a new HTML div element for generic content grouping.
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the HTML element, useful for styling and scripting.
  ///   - classes: An array of CSS classnames for styling the div container.
  ///   - role: ARIA role of the element for accessibility and screen readers.
  ///   - label: ARIA label to describe the element's purpose for screen readers.
  ///   - data: Dictionary of `data-*` attributes for storing custom data related to the container.
  ///   - content: Closure providing the container's content elements.
  ///
  /// - Example:
  ///   ```swift
  ///   Stack(id: "user-profile", classes: ["card", "shadow"], data: ["user-id": "123"]) {
  ///     Image(source: "/avatar.jpg", description: "User Avatar")
  ///     Heading(.three) { "Jane Doe" }
  ///     Text { "Software Engineer" }
  ///   }
  ///   ```
  public init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(
      tag: "div", id: id, classes: classes, role: role, label: label, data: data, content: content)
  }
}
