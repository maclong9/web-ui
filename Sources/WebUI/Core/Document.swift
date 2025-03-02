import Foundation

// TODO: Create optimised bundles of CSS and JS named `{page-title}.css`
// TODO: Validate the HTML, CSS and JS output on build

/// Represents a document containing content, configuration, and rendering logic.
public struct Document {
  let configuration: Configuration
  let title: String
  let description: String
  let keywords: [String]?
  let author: String?
  let type: String?

  private let contentBuilder: () -> [any HTML]

  /// The computed property that evaluates the content builder to get the nested HTML components.
  var content: [any HTML] {
    contentBuilder()
  }

  /// Creates a new `Document` instance.
  ///
  /// - Parameters:
  ///   - configuration: The configuration settings.
  ///   - title: The document title.
  ///   - description: A description of the document content.
  ///   - keywords: An array of keywords for seo.
  ///   - content: The main content of the document.
  init(
    configuration: Configuration = Configuration(),
    title: String,
    description: String,
    keywords: [String]? = nil,
    author: String? = nil,
    type: String? = nil,
    @HTMLBuilder content: @escaping () -> [any HTML]
  ) {
    self.configuration = configuration
    self.title = title
    self.description = description
    self.keywords = keywords
    self.author = author
    self.type = type
    self.contentBuilder = content
  }

  /// Renders the document as an HTML string.
  ///
  /// - Returns: A `String` containing the rendered HTML document.
  func render() -> String {
    let pageTitle = "\(title) | \(configuration.metadata.site)"

    return """
      <!DOCTYPE html>
      <html lang="\(configuration.metadata.locale)">
        \(configuration.metadata.render(
          pageTitle: pageTitle,
          description: description,
          twitter: configuration.metadata.twitter,
          author: author,
          keywords: keywords,
          type: type
        ))
        <body>
          \(content.map { $0.render() }.joined())
        </body>
      </html>
      """
  }
}
