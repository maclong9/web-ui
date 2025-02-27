import Testing

@testable import WebUI

@Suite("Full Page Tests") struct FullPageTests {
  @Test
  func shouldRenderFullPage() async throws {
    let config = Configuration()
    let html = Document(
      configuration: config, title: "Hello, world!", description: "An introductory page"
    ) {
      Article {
        Section {
          Stack { "Hello, world!" }
          Stack { "Here is a fun description of the website!" }
        }
        Section {
          Stack { "This is another section of the site!" }
          Stack { "And another sentence!" }
        }
      }
    }.render()
    print(html)

    #expect(html.contains("<!DOCTYPE html>"))
    #expect(html.contains("<title>Hello, world! | Great Site</title>"))
    #expect(html.contains("<meta name=\"description\" content=\"An introductory page\">"))
    #expect(
      html.contains(
        "<article><section><div>Hello, world!</div><div>Here is a fun description of the website!</div></section><section><div>This is another section of the site!</div><div>And another sentence!</div></section></article>"
      )
    )
  }
}
