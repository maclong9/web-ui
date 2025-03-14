import Foundation
import Testing

@testable import WebUI

@Suite("Basic Element Tests") struct BasicElementTests {
  @Test("Elements can be rendered as strings")
  func testStringRender() throws {
    let html = Stack {
      Text {
        "Hello, world!"
      }
    }.render()

    #expect(html.contains("<div>"))
    #expect(html.contains("<span>Hello, world!</span>"))
    #expect(html.contains("</div>"))
  }

  @Test("Elements should be styled correctly")
  func testStyleRender() throws {
    let html = Stack {
      Text {
        "Hello, world!"
      }.font(size: .base, color: .cyan(._500))
    }.render()

    #expect(html.contains("<span class=\"text-base text-cyan-500\">Hello, world!</span>"))
  }

  @Test("Scripts should render inline")
  func testScriptRender() throws {
    let html = Stack {
      Text {
        "Hello, world!"
      }.script(style: .color, add: true, value: "red")
    }.render()

    #expect(html.contains("<script>document.querySelector('#"))
    #expect(html.contains("').style.color = 'red';</script>"))

    let pattern = #"querySelector\('#gen[a-zA-Z0-9_]{32}'\)"#
    let regex = try NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(html.startIndex..<html.endIndex, in: html)
    let matches = regex.matches(in: html, options: [], range: range)
    #expect(matches.count > 0)
  }
}
