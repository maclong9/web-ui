public struct Metadata {
  let site: String
  let title: String
  let author: String?
  let keywords: [String]?
  let twitter: String?
  let locale: String
  let type: String?

  /// Creates a new `Metadata` instance with optional parameters.
  init(
    site: String = "Great Site",
    title: String = "%s",
    author: String? = nil,
    keywords: [String]? = nil,
    twitter: String? = nil,
    locale: String = "en",
    type: String? = nil
  ) {
    self.site = site
    self.title = "\(title) | \(site)"
    self.author = author
    self.keywords = keywords
    self.twitter = twitter
    self.locale = locale
    self.type = type
  }

  func render(
    pageTitle: String,
    description: String,
    twitter: String?,
    author: String?,
    keywords: [String]?,
    type: String?
  ) -> String {
    // Determine effective values: page-specific takes precedence, fallback to site-wide
    let effectiveAuthor = author?.isEmpty == false ? author : self.author
    let effectiveKeywords = keywords?.isEmpty == false ? keywords : self.keywords
    let effectiveTwitter = twitter?.isEmpty == false ? twitter : self.twitter
    let effectiveType = type?.isEmpty == false ? type : self.type

    return """
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>\(pageTitle)</title>
        <meta property="og:title" content="\(pageTitle)">
        <meta name="description" content="\(description)">
        <meta property="og:description" content="\(description)">
        <meta name="twitter:card" content="summary_large_image">
        \(effectiveAuthor?.isEmpty == false ? "<meta name=\"author\" content=\"\(effectiveAuthor ?? "")\">" : "")
        \(effectiveType?.isEmpty == false ? "<meta property=\"og:type\" content=\"\(effectiveType ?? "")\">" : "")
        \(effectiveTwitter?.isEmpty == false ? "<meta name=\"twitter:creator\" content=\"@\(effectiveTwitter ?? "")\">" : "")
        \(effectiveKeywords?.isEmpty == false
            ? "<meta name=\"keywords\" content=\"\(effectiveKeywords?.joined(separator: ", ") ?? "")\">"
            : "")
        <link rel="stylesheet" href="/\(pageTitle.split(separator: "|")[0].replacingOccurrences(of: " ", with: "-").lowercased()).css">
      </head>
      """
  }
}
