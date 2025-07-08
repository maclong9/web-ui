import Foundation

/// Represents structured data in JSON-LD format for rich snippets in search results.
///
/// The `StructuredData` struct provides a type-safe way to define structured
/// data following various schema.org schemas like Article, Product, Organization, etc.
public struct StructuredData {
    /// The type of schema used for this structured data.
    public let type: SchemaType

    /// The raw data to be included in the structured data.
    private let data: [String: Any]

    /// Returns a copy of the raw data dictionary.
    ///
    /// - Returns: A dictionary containing the structured data properties.
    public func retrieveStructuredDataDictionary() -> [String: Any] {
        data
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
    public func convertToJsonString() -> String {
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
            options: [.withoutEscapingSlashes]
        ) {
            // Convert the data to a string
            return String(data: jsonData, encoding: .utf8) ?? ""
        }

        return ""
    }

    // MARK: - Backward Compatibility

    /// Backward compatibility alias for `retrieveStructuredDataDictionary()`.
    ///
    /// - Deprecated: Use `retrieveStructuredDataDictionary()` instead.
    /// - Returns: A dictionary containing the structured data properties.
    @available(*, deprecated, message: "Use retrieveStructuredDataDictionary() instead")
    public func getData() -> [String: Any] {
        retrieveStructuredDataDictionary()
    }

    /// Backward compatibility alias for `convertToJsonString()`.
    ///
    /// - Deprecated: Use `convertToJsonString()` instead.
    /// - Returns: A JSON string representation of the structured data.
    @available(*, deprecated, message: "Use convertToJsonString() instead")
    public func toJSON() -> String {
        convertToJsonString()
    }
}
