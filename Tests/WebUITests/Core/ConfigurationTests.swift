import Testing

@testable import WebUI

@Suite("Configuration Tests")
struct ConfigurationTests {
  @Test("Configuration initializes with defaults")
  func testDefaultInitialization() throws {
    let config = Configuration()
    #expect(config.metadata.site == "Great Site")
    #expect(config.metadata.locale == "en")
  }
}
