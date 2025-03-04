import Foundation

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
