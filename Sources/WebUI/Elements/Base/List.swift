/// Defines types of HTML list elements.
///
/// HTML supports two main types of lists: ordered (numbered) lists and unordered (bulleted) lists.
/// This enum provides a type-safe way to specify which list type to create.
public enum ListType: String {
    /// Creates an ordered (numbered) list using the `<ol>` tag.
    ///
    /// Use for sequential, prioritized, or step-by-step items.
    case ordered = "ol"

    /// Creates an unordered (bulleted) list using the `<ul>` tag.
    ///
    /// Use for items where the sequence doesn't matter.
    case unordered = "ul"
}

/// Generates HTML list elements (`<ul>` or `<ol>`).
///
/// `List` can be rendered as an unordered list with bullet points when sequence is unimportant,
/// or as an ordered list with numbered markings when sequence matters.
///
/// - Note: Use `Item` elements as children of a `List` to create list items.
///
/// ## Example
/// ```swift
/// List(type: .ordered) {
///   Item { "First item" }
///   Item { "Second item" }
///   Item { "Third item" }
/// }
/// // Renders: <ol><li>First item</li><li>Second item</li><li>Third item</li></ol>
/// ```
public final class List: Element {
    let type: ListType

    /// Creates a new HTML list element (`<ul>` or `<ol>`).
    ///
    /// - Parameters:
    ///   - type: List type (ordered or unordered), defaults to unordered.
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of CSS classnames for styling the list.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element for screen readers.
    ///   - data: Dictionary of `data-*` attributes for storing custom data.
    ///   - content: Closure providing list items, typically `Item` elements.
    ///
    /// ## Example
    /// ```swift
    /// List(type: .unordered, classes: ["checklist"]) {
    ///   Item { "Buy groceries" }
    ///   Item { "Clean house" }
    /// }
    /// ```
    public init(
        type: ListType = .unordered,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML] = { [] }
    ) {
        self.type = type
        super.init(
            tag: type.rawValue,
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}

/// Generates an HTML list item element (`<li>`).
///
/// `Item` elements should be used as children of a `List` element to represent
/// individual entries in a list. Each item can contain any HTML content.
///
/// ## Example
/// ```swift
/// Item {
///   Text { "This is a list item with " }
///   Strong { "bold text" }
/// }
/// // Renders: <li><span>This is a list item with </span><strong>bold text</strong></li>
/// ```
public final class Item: Element {
    /// Creates a new HTML list item element.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the HTML element.
    ///   - classes: An array of CSS classnames for styling the list item.
    ///   - role: ARIA role of the element for accessibility.
    ///   - label: ARIA label to describe the element for screen readers.
    ///   - data: Dictionary of `data-*` attributes for storing custom data.
    ///   - content: Closure providing the list item's content (text or other HTML elements).
    ///
    /// ## Example
    /// ```swift
    /// Item(classes: ["completed"], data: ["task-id": "123"]) {
    ///   "Complete documentation"
    /// }
    /// // Renders: <li class="completed" data-task-id="123">Complete documentation</li>
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
            tag: "li",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            content: content
        )
    }
}
