import Testing

@testable import WebUI

@Suite("Typography Tests")
struct TypographyTests {
  @Test("Typography initializes with defaults")
  func testDefaultInitialization() throws {
    let typography = Typography()
    #expect(typography.heading == ["system-ui", "sans-serif"])
    #expect(typography.body == ["system-ui", "sans-serif"])
    #expect(typography.mono == ["system-ui", "monospace"])
    #expect(typography.width == 60)
    #expect(typography.multiplier == 1.0)
  }

  @Test("Typography accepts custom values")
  func testCustomInitialization() throws {
    let typography = Typography(
      heading: ["Arial"],
      body: ["Times"],
      mono: ["Courier"],
      width: 80,
      multiplier: 1.5
    )
    #expect(typography.heading == ["Arial"])
    #expect(typography.body == ["Times"])
    #expect(typography.mono == ["Courier"])
    #expect(typography.width == 80)
    #expect(typography.multiplier == 1.5)
  }

  @Test("Tracking raw values are correct")
  func testTrackingValues() throws {
    #expect(Tracking.tighter.rawValue == -0.05)
    #expect(Tracking.tight.rawValue == -0.025)
    #expect(Tracking.normal.rawValue == 0)
    #expect(Tracking.wide.rawValue == 0.025)
    #expect(Tracking.wider.rawValue == 0.05)
    #expect(Tracking.widest.rawValue == 0.1)
  }

  @Test("Leading raw values are correct")
  func testLeadingValues() throws {
    #expect(Leading.tightest.rawValue == 1.0)
    #expect(Leading.tighter.rawValue == 1.25)
    #expect(Leading.tight.rawValue == 1.375)
    #expect(Leading.normal.rawValue == 1.5)
    #expect(Leading.relaxed.rawValue == 1.625)
    #expect(Leading.loose.rawValue == 2.0)
  }

  @Test("Size lineHeight returns correct values")
  func testSizeLineHeight() throws {
    #expect(Size.xs.lineHeight == 1.5)
    #expect(Size.lg.lineHeight == 1.625)
    #expect(Size.xl2.lineHeight == 1.75)
    #expect(Size.xl5.lineHeight == 1.5)
    #expect(Size.xl7.lineHeight == 1.25)
  }

  @Test("Size raw values match expected scale")
  func testSizeRawValues() throws {
    #expect(Size.xs.rawValue == -2)
    #expect(Size.base.rawValue == 0)
    #expect(Size.xl9.rawValue == 10)
  }
}
