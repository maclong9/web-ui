import Testing

@testable import WebUI

@Suite("Style Tests") struct StyleTests {
  @Test("Breakpoints Render Correctly")
  func breakpointsShouldRenderCorrectly() async throws {
    let element = Text { "Hello, world!" }
      .font(weight: .bold)
      .font(weight: .extrabold, on: .xl)
      .render()
    
    #expect(element.contains("font-bold xl:font-extrabold"))
  }
  @Test("Font Styles Render Correctly")
  func fontStylesShouldRenderCorrectly() async throws {
    let element = Text { "Hello, world!" }
      .font(
        weight: .extrabold,
        size: .xl5,
        alignment: .right,
        tracking: .wider,
        leading: .relaxed,
        decoration: .double
      )
      .render()

    #expect(element.contains("font-extrabold text-5xl text-right tracking-wider leading-relaxed decoration-double"))
  }

  @Test("Flex Styles Render Correctly")
  func flexStylesShouldRenderCorrectly() async throws {
    let element = Text { "Flex Container" }
      .flex(
        .column,
        justify: .between,
        align: .center
      )
      .render()

    #expect(element.contains("flex flex-col justify-between items-center"))
  }

  @Test("Grid Styles Render Correctly")
  func gridStylesShouldRenderCorrectly() async throws {
    let element = Text { "Grid Container" }
      .grid(
        justify: .center,
        align: .stretch,
        columns: 3
      )
      .render()

    #expect(element.contains("grid justify-center items-stretch grid-cols-3"))
  }

  @Test("Hidden Style Renders Correctly When True")
  func hiddenStyleShouldRenderCorrectlyWhenTrue() async throws {
    let element = Text { "Hidden Element" }
      .hidden(true)
      .render()

    #expect(element.contains("hidden"))
  }

  @Test("Hidden Style Does Not Render When False")
  func hiddenStyleShouldNotRenderWhenFalse() async throws {
    let element = Text { "Visible Element" }
      .hidden(false)
      .render()

    #expect(!element.contains("hidden"))
  }

  @Test("Chained Styles Render Correctly")
  func chainedStylesShouldRenderCorrectly() async throws {
    let element = Text { "Chained Styles" }
      .flex(.row, justify: .around)
      .font(weight: .bold, size: .lg)
      .hidden(false)
      .render()

    #expect(element.contains("flex flex-row justify-around font-bold text-lg"))
    #expect(!element.contains("hidden"))
  }
}
