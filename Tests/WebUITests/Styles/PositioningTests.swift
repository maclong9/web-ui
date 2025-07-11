import Testing

@testable import WebUI

@Suite("Positioning Style Tests") struct PositioningStyleTests {
  // MARK: - Transition Tests

  @Test("Transition with default property")
  func testTransitionWithDefaultProperty() async throws {
    let element = Stack().transition()
    let rendered = element.render()
    #expect(rendered.contains("class=\"transition\""))
  }

  @Test("Transition with specific property and duration")
  func testTransitionWithPropertyAndDuration() async throws {
    let element = Stack().transition(of: .opacity, for: 300)
    let rendered = element.render()
    #expect(rendered.contains("class=\"transition-opacity duration-300\""))
  }

  @Test("Transition with easing and delay")
  func testTransitionWithEasingAndDelay() async throws {
    let element = Stack().transition(of: nil, easing: .inOut, delay: 100)
    let rendered = element.render()
    #expect(rendered.contains("class=\"transition ease-in-out delay-100\""))
  }

  // MARK: - Z-Index Tests

  @Test("Z-Index with positive value")
  func testZIndexWithPositiveValue() async throws {
    let element = Stack().zIndex(10)
    let rendered = element.render()
    #expect(rendered.contains("class=\"z-10\""))
  }

  @Test("Z-Index with negative value")
  func testZIndexWithNegativeValue() async throws {
    let element = Stack().zIndex(-5)
    let rendered = element.render()
    #expect(rendered.contains("class=\"z--5\""))
  }

  // MARK: - Position Tests

  @Test("Position with type only")
  func testPositionWithTypeOnly() async throws {
    let element = Stack().position(.absolute)
    let rendered = element.render()
    #expect(rendered.contains("class=\"absolute\""))
  }

  @Test("Position with edges and length")
  func testPositionWithEdgesAndLength() async throws {
    let element = Stack().position(.fixed, at: .top, .leading, offset: 4)
    let rendered = element.render()
    #expect(rendered.contains("class=\"fixed top-4 left-4\""))
  }

  @Test("Position with negative length")
  func testPositionWithNegativeLength() async throws {
    let element = Stack().position(.relative, at: .bottom, offset: -2)
    let rendered = element.render()
    #expect(rendered.contains("class=\"relative -bottom-2\""))
  }

  @Test("Position with multiple negative values")
  func testPositionWithMultipleNegativeValues() async throws {
    let element = Stack().position(
      .absolute, at: .top, .trailing, offset: -10)
    let rendered = element.render()
    #expect(rendered.contains("class=\"absolute -top-10 -right-10\""))
    #expect(!rendered.contains("-top--10"))  // Should NOT contain double negative
  }

  @Test("Position with horizontal edge")
  func testPositionWithHorizontalEdge() async throws {
    let element = Stack().position(.absolute, at: .horizontal, offset: 8)
    let rendered = element.render()
    #expect(rendered.contains("class=\"absolute inset-x-8\""))
  }

  // MARK: - Overflow Tests

  @Test("Overflow with default axis")
  func testOverflowWithDefaultAxis() async throws {
    let element = Stack().overflow(.hidden)
    let rendered = element.render()
    #expect(rendered.contains("class=\"overflow-hidden\""))
  }

  @Test("Overflow with specific axis")
  func testOverflowWithSpecificAxis() async throws {
    let element = Stack().overflow(.scroll, axis: .horizontal)
    let rendered = element.render()
    #expect(rendered.contains("class=\"overflow-x-scroll\""))
  }

  // MARK: - Transform Tests

  @Test("Transform with scale")
  func testTransformWithScale() async throws {
    let element = Stack().transform(scale: (x: 75, y: 125))
    let rendered = element.render()
    #expect(rendered.contains("class=\"transform scale-x-75 scale-y-125\""))
  }

  @Test("Transform with rotate")
  func testTransformWithRotate() async throws {
    let element = Stack().transform(rotate: 45)
    let rendered = element.render()
    #expect(rendered.contains("class=\"transform rotate-45\""))
  }

  @Test("Transform with negative translate")
  func testTransformWithNegativeTranslate() async throws {
    let element = Stack().transform(translate: (x: -10, y: 20))
    let rendered = element.render()
    #expect(
      rendered.contains(
        "class=\"transform -translate-x-10 translate-y-20\""))
  }

  @Test("Transform with multiple properties")
  func testTransformWithMultipleProperties() async throws {
    let element = Stack().transform(
      scale: (x: 90, y: nil),
      rotate: -30,
      translate: (x: 5, y: nil),
      skew: (x: nil, y: 10)
    )
    let rendered = element.render()
    #expect(
      rendered.contains(
        "class=\"transform scale-x-90 -rotate-30 translate-x-5 skew-y-10\""
      ))
  }

  // MARK: - Scroll Tests

  @Test("Scroll with behavior only")
  func testScrollWithBehaviorOnly() async throws {
    let element = Stack().scroll(behavior: .smooth)
    let rendered = element.render()
    #expect(rendered.contains("class=\"scroll-smooth\""))
  }

  @Test("Scroll with margin and specific edges")
  func testScrollWithMarginAndEdges() async throws {
    let element = Stack().scroll(
      margin: (value: 4, edges: [.top, .bottom]))
    let rendered = element.render()
    #expect(rendered.contains("class=\"scroll-mt-4 scroll-mb-4\""))
  }

  @Test("Scroll with padding and all edges")
  func testScrollWithPaddingAndAllEdges() async throws {
    let element = Stack().scroll(padding: (value: 8, edges: []))
    let rendered = element.render()
    #expect(rendered.contains("class=\"scroll-p-8\""))
  }

  @Test("Scroll with snap properties")
  func testScrollWithSnapProperties() async throws {
    let element = Stack().scroll(
      snapAlign: .center,
      snapStop: .always,
      snapType: .x
    )
    let rendered = element.render()
    #expect(rendered.contains("class=\"snap-center snap-always snap-x\""))
  }

  @Test("Scroll with multiple properties")
  func testScrollWithMultipleProperties() async throws {
    let element = Stack().scroll(
      behavior: .smooth,
      margin: (value: 2, edges: [.horizontal]),
      padding: (value: 6, edges: [.vertical]),
      snapAlign: .start,
      snapStop: .normal,
      snapType: .both
    )
    let rendered = element.render()
    #expect(
      rendered.contains(
        "class=\"scroll-smooth scroll-mx-2 scroll-py-6 snap-start snap-normal snap-both\""
      )
    )
  }

  // MARK: - Complex Positioning Tests

  @Test("Combined positioning styles")
  func testCombinedPositioningStyles() async throws {
    let element = Stack()
      .transition(of: .transform, for: 200, easing: .out)
      .zIndex(30)
      .position(.absolute, at: .top, .trailing, offset: 4)
      .overflow(.hidden, axis: .vertical)
      .transform(scale: (x: 95, y: 95), rotate: 15)
    let rendered = element.render()
    #expect(
      rendered.contains(
        "class=\"transition-transform duration-200 ease-out z-30 absolute top-4 right-4 overflow-y-hidden transform scale-x-95 scale-y-95 rotate-15\""
      )
    )
  }

  // MARK: - Edge Cases

  @Test("Transition with no properties")
  func testTransitionWithNoProperties() async throws {
    let element = Stack().transition()
    let rendered = element.render()
    #expect(rendered.contains("class=\"transition\""))
  }

  @Test("Position with no type or edges")
  func testPositionWithNoTypeOrEdges() async throws {
    let element = Stack().position()
    let rendered = element.render()
    #expect(rendered.contains("<div></div>"))
  }

  @Test("Transform with no values")
  func testTransformWithNoValues() async throws {
    let element = Stack().transform()
    let rendered = element.render()
    #expect(rendered.contains("class=\"transform\""))
  }

}
