import Foundation

// TODO: Create optimised bundles of CSS and JS named `{page-title}.css`
// TODO: Validate the HTML, CSS and JS output on build

public struct Document {
  let configuration: Configuration
  let title: String
  let description: String
  let keywords: [String]?
  let author: String?
  let type: String?

  private let contentBuilder: () -> [any HTML]

  var content: [any HTML] {
    contentBuilder()
  }

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
