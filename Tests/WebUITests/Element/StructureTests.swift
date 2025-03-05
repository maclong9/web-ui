import Testing

@testable import WebUI

@Suite("Article, Section, and Stack Element Tests")
struct ArticleSectionStackElementTests {
  @Test("Article renders with no content")
  func testArticleEmptyContent() throws {
    let article = Article()
    let html = article.render()
    #expect(html == "<article></article>")
  }

  @Test("Article renders with string content")
  func testArticleStringContent() throws {
    let article = Article {
      "Blog Post Content"
    }
    let html = article.render()
    #expect(html == "<article>Blog Post Content</article>")
  }

  @Test("Article renders with multiple elements")
  func testArticleMultipleElements() throws {
    let article = Article {
      Element(tag: "h2") { "Post Title" }
      Element(tag: "p") { "Post description" }
    }
    let html = article.render()
    #expect(html == "<article><h2>Post Title</h2><p>Post description</p></article>")
  }

  @Test("Article renders with full attributes")
  func testArticleFullAttributes() throws {
    let article = Article(
      id: "post-123",
      classes: ["featured", "blog-post"]
    ) {
      "Article Content"
    }
    let html = article.render()
    #expect(html == "<article id=\"post-123\" class=\"featured blog-post\">Article Content</article>")
  }

  @Test("Section renders with no content")
  func testSectionEmptyContent() throws {
    let section = Section()
    let html = section.render()
    #expect(html == "<section></section>")
  }

  @Test("Section renders with nested elements")
  func testSectionNestedElements() throws {
    let section = Section {
      Element(tag: "h3") { "Section Heading" }
      Article {
        "Nested Article Content"
      }
    }
    let html = section.render()
    #expect(html == "<section><h3>Section Heading</h3><article>Nested Article Content</article></section>")
  }

  @Test("Section renders with full attributes")
  func testSectionFullAttributes() throws {
    let section = Section(
      id: "intro",
      classes: ["primary", "content-section"],
      role: .complementary
    ) {
      "Section Description"
    }
    let html = section.render()
    #expect(
      html
        == "<section id=\"intro\" class=\"primary content-section\" role=\"complementary\">Section Description</section>"
    )
  }

  @Test("Stack renders with no content")
  func testStackEmptyContent() throws {
    let stack = Stack()
    let html = stack.render()
    #expect(html == "<div></div>")
  }

  @Test("Stack renders with multiple content types")
  func testStackMultipleContentTypes() throws {
    let stack = Stack {
      "Text content"
      Element(tag: "span") { "Span element" }
      Section {
        "Nested section"
      }
    }
    let html = stack.render()
    #expect(html == "<div>Text content<span>Span element</span><section>Nested section</section></div>")
  }

  @Test("Stack renders with full attributes")
  func testStackFullAttributes() throws {
    let stack = Stack(
      id: "container",
      classes: ["flex", "layout"],
      role: .complementary
    ) {
      "Stack Content"
    }
    let html = stack.render()
    #expect(html == "<div id=\"container\" class=\"flex layout\" role=\"complementary\">Stack Content</div>")
  }
}
