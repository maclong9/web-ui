import Foundation

/// A concrete implementation of the Document protocol for type-erased document instances.
///
/// This struct allows creating Document instances from closures, enabling the `document()` method
/// in the Document protocol extension to work properly. It wraps document properties and content
/// in a type-erased way while maintaining the Document protocol interface.
public struct ConcreteDocument: Document {
    public typealias Body = AnyHTML

    public let metadata: Metadata
    public let path: String?
    public let scripts: [Script]?
    public let stylesheets: [String]?
    public let theme: Theme?
    public let head: String?
    private let content: HTMLContentBuilder

    /// Creates a concrete document instance with the specified properties and content.
    ///
    /// - Parameters:
    ///   - path: The URL path for this document
    ///   - metadata: The metadata configuration for this document
    ///   - scripts: Optional JavaScript sources specific to this document
    ///   - stylesheets: Optional stylesheet URLs specific to this document
    ///   - theme: Optional theme configuration specific to this document
    ///   - head: Optional custom HTML to append to this document's head section
    ///   - content: A closure that returns the HTML content for the document body
    public init(
        path: String?,
        metadata: Metadata,
        scripts: [Script]? = nil,
        stylesheets: [String]? = nil,
        theme: Theme? = nil,
        head: String? = nil,
        content: @escaping HTMLContentBuilder
    ) {
        self.path = path
        self.metadata = metadata
        self.scripts = scripts
        self.stylesheets = stylesheets
        self.theme = theme
        self.head = head
        self.content = content
    }

    public var body: AnyHTML {
        let htmlElements = content()
        let combinedContent = htmlElements.map { $0.render() }.joined()
        return AnyHTML(HTMLString(content: combinedContent))
    }
}

/// Namespace for WebUI types to avoid naming conflicts.
public enum WebUI {
    /// Type alias for the concrete document implementation.
    public typealias Document = ConcreteDocument
}
