import Testing

@testable import WebUI

@Suite("Basic Elements Tests")
struct BasicElementsTests {
  // From ElementTests
  @Test("Element renders basic tag with no attributes")
  func testBasicRender() throws {
    let element = Element(tag: "div") {}
    let html = element.render()
    #expect(html == "<div></div>")
  }

  @Test("Element renders with id, classes, and role")
  func testAttributesRender() throws {
    let element = Element(tag: "span", id: "test-id", classes: ["class1", "class2"], role: .menu) {}
    let html = element.render()
    #expect(html == "<span id=\"test-id\" class=\"class1 class2\" role=\"menu\"></span>")
  }

  @Test("Element renders nested content")
  func testNestedContent() throws {
    let element = Element(tag: "div") {
      Element(tag: "p") { "Hello" }
    }
    let html = element.render()
    #expect(html == "<div><p>Hello</p></div>")
  }

  @Test("Content builder evaluates lazily")
  func testContentBuilder() throws {
    let element = Element(tag: "div") {
      Element(tag: "span") { "Test" }
    }
    let content = element.content
    #expect(content.count == 1)
    #expect(content[0].render() == "<span>Test</span>")
  }

  // From ArticleSectionStackElementTests
  @Test("Article renders with no content")
  func testArticleEmptyContent() throws {
    let article = Article()
    let html = article.render()
    #expect(html == "<article></article>")
  }

  @Test("Article renders with string content")
  func testArticleStringContent() throws {
    let article = Article { "Blog Post Content" }
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
    let article = Article(id: "post-123", classes: ["featured", "blog-post"]) { "Article Content" }
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
      Article { "Nested Article Content" }
    }
    let html = section.render()
    #expect(html == "<section><h3>Section Heading</h3><article>Nested Article Content</article></section>")
  }

  @Test("Section renders with full attributes")
  func testSectionFullAttributes() throws {
    let section = Section(id: "intro", classes: ["primary", "content-section"], role: .complementary) {
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
      Section { "Nested section" }
    }
    let html = stack.render()
    #expect(html == "<div>Text content<span>Span element</span><section>Nested section</section></div>")
  }

  @Test("Stack renders with full attributes")
  func testStackFullAttributes() throws {
    let stack = Stack(id: "container", classes: ["flex", "layout"], role: .complementary) {
      "Stack Content"
    }
    let html = stack.render()
    #expect(html == "<div id=\"container\" class=\"flex layout\" role=\"complementary\">Stack Content</div>")
  }

  // From NewElementsTests
  @Test("Aside renders with no content")
  func testAsideEmptyContent() throws {
    let aside = Aside()
    let html = aside.render()
    #expect(html == "<aside></aside>")
  }

  @Test("Aside renders with text and attributes")
  func testAsideWithContent() throws {
    let aside = Aside(classes: ["sidebar"]) { Text { "Related info" } }
    let html = aside.render()
    #expect(html == "<aside class=\"sidebar\"><span>Related info</span></aside>")
  }

  @Test("Unordered List renders with items")
  func testUnorderedListWithItems() throws {
    let list = List(type: .unordered) {
      ListItem { "Item 1" }
      ListItem { "Item 2" }
    }
    let html = list.render()
    #expect(html == "<ul><li>Item 1</li><li>Item 2</li></ul>")
  }

  @Test("Ordered List renders with attributes and items")
  func testOrderedListWithAttributes() throws {
    let list = List(type: .ordered, id: "steps", classes: ["numbered"]) {
      ListItem { "Step 1" }
      ListItem { "Step 2" }
    }
    let html = list.render()
    #expect(html == "<ol id=\"steps\" class=\"numbered\"><li>Step 1</li><li>Step 2</li></ol>")
  }

  @Test("Progress renders with no attributes")
  func testProgressEmpty() throws {
    let progress = Progress()
    let html = progress.render()
    #expect(html == "<progress>")
  }

  @Test("Progress renders with value and max")
  func testProgressWithAttributes() throws {
    let progress = Progress(value: 75.0, max: 100.0, id: "download")
    let html = progress.render()
    #expect(html == "<progress id=\"download\" value=\"75.0\" max=\"100.0\">")
  }
}
