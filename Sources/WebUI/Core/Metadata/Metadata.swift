import Foundation

/// Represents metadata for an HTML document including SEO and social media properties.
///
/// The `Metadata` struct encapsulates all the metadata that can be included in the `<head>` section
/// of an HTML document, such as title, description, Open Graph tags, and Twitter card information.
/// It also supports structured data for enhanced SEO and rich snippets in search results.
public struct Metadata {
    /// The name of the website or application.
    public var site: String?
    /// The title of the current page.
    public var title: String?
    /// The separator between the title and site name (e.g., " - " or " | ").
    public var titleSeparator: String?
    /// A concise description of the page content.
    public var description: String?
    /// The publication date of the content.
    public var date: Date?
    /// URL to an image representing the content (for social media sharing).
    public var image: String?
    /// The name of the content author.
    public var author: String?
    /// Keywords relevant to the content for SEO.
    public var keywords: [String]?
    /// Twitter handle for attribution without the @ symbol.
    public var twitter: String?
    /// The language locale of the content.
    public var locale: Locale
    /// The type of content for Open Graph categorization.
    public var type: ContentType
    /// The browser theme color for the document.
    public var themeColor: ThemeColor?
    /// The favicons for the document, supporting different sizes and modes.
    public var favicons: [Favicon]?
    /// The structured data for the document in JSON-LD format.
    public var structuredData: StructuredData?

    /// The fully formatted page title combining the title, separator, and site name.
    ///
    /// - Returns: A string combining the title, separator, and site name, handling nil values appropriately.
    public var pageTitle: String {
        let titlePart = title ?? ""
        let sitePart = site ?? ""
        
        // Only include separator if both title and site are present
        if !titlePart.isEmpty && !sitePart.isEmpty {
            return "\(titlePart)\(titleSeparator ?? "")\(sitePart)"
        } else if !titlePart.isEmpty {
            return titlePart
        } else if !sitePart.isEmpty {
            return sitePart
        } else {
            return ""
        }
    }

    /// Creates a new metadata configuration for an HTML document.
    ///
    /// - Parameters:
    ///   - site: The name of the website or application.
    ///   - title: The title of the current page.
    ///   - titleSeparator: The separator between title and site name (defaults to a space).
    ///   - description: A concise description of the page content.
    ///   - date: The publication date of the content.
    ///   - image: URL to an image representing the content.
    ///   - author: The name of the content author.
    ///   - keywords: Keywords relevant to the content for SEO.
    ///   - twitter: Twitter handle for attribution (without the @ symbol).
    ///   - locale: The language locale of the content (defaults to English).
    ///   - type: The type of content (defaults to "website").
    ///   - themeColor: The browser theme color for the document.
    ///   - favicons: The favicons for the document in various sizes and for different modes.
    ///   - structuredData: The structured data for the document in JSON-LD format.
    ///
    /// - Example:
    ///   ```swift
    ///   let pageMetadata = Metadata(
    ///     site: "My Website",
    ///     title: "Welcome",
    ///     titleSeparator: " | ",
    ///     description: "A modern website built with WebUI",
    ///     author: "Jane Doe",
    ///     keywords: ["swift", "web", "ui"],
    ///     locale: .en,
    ///     themeColor: ThemeColor("#3366ff"),
    ///     favicons: [
    ///       Favicon("/favicon.png", dark: "/favicon-dark.png", size: "32x32"),
    ///       Favicon("/favicon.ico")
    ///     ]
    ///   )
    ///   ```
    public init(
        site: String? = nil,
        title: String? = nil,
        titleSeparator: String? = " ",
        description: String? = nil,
        date: Date? = nil,
        image: String? = nil,
        author: String? = nil,
        keywords: [String]? = nil,
        twitter: String? = nil,
        locale: Locale = .en,
        type: ContentType = .website,
        themeColor: ThemeColor? = nil,
        favicons: [Favicon]? = nil,
        structuredData: StructuredData? = nil
    ) {
        self.site = site
        self.title = title
        self.titleSeparator = titleSeparator
        self.description = description
        self.date = date
        self.image = image
        self.author = author
        self.keywords = keywords
        self.twitter = twitter
        self.locale = locale
        self.type = type
        self.themeColor = themeColor
        self.favicons = favicons
        self.structuredData = structuredData
    }

    /// Creates a new metadata configuration by extending an existing one.
    ///
    /// This initializer allows creating a new metadata instance that inherits values from a base
    /// instance while selectively overriding specific properties. This is useful for creating page-specific
    /// metadata that inherits site-wide defaults.
    ///
    /// - Parameters:
    ///   - base: The base metadata to inherit values from.
    ///   - site: Override for the website name.
    ///   - title: Override for the page title.
    ///   - titleSeparator: Override for the title separator.
    ///   - description: Override for the description.
    ///   - date: Override for the publication date.
    ///   - image: Override for the image URL.
    ///   - author: Override for the author name.
    ///   - keywords: Override for the keywords.
    ///   - twitter: Override for the Twitter handle.
    ///   - locale: Override for the language locale.
    ///   - type: Override for the content type.
    ///   - themeColor: Override for the theme color.
    ///   - favicons: Override for the favicons.
    ///   - structuredData: Override for the structured data.
    ///
    /// - Example:
    ///   ```swift
    ///   let siteMetadata = Metadata(
    ///     site: "My Website",
    ///     titleSeparator: " | ",
    ///     description: "A website about Swift"
    ///   )
    ///
    ///   let pageMetadata = Metadata(
    ///     from: siteMetadata,
    ///     title: "Blog Post",
    ///     description: "A specific blog post about WebUI",
    ///     date: Date()
    ///   )
    ///   ```
    public init(
        from base: Metadata,
        site: String? = nil,
        title: String? = nil,
        titleSeparator: String? = nil,
        description: String? = nil,
        date: Date? = nil,
        image: String? = nil,
        author: String? = nil,
        keywords: [String]? = nil,
        twitter: String? = nil,
        locale: Locale? = nil,
        type: ContentType? = nil,
        themeColor: ThemeColor? = nil,
        favicons: [Favicon]? = nil,
        structuredData: StructuredData? = nil
    ) {
        self.site = site ?? base.site
        self.title = title ?? base.title
        self.titleSeparator = titleSeparator ?? base.titleSeparator
        self.description = description ?? base.description
        self.date = date ?? base.date
        self.image = image ?? base.image
        self.author = author ?? base.author
        self.keywords = keywords ?? base.keywords
        self.twitter = twitter ?? base.twitter
        self.locale = locale ?? base.locale
        self.type = type ?? base.type
        self.themeColor = themeColor ?? base.themeColor
        self.favicons = favicons ?? base.favicons
        self.structuredData = structuredData ?? base.structuredData
    }

    /// Generates HTML meta tags from the metadata.
    ///
    /// This property converts the metadata into an array of HTML meta tag strings
    /// ready to be inserted into the document's head section, including Open Graph,
    /// Twitter card, and standard meta tags.
    ///
    /// - Returns: An array of HTML meta tag strings.
    ///
    /// - Note: This includes basic SEO tags, social media sharing tags, and theme color
    ///   tags with appropriate media queries for dark mode support when applicable.
    var tags: [String] {
        var baseTags: [String] = [
            "<meta property=\"og:title\" content=\"\(pageTitle)\">",
            "<meta property=\"og:type\" content=\"\(type.rawValue)\">",
            "<meta name=\"twitter:card\" content=\"summary_large_image\">",
        ]
        // Description
        if let description, !description.isEmpty {
            baseTags.append(
                "<meta name=\"description\" content=\"\(description)\">")
            baseTags.append(
                "<meta property=\"og:description\" content=\"\(description)\">")
        }
        // Image
        if let image, !image.isEmpty {
            baseTags.append("<meta property=\"og:image\" content=\"\(image)\">")
        }
        // Author
        if let author, !author.isEmpty {
            baseTags.append("<meta name=\"author\" content=\"\(author)\">")
        }
        // Twitter
        if let twitter, !twitter.isEmpty {
            baseTags.append(
                "<meta name=\"twitter:creator\" content=\"@\(twitter)\">")
        }
        // Keywords
        if let keywords, !keywords.isEmpty {
            baseTags.append(
                "<meta name=\"keywords\" content=\"\(keywords.joined(separator: ", "))\">"
            )
        }
        // Theme Color
        if let themeColor {
            baseTags.append(
                "<meta name=\"theme-color\" content=\"\(themeColor.light)\" \(themeColor.dark != nil ? "media=\"(prefers-color-scheme: light)\"" : "")>"
            )
            if let themeDark = themeColor.dark {
                baseTags.append(
                    "<meta name=\"theme-color\" content=\"\(themeDark)\" media=\"(prefers-color-scheme: dark)\">"
                )
            }
        }
        // Favicons
        if let favicons {
            for favicon in favicons {
                let sizeAttr = favicon.size.map { " sizes=\"\($0)\"" } ?? ""

                if favicon.dark != nil {
                    baseTags.append(
                        "<link rel=\"icon\" type=\"\(favicon.type.rawValue)\" href=\"\(favicon.light)\"\(sizeAttr) media=\"(prefers-color-scheme: light)\">"
                    )
                    baseTags.append(
                        "<link rel=\"icon\" type=\"\(favicon.type.rawValue)\" href=\"\(favicon.dark!)\"\(sizeAttr) media=\"(prefers-color-scheme: dark)\">"
                    )
                } else {
                    baseTags.append(
                        "<link rel=\"icon\" type=\"\(favicon.type.rawValue)\" href=\"\(favicon.light)\"\(sizeAttr)>"
                    )
                }
                if favicon.type == .png, let size = favicon.size {
                    baseTags.append(
                        "<link rel=\"apple-touch-icon\" sizes=\"\(size)\" href=\"\(favicon.light)\">"
                    )
                }
            }
        }
        // Structured Data
        if let structuredData = structuredData {
            let jsonString = structuredData.convertToJsonString()
            if !jsonString.isEmpty {
                baseTags.append(
                    "<script type=\"application/ld+json\">\n\(jsonString)\n</script>"
                )
            }
        }
        return baseTags
    }
}
