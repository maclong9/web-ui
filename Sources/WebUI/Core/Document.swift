import Foundation
import Logging

/// Defines attributes for controlling JavaScript script loading behavior.
///
/// These attributes help optimize loading performance by controlling when scripts are loaded and executed.
public enum ScriptAttribute: String {
    /// Defers downloading and execution of the script until after the page has been parsed.
    ///
    /// - Note: Scripts with the `defer` attribute will execute in the order they appear in the document.
    case `defer`

    /// Causes the script to download in parallel and execute as soon as it's available.
    ///
    /// - Note: Scripts with the `async` attribute may execute in any order and should not depend on other scripts.
    case async
}

/// Represents a JavaScript script with its source and optional loading attribute.
///
/// Used to define scripts that should be included in the HTML document.
///
/// - Example:
///   ```swift
///   let mainScript = Script(src: "/js/main.js", attribute: .defer)
///   ```
public struct Script {
    /// The source URL of the script.
    let src: String

    /// Optional attribute controlling how the script is loaded and executed.
    let attribute: ScriptAttribute?
}

/// Represents an immutable HTML document with metadata, scripts, stylesheets, and content.
///
/// The `Document` struct serves as the core building block for constructing HTML pages
/// with a consistent structure and the ability to customize various aspects like metadata,
/// scripts, and styling.
public struct Document {
    private let logger = Logger(label: "com.webui.document")
    public let path: String?
    public var metadata: Metadata
    public var scripts: [String: ScriptAttribute?]?
    public var stylesheets: [String]?
    public var theme: Theme?
    public let head: String?
    public let contentBuilder: () -> [any HTML]

    /// Computed HTML content from the content builder.
    ///
    /// This property executes the content builder closure to generate the document's HTML elements.
    var content: [any HTML] {
        contentBuilder()
    }

    /// Creates a new HTML document with metadata, optional head content, and body content.
    ///
    /// This initializer creates a complete HTML document structure including the necessary
    /// metadata, scripts, stylesheets, and content.
    ///
    /// - Parameters:
    ///   - path: URL path for navigating to the document. Required for static site building, not for server-side rendering.
    ///   - metadata: Configuration for the head section including title, description, and other meta tags.
    ///   - scripts: Optional dictionary mapping script sources to their attributes to append to the head section.
    ///   - stylesheets: Optional array of stylesheet URLs to append to the head section.
    ///   - theme: Optional theme configuration to extend the default theme with custom values.
    ///   - head: Optional raw HTML string to append to the head section (e.g., additional scripts, styles).
    ///   - content: A closure that builds the document's HTML content using the HTML builder DSL.
    ///
    /// ## Example
    ///   ```swift
    ///   let homePage = Document(
    ///     path: "index",
    ///     metadata: Metadata(title: "Home", description: "Welcome to our site"),
    ///     scripts: ["main.js": .defer],
    ///     stylesheets: ["styles.css"],
    ///     content: {
    ///       Heading(.largeTitle) { "Welcome" }
    ///       Text { "This is our homepage." }
    ///     }
    ///   )
    ///   ```
    public init(
        path: String? = nil,
        metadata: Metadata,
        scripts: [String: ScriptAttribute?]? = nil,
        stylesheets: [String]? = nil,
        theme: Theme? = nil,
        head: String? = nil,
        @HTMLBuilder content: @escaping () -> [any HTML]
    ) {
        self.metadata = metadata
        self.path = path ?? metadata.title?.pathFormatted()
        self.scripts = scripts
        self.stylesheets = stylesheets
        self.theme = theme
        self.head = head
        self.contentBuilder = content

        logger.debug(
            "Document initialized with path: \(path ?? "index"), title: \(metadata.pageTitle)"
        )
        logger.trace(
            "Document has \(scripts?.count ?? 0) scripts, \(stylesheets?.count ?? 0) stylesheets"
        )
    }

    /// Renders the document as a complete HTML string.
    ///
    /// Generates a complete HTML document with:
    /// - A DOCTYPE declaration
    /// - An HTML element with the specified language
    /// - A head section containing metadata, scripts, stylesheets, and optional custom head content
    /// - A body section containing the document's content
    ///
    /// - Returns: A complete HTML document as a string.
    /// - Complexity: O(n) where n is the number of content elements.
    ///
    /// - Example:
    ///   ```swift
    ///   let htmlString = document.render()
    ///   // Returns "<!DOCTYPE html><html lang="en">...</html>"
    ///   ```
    public func render() -> String {
        logger.debug("Rendering document: \(path ?? "index")")
        logger.trace("Starting metadata rendering")

        var optionalTags: [String] = metadata.tags + []
        if let scripts = scripts {
            logger.trace("Adding \(scripts.count) script tags")
            for script in scripts {
                optionalTags.append(
                    "<script \(script.value?.rawValue ?? "") src=\"\(script.key)\"></script>"
                )
            }
        }
        if let stylesheets = stylesheets {
            logger.trace("Adding \(stylesheets.count) stylesheet links")
            for stylesheet in stylesheets {
                optionalTags.append(
                    "<link rel=\"stylesheet\" href=\"\(stylesheet)\">"
                )
            }
        }

        logger.debug("Document rendered successfully: \(metadata.pageTitle)")

        return """
            <!DOCTYPE html>
            <html lang="\(metadata.locale.rawValue)">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>\(metadata.pageTitle)</title>
                \(optionalTags.joined(separator: "\n"))
                <script src="https://unpkg.com/@tailwindcss/browser@4"></script>
                \(head ?? "")
            </head> 
            <body>
              \(content.map { $0.render() }.joined())
            </body>
            </html>
            """
    }
}
