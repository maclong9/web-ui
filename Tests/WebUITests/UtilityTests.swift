import Foundation
import Testing

@testable import WebUI

@Suite("Utility Tests") struct DateTests {
    @Test("String path formatting")
    func stringPathFormatting() {
        // Test basic string formatting
        let basicString = "Hello World"
        #expect(basicString.pathFormatted() == "hello-world")

        // Test string with mixed case and special characters
        let complexString = "Hello, World! 123 @#$"
        #expect(complexString.pathFormatted() == "hello-world-123")

        // Test string with multiple spaces
        let spacedString = "Multiple   Spaces   Here"
        #expect(spacedString.pathFormatted() == "multiple-spaces-here")

        // Test empty string
        let emptyString = ""
        #expect(emptyString.pathFormatted() == "")

        // Test string with only special characters
        let specialChars = "!@#$%^&*()"
        #expect(specialChars.pathFormatted() == "")

        // Test string with numbers and letters
        let alphanumeric = "Test123String"
        #expect(alphanumeric.pathFormatted() == "test123string")
    }

    @Test("Formatted year returns correctly")
    func testFormatAsYear() throws {
        // Test with given date
        let date = Date(timeIntervalSince1970: 1_677_657_600)  // Feb 28, 2023
        let year = date.formatAsYear()
        #expect(year == "2023")

        // Test with current date
        let currentYear = Date().formatAsYear()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let expected = formatter.string(from: Date())
        #expect(currentYear == expected)
    }
}
