/// Represents metadata associated with a website, including author, keywords, and social media information.
struct Metadata {
  let site: String
  let title: String
  let author: String
  let keywords: [String]
  let twitter: String
  let locale: String
  let type: String

  /// Initializes a new `Metadata` instance with optional parameters.
  ///
  /// - Parameters:
  ///   - site: The name of the website, defaulting to "Great Site".
  ///   - title: The title format, defaulting to `"%s"`.
  ///   - author: The author of the content, defaulting to "Unknown".
  ///   - keywords: An array of keywords for SEO, defaulting to an empty array.
  ///   - twitter: The Twitter handle associated with the site, defaulting to "@example".
  ///   - locale: The locale of the site, defaulting to "en".
  ///   - type: The type of the site, defaulting to "website".
  init(
    site: String = "Great Site",
    title: String = "%s",
    author: String = "Unknown",
    keywords: [String] = [],
    twitter: String = "@example",
    locale: String = "en",
    type: String = "website"
  ) {
    self.site = site
    self.title = "%s | \(site)"
    self.author = author
    self.keywords = keywords
    self.twitter = twitter
    self.locale = locale
    self.type = type
  }
}
