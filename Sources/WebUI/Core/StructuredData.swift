import Foundation

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
        StructuredData(type: type, data: data)
    }

    /// Initializes a new structured data object with the specified schema type and data.
    ///
    /// - Parameters:
    ///   - type: The schema type for the structured data.
    ///   - data: The data to include in the structured data.
    public init(type: SchemaType, data: [String: Any]) {
        self.type = type
        self.data = data
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
