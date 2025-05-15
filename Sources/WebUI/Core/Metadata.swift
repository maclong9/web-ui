// Metadata.swift
import Foundation

/// Defines the type of content for Open Graph metadata.
///
/// Content type affects how social media platforms and search engines categorize and display the content.
public enum ContentType: String {
  /// Standard website content type.
  case website
  /// Article or blog post content type.
  case article
  /// Video content type.
  case video
  /// Personal or organizational profile content type.
  case profile
}

/// Defines supported language locales for content.
///
/// Used to specify the language of the document for accessibility and SEO purposes.
public enum Locale: String {
  /// English locale.
  case en
  /// Spanish locale.
  case sp
  /// French locale.
  case fr
  /// German locale.
  case de
  /// Japanese locale.
  case ja
  /// Russian locale.
  case ru
}

/// Represents a theme color with optional dark mode variant.
///
/// Used to specify the browser theme color for the document, supporting both light and dark mode.
public struct ThemeColor {
  /// The color value for light mode.
  public let light: String

  /// The optional color value for dark mode.
  public let dark: String?

  /// Creates a new theme color with optional dark mode variant.
  ///
  /// - Parameters:
  ///   - light: The color value for light mode (can be any valid CSS color).
  ///   - dark: The optional color value for dark mode (can be any valid CSS color).
  ///
  /// - Example:
  ///   ```swift
  ///   let brandColor = ThemeColor("#0077ff", dark: "#3399ff")
  ///   ```
  public init(_ light: String, dark: String? = nil) {
    self.light = light
    self.dark = dark
  }
}

/// Represents favicon configuration with optional dark mode variant.
///
/// Used to specify different favicon images for light and dark mode.
public struct Favicon {
  /// The path to the favicon for light mode.
  public let light: String

  /// The optional path to the favicon for dark mode.
  public let dark: String?

  /// The type of the favicon (e.g., "image/png").
  public let type: String

  /// The size of the favicon (e.g., "32x32").
  public let size: String?

  /// Creates a new favicon configuration with optional dark mode variant.
  ///
  /// - Parameters:
  ///   - light: The path to the favicon for light mode.
  ///   - dark: The optional path to the favicon for dark mode.
  ///   - type: The MIME type of the favicon (defaults to "image/png").
  ///   - size: The size of the favicon in pixels (e.g., "32x32").
  ///
  /// - Example:
  ///   ```swift
  ///   let icon = Favicon("/icons/favicon.png", dark: "/icons/favicon-dark.png", size: "32x32")
  ///   ```
  public init(_ light: String, dark: String? = nil, type: String = "image/png", size: String? = nil) {
    self.light = light
    self.dark = dark
    self.type = type
    self.size = size
  }
}

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
  public var titleSeperator: String?

  /// A concise description of the page content.
  public var description: String

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
    "\(title ?? "")\(titleSeperator ?? "")\(site ?? "")"
  }

  /// Creates a new metadata configuration for an HTML document.
  ///
  /// - Parameters:
  ///   - site: The name of the website or application.
  ///   - title: The title of the current page.
  ///   - titleSeperator: The separator between title and site name (defaults to a space).
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
  ///     titleSeperator: " | ",
  ///     description: "A modern website built with WebUI",
  ///     author: "John Doe",
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
    titleSeperator: String? = " ",
    description: String,
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
    self.titleSeperator = titleSeperator
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
  ///   - titleSeperator: Override for the title separator.
  ///   - description: Override for the description.
  ///   - date: Override for the publication date.
  ///   - image: Override for the image URL.
  ///   - author: Override for the author name.
  ///   - keywords: Override for the keywords.
  ///   - twitter: Override for the Twitter handle.
  ///   - locale: Override for the language locale.
  ///   - type: Override for the content type.
  ///   - themeColor: Override for the theme color.
  ///
  /// - Example:
  ///   ```swift
  ///   let siteMetadata = Metadata(
  ///     site: "My Website",
  ///     titleSeperator: " | ",
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
    titleSeperator: String? = nil,
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
    self.titleSeperator = titleSeperator ?? base.titleSeperator
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
      "<meta name=\"description\" content=\"\(description)\">",
      "<meta property=\"og:description\" content=\"\(description)\">",
      "<meta property=\"og:type\" content=\"\(type.rawValue)\">",
      "<meta name=\"twitter:card\" content=\"summary_large_image\">",
    ]

    if let image, !image.isEmpty {
      baseTags.append("<meta property=\"og:image\" content=\"\(image)\">")
    }
    if let author, !author.isEmpty {
      baseTags.append("<meta name=\"author\" content=\"\(author)\">")
    }
    if let twitter, !twitter.isEmpty {
      baseTags.append("<meta name=\"twitter:creator\" content=\"@\(twitter)\">")
    }
    if let keywords, !keywords.isEmpty {
      baseTags.append(
        "<meta name=\"keywords\" content=\"\(keywords.joined(separator: ", "))\">"
      )
    }
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

    if let favicons {
      for favicon in favicons {
        let sizeAttr = favicon.size.map { " sizes=\"\($0)\"" } ?? ""

        if favicon.dark != nil {
          baseTags.append(
            "<link rel=\"icon\" type=\"\(favicon.type)\" href=\"\(favicon.light)\"\(sizeAttr) media=\"(prefers-color-scheme: light)\">"
          )
          baseTags.append(
            "<link rel=\"icon\" type=\"\(favicon.type)\" href=\"\(favicon.dark!)\"\(sizeAttr) media=\"(prefers-color-scheme: dark)\">"
          )
        } else {
          baseTags.append(
            "<link rel=\"icon\" type=\"\(favicon.type)\" href=\"\(favicon.light)\"\(sizeAttr)>"
          )
        }

        // Add Apple touch icon if this is a PNG and has a size
        if favicon.type == "image/png", let size = favicon.size {
          baseTags.append(
            "<link rel=\"apple-touch-icon\" sizes=\"\(size)\" href=\"\(favicon.light)\">"
          )
        }
      }
    }

    // Add structured data if available
    if let structuredData = structuredData {
      let jsonString = structuredData.toJSON()
      if !jsonString.isEmpty {
        baseTags.append(
          "<script type=\"application/ld+json\">\n\(jsonString)\n</script>"
        )
      }
    }

    return baseTags
  }
}

/// Represents structured data in JSON-LD format for rich snippets in search results.
///
/// The `StructuredData` struct provides a type-safe way to define structured data
/// following various schema.org schemas like Article, Product, Organization, etc.
public struct StructuredData {

  /// The schema type for the structured data.
  public enum SchemaType: String {
    case article = "Article"
    case blogPosting = "BlogPosting"
    case breadcrumbList = "BreadcrumbList"
    case course = "Course"
    case event = "Event"
    case faqPage = "FAQPage"
    case howTo = "HowTo"
    case localBusiness = "LocalBusiness"
    case organization = "Organization"
    case person = "Person"
    case product = "Product"
    case recipe = "Recipe"
    case review = "Review"
    case website = "WebSite"
  }

  /// The type of schema used for this structured data.
  public let type: SchemaType

  /// The raw data to be included in the structured data.
  private let data: [String: Any]

  /// Creates structured data for an Article.
  ///
  /// - Parameters:
  ///   - headline: The title of the article.
  ///   - image: The URL to the featured image of the article.
  ///   - author: The name or URL of the author.
  ///   - publisher: The name or URL of the publisher.
  ///   - datePublished: The date the article was published.
  ///   - dateModified: The date the article was last modified.
  ///   - description: A short description of the article content.
  ///   - url: The URL of the article.
  /// - Returns: A structured data object for an article.
  ///
  /// - Example:
  ///   ```swift
  ///   let articleData = StructuredData.article(
  ///     headline: "How to Use WebUI",
  ///     image: "https://example.com/images/article.jpg",
  ///     author: "John Doe",
  ///     publisher: "WebUI Blog",
  ///     datePublished: Date(),
  ///     description: "A guide to using WebUI for Swift developers"
  ///   )
  ///   ```
  public static func article(
    headline: String,
    image: String,
    author: String,
    publisher: String,
    datePublished: Date,
    dateModified: Date? = nil,
    description: String? = nil,
    url: String? = nil
  ) -> StructuredData {
    var data: [String: Any] = [
      "headline": headline,
      "image": image,
      "author": ["@type": "Person", "name": author],
      "publisher": ["@type": "Organization", "name": publisher],
      "datePublished": ISO8601DateFormatter().string(from: datePublished),
    ]

    if let dateModified = dateModified {
      data["dateModified"] = ISO8601DateFormatter().string(from: dateModified)
    }

    if let description = description {
      data["description"] = description
    }

    if let url = url {
      data["url"] = url
    }

    return StructuredData(type: .article, data: data)
  }

  /// Creates structured data for a product.
  ///
  /// - Parameters:
  ///   - name: The name of the product.
  ///   - image: The URL to the product image.
  ///   - description: A description of the product.
  ///   - sku: The Stock Keeping Unit identifier.
  ///   - brand: The brand name of the product.
  ///   - offers: The offer details (price, availability, etc.).
  ///   - review: Optional review information.
  /// - Returns: A structured data object for a product.
  ///
  /// - Example:
  ///   ```swift
  ///   let productData = StructuredData.product(
  ///     name: "Swift WebUI Course",
  ///     image: "https://example.com/images/course.jpg",
  ///     description: "Master WebUI development with Swift",
  ///     sku: "WEBUI-101",
  ///     brand: "Swift Academy",
  ///     offers: ["price": "99.99", "priceCurrency": "USD", "availability": "InStock"]
  ///   )
  ///   ```
  public static func product(
    name: String,
    image: String,
    description: String,
    sku: String,
    brand: String,
    offers: [String: Any],
    review: [String: Any]? = nil
  ) -> StructuredData {
    var data: [String: Any] = [
      "name": name,
      "image": image,
      "description": description,
      "sku": sku,
      "brand": ["@type": "Brand", "name": brand],
      "offers": offers.merging(["@type": "Offer"]) { _, new in new },
    ]

    if let review = review {
      data["review"] = review.merging(["@type": "Review"]) { _, new in new }
    }

    return StructuredData(type: .product, data: data)
  }

  /// Creates structured data for an organization.
  ///
  /// - Parameters:
  ///   - name: The name of the organization.
  ///   - logo: The URL to the organization's logo.
  ///   - url: The URL of the organization's website.
  ///   - contactPoint: Optional contact information.
  ///   - sameAs: Optional array of URLs that also represent the entity.
  /// - Returns: A structured data object for an organization.
  ///
  /// - Example:
  ///   ```swift
  ///   let orgData = StructuredData.organization(
  ///     name: "WebUI Technologies",
  ///     logo: "https://example.com/logo.png",
  ///     url: "https://example.com",
  ///     sameAs: ["https://twitter.com/webui", "https://github.com/webui"]
  ///   )
  ///   ```
  public static func organization(
    name: String,
    logo: String,
    url: String,
    contactPoint: [String: Any]? = nil,
    sameAs: [String]? = nil
  ) -> StructuredData {
    var data: [String: Any] = [
      "name": name,
      "logo": logo,
      "url": url,
    ]

    if let contactPoint = contactPoint {
      data["contactPoint"] = contactPoint.merging(["@type": "ContactPoint"]) { _, new in new }
    }

    if let sameAs = sameAs {
      data["sameAs"] = sameAs
    }

    return StructuredData(type: .organization, data: data)
  }

  /// Creates structured data for a FAQ page.
  ///
  /// - Parameter questions: Array of question-answer pairs.
  /// - Returns: A structured data object for a FAQ page.
  ///
  /// - Example:
  ///   ```swift
  ///   let faqData = StructuredData.faqPage([
  ///     ["question": "What is WebUI?", "answer": "WebUI is a Swift framework for building web interfaces."],
  ///     ["question": "Is it open source?", "answer": "Yes, WebUI is available under the MIT license."]
  ///   ])
  ///   ```
  public static func faqPage(_ questions: [[String: String]]) -> StructuredData {
    let mainEntity = questions.map { question in
      return [
        "@type": "Question",
        "name": question["question"] ?? "",
        "acceptedAnswer": [
          "@type": "Answer",
          "text": question["answer"] ?? "",
        ],
      ]
    }

    return StructuredData(type: .faqPage, data: ["mainEntity": mainEntity])
  }

  /// Creates structured data for breadcrumbs navigation.
  ///
  /// - Parameter items: Array of breadcrumb items with name, item (URL), and position.
  /// - Returns: A structured data object for breadcrumbs navigation.
  ///
  /// - Example:
  ///   ```swift
  ///   let breadcrumbsData = StructuredData.breadcrumbs([
  ///     ["name": "Home", "item": "https://example.com", "position": 1],
  ///     ["name": "Blog", "item": "https://example.com/blog", "position": 2],
  ///     ["name": "Article Title", "item": "https://example.com/blog/article", "position": 3]
  ///   ])
  ///   ```
  public static func breadcrumbs(_ items: [[String: Any]]) -> StructuredData {
    let itemListElements = items.map { item in
      var element: [String: Any] = ["@type": "ListItem"]

      if let name = item["name"] as? String {
        element["name"] = name
      }

      if let itemUrl = item["item"] as? String {
        element["item"] = itemUrl
      }

      if let position = item["position"] as? Int {
        element["position"] = position
      }

      return element
    }

    return StructuredData(type: .breadcrumbList, data: ["itemListElement": itemListElements])
  }

  /// Creates a custom structured data object with the specified schema type and data.
  ///
  /// - Parameters:
  ///   - type: The schema type for the structured data.
  ///   - data: The data to include in the structured data.
  /// - Returns: A structured data object with the specified type and data.
  ///
  /// - Example:
  ///   ```swift
  ///   let customData = StructuredData.custom(
  ///     type: .review,
  ///     data: [
  ///       "itemReviewed": ["@type": "Product", "name": "WebUI Framework"],
  ///       "reviewRating": ["@type": "Rating", "ratingValue": "5"],
  ///       "author": ["@type": "Person", "name": "Jane Developer"]
  ///     ]
  ///   )
  ///   ```
  public static func custom(type: SchemaType, data: [String: Any]) -> StructuredData {
    return StructuredData(type: type, data: data)
  }

  /// Converts the structured data to a JSON string.
  ///
  /// - Returns: A JSON string representation of the structured data, or an empty string if serialization fails.
  public func toJSON() -> String {
    var jsonObject: [String: Any] = [
      "@context": "https://schema.org",
      "@type": type.rawValue,
    ]

    // Merge the data dictionary with the base JSON object
    for (key, value) in data {
      jsonObject[key] = value
    }

    // Try to serialize the JSON object to data
    if let jsonData = try? JSONSerialization.data(
      withJSONObject: jsonObject,
      options: [.prettyPrinted, .withoutEscapingSlashes]
    ) {
      // Convert the data to a string
      return String(data: jsonData, encoding: .utf8) ?? ""
    }

    return ""
  }
}
