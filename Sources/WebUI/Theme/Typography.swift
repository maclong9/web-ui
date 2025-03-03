import Foundation

enum Size: String {
  case
    xs = "text-xs",
    sm = "text-sm",
    base = "text-base",
    lg = "text-lg",
    xl = "text-xl",
    _2xl = "text-2xl",
    _3xl = "text-3xl",
    _4xl = "text-4xl",
    _5xl = "text-5xl",
    _6xl = "text-6xl",
    _7xl = "text-7xl",
    _8xl = "text-8xl",
    _9xl = "text-9xl"
}

enum Alignment: String {
  case left, center, right

  var rawValue: String {
    return "text-\(self)"
  }
}

enum Weight: String {
  case thin, extralight, light, normal, medium, semibold, bold, extrabold, black

  var rawValue: String {
    return "font-\(self)"
  }
}

enum Tracking: String {
  case tighter, tight, normal, wide, wider, widest

  var rawValue: String {
    return "tracking-\(self)"
  }
}

enum Leading: String {
  case tightest, tighter, tight, normal, relaxed, loose

  var rawValue: String {
    return "leading-\(self)"
  }
}

enum Decoration: String {
  case underline, lineThrough, double, dotted, dashed, wavy

  var rawValue: String {
    return "decoration-\(self)"
  }
}

struct Typography {
  let heading: [String]
  let body: [String]
  let mono: [String]

  init(
    heading: [String] = ["system-ui", "sans-serif"],
    body: [String] = ["system-ui", "sans-serif"],
    mono: [String] = ["system-ui", "monospace"],
    width: Int = 60
  ) {
    self.heading = heading
    self.body = body
    self.mono = mono
  }
}
