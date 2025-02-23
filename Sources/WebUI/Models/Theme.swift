/// Represents font size properties including size and optional line height.
struct FontSize {
  let size: Double
  let lineHeight: Double?

  /// Initializes a new `FontSize` instance.
  ///
  /// - Parameters:
  ///   - size: The font size.
  ///   - lineHeight: The optional line height.
  init(size: Double, lineHeight: Double? = nil) {
    self.size = size
    self.lineHeight = lineHeight
  }
}

/// Defines typography settings including fonts, sizes, tracking, and leading.
struct Typography {
  let heading: [String]
  let body: [String]
  let mono: [String]
  let width: Int
  let sizes: [String: FontSize]
  let tracking: [String: Double]
  let leading: [String: Double]

  /// Initializes a new `Typography` instance with customizable font settings.
  ///
  /// - Parameters:
  ///   - heading: The heading fonts.
  ///   - body: The body fonts.
  ///   - mono: The monospaced fonts.
  ///   - width: The typography width.
  ///   - sizes: A dictionary of font sizes.
  ///   - tracking: A dictionary of letter spacing values.
  ///   - leading: A dictionary of line heights.
  init(
    heading: [String] = ["system-ui", "sans-serif"],
    body: [String] = ["system-ui", "sans-serif"],
    mono: [String] = ["system-ui", "monospace"],
    width: Int = 60,
    sizes: [String: FontSize] = [
      "xSmall": FontSize(size: 0.75, lineHeight: 1 / 0.75),
      "small": FontSize(size: 0.875, lineHeight: 1.25 / 0.875),
      "base": FontSize(size: 1),
      "large": FontSize(size: 1.125, lineHeight: 1.75 / 1.125),
      "xLarge": FontSize(size: 1.25, lineHeight: 1.75 / 1.25),
      "twoXLarge": FontSize(size: 1.5, lineHeight: 2 / 1.5),
      "threeXLarge": FontSize(size: 1.875, lineHeight: 2.25 / 1.875),
      "fourXLarge": FontSize(size: 2.25, lineHeight: 2.5 / 2.25),
      "fiveXLarge": FontSize(size: 3, lineHeight: 1),
      "sixXLarge": FontSize(size: 3.75, lineHeight: 1),
      "sevenXLarge": FontSize(size: 4.5, lineHeight: 1),
      "eightXLarge": FontSize(size: 5.25, lineHeight: 1),
      "nineXLarge": FontSize(size: 6, lineHeight: 1),
    ],
    tracking: [String: Double] = [
      "tighter": -0.05,
      "tight": -0.025,
      "normal": 0,
      "wide": 0.025,
      "wider": 0.05,
      "widest": 0.1,
    ],
    leading: [String: Double] = [
      "tight": 1.125,
      "snug": 1.375,
      "normal": 1.5,
      "relaxed": 1.625,
      "loose": 2,
    ]
  ) {
    self.heading = heading
    self.body = body
    self.mono = mono
    self.width = width
    self.sizes = sizes
    self.tracking = tracking
    self.leading = leading
  }
}

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
