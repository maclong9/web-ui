import Foundation

extension StructuredData {
  /// Creates structured data for an organization.
  ///
  /// - Parameters:
  ///   - name: The name of the organization.
  ///   - logo: The URL to the organization's logo.
  ///   - webAddress: The web address of the organization's website.
  ///   - contactPoint: Optional contact information.
  ///   - sameAs: Optional array of URLs that also represent the entity.
  /// - Returns: A structured data object for an organization.
  ///
  /// - Example:
  ///   ```swift
  ///   let orgData = StructuredData.organization(
  ///     name: "WebUI Technologies",
  ///     logo: "https://example.com/logo.png",
  ///     webAddress: "https://example.com",
  ///     sameAs: ["https://twitter.com/webui", "https://github.com/webui"]
  ///   )
  ///   ```
  public static func organization(
    name: String,
    logo: String,
    webAddress: String,
    contactPoint: [String: Any]? = nil,
    sameAs: [String]? = nil
  ) -> StructuredData {
    var data: [String: Any] = [
      "name": name,
      "logo": logo,
      "url": webAddress,
    ]

    if let contactPoint = contactPoint {
      data["contactPoint"] = contactPoint.merging([
        "@type": "ContactPoint"
      ]) {
        _, new in new
      }
    }

    if let sameAs = sameAs {
      data["sameAs"] = sameAs
    }

    return StructuredData(type: .organization, data: data)
  }
}
