import Foundation
import Logging

public enum ScriptAttribute: String {
  /// Defers downloading of the script to during page pare
  case `defer`
  /// Causes the script to run as soon as it's available
  case async
}

public struct Script {
  let src: String
  let attribute: ScriptAttribute?
}

/// Represents an immutable HTML document with metadata and content.
public struct Document {
  private let logger = Logger(label: "com.webui.document")
  public let path: String?
  public var metadata: Metadata
  public var scripts: [String: ScriptAttribute?]?
  public var stylesheets: [String]?
  public var theme: Theme?
  public let head: String?
  private let contentBuilder: () -> [any HTML]

  /// Computed HTML content from the content builder.
  var content: [any HTML] {
    contentBuilder()
  }

  /// Creates a new HTML document with metadata, optional head content, and body content.
  ///
  /// - Parameters:
  ///   - path: URL path for navigating to the document. Required for build, not for server side rendering.
  ///   - metadata: Configuration for the head section.
  ///   - scripts: Optional array of strings that contain script sources to append to the head section.
  ///   - stylesheets: Optional array of strings that contain stylesheet sources to append to the head section.
  ///   - theme: Optionally extend the default theme with custom values.
  ///   - head: Optional raw HTML string to append to the head section (e.g., scripts, styles).
  ///   - content: Closure building the body's HTML content.
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
  /// Generates HTML with a head section (metadata and optional head content) and body (content).
  ///
  /// - Returns: Complete HTML document string.
  /// - Complexity: O(n) where n is the number of content elements.
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
