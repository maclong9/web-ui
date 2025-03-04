/// Represents different breakpoints for responsive design.
/// Used to define different screen sizes for styling purposes.
enum Breakpoint: Int {
  case small = 40, medium = 48, large = 64, xLarge = 80, twoXLarge = 96
}

/// Defines typography settings.
/// Holds font families for headings, body text, and monospaced text.
struct Typography {
  let heading: [String]
  let body: [String]
  let mono: [String]

  /// Creates typography settings for text styling.
  /// This prepares font choices for headings, body text, and monospaced text on the webpage.
  /// - Parameters:
  ///   - heading: Font names for headings, like "system-ui, sans-serif", with a default if not provided.
  ///   - body: Font names for regular text, like "system-ui, sans-serif", with a default if not provided.
  ///   - mono: Font names for monospaced text, like "system-ui, monospace", with a default if not provided.
  init(
    heading: [String] = ["system-ui", "sans-serif"],
    body: [String] = ["system-ui", "sans-serif"],
    mono: [String] = ["system-ui", "monospace"]
  ) {
    self.heading = heading
    self.body = body
    self.mono = mono
  }
}

/// A struct for defining theme settings.
/// This struct holds breakpoints and typography settings for the HTML document.
struct Theme {
  let breakpoints: [String: Int]
  let typography: Typography

  /// Creates theme settings for the webpage’s look and feel.
  /// This prepares styling options like breakpoints and typography for consistent design.
  /// - Parameters:
  ///   - breakpoints: Screen size settings, like "sm: 40", with an empty default if not provided.
  ///   - typography: Typography settings for fonts, with a default if not provided.
  init(
    breakpoints: [String: Int] = [:],
    typography: Typography = Typography()
  ) {
    self.breakpoints = breakpoints
    self.typography = typography
  }
}
