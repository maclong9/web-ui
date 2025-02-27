// In WebUI module
import Foundation

func validateHTML(_ htmlCode: String) async throws -> Bool {
  let url = URL(string: "https://validator.w3.org/nu/?out=json")!
  var request = URLRequest(url: url)
  request.httpMethod = "POST"
  request.setValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
  request.httpBody = htmlCode.data(using: .utf8)

  let (data, response) = try await URLSession.shared.data(for: request)

  guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
    print("HTML Validation HTTP Error: Status \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
    return false
  }

  // Debug: Print raw response
  if let jsonString = String(data: data, encoding: .utf8) {
    print("HTML Validation Response: \(jsonString)")
  }

  struct ValidationResponse: Codable {
    let messages: [Message]
    struct Message: Codable {
      let type: String
      let message: String?  // Optional, for detailed error info
    }
  }

  let decoder = JSONDecoder()
  let result = try decoder.decode(ValidationResponse.self, from: data)

  // Filter for errors only (ignore info/warnings)
  let errors = result.messages.filter { $0.type == "error" }
  if !errors.isEmpty {
    print("HTML Validation Errors: \(errors)")
    return false
  }

  print("HTML Validation Passed: No errors found")
  return true
}
