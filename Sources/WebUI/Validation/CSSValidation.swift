import Foundation

func validateCSS(_ cssCode: String) async throws -> Bool {
  let encodedCSS = cssCode.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
  guard let url = URL(string: "https://jigsaw.w3.org/css-validator/validator?output=json&text=\(encodedCSS)") else {
    print("CSS Validation Error: Invalid URL")
    return false
  }

  let (data, response) = try await URLSession.shared.data(from: url)

  // Properly scope httpResponse
  guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
    print("CSS Validation HTTP Error: Status \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
    return false
  }

  // Debug: Print raw response
  if let jsonString = String(data: data, encoding: .utf8) {
    print("CSS Validation Response: \(jsonString)")
  }

  struct ValidationResponse: Codable {
    let cssvalidation: CSSValidation
    struct CSSValidation: Codable {
      let validity: Bool
      let errors: [Error]?
      let warnings: [Warning]?

      struct Error: Codable {
        let message: String
        let line: Int?
        let type: String?
      }

      struct Warning: Codable {
        let message: String
        let line: Int?
      }
    }
  }

  let decoder = JSONDecoder()
  let result = try decoder.decode(ValidationResponse.self, from: data)

  if let errors = result.cssvalidation.errors, !errors.isEmpty {
    print("CSS Validation Errors: \(errors)")
  }
  if let warnings = result.cssvalidation.warnings, !warnings.isEmpty {
    print("CSS Validation Warnings: \(warnings)")
  }

  return result.cssvalidation.validity
}
