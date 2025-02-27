import Testing

@testable import WebUI

@Suite("Theme Tests")
struct ThemeTests {
  @Test("Theme initializes with default breakpoints")
  func testDefaultInitialization() throws {
    let theme = Theme()
    #expect(theme.breakpoints.isEmpty)
    #expect(theme.typography.width == 60)  // From default Typography
  }

  @Test("Theme accepts custom breakpoints")
  func testCustomBreakpoints() throws {
    let customBreakpoints = ["sm": 30, "lg": 70]
    let theme = Theme(breakpoints: customBreakpoints)
    #expect(theme.breakpoints["sm"] == 30)
    #expect(theme.breakpoints["lg"] == 70)
  }

  @Test("Breakpoint raw values are correct")
  func testBreakpointValues() throws {
    #expect(Breakpoint.small.rawValue == 40)
    #expect(Breakpoint.medium.rawValue == 48)
    #expect(Breakpoint.large.rawValue == 64)
    #expect(Breakpoint.xLarge.rawValue == 80)
    #expect(Breakpoint.twoXLarge.rawValue == 96)
  }
}
