import Testing

@testable import WebUI

@Suite("Structural Elements Tests")
struct StructuralElementsTests {
  @Test("Header renders with no content")
  func testHeaderEmptyContent() throws {
    let header = Header()
    let html = header.render()
    #expect(html == "<header></header>")
  }

  @Test("Header renders with string content")
  func testHeaderStringContent() throws {
    let header = Header {
      "Page Title"
    }
    let html = header.render()
    #expect(html == "<header>Page Title</header>")
  }

  @Test("Header renders with multiple elements")
  func testHeaderMultipleElements() throws {
    let header = Header {
      Element(tag: "h1") { "Welcome" }
      Element(tag: "p") { "Subtitle" }
    }
    let html = header.render()
    #expect(html == "<header><h1>Welcome</h1><p>Subtitle</p></header>")
  }

  @Test("Header renders with full attributes")
  func testHeaderFullAttributes() throws {
    let header = Header(
      id: "main-header",
      classes: ["primary", "site-header"]
    ) {
      "Header Content"
    }
    let html = header.render()
    #expect(html == "<header id=\"main-header\" class=\"primary site-header\">Header Content</header>")
  }

  @Test("Navigation renders with no content")
  func testNavigationEmptyContent() throws {
    let nav = Navigation()
    let html = nav.render()
    #expect(html == "<nav></nav>")
  }

  @Test("Navigation renders with multiple links")
  func testNavigationMultipleLinks() throws {
    let nav = Navigation {
      Link(href: "/") { "Home" }
      Link(href: "/about") { "About" }
    }
    let html = nav.render()
    #expect(html == "<nav><a href=\"/\">Home</a><a href=\"/about\">About</a></nav>")
  }

  @Test("Main renders with no content")
  func testMainEmptyContent() throws {
    let main = Main()
    let html = main.render()
    #expect(html == "<main></main>")
  }

  @Test("Main renders with complex content")
  func testMainComplexContent() throws {
    let main = Main {
      Section {
        "Section Content"
      }
      Article {
        "Article Content"
      }
    }
    let html = main.render()
    #expect(html == "<main><section>Section Content</section><article>Article Content</article></main>")
  }

  @Test("Footer renders with no content")
  func testFooterEmptyContent() throws {
    let footer = Footer()
    let html = footer.render()
    #expect(html == "<footer></footer>")
  }

  @Test("Footer renders with copyright and links")
  func testFooterWithContent() throws {
    let footer = Footer(classes: ["site-footer"]) {
      Element(tag: "p") { "© 2024 My Company" }
      Navigation {
        Link(href: "/privacy") { "Privacy Policy" }
        Link(href: "/terms") { "Terms of Service" }
      }
    }
    let html = footer.render()
    #expect(
      html
        == "<footer class=\"site-footer\"><p>© 2024 My Company</p><nav><a href=\"/privacy\">Privacy Policy</a><a href=\"/terms\">Terms of Service</a></nav></footer>"
    )
  }
}
