// TODO: Implement Styling

/// An HTML article element.
/// - Article elements represent self-contained compositions in a document, such as a blog post or news story.
public class Article: Element {
  /// Creates a new HTML article element with optional attributes and content.
  /// - Parameters:
  ///   - id: An optional ID attribute for the element.
  ///   - classes: Optional CSS classes to apply to the element.
  ///   - role: An optional ARIA role for accessibility (defaults to .article).
  ///   - content: A result builder closure that defines the nested content.
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "article", id: id, classes: classes, role: role, content: content)
  }
}

/// An HTML section element.
/// - Section elements represent a standalone section of content within a document,
///   typically with its own heading.
public class Section: Element {
  /// Creates a new HTML section element with optional attributes and content.
  /// - Parameters:
  ///   - id: An optional ID attribute for the element.
  ///   - classes: Optional CSS classes to apply to the element.
  ///   - role: An optional ARIA role for accessibility (defaults to nil).
  ///   - content: A result builder closure that defines the nested content.
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "section", id: id, classes: classes, role: role, content: content)
  }
}

/// A container element implemented as an HTML div.
/// - This is a generic container element useful for grouping and styling content.
public class Stack: Element {
  /// Creates a new HTML div element with optional attributes and content.
  /// - Parameters:
  ///   - id: An optional ID attribute for the element.
  ///   - classes: Optional CSS classes to apply to the element.
  ///   - role: An optional ARIA role for accessibility (defaults to nil).
  ///   - content: A result builder closure that defines the nested content.
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "div", id: id, classes: classes, role: role, content: content)
  }
}

/// An action element for providing a user a space to click
public class Button: Element {
  /// Creates a new HTML button element with optional attributes and content.
  /// - Parameters:
  ///   - id: An optional ID attribute for the element.
  ///   - classes: Optional CSS classes to apply to the element.
  ///   - role: An optional ARIA role for accessibility (defaults to .button).
  ///   - content: A result builder closure that defines the nested content.
  init(
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
  ) {
    super.init(tag: "button", id: id, classes: classes, role: role, content: content)
  }
}
