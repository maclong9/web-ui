/// Represents an immutable HTML document with metadata and content.
public struct Document: Sendable {
  /// Navigation path for the document.
  public let path: String?

  /// Metadata configuration for the document’s head section.
  public var metadata: Metadata

  /// Closure generating the document’s HTML content.
  private let contentBuilder: @Sendable () -> [any HTML]

  /// Computed HTML content from the content builder.
  var content: [any HTML] {
    contentBuilder()
  }

  /// Creates a new HTML document with metadata and content.
  ///
  /// - Parameters:
  ///   - path: URL path for navigating to the document. Required for build, not for server side rendering.
  ///   - metadata: Configuration for the head section.
  ///   - content: Closure building the body’s HTML content.
  public init(
    path: String? = nil,
    metadata: Metadata,
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML]
  ) {
    self.path = path
    self.metadata = metadata
    self.contentBuilder = content
  }

  /// Renders the document as a complete HTML string.
  ///
  /// Generates HTML with a head section (metadata) and body (content).
  ///
  /// - Returns: Complete HTML document string.
  /// - Complexity: O(n) where n is the number of content elements.
  func render() -> String {
    let cssFilename = metadata.pageTitle
      .split(separator: " \(metadata.titleSeperator)")[0]
      .replacingOccurrences(of: " ", with: "-")
      .lowercased()

    var optionalMetaTags: [String] = []
    if let image = metadata.image, !image.isEmpty {
      optionalMetaTags.append("<meta property=\"og:image\" content=\"\(image)\">")
    }
    if let author = metadata.author, !author.isEmpty {
      optionalMetaTags.append("<meta name=\"author\" content=\"\(author)\">")
    }
    if let type = metadata.type {
      optionalMetaTags.append("<meta property=\"og:type\" content=\"\(type.rawValue)\">")
    }
    if let twitter = metadata.twitter, !twitter.isEmpty {
      optionalMetaTags.append("<meta name=\"twitter:creator\" content=\"@\(twitter)\">")
    }
    if let keywords = metadata.keywords, !keywords.isEmpty {
      optionalMetaTags.append("<meta name=\"keywords\" content=\"\(keywords.joined(separator: ", "))\">")
    }

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
              }
          </style>
      </head>
      """

    return """
      <!DOCTYPE html>
      <html lang="\(metadata.locale.rawValue)">
      \(headSection)
      <body>
        \(content.map { $0.render() }.joined())
      </body>
      </html>
      """
  }
}
