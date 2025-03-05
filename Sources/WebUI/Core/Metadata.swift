/// Manages and renders HTML metadata.
/// This holds information such as site name, title, author, keywords, Twitter handle, locale, and type.
/// - `<meta>` tags for character set, viewport, description, Open Graph properties, and more.
/// - A `<title>` tag with the provided page title.
/// - Conditional `<meta>` tags for author, keywords, Twitter creator, and Open Graph type if provided.
public struct Metadata {
  let site: String
  let title: String
  let author: String?
  let keywords: [String]?
  let twitter: String?
  let locale: String
  let type: String?

  /// Creates metadata for an HTML document.
  ///
  /// This prepares details like the site name, title format, and other optional info for the webpage’s `<head>` section.
  /// - Parameters:
  ///   - site: The name of the website, like "Great Site", used in the title and branding.
  ///   - title: A template for the page title, like "%s", which gets combined with the site name.
  ///   - author: An optional name of the page’s creator, like "John Smith".
  ///   - keywords: Optional words or phrases, like "tech, coding", for search engines.
  ///   - twitter: An optional Twitter handle, like "johndoe", without the "@" symbol.
  ///   - locale: The language setting, like "en" for English, with "en" as the default.
  ///   - type: An optional category, like "article", to describe the page type.
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

  /// Generates the HTML `<head>` section with metadata for the webpage.
  ///
  /// This function constructs a string containing essential HTML tags such as `<title>`, `<meta>` tags for character encoding,
  /// viewport settings, Open Graph (OG) metadata, Twitter card information, and optional metadata like author, keywords,
  /// and content type. It also includes a dynamically generated stylesheet link based on the page title.
  ///
  /// The function prioritizes provided parameter values but falls back to configuration-level defaults (e.g., `self.author`,
  /// `self.keywords`) if optional parameters are either omitted or empty.
  ///
  /// - Note: The CSS filename is derived from the first part of the `pageTitle` (before any "|" character), with spaces
  ///   replaced by hyphens and converted to lowercase. For example, "My Blog | Site" becomes "my-blog.css".
  ///
  /// - Parameters:
  ///   - pageTitle: The title of the webpage, used in the `<title>` tag and Open Graph `og:title` meta tag.
  ///   - description: A brief description of the webpage content, used in `<meta name="description">` and `og:description`.
  ///   - twitter: An optional Twitter handle (without "@") for the content creator, used in `<meta name="twitter:creator">`.
  ///   - author: An optional author name for the webpage, used in `<meta name="author">`.
  ///   - keywords: An optional array of keywords for SEO, joined with commas in `<meta name="keywords">`.
  ///   - type: An optional Open Graph content type (e.g., "article", "website"), used in `<meta property="og:type">`.
  ///
  /// - Returns: A string containing the fully formatted HTML `<head>` section.
  func render(
    pageTitle: String,
    description: String,
    twitter: String? = nil,
    author: String? = nil,
    keywords: [String]? = nil,
    type: String? = nil
  ) -> String {
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
        <script src="https://unpkg.com/@tailwindcss/browser@4"></script>
      </head>
      """
  }
}
