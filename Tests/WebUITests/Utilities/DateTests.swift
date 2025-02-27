import Foundation
import Testing

@testable import WebUI

@Suite("Date Tests")
struct DateTests {
  @Test("Formatted year returns correct string")
  func testFormattedYear() throws {
    let date = Date(timeIntervalSince1970: 1677657600)  // Feb 28, 2023
    let year = date.formattedYear()
    #expect(year == "2023")
  }

  @Test("Formatted year works for current date")
  func testCurrentDate() throws {
    let currentYear = Date().formattedYear()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    let expected = formatter.string(from: Date())
    #expect(currentYear == expected)
  }
}
