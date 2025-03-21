import Foundation
import Testing

@testable import WebUI

@Suite("Positioning Tests for Web Elements") struct PositioningTests {
  @Test("Element should render with overflow styling")
  func shouldRenderWithOverflow() {
    let article = Article()
      .overflow(.hidden)
      .render()
    #expect(article == "<article class=\"overflow-hidden\"></article>")
  }

  @Test("Element should render with overflow on specific axis")
  func shouldRenderWithOverflowOnAxis() {
    let section = Section()
      .overflow(.scroll, axis: .x)
      .render()
    #expect(section == "<section class=\"overflow-x-scroll\"></section>")

    let stack = Stack()
      .overflow(.auto, axis: .y)
      .render()
    #expect(stack == "<div class=\"overflow-y-auto\"></div>")
  }

  @Test("Element should render with position styling")
  func shouldRenderWithPosition() {
    let article = Article()
      .position(.absolute)
      .render()
    #expect(article == "<article class=\"absolute\"></article>")
  }

  @Test("Element should render with position and inset values")
  func shouldRenderWithPositionAndInset() {
    let section = Section()
      .position(.fixed, length: 0)
      .render()
    #expect(section == "<section class=\"fixed inset-0\"></section>")

    let stack = Stack()
      .position(.sticky, edge: .top, length: 0)
      .render()
    #expect(stack == "<div class=\"sticky top-0\"></div>")
  }

  @Test("Element should render with position and directional values")
  func shouldRenderWithPositionAndDirectional() {
    let header = Header()
      .position(.absolute, edges: [.top, .horizontal], length: 0)
      .render()
    #expect(header == "<header class=\"absolute top-0 inset-x-0\"></header>")
  }

  @Test("Element should render with z-index styling")
  func shouldRenderWithZIndex() {
    let article = Article()
      .zIndex(10)
      .render()
    #expect(article == "<article class=\"z-10\"></article>")
  }

  @Test("Element should render with transform styling")
  func shouldRenderWithTransform() {
    let header = Header()
      .transform(scale: (x: 2, y: nil as Int?))
      .render()
    #expect(header == "<header class=\"transform scale-x-2\"></header>")
  }

  @Test("Element should render with complex transform styling")
  func shouldRenderWithComplexTransform() {
    let navigation = Navigation()
      .transform(scale: (x: 2, y: 1), rotate: 45, translate: (x: 10, y: 5))
      .render()
    #expect(navigation == "<nav class=\"transform scale-x-2 scale-y-1 rotate-45 translate-x-10 translate-y-5\"></nav>")
  }

  @Test("Element should render with negative transform values")
  func shouldRenderWithNegativeTransform() {
    let aside = Aside()
      .transform(rotate: -90, translate: (x: -10, y: -5))
      .render()
    #expect(aside == "<aside class=\"transform rotate-90 translate-x-10 translate-y-5\"></aside>")
  }

  @Test("Element should render with transform using tuple syntax")
  func shouldRenderWithTransformUsingTuple() {
    let main = Main()
      .transform(scale: (x: 2, y: 3), skew: (x: 15, y: nil as Int?))
      .render()
    #expect(main == "<main class=\"transform scale-x-2 scale-y-3 skew-x-15\"></main>")
  }

  @Test("Element should render with basic transition")
  func shouldRenderWithBasicTransition() {
    let article = Article()
      .transition()
      .render()
    #expect(article == "<article class=\"transition\"></article>")
  }

  @Test("Element should render with specific transition property")
  func shouldRenderWithSpecificTransitionProperty() {
    let section = Section()
      .transition(property: .colors)
      .render()
    #expect(section == "<section class=\"transition-colors\"></section>")
  }

  @Test("Element should render with complete transition styling")
  func shouldRenderWithCompleteTransition() {
    let footer = Footer()
      .transition(property: .transform, duration: 300, easing: .inOut, delay: 100)
      .render()
    #expect(footer == "<footer class=\"transition-transform duration-300 ease-in-out delay-100\"></footer>")
  }

  @Test("Element should render with combined positioning styles")
  func shouldRenderWithCombinedPositioningStyles() {
    let stack = Stack()
      .position(.sticky, edge: .top, length: 0)
      .zIndex(50)
      .overflow(.hidden)
      .transform(scale: (x: 1, y: nil as Int?))
      .transition(duration: 200)
      .render()
    #expect(
      stack == "<div class=\"sticky top-0 z-50 overflow-hidden transform scale-x-1 transition duration-200\"></div>")
  }

  @Test("Element should render with absolute positioning and corner insets")
  func shouldRenderWithAbsolutePositioningAndCornerInsets() {
    let header = Header()
      .position(.absolute, edges: [.top, .trailing], length: 4)
      .render()
    #expect(header == "<header class=\"absolute top-4 right-4\"></header>")
  }

  @Test("Element should render with positioning styles on specific breakpoints")
  func shouldRenderWithPositioningOnBreakpoints() {
    let navigation = Navigation()
      .position(.relative, on: .md)
      .position(.absolute, edge: .top, length: 0, on: .lg)
      .overflow(.auto, axis: .x, on: .sm)
      .zIndex(20, on: .md)
      .render()
    #expect(navigation == "<nav class=\"md:relative lg:absolute lg:top-0 sm:overflow-x-auto md:z-20\"></nav>")
  }

  @Test("Element should render with transform and transition together")
  func shouldRenderWithTransformAndTransition() {
    let article = Article()
      .transform(scale: (x: 1, y: nil as Int?), translate: (x: 0, y: 0))
      .transition(property: .transform, duration: 150)
      .render()
    #expect(
      article
        == "<article class=\"transform scale-x-1 translate-x-0 translate-y-0 transition-transform duration-150\"></article>"
    )
  }

  @Test("Element should render with combination of all positioning features")
  func shouldRenderWithAllPositioningFeatures() {
    let modal = Stack()
      .position(.absolute, edge: .all, length: 0)
      .zIndex(40)
      .overflow(.auto)
      .transform(translate: (x: 0, y: 0))
      .transition(property: .all, duration: 300, easing: .inOut)
      .render()
    #expect(
      modal
        == "<div class=\"absolute inset-0 z-40 overflow-auto transform translate-x-0 translate-y-0 transition-all duration-300 ease-in-out\"></div>"
    )
  }

  @Test("Element should render with all position types")
  func shouldRenderWithAllPositionTypes() {
    let staticDiv = Stack()
      .position(.static)
      .render()
    #expect(staticDiv == "<div class=\"static\"></div>")

    let relativeDiv = Stack()
      .position(.relative)
      .render()
    #expect(relativeDiv == "<div class=\"relative\"></div>")

    let absoluteDiv = Stack()
      .position(.absolute)
      .render()
    #expect(absoluteDiv == "<div class=\"absolute\"></div>")

    let fixedDiv = Stack()
      .position(.fixed)
      .render()
    #expect(fixedDiv == "<div class=\"fixed\"></div>")

    let stickyDiv = Stack()
      .position(.sticky)
      .render()
    #expect(stickyDiv == "<div class=\"sticky\"></div>")
  }

  @Test("Element should render with all single edge insets")
  func shouldRenderWithAllSingleEdges() {
    let topDiv = Stack()
      .position(.absolute, edge: .top, length: 2)
      .render()
    #expect(topDiv == "<div class=\"absolute top-2\"></div>")

    let leadingDiv = Stack()
      .position(.absolute, edge: .leading, length: 2)
      .render()
    #expect(leadingDiv == "<div class=\"absolute left-2\"></div>")

    let trailingDiv = Stack()
      .position(.absolute, edge: .trailing, length: 2)
      .render()
    #expect(trailingDiv == "<div class=\"absolute right-2\"></div>")

    let bottomDiv = Stack()
      .position(.absolute, edge: .bottom, length: 2)
      .render()
    #expect(bottomDiv == "<div class=\"absolute bottom-2\"></div>")
  }

  @Test("Element should render with composite edge insets")
  func shouldRenderWithCompositeEdges() {
    let horizontalDiv = Stack()
      .position(.absolute, edge: .horizontal, length: 4)
      .render()
    #expect(horizontalDiv == "<div class=\"absolute inset-x-4\"></div>")

    let verticalDiv = Stack()
      .position(.absolute, edge: .vertical, length: 4)
      .render()
    #expect(verticalDiv == "<div class=\"absolute inset-y-4\"></div>")
  }

  @Test("Element should render with multiple edges without length")
  func shouldRenderWithMultipleEdgesNoLength() {
    let div = Stack()
      .position(.fixed, edges: [.top, .bottom, .leading])
      .render()
    #expect(div == "<div class=\"fixed\"></div>")
  }

  @Test("Element should render with all edges and breakpoint")
  func shouldRenderWithAllEdgesAndBreakpoint() {
    let div = Stack()
      .position(.absolute, edges: [.top, .bottom, .leading, .trailing], length: 8, on: .lg)
      .render()
    #expect(div == "<div class=\"lg:absolute lg:top-8 lg:bottom-8 lg:left-8 lg:right-8\"></div>")
  }

  @Test("Element should render with mixed edge combinations")
  func shouldRenderWithMixedEdgeCombinations() {
    let div = Stack()
      .position(.relative, edges: [.vertical, .trailing], length: 6)
      .render()
    #expect(div == "<div class=\"relative inset-y-6 right-6\"></div>")
  }
}
