enum Breakpoint: Int {
  case small = 40, medium = 48, large = 64, xLarge = 80, twoXLarge = 96
}

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
