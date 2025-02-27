import Foundation

// MARK: - Typography Enums

/// Defines letter spacing (tracking) values for typography.
///
/// These raw values represent the amount of space added or removed between characters,
/// measured as a fraction of the font size.
enum Tracking: Double {
  case tighter = -0.05
  case tight = -0.025
  case normal = 0
  case wide = 0.025
  case wider = 0.05
  case widest = 0.1
}

/// Defines line spacing (leading) values for typography.
///
/// These values represent the multiplier applied to the font size to determine
/// the total line height.
enum Leading: Double {
  case tightest = 1.0  // Added default value for consistency
  case tighter = 1.25  // Added default value for consistency
  case tight = 1.375
  case normal = 1.5
  case relaxed = 1.625
  case loose = 2.0
}

/// Represents predefined typography size scales with associated line heights.
///
/// The raw values indicate relative size steps from the base size,
/// with negative values being smaller and positive values being larger.
enum Size: Int, CaseIterable {
  case xs = -2
  case sm = -1
  case base = 0
  case lg = 1
  case xl = 2
  case xl2 = 3
  case xl3 = 4
  case xl4 = 5
  case xl5 = 6
  case xl6 = 7
  case xl7 = 8
  case xl8 = 9
  case xl9 = 10

  // MARK: - Properties

  var lineHeight: Double {
    switch self {
      case .xs, .sm, .base:
        return 1.5
      case .lg, .xl:
        return 1.625
      case .xl2, .xl3, .xl4:
        return 1.75
      case .xl5, .xl6:
        return 1.5
      case .xl7, .xl8, .xl9:
        return 1.25
    }
  }
}

// MARK: - Typography Configuration

/// Defines typography settings including font families, sizes, and layout properties.
///
/// This struct provides a comprehensive configuration for typographic styles
/// across different text categories in an application.
struct Typography {
  // MARK: - Properties

  let heading: [String]
  let body: [String]
  let mono: [String]
  let width: Int
  let multiplier: Double

  // MARK: - Initialization

  /// Creates a new Typography configuration with customizable parameters.
  /// - Parameters:
  ///   - heading: Font families for headings, defaults to system sans-serif.
  ///   - body: Font families for body text, defaults to system sans-serif.
  ///   - mono: Font families for monospaced text, defaults to system monospace.
  ///   - width: Maximum width for text layout, defaults to 60 points.
  ///   - multiplier: Size scaling factor, defaults to 1.0.
  init(
    heading: [String] = ["system-ui", "sans-serif"],
    body: [String] = ["system-ui", "sans-serif"],
    mono: [String] = ["system-ui", "monospace"],
    width: Int = 60,
    multiplier: Double = 1.0
  ) {
    self.heading = heading
    self.body = body
    self.mono = mono
    self.width = width
    self.multiplier = multiplier
  }
}
