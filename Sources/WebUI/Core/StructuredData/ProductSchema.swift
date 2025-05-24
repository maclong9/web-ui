import Foundation

extension StructuredData {
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
            data["review"] = review.merging(["@type": "Review"]) { _, new in new
            }
        }

        return StructuredData(type: .product, data: data)
    }
}
