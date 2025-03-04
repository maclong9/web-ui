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

  init(
    breakpoints: [String: Int] = [:],
    typography: Typography = Typography()
  ) {
    self.breakpoints = breakpoints
    self.typography = typography
  }
}
