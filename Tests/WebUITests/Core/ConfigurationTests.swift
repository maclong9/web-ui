import Testing

@testable import WebUI

@Suite("Configuration Tests")
struct ConfigurationTests {
  @Test("Configuration initializes with defaults")
  func testDefaultInitialization() throws {
    let config = Configuration()
    #expect(config.metadata.site == "Great Site")
    #expect(config.metadata.locale == "en")
    #expect(config.socials == nil)
  }

  @Test("Configuration accepts custom socials")
  func testCustomSocials() throws {
    let socials = [Social(label: "Twitter", url: "https://x.com/test", icon: "twitter")]
    let config = Configuration(socials: socials)
    #expect(config.socials?.count == 1)
    #expect(config.socials?[0].label == "Twitter")
  }
}
