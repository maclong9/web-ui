import Testing

@testable import WebUI

@Suite("HTML Tests") struct HTMLTests {
  @Test("String renders as HTML directly")
  func testStringRender() throws {
    let string: String = "Hello, World!"
    let html = string.render()
    #expect(html == "Hello, World!")
  }
}
