// TODO: Implement Styling

// MARK: - Article
/// Represents a self-contained composition in a document, such as a blog post or news story.
///
/// The `Article` class generates an HTML `<article>` element, which is ideal for content that can stand alone
/// or be syndicated independently, such as blog posts, news articles, or user comments. It inherits from
///
/// - Note: This element is semantic and improves accessibility and SEO by clearly defining independent
/// content blocks within a document.
///
/// - SeeAlso: `Section` for thematic grouping within a larger document, or `Stack` for generic grouping.
public class Article: Element {
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "article", id: id, classes: classes, role: role, content: content)
  }
}

// MARK: - Section
/// A standalone section of content within a document.
///
/// The `Section` class generates an HTML `<section>` element, representing a thematic grouping of content,
/// typically with a heading. It’s useful for dividing a document into logical parts, such as chapters or
/// topical segments, and inherits from the `Element` superclass.
///
/// - Note: Unlike `Article`, a `Section` does not imply standalone or syndicatable content; it’s meant
/// to organize content within a larger context.
///
/// - SeeAlso: `Article` for independent content, or `Stack` for non-semantic grouping.
public class Section: Element {
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "section", id: id, classes: classes, role: role, content: content)
  }
}

// MARK: - Stack
/// A generic container element implemented as an HTML `<div>`, useful for grouping content.
///
/// The `Stack` class generates an HTML `<div>` element, serving as a non-semantic container for layout
/// or styling purposes. It inherits from the `Element` superclass and is highly versatile, allowing
/// you to group other elements without implying a specific meaning or structure.
///
/// - Note: Use `Stack` when semantic elements like `Article` or `Section` are not appropriate, such as
/// for pure layout containers or styling wrappers.
///
/// - SeeAlso: `Article` or `Section` for semantic grouping with specific document roles.
public class Stack: Element {
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "div", id: id, classes: classes, role: role, content: content)
  }
}

// MARK: - Button
/// An action element for providing the user a space to click.
///
/// The `Button` class generates an HTML `<button>` element, designed for interactive actions such as
/// submitting forms, triggering events, or navigating. It inherits from the `Element` superclass and
/// supports optional identifiers, CSS classes, ARIA roles, and nested content.
///
/// - SeeAlso: `Link` for hyperlink-based navigation instead of button actions.
public class Button: Element {
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "button", id: id, classes: classes, role: role, content: content)
  }
}
