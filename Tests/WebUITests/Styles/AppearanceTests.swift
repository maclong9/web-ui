import Foundation
import Testing

@testable import WebUI

@Suite("Appearance Style Tests for Element Styling") struct AppearanceTests {
  @Test("Element should render with opacity")
  func shouldRenderWithOpacity() {
    let element = Element(tag: "div")
      .opacity("50")
      .render()
    #expect(element == "<div class=\"opacity-50\"></div>")
  }

  @Test("Element should render with breakpoint-specific opacity")
  func shouldRenderWithBreakpointOpacity() {
    let element = Element(tag: "div")
      .opacity("75", on: .medium)
      .render()
    #expect(element == "<div class=\"md:opacity-75\"></div>")
  }

  @Test("Element should render with flex styling")
  func shouldRenderWithFlexStyling() {
    let element = Element(tag: "div")
      .flex(direction: .row, justify: .between, align: .center, grow: .one)
      .render()
    #expect(element == "<div class=\"flex flex-row justify-between items-center flex-1\"></div>")
  }

  @Test("Element should render with grid styling")
  func shouldRenderWithGridStyling() {
    let element = Element(tag: "div")
      .grid(justify: .around, align: .stretch, columns: 3)
      .render()
    #expect(element == "<div class=\"grid justify-around items-stretch grid-cols-3\"></div>")
  }

  @Test("Element should render with hidden styling")
  func shouldRenderWithHiddenStyling() {
    let element = Element(tag: "div")
      .hidden()
      .render()
    #expect(element == "<div class=\"hidden\"></div>")
  }

  @Test("Element should render with visible styling")
  func shouldRenderWithVisibleStyling() {
    let element = Element(tag: "div")
      .hidden(isHidden: false)
      .render()
    #expect(element == "<div></div>")
  }

  @Test("Element should render with background color")
  func shouldRenderWithBackgroundColor() {
    let element = Element(tag: "div")
      .background(color: .blue(._500))
      .render()
    #expect(element == "<div class=\"bg-blue-500\"></div>")
  }

  @Test("Element should render with custom background color")
  func shouldRenderWithCustomBackgroundColor() {
    let element = Element(tag: "div")
      .background(color: .custom("#ff0000"))
      .render()
    #expect(element == "<div class=\"bg-[#ff0000]\"></div>")
  }

  @Test("Element should render with border styling")
  func shouldRenderWithBorderStyling() {
    let element = Element(tag: "div")
      .border(
        width: 2,
        radius: (side: .topLeft, size: .lg),
        style: .dashed,
        color: .red(._300)
      )
      .render()
    #expect(element == "<div class=\"border-2 rounded-tl-lg border-dashed border-red-300\"></div>")
  }

  @Test("Element should render with outline styling")
  func shouldRenderWithOutlineStyling() {
    let element = Element(tag: "div")
      .outline(width: 1, style: .dotted, color: .green(._400))
      .render()
    #expect(element == "<div class=\"outline-1 outline-dotted outline-green-400\"></div>")
  }

  @Test("Element should render with box shadow")
  func shouldRenderWithBoxShadow() {
    let element = Element(tag: "div")
      .boxShadow(size: .large, color: .purple(._200))
      .render()
    #expect(element == "<div class=\"shadow-lg shadow-purple-200\"></div>")
  }

  @Test("Element should render with ring effect")
  func shouldRenderWithRingEffect() {
    let element = Element(tag: "div")
      .ring(size: 3, color: .indigo(._600))
      .render()
    #expect(element == "<div class=\"ring-3 ring-indigo-600\"></div>")
  }

  @Test("Element should render with combined appearance styling")
  func shouldRenderWithCombinedAppearanceStyling() {
    let element = Element(tag: "div")
      .opacity("80")
      .flex(direction: .column, justify: .center, align: .start)
      .background(color: .slate(._100))
      .border(width: 1, style: .solid, color: .gray(._300))
      .boxShadow(size: .medium)
      .render()
    #expect(
      element
        == "<div class=\"opacity-80 flex flex-col justify-center items-start bg-slate-100 border-1 border-solid border-gray-300 shadow-md\"></div>"
    )
  }

  @Test("Element should render with breakpoint-specific appearance styling")
  func shouldRenderWithBreakpointAppearanceStyling() {
    let element = Element(tag: "div")
      .opacity("60", on: .small)
      .flex(direction: .row, on: .medium)
      .grid(columns: 4, on: .large)
      .hidden(on: .extraLarge)
      .background(color: .pink(._200), on: .medium)
      .border(radius: (side: .all, size: .md), on: .large)
      .render()
    #expect(
      element
        == "<div class=\"sm:opacity-60 md:flex md:flex-row lg:grid lg:grid-cols-4 xl:hidden md:bg-pink-200 lg:rounded-md\"></div>"
    )
  }
}
