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
    #expect(!html.contains("<meta name=\"author\""))
    #expect(!html.contains("<meta name=\"twitter:creator\""))
    #expect(!html.contains("<meta name=\"keywords\""))
    #expect(!html.contains("<meta property=\"og:type\""))
    #expect(html.contains("<link rel=\"stylesheet\" href=\"/home.css\">"))
  }

  @Test("Metadata prioritizes page-specific values")
  func testPageSpecificValues() throws {
    let metadata = Metadata(author: "Site Author", keywords: ["site"], twitter: "siteuser", type: "website")
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
    #expect(!html.contains("Site Author"))
    #expect(!html.contains("siteuser"))
    #expect(!html.contains("site"))
    #expect(!html.contains("website"))
  }

  @Test("Metadata falls back to site-wide values when page-specific are nil")
  func testFallbackToSiteWide() throws {
    let metadata = Metadata(author: "Site Author", keywords: ["site", "wide"], twitter: "siteuser", type: "website")
    let html = metadata.render(
      pageTitle: "Test",
      description: "Desc",
      twitter: nil,
      author: nil,
      keywords: nil,
      type: nil
    )

    #expect(html.contains("<meta name=\"author\" content=\"Site Author\">"))
    #expect(html.contains("<meta name=\"keywords\" content=\"site, wide\">"))
    #expect(html.contains("<meta name=\"twitter:creator\" content=\"@siteuser\">"))
    #expect(html.contains("<meta property=\"og:type\" content=\"website\">"))
  }

  @Test("Metadata omits optional tags when both site-wide and page-specific are empty or nil")
  func testEmptyValues() throws {
    let metadata = Metadata(author: "", keywords: [], twitter: "", type: "")
    let html = metadata.render(
      pageTitle: "Test",
      description: "Desc",
      twitter: "",
      author: "",
      keywords: [],
      type: ""
    )

    #expect(!html.contains("<meta name=\"author\""))
    #expect(!html.contains("<meta name=\"keywords\""))
    #expect(!html.contains("<meta name=\"twitter:creator\""))
    #expect(!html.contains("<meta property=\"og:type\""))
  }

  @Test("Metadata handles mixed nil and empty page-specific values with site-wide fallbacks")
  func testMixedValues() throws {
    let metadata = Metadata(author: "Site Author", keywords: ["site"], twitter: "siteuser", type: "website")
    let html = metadata.render(
      pageTitle: "Test",
      description: "Desc",
      keywords: ["page"]
    )

    #expect(html.contains("<meta name=\"author\" content=\"Site Author\">"))  // Falls back to site-wide
    #expect(html.contains("<meta name=\"keywords\" content=\"page\">"))  // Uses page-specific
    #expect(html.contains("<meta name=\"twitter:creator\" content=\"@siteuser\">"))  // Falls back to site-wide
  }

  @Test("Stylesheet generation handles complex page titles")
  func testStylesheetGeneration() throws {
    let metadata = Metadata()
    let html1 = metadata.render(
      pageTitle: "About Us | Great Site",
      description: "Company Information"
    )
    #expect(html1.contains("<link rel=\"stylesheet\" href=\"/about-us.css\">"))

    let html2 = metadata.render(
      pageTitle: "Contact Page with Multiple Words | Great Site",
      description: "Get in Touch"
    )
    #expect(html2.contains("<link rel=\"stylesheet\" href=\"/contact-page-with-multiple-words.css\">"))
  }

  @Test("Metadata initializer sets correct default values")
  func testMetadataInitializer() throws {
    let metadata = Metadata()

    #expect(metadata.site == "Great Site")
    #expect(metadata.title == "%s | Great Site")
    #expect(metadata.author == nil)
    #expect(metadata.keywords == nil)
    #expect(metadata.twitter == nil)
    #expect(metadata.locale == "en")
    #expect(metadata.type == nil)
  }
}
