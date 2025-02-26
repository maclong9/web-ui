import Testing

@testable import WebUI

@Suite("Configuration Tests")
struct ConfigurationTests {
  @Test("Create with default values")
  func testDefaultInitialization() async throws {
    let config = Configuration()
    #expect(config.metadata.locale == "en")
  }

  @Test("Create with custom site")
  func testCustomSiteInitialization() async throws {
    let customSite = "Custom Site"
    let config = Configuration(metadata: Metadata(site: customSite))
    #expect(config.metadata.site == customSite)
  }
}
