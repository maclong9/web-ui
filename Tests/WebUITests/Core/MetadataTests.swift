import Testing

@testable import WebUI

@Suite("Metadata Tests")
struct MetadataTests {
  @Test("Metadata renders with defaults")
  func testDefaultRender() throws {
    let metadata = Metadata()
    let html = metadata.render(
      pageTitle: "Home",
      description: "Welcome",
      twitter: nil,
      author: nil,
      keywords: nil,
      type: nil
    )

    #expect(html.contains("<title>Home</title>"))
    #expect(html.contains("<meta name=\"description\" content=\"Welcome\">"))
    #expect(html.contains("<meta charset=\"UTF-8\">"))
    #expect(html.contains("<link rel=\"stylesheet\" href=\"/home.css\">"))
  }

  @Test("Metadata prioritizes page-specific values")
  func testPageSpecificValues() throws {
    let metadata = Metadata(author: "Site Author", keywords: ["site"])
    let html = metadata.render(
      pageTitle: "Test",
      description: "Desc",
      twitter: "testuser",
      author: "Page Author",
      keywords: ["page"],
      type: "article"
    )

    #expect(html.contains("<meta name=\"author\" content=\"Page Author\">"))
    #expect(html.contains("<meta name=\"keywords\" content=\"page\">"))
    #expect(html.contains("<meta name=\"twitter:creator\" content=\"@testuser\">"))
    #expect(html.contains("<meta property=\"og:type\" content=\"article\">"))
  }
}
