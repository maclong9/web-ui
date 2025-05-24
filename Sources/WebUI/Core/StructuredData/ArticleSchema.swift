import Foundation

extension StructuredData {
    /// Creates structured data for an Article.
    ///
    /// - Parameters:
    ///   - headline: The title of the article.
    ///   - image: The URL to the featured image of the article.
    ///   - author: The name or URL of the author.
    ///   - publisher: Optional publisher, either as a StructuredData person or organization, or as a String name.
    ///   - datePublished: The date the article was published.
    ///   - dateModified: The date the article was last modified.
    ///   - description: A short description of the article content.
    ///   - url: The URL of the article.
    /// - Returns: A structured data object for an article.
    ///
    /// - Example:
    ///   ```swift
    ///   // Using a String for publisher
    ///   let articleData = StructuredData.article(
    ///     headline: "How to Use WebUI",
    ///     image: "https://example.com/images/article.jpg",
    ///     author: "John Doe",
    ///     publisher: "WebUI Blog",
    ///     datePublished: Date(),
    ///     description: "A guide to using WebUI for Swift developers"
    ///   )
    ///
    ///   // Using a StructuredData organization as publisher
    ///   let orgPublisher = StructuredData.organization(
    ///     name: "WebUI Technologies",
    ///     logo: "https://example.com/logo.png",
    ///     url: "https://example.com"
    ///   )
    ///
    ///   let articleWithOrg = StructuredData.article(
    ///     headline: "How to Use WebUI",
    ///     image: "https://example.com/images/article.jpg",
    ///     author: "John Doe",
    ///     publisher: orgPublisher,
    ///     datePublished: Date(),
    ///     description: "A guide to using WebUI for Swift developers"
    ///   )
    ///
    ///   // Without a publisher
    ///   let minimalArticle = StructuredData.article(
    ///     headline: "Quick Tips",
    ///     image: "https://example.com/images/tips.jpg",
    ///     author: "Alex Developer",
    ///     datePublished: Date()
    ///   )
    ///   ```
    ///
    /// - Note: For more control over the publisher entity, use the overloaded version
    ///   of this method that accepts a StructuredData object as the publisher parameter.
    public static func article(
        headline: String,
        image: String,
        author: String,
        publisher: Any? = nil,
        datePublished: Date,
        dateModified: Date? = nil,
        description: String? = nil,
        url: String? = nil
    ) -> StructuredData {
        var data: [String: Any] = [
            "headline": headline,
            "image": image,
            "author": ["@type": "Person", "name": author],
            "datePublished": ISO8601DateFormatter().string(from: datePublished),
        ]

        // Handle different publisher types
        if let publisher = publisher {
            if let publisherName = publisher as? String {
                data["publisher"] = ["@type": "Organization", "name": publisherName]
            } else if let publisherData = publisher as? StructuredData {
                if publisherData.type == .organization || publisherData.type == .person {
                    // Extract the raw data from the structured data object
                    let publisherDict = publisherData.getData()
                    var typeDict = publisherDict
                    typeDict["@type"] = publisherData.type.rawValue
                    data["publisher"] = typeDict
                }
            }
        }

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

    /// Creates structured data for an Article with a StructuredData publisher.
    ///
    /// - Parameters:
    ///   - headline: The title of the article.
    ///   - image: The URL to the featured image of the article.
    ///   - author: The name or URL of the author.
    ///   - publisher: Optional StructuredData object representing the publisher as a person or organization.
    ///   - datePublished: The date the article was published.
    ///   - dateModified: The date the article was last modified.
    ///   - description: A short description of the article content.
    ///   - url: The URL of the article.
    /// - Returns: A structured data object for an article.
    ///
    /// - Example:
    ///   ```swift
    ///   // Using an organization as publisher
    ///   let organization = StructuredData.organization(
    ///     name: "WebUI Technologies",
    ///     logo: "https://example.com/logo.png",
    ///     url: "https://example.com"
    ///   )
    ///
    ///   let articleWithOrg = StructuredData.article(
    ///     headline: "How to Use WebUI",
    ///     image: "https://example.com/images/article.jpg",
    ///     author: "John Doe",
    ///     publisher: organization,
    ///     datePublished: Date(),
    ///     description: "A guide to using WebUI for Swift developers"
    ///   )
    ///
    ///   // Using a person as publisher
    ///   let personPublisher = StructuredData.person(
    ///     name: "Jane Doe",
    ///     url: "https://janedoe.com"
    ///   )
    ///
    ///   let articleWithPerson = StructuredData.article(
    ///     headline: "My WebUI Journey",
    ///     image: "https://example.com/images/journey.jpg",
    ///     author: "John Smith",
    ///     publisher: personPublisher,
    ///     datePublished: Date(),
    ///     description: "Personal experiences with WebUI framework"
    ///   )
    ///
    ///   // Without a publisher
    ///   let minimalArticle = StructuredData.article(
    ///     headline: "Quick Tips",
    ///     image: "https://example.com/images/tips.jpg",
    ///     author: "Alex Developer",
    ///     datePublished: Date()
    ///   )
    ///   ```
    public static func article(
        headline: String,
        image: String,
        author: String,
        publisher: StructuredData?,
        datePublished: Date,
        dateModified: Date? = nil,
        description: String? = nil,
        url: String? = nil
    ) -> StructuredData {
        var data: [String: Any] = [
            "headline": headline,
            "image": image,
            "author": ["@type": "Person", "name": author],
            "datePublished": ISO8601DateFormatter().string(from: datePublished),
        ]

        if let publisher = publisher {
            if publisher.type == .organization || publisher.type == .person {
                // Extract the raw data from the structured data object
                let publisherDict = publisher.getData()
                var typeDict = publisherDict
                typeDict["@type"] = publisher.type.rawValue
                data["publisher"] = typeDict
            }
        }

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
}
