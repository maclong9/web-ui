/// Represents a design theme including breakpoints, colors, and typography settings.
struct Theme {
  let breakpoints: [String: Int]
  let colors: [String: String]
  let typography: Typography

  /// Initializes a new `Theme` instance with optional design settings.
  ///
  /// - Parameters:
  ///   - breakpoints: A dictionary defining responsive breakpoints.
  ///   - colors: A dictionary of theme colors.
  ///   - typography: The typography settings.
  init(
    breakpoints: [String: Int] = [
      "small": 40,
      "medium": 48,
      "large": 64,
      "xLarge": 80,
      "twoXLarge": 96,
    ],
    colors: [String: String] = [
      "primary": "#0099ff",
      "accent": "#FF6600",
      "surface": "#1c1c1c",
    ],
    typography: Typography = Typography()
  ) {
    self.breakpoints = breakpoints
    self.colors = colors
    self.typography = typography
  }
}
