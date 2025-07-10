import Foundation

extension StructuredData {
  /// Creates structured data for a person.
  ///
  /// - Parameters:
  ///   - name: The name of the person.
  ///   - givenName: The given (first) name of the person.
  ///   - familyName: The family (last) name of the person.
  ///   - image: The URL to an image of the person.
  ///   - jobTitle: The person's job title.
  ///   - email: The person's email address.
  ///   - telephone: The person's telephone number.
  ///   - webAddress: The web address of the person's website or profile.
  ///   - address: Optional address information.
  ///   - birthDate: The person's date of birth.
  ///   - sameAs: Optional array of URLs that also represent the person (social profiles).
  /// - Returns: A structured data object for a person.
  ///
  /// - Example:
  ///   ```swift
  ///   let personData = StructuredData.person(
  ///     name: "Jane Doe",
  ///     givenName: "Jane",
  ///     familyName: "Doe",
  ///     jobTitle: "Software Engineer",
  ///     webAddress: "https://janedoe.com",
  ///     sameAs: ["https://twitter.com/janedoe", "https://github.com/janedoe"]
  ///   )
  ///   ```
  public static func person(
    name: String,
    givenName: String? = nil,
    familyName: String? = nil,
    image: String? = nil,
    jobTitle: String? = nil,
    email: String? = nil,
    telephone: String? = nil,
    webAddress: String? = nil,
    address: [String: Any]? = nil,
    birthDate: Date? = nil,
    sameAs: [String]? = nil
  ) -> StructuredData {
    var data: [String: Any] = [
      "name": name
    ]

    if let givenName = givenName {
      data["givenName"] = givenName
    }

    if let familyName = familyName {
      data["familyName"] = familyName
    }

    if let image = image {
      data["image"] = image
    }

    if let jobTitle = jobTitle {
      data["jobTitle"] = jobTitle
    }

    if let email = email {
      data["email"] = email
    }

    if let telephone = telephone {
      data["telephone"] = telephone
    }

    if let webAddress = webAddress {
      data["url"] = webAddress
    }

    if let address = address {
      data["address"] = address.merging(["@type": "PostalAddress"]) {
        _, new in
        new
      }
    }

    if let birthDate = birthDate {
      data["birthDate"] = ISO8601DateFormatter().string(from: birthDate)
    }

    if let sameAs = sameAs {
      data["sameAs"] = sameAs
    }

    return StructuredData(type: .person, data: data)
  }
}
