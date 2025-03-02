import Foundation
import JavaScriptCore
import Testing

@testable import WebUI

@Suite("Code Validation Test") struct CodeValidationTests {
  @Test("Code Validation Tests")
  func testCodeValidation() {
    #expect(validateJS("function test() { return 1 + 2; }"))
    #expect(!validateJS("function test() { return 1 + ; }"))
  }
}
