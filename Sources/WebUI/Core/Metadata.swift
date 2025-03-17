/// Supported Open Graph content types for the document.
public enum ContentType: String {
  case website = "website"
  case article = "article"
  case video = "video"
  case profile = "profile"
}

/// Supported language locales for the document.
public enum Locale: String {
  case english = "en"
  case spanish = "es"
  case french = "fr"
  case german = "de"
  case japanese = "ja"
}

/// Metadata configuration for the document's `<head>` section.
public struct Metadata {
  var site: String?
  var title: String
  var titleSeperator: String
  var pageTitle: String
  var description: String
  var author: String?
  var keywords: [String]?
  var twitter: String?
  var locale: Locale
  var type: ContentType?

  /// Creates metadata configuration for the document.
  ///
  /// - Parameters:
  ///   - site: The website name, used in title and branding (default: nil).
  ///   - title: Base template for the page title.
  ///   - titleSeperator: The string used to seperate the title and description.
  ///   - description: A brief summary of the page content for `<meta>` tags.
  ///   - author: Optional author name for the content.
  ///   - keywords: Optional SEO keywords.
  ///   - twitter: Optional Twitter handle (without "@").
  ///   - locale: Language setting (default: .english).
  ///   - type: Optional Open Graph content type.
  init(
    site: String? = nil,
    title: String,
    titleSeperator: String = "|",
    description: String,
    author: String? = nil,
    keywords: [String]? = nil,
    twitter: String? = nil,
    locale: Locale = .english,
    type: ContentType? = nil
  ) {
    self.site = site
    self.title = title
    self.titleSeperator = titleSeperator
    self.pageTitle = "\(title)\(site.map { " \(titleSeperator) \($0)" } ?? "")"
    self.description = description
    self.author = author
    self.keywords = keywords
    self.twitter = twitter
    self.locale = locale
    self.type = type
  }
}
