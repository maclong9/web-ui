import Testing

@testable import WebUI

@Suite("Structural Element Tests")
struct StructuralElementTests {
  @Test("Article renders as article tag")
  func testArticleRender() throws {
    let article = Article(id: "art1", classes: ["post"]) {
      "Blog content"
    }
    let html = article.render()
    #expect(html == "<article id=\"art1\" class=\"post\">Blog content</article>")
  }

  @Test("Section renders as section tag")
  func testSectionRender() throws {
    let section = Section(role: .complementary) {
      "Sidebar content"
    }
    let html = section.render()
    #expect(html == "<section role=\"complementary\">Sidebar content</section>")
  }

  @Test("Stack renders as div tag")
  func testStackRender() throws {
    let stack = Stack(classes: ["container"]) {
      "Layout content"
    }
    let html = stack.render()
    #expect(html == "<div class=\"container\">Layout content</div>")
  }
}
