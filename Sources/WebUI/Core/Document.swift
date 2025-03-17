/// Represents a complete HTML document with fixed metadata.
///
/// This structure encapsulates both the document’s content and its metadata, including site information,
/// page title, description, and other HTML `<head>` elements such as `<meta>` and `<title>` tags.
/// - All metadata is set at initialization and cannot be altered during rendering.
/// - Produces a fully formatted HTML document with `<head>` and `<body>` sections.
public struct Document {
  let path: String
  var metadata: Metadata
  private let contentBuilder: () -> [any HTML]

  var content: [any HTML] {
    contentBuilder()
  }

  /// Creates an HTML document with fixed metadata and content.
  ///
  /// - Parameters:
  ///   - path: The pathname for navigatin to that document
  ///   - metadata: The complete metadata configuration for the document.
  ///   - content: The HTML content for the `<body>` section.
  init(path: String, metadata: Metadata, @HTMLBuilder content: @escaping () -> [any HTML]) {
    self.path = path
    self.metadata = metadata
    self.contentBuilder = content
  }

  /// Generates a complete HTML document string.
  ///
  /// This function renders a full HTML document including the `<head>` section with all metadata
  ///
  /// - Note: The CSS filename is derived from the first part of `metadata.pageTitle` (before "|"),
  ///   with spaces replaced by hyphens and converted to lowercase
  ///
  /// - Returns: A string containing the complete HTML document.
  func render() -> String {
    let cssFilename = metadata.pageTitle
      .split(separator: " \(metadata.titleSeperator)")[0]
      .replacingOccurrences(of: " ", with: "-")
      .lowercased()

    var optionalMetaTags: [String] = []
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
          <link rel="stylesheet" href="/\(cssFilename).css">
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
