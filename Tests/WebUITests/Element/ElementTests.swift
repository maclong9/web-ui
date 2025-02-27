import Testing

@testable import WebUI

@Suite("Element Tests")
struct ElementTests {
  @Test("Element renders basic tag with no attributes")
  func testBasicRender() throws {
    let element = Element(tag: "div") {}
    let html = element.render()
    #expect(html == "<div></div>")
  }

  @Test("Element renders with id, classes, and role")
  func testAttributesRender() throws {
    let element = Element(
      tag: "span",
      id: "test-id",
      classes: ["class1", "class2"],
      role: .main
    ) {}
    let html = element.render()
    #expect(html == "<span id=\"test-id\" class=\"class1 class2\" role=\"main\"></span>")
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
}
