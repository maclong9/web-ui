import Testing

@testable import WebUI

@Suite("Document Renderer Tests") struct DocumentTests {
  var document = Document(
    path: "about",
    metadata: Metadata(
      site: "Test",
      title: "Hello, world!",
      description: "Simple description"
    )
  ) { "Hello, world!" }
  
  @Test("Should render page structure correctly")
  func renderPageStructure() async throws {
    let html = document.render()
    #expect(html.contains("<!DOCTYPE html>"))
    #expect(html.contains("<html lang=\"en\">"))
    #expect(html.contains("<head>"))
    #expect(html.contains("<body>"))
    #expect(html.contains("</body>"))
    #expect(html.contains("</html>"))
  }
  
  @Test("Should render page title correctly")
  func renderPageTitle() async throws {
    let html = document.render()
    #expect(html.contains("<title>Hello, world! | Test</title>"))
  }

  @Test("Optional Metadata tags are rendered correctly")
  mutating func renderOptionalMetadata() async throws {
    document.metadata.titleSeperator = "-"
    document.metadata.author = "Jane Doe"
    document.metadata.keywords = ["swift", "webui"]
    document.metadata.twitter = "janedoe"
    document.metadata.type = .article
    let html = document.render()
    #expect(html.contains("<meta name=\"author\" content=\"Jane Doe\">"))
    #expect(html.contains("<meta name=\"keywords\" content=\"swift, webui\">"))
    #expect(html.contains("<meta name=\"twitter:card\" content=\"summary_large_image\">"))
    #expect(html.contains("<meta name=\"twitter:creator\" content=\"@janedoe\">"))
    #expect(html.contains("<meta property=\"og:type\" content=\"article\">"))
  }
}
