import Foundation

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

  /// Initializes a new `Typography` instance with customizable font settings using a type scale.
  ///
  /// - Parameters:
  ///   - heading: The heading fonts.
  ///   - body: The body fonts.
  ///   - mono: The monospaced fonts.
  ///   - width: The typography width.
  ///   - baseSize: The base font size in rem (default 1).
  ///   - scaleRatio: The ratio for the type scale (default 1.25 for a major third).
  ///   - multiplier: Multiplier to increase/decrease all sizes (default 1.0).
  ///   - tracking: A dictionary of letter spacing values.
  ///   - leading: A dictionary of line heights.
  init(
    heading: [String] = ["system-ui", "sans-serif"],
    body: [String] = ["system-ui", "sans-serif"],
    mono: [String] = ["system-ui", "monospace"],
    width: Int = 60,
    scaleRatio: Double = 1.25,
    multiplier: Double = 1.0,
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
    self.tracking = tracking
    self.leading = leading

    // MARK: - Typescale
    // Calculate sizes based on type scale
    let adjustedBase = 1.0 * multiplier
    self.sizes = [
      "xSmall": FontSize(
        size: adjustedBase * pow(scaleRatio, -2),
        lineHeight: 1.5
      ),
      "small": FontSize(
        size: adjustedBase * pow(scaleRatio, -1),
        lineHeight: 1.5
      ),
      "base": FontSize(
        size: adjustedBase,
        lineHeight: 1.5
      ),
      "large": FontSize(
        size: adjustedBase * pow(scaleRatio, 1),
        lineHeight: 1.625
      ),
      "xLarge": FontSize(
        size: adjustedBase * pow(scaleRatio, 2),
        lineHeight: 1.625
      ),
      "twoXLarge": FontSize(
        size: adjustedBase * pow(scaleRatio, 3),
        lineHeight: 1.75
      ),
      "threeXLarge": FontSize(
        size: adjustedBase * pow(scaleRatio, 4),
        lineHeight: 1.75
      ),
      "fourXLarge": FontSize(
        size: adjustedBase * pow(scaleRatio, 5),
        lineHeight: 1.75
      ),
      "fiveXLarge": FontSize(
        size: adjustedBase * pow(scaleRatio, 6),
        lineHeight: 1.5
      ),
      "sixXLarge": FontSize(
        size: adjustedBase * pow(scaleRatio, 7),
        lineHeight: 1.5
      ),
      "sevenXLarge": FontSize(
        size: adjustedBase * pow(scaleRatio, 8),
        lineHeight: 1.25
      ),
      "eightXLarge": FontSize(
        size: adjustedBase * pow(scaleRatio, 9),
        lineHeight: 1.25
      ),
      "nineXLarge": FontSize(
        size: adjustedBase * pow(scaleRatio, 10),
        lineHeight: 1.25
      ),
    ]
  }
}
