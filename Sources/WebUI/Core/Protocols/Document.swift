import Foundation

/// A protocol for defining website pages with a SwiftUI-like pattern.
///
/// The `Document` protocol allows you to define website pages using a declarative syntax
/// similar to SwiftUI. Pages specify their metadata and content through computed properties,
/// making the code more readable and maintainable.
///
/// ## Example
/// ```swift
/// struct Home: Document {
///   var metadata { 
///     Metadata(from: Portfolio.metadata, title: "Home") 
///   }
///   
///   var body: some HTML {
///     Card(title: "Hello, world")
///   }
/// }
/// ```
public protocol Document {
    /// The type of HTML content this document produces.
    associatedtype Body: HTML
    
    /// The metadata configuration for this document.
    ///
    /// Defines the page title, description, and other metadata that will appear
    /// in the HTML head section.
    var metadata: Metadata { get }
    
    /// The main content of the document.
    ///
    /// This property returns the HTML content that will be rendered as the
    /// body of the page.
    var body: Body { get }
    
    /// The URL path for this document.
    ///
    /// If not provided, the path will be derived from the metadata title.
    /// Use "/" or "index" for the root page, or specify custom paths like "about" or "blog/post".
    var path: String? { get }
    
    /// Optional JavaScript sources specific to this document.
    var scripts: [Script]? { get }
    
    /// Optional stylesheet URLs specific to this document.
    var stylesheets: [String]? { get }
    
    /// Optional theme configuration specific to this document.
    var theme: Theme? { get }
    
    /// Optional custom HTML to append to this document's head section.
    var head: String? { get }
}

// MARK: - Default Implementations

public extension Document {
    /// Default path implementation derives from metadata title.
    var path: String? { metadata.title?.pathFormatted() }
    
    /// Default scripts implementation returns nil.
    var scripts: [Script]? { nil }
    
    /// Default stylesheets implementation returns nil.
    var stylesheets: [String]? { nil }
    
    /// Default theme implementation returns nil.
    var theme: Theme? { nil }
    
    /// Default head implementation returns nil.
    var head: String? { nil }
    
    /// Creates a concrete Document instance for rendering.
    func document() -> any Document {
        WebUI.Document(
            path: path,
            metadata: metadata,
            scripts: scripts,
            stylesheets: stylesheets,
            theme: theme,
            head: head
        ) {
            [body]
        }
    }
}