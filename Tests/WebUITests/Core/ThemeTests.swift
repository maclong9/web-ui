import Testing

@testable import WebUI  // Assuming the module name is WebUI

@Suite("Theme Tests")
struct ThemeTests {
  // MARK: - Theme Tests

  @Test("Empty Theme Config")
  func testThemeEmptyConfig() {
    let theme = Theme()
    let css = theme.generateCSS()
    #expect(css == "", "Empty theme config should produce no CSS")
  }

  @Test("Theme with Colors")
  func testThemeWithColors() {
    let theme = Theme(colors: ["primary": "red", "secondary": "#10b981"])
    let css = theme.generateCSS()

    #expect(css.contains("--color-primary: red;"))
    #expect(css.contains("--color-secondary: #10b981;"))
  }

  @Test("Theme with Multiple Properties")
  func testThemeWithMultipleProperties() {
    let theme = Theme(
      colors: ["primary": "blue"],
      spacing: ["4": "1rem"],
      textSizes: ["lg": "1.25rem"],
      custom: ["opacity": ["faint": "0.1"]]
    )
    let css = theme.generateCSS()

    #expect(css.contains("--color-primary: blue;"))
    #expect(css.contains("--spacing-4: 1rem;"))
    #expect(css.contains("--text-size-lg: 1.25rem;"))
    #expect(css.contains("--opacity-faint: 0.1;"))
  }

  @Test("Theme with Sanitized Keys")
  func testThemeWithSanitizedKeys() {
    let theme = Theme(colors: ["primary-color": "red", "secondary_color": "blue"])
    let css = theme.generateCSS()
    #expect(css.contains("--color-primary-color: red;"))
    #expect(css.contains("--color-secondary-color: blue;"))
  }
}
