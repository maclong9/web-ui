/// Groups multiple markup elements without adding additional HTML structure.
///
/// `Group` allows you to combine multiple markup elements into a single
/// logical unit without wrapping them in a container element. This is useful
/// when you need to return multiple elements from a builder but don't want
/// to add extra HTML markup.
///
/// ## Example
/// ```swift
/// Group {
///     Heading(.h2) { "Title" }
///     Text("Some description text")
///     Button("Action") { }
/// }
/// ```
public struct Group<Content: Markup>: Markup {
    private let content: Content

    /// Creates a group of markup elements.
    ///
    /// - Parameter content: A builder closure that provides the grouped content.
    public init(@MarkupBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: MarkupString {
        return MarkupString(content: content.render())
    }
}