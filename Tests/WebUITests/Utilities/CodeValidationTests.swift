import Foundation
import JavaScriptCore
import Testing

@testable import WebUI

@Suite("Code Validation Test") struct CodeValidationTests {
  @Test("Code Validation Tests")
  func testCodeValidation() async throws {
    // JS Validation
    #expect(validateJS("function test() { return 1 + 2; }"))
    #expect(!validateJS("function test() { return 1 + ; }"))

    // HTML Validation
    let validHTMLResult = try await validateHTML(
      "<!DOCTYPE html><html lang=\"en\"><head><title>Hello, world!</title></head><body><h1>Hello</h1></body></html>")
    let invalidHTMLResult = try await validateHTML("<html><body><h1>Hello</body></h1></html>")
    #expect(validHTMLResult)
    #expect(!invalidHTMLResult)

    // CSS Validation
    let validCSSResult = try await validateCSS("body { color: blue; }")
    let invalidCSSResult = try await validateCSS("body color:; }")
    #expect(validCSSResult)
    #expect(!invalidCSSResult)
  }
}
