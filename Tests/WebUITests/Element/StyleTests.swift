import Testing

@testable import WebUI

@Suite("Style Tests") struct StyleTests {
  @Test("Font Styles Render Correctly")
  func fontStylesShouldRenderCorrectly() async throws {
    let element = Text { "Hello, world!" }
      .font(
        weight: .extrabold,
        size: ._5xl,
        alignment: .right,
        tracking: .wider,
        leading: .relaxed,
        decoration: .double
      )
      .render()

    #expect(element.contains("font-extrabold text-5xl text-right tracking-wider leading-relaxed decoration-double"))
  }
}
