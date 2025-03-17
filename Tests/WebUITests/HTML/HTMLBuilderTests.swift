import Testing

@testable import WebUI

@Suite("HTMLBuilder Tests") struct HTMLBuilderTests {
  @Test("BuildBlock combines multiple components")
  func testBuildBlock() throws {
    let result = HTMLBuilder.buildBlock(
      ["<p>One</p>" as HTML],
      ["<div>Two</div>" as HTML]
    )
    #expect(result.count == 2)
    #expect(result[0].render() == "<p>One</p>")
    #expect(result[1].render() == "<div>Two</div>")
  }

  @Test("BuildExpression wraps single component")
  func testBuildExpression() throws {
    let result = HTMLBuilder.buildExpression("<span>Test</span>" as HTML)
    #expect(result.count == 1)
    #expect(result[0].render() == "<span>Test</span>")
  }

  @Test("BuildOptional handles nil and non-nil cases")
  func testBuildOptional() throws {
    let nilResult = HTMLBuilder.buildOptional(nil)
    #expect(nilResult.isEmpty)

    let someResult = HTMLBuilder.buildOptional(["<p>Content</p>" as HTML])
    #expect(someResult.count == 1)
    #expect(someResult[0].render() == "<p>Content</p>")
  }

  @Test("BuildEither handles first and second branches")
  func testBuildEither() throws {
    let first = HTMLBuilder.buildEither(first: ["<h1>First</h1>" as HTML])
    #expect(first.count == 1)
    #expect(first[0].render() == "<h1>First</h1>")

    let second = HTMLBuilder.buildEither(second: ["<h2>Second</h2>" as HTML])
    #expect(second.count == 1)
    #expect(second[0].render() == "<h2>Second</h2>")
  }

  @Test("BuildArray flattens nested arrays")
  func testBuildArray() throws {
    let result = HTMLBuilder.buildArray([
      ["<p>One</p>" as HTML],
      ["<p>Two</p>" as HTML],
    ])
    #expect(result.count == 2)
    #expect(result[0].render() == "<p>One</p>")
    #expect(result[1].render() == "<p>Two</p>")
  }
}
