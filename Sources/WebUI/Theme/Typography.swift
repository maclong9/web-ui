import Foundation

enum Tracking: Double {
  case tighter = -0.05
  case tight = -0.025
  case normal = 0
  case wide = 0.025
  case wider = 0.05
  case widest = 0.1
}

enum Leading: Double {
  case tightest = 1.0
  case tighter = 1.25
  case tight = 1.375
  case normal = 1.5
  case relaxed = 1.625
  case loose = 2.0
}

enum Size: String, CaseIterable {
  case xs
  case sm
  case base
  case lg
  case xl
  case xl2
  case xl3
  case xl4
  case xl5
  case xl6
  case xl7
  case xl8
  case xl9

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

struct Typography {
  let heading: [String]
  let body: [String]
  let mono: [String]
  let width: Int
  let multiplier: Double

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
