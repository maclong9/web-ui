import Testing

@testable import WebUI

@Suite("Layout Tests")
struct LayoutTests {
  @Test("Layout initializes with defaults")
  func testDefaultInitialization() throws {
    let layout = Layout()
    #expect(layout.navigation.isEmpty)
    #expect(layout.sitemap.isEmpty)
    #expect(layout.header == .normal)
    #expect(layout.footer == .normal)
  }

  @Test("Sitemap combines navigation and additional routes")
  func testSitemapGeneration() throws {
    let nav = [Route(label: "Home", path: "/")]
    let sitemap = [Route(label: "About", path: "/about")]
    let layout = Layout(navigation: nav, sitemap: sitemap)

    #expect(layout.sitemap.count == 2)
    #expect(layout.sitemap[0].label == "Home")
    #expect(layout.sitemap[1].label == "About")
  }
}
