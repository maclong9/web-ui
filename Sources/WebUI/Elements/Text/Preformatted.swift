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
public struct Preformatted: Element {
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    private let contentBuilder: () -> [any HTML]
    
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
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
        self.contentBuilder = content
    }
    
    public var body: some HTML {
        HTMLString(content: renderTag())
    }
    
    private func renderTag() -> String {
        let attributes = buildAttributes()
        let content = contentBuilder().map { $0.render() }.joined()
        
        return "<pre \(attributes.joined(separator: " "))>\(content)</pre>"
    }
    
    private func buildAttributes() -> [String] {
        var attributes: [String] = []
        
        if let id = id {
            attributes.append(Attribute.string("id", id)!)
        }
        
        if let classes = classes, !classes.isEmpty {
            attributes.append(Attribute.string("class", classes.joined(separator: " "))!)
        }
        
        if let role = role {
            attributes.append(Attribute.typed("role", role)!)
        }
        
        if let label = label {
            attributes.append(Attribute.string("aria-label", label)!)
        }
        
        if let data = data {
            for (key, value) in data {
                attributes.append(Attribute.string("data-\(key)", value)!)
            }
        }
        
        return attributes
    }
}