import Testing

@testable import WebUI  // Assuming the module name is WebUI

@Suite("Theme Tests")
struct ThemeTests {
  // MARK: - Theme Tests

  @Test("Empty Theme Config")
  func testThemeEmptyConfig() {
    let theme = Theme(config: ThemeConfig())
    let css = theme.generateCSS()
    #expect(css == "", "Empty theme config should produce no CSS")
  }

  @Test("Theme with Colors")
  func testThemeWithColors() {
    let theme = Theme(config: ThemeConfig(colors: ["primary": "red", "secondary": "#10b981"]))
    let css = theme.generateCSS()
    let expected = """
      @theme {
        --color-secondary: #10b981;
        --color-primary: red;
      }
      """
    #expect(css == expected, "Theme should generate correct color CSS variables")
  }

  @Test("Theme with Multiple Properties")
  func testThemeWithMultipleProperties() {
    let theme = Theme(
      config: ThemeConfig(
        colors: ["primary": "blue"],
        spacing: ["4": "1rem"],
        textSizes: ["lg": "1.25rem"],
        custom: ["opacity": ["faint": "0.1"]]
      ))
    let css = theme.generateCSS()
    let expected = """
      @theme {
        --color-primary: blue;
        --spacing-4: 1rem;
        --text-size-lg: 1.25rem;

        /* Opacity */
        --opacity-faint: 0.1;
      }
      """
    #expect(css == expected, "Theme should generate CSS for multiple properties")
  }

  @Test("Theme with Sanitized Keys")
  func testThemeWithSanitizedKeys() {
    let theme = Theme(config: ThemeConfig(colors: ["primary-color": "red", "secondary_color": "blue"]))
    let css = theme.generateCSS()
    let expected = """
      @theme {
        --color-primary-color: red;
        --color-secondary-color: blue;
      }
      """
    #expect(css == expected, "Theme should sanitize keys for CSS variables")
  }
}
