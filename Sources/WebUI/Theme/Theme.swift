/// Breakpoint sizes in rem units
enum Breakpoint: Int {
  case small = 40, medium = 48, large = 64, xLarge = 80, twoXLarge = 96
}

// TODO: Implement a good color system with shades and extensibility

/// Represents a design theme including breakpoints, colors, and typography settings.
struct Theme {
  let breakpoints: [String: Int]
  let typography: Typography

  /// Creates a new `Theme` instance with optional design settings.
  ///
  /// - Parameters:
  ///   - breakpoints: A dictionary defining responsive breakpoints (defaults to enum values).
  ///   - typography: The typography settings.
  init(
    breakpoints: [String: Int] = [:],
    typography: Typography = Typography()
  ) {
    self.breakpoints = breakpoints
    self.typography = typography
  }
}
