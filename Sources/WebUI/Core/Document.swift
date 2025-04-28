import Foundation
import Logging

/// Represents an immutable HTML document with metadata and content.
public struct Document {
  private let logger = Logger(label: "com.webui.document")
  public let path: String?
  public var metadata: Metadata
  public var scripts: [String]?
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
    scripts: [String]? = nil,
    stylesheets: [String]? = nil,
    theme: Theme? = nil,
    head: String? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    self.path = path
    self.metadata = metadata
    self.scripts = scripts
    self.stylesheets = stylesheets
    self.theme = theme
    self.head = head
    self.contentBuilder = content

    logger.debug("Document initialized with path: \(path ?? "index"), title: \(metadata.pageTitle)")
    logger.trace("Document has \(scripts?.count ?? 0) scripts, \(stylesheets?.count ?? 0) stylesheets")
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

    var optionalMetaTags: [String] = []
    if let image = metadata.image, !image.isEmpty {
      logger.trace("Adding og:image meta tag: \(image)")
      optionalMetaTags.append(
        "<meta property=\"og:image\" content=\"\(image)\">")
    }
    if let author = metadata.author, !author.isEmpty {
      logger.trace("Adding author meta tag: \(author)")
      optionalMetaTags.append("<meta name=\"author\" content=\"\(author)\">")
    }
    if let type = metadata.type {
      logger.trace("Adding og:type meta tag: \(type.rawValue)")
      optionalMetaTags.append(
        "<meta property=\"og:type\" content=\"\(type.rawValue)\">")
    }
    if let twitter = metadata.twitter, !twitter.isEmpty {
      logger.trace("Adding twitter meta tag: \(twitter)")
      optionalMetaTags.append(
        "<meta name=\"twitter:creator\" content=\"@\(twitter)\">")
    }
    if let keywords = metadata.keywords, !keywords.isEmpty {
      logger.trace("Adding keywords meta tag with \(keywords.count) keywords")
      optionalMetaTags.append(
        "<meta name=\"keywords\" content=\"\(keywords.joined(separator: ", "))\">"
      )
    }
    if let themeColor = metadata.themeColor {
      logger.trace("Adding theme-color meta tags")
      optionalMetaTags.append(
        "<meta name=\"theme-color\" content=\"\(themeColor.light)\" media=\"(prefers-color-scheme: light)\">")
      optionalMetaTags.append(
        "<meta name=\"theme-color\" content=\"\(themeColor.dark)\" media=\"(prefers-color-scheme: dark)\">")
    }
    if let scripts = scripts {
      logger.trace("Adding \(scripts.count) script tags")
      for script in scripts {
        optionalMetaTags.append("<script src=\"\(script)\"></script>")
      }
    }
    if let stylesheets = stylesheets {
      logger.trace("Adding \(stylesheets.count) stylesheet links")
      for stylesheet in stylesheets {
        optionalMetaTags.append(
          "<link rel=\"stylesheet\" href=\"\(stylesheet)\">")
      }
    }

    logger.trace("Building head section")
    let headSection = """
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>\(metadata.pageTitle)</title>
          <meta property="og:title" content="\(metadata.pageTitle)">
          <meta name="description" content="\(metadata.description)">
          <meta property="og:description" content="\(metadata.description)">
          <meta name="twitter:card" content="summary_large_image">
          \(optionalMetaTags.joined(separator: "\n"))
          <script src="https://unpkg.com/@tailwindcss/browser@4"></script>
          <style type="text/tailwindcss">
              @theme {
                  --breakpoint-xs: 30rem;
                  --breakpoint-3xl: 120rem;
                  --breakpoint-4xl: 160rem;
                  \(theme?.generateCSS() ?? "")
              }
          </style>
          \(head ?? "")
      </head>
      """

    logger.trace("Rendering content elements")
    let contentElements = content.map { $0.render() }.joined()
    logger.debug("Document rendered successfully: \(metadata.pageTitle)")

    return """
      <!DOCTYPE html>
      <html lang="\(metadata.locale.rawValue)">
      \(headSection)
      <body>
        \(contentElements)
      </body>
      </html>
      """
  }
}
