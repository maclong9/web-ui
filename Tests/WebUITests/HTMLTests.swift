import Foundation
import Testing

@testable import WebUI

@Suite("HTML Tests")
struct HTMLTests {
  // MARK: - HTML Protocol Tests

  @Test("HTML protocol render with simple string content")
  func testHTMLProtocolSimpleRender() throws {
    struct SimpleHTML: HTML {
      let content: String
      func render() -> String { content }
    }

    let html = SimpleHTML(content: "<p>Test Content</p>")
    let rendered = html.render()
    #expect(
      rendered == "<p>Test Content</p>", "HTML protocol render should return the provided content")
  }

  // MARK: - HTMLBuilder Tests

  @Test("HTMLBuilder buildBlock with multiple components")
  func testBuildBlockMultipleComponents() throws {
    struct TestHTML: HTML {
      let content: String
      func render() -> String { content }
    }

    let components = HTMLBuilder.buildBlock(
      [TestHTML(content: "<div>One</div>")],
      [TestHTML(content: "<div>Two</div>"), TestHTML(content: "<div>Three</div>")]
    )

    #expect(components.count == 3, "buildBlock should combine all components into a single array")
    #expect(components[0].render() == "<div>One</div>", "First component should be preserved")
    #expect(components[1].render() == "<div>Two</div>", "Second component should be preserved")
    #expect(components[2].render() == "<div>Three</div>", "Third component should be preserved")
  }

  @Test("HTMLBuilder buildExpression with single HTML entity")
  func testBuildExpression() throws {
    struct TestHTML: HTML {
      let content: String
      func render() -> String { content }
    }

    let expression = TestHTML(content: "<span>Test</span>")
    let components = HTMLBuilder.buildExpression(expression)

    #expect(components.count == 1, "buildExpression should return a single-item array")
    #expect(
      components.first?.render() == "<span>Test</span>",
      "buildExpression should wrap the HTML entity correctly")
  }

  @Test("HTMLBuilder buildOptional with present components")
  func testBuildOptionalPresent() throws {
    struct TestHTML: HTML {
      let content: String
      func render() -> String { content }
    }

    let optionalComponents: [any HTML]? = [TestHTML(content: "<p>Optional</p>")]
    let components = HTMLBuilder.buildOptional(optionalComponents)

    #expect(components.count == 1, "buildOptional should return the provided components")
    #expect(
      components.first?.render() == "<p>Optional</p>",
      "buildOptional should preserve the components")
  }

  @Test("HTMLBuilder buildOptional with nil components")
  func testBuildOptionalNil() throws {
    let optionalComponents: [any HTML]? = nil
    let components = HTMLBuilder.buildOptional(optionalComponents)

    #expect(components.isEmpty, "buildOptional should return an empty array for nil input")
  }

  @Test("HTMLBuilder buildEither with first branch")
  func testBuildEitherFirst() throws {
    struct TestHTML: HTML {
      let content: String
      func render() -> String { content }
    }

    let firstComponents = [TestHTML(content: "<div>First</div>")]
    let components = HTMLBuilder.buildEither(first: firstComponents)

    #expect(components.count == 1, "buildEither(first:) should return the first branch components")
    #expect(
      components.first?.render() == "<div>First</div>",
      "buildEither(first:) should preserve the first branch")
  }

  @Test("HTMLBuilder buildEither with second branch")
  func testBuildEitherSecond() throws {
    struct TestHTML: HTML {
      let content: String
      func render() -> String { content }
    }

    let secondComponents = [TestHTML(content: "<div>Second</div>")]
    let components = HTMLBuilder.buildEither(second: secondComponents)

    #expect(
      components.count == 1, "buildEither(second:) should return the second branch components")
    #expect(
      components.first?.render() == "<div>Second</div>",
      "buildEither(second:) should preserve the second branch")
  }

  @Test("HTMLBuilder buildArray with nested arrays")
  func testBuildArray() throws {
    struct TestHTML: HTML {
      let content: String
      func render() -> String { content }
    }

    let nestedArrays: [[any HTML]] = [
      [TestHTML(content: "<p>One</p>")],
      [TestHTML(content: "<p>Two</p>"), TestHTML(content: "<p>Three</p>")],
    ]

    let components = HTMLBuilder.buildArray(nestedArrays)

    #expect(components.count == 3, "buildArray should flatten the nested arrays")
    #expect(components[0].render() == "<p>One</p>", "First component should be preserved")
    #expect(components[1].render() == "<p>Two</p>", "Second component should be preserved")
    #expect(components[2].render() == "<p>Three</p>", "Third component should be preserved")
  }

  @Test("HTMLBuilder complex composition with conditional and loop")
  func testComplexBuilderComposition() throws {
    struct TestHTML: HTML {
      let content: String
      func render() -> String { content }
    }

    @HTMLBuilder
    func buildComplexHTML(condition: Bool, items: [String]) -> [any HTML] {
      TestHTML(content: "<header>Header</header>")
      if condition {
        TestHTML(content: "<div>Conditional Content</div>")
      }
      for item in items {
        TestHTML(content: "<p>\(item)</p>")
      }
    }

    let components = buildComplexHTML(condition: true, items: ["Item1", "Item2"])

    #expect(
      components.count == 4,
      "Complex composition should include header, conditional, and loop items")
    #expect(components[0].render() == "<header>Header</header>", "Header should be first")
    #expect(
      components[1].render() == "<div>Conditional Content</div>",
      "Conditional content should be included")
    #expect(components[2].render() == "<p>Item1</p>", "First loop item should be correct")
    #expect(components[3].render() == "<p>Item2</p>", "Second loop item should be correct")
  }
}
