import Testing

@testable import WebUI

@Suite("Flow Control Tests")
struct FlowControlTests {
  @Test("Renders conditionally")
  func rendersConditionally() async throws {
    let isVisible = true
    let html = Section {
      if isVisible {
        Text { "Content Visible" }
      }
    }.render()

    #expect(html.contains("<section><span>Content Visible</span></section>"))
  }

  @Test("Renders Conditionally with Else")
  func rendersConditionallyWithElse() async throws {
    let isVisible = false
    let html = Section {
      if isVisible {
        Text { "Content Visible" }
      } else {
        Text { "Content Not Visible" }
      }
    }.render()

    #expect(html.contains("<section><span>Content Not Visible</span></section>"))
  }

  @Test("Renders Loop")
  func rendersLoop() async throws {
    let numbers: [Int] = [1, 2, 3, 4, 5]
    let html = Section {
      for number in numbers {
        Text { "\(number)" }
      }
    }.render()

    #expect(html.contains("<section><span>1</span><span>2</span><span>3</span><span>4</span><span>5</span></section>"))
  }
}
