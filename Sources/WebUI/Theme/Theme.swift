enum Breakpoint: Int {
  case small = 40, medium = 48, large = 64, xLarge = 80, twoXLarge = 96
}

// TODO: Implement a good color system with shades and extensibility

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
