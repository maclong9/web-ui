enum Size: String {
  case xs, sm, base, lg, xl, xl2, xl3, xl4, xl5, xl6, xl7, xl8, xl9

  var rawValue: String {
    let raw = String(describing: self)
    if raw.hasPrefix("xl"), let number = raw.dropFirst(2).first {
      return "text-\(number)xl"
    }
    return "text-\(raw)"
  }
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

// MARK: - Element Modifiers
extension Element {
  func font(
    weight: Weight? = nil,
    size: Size? = nil,
    alignment: Alignment? = nil,
    tracking: Tracking? = nil,
    leading: Leading? = nil,
    decoration: Decoration? = nil
  ) -> Element {
    let updatedClasses: [String] =
      (self.classes ?? [])
      + [
        weight?.rawValue,
        size?.rawValue,
        alignment?.rawValue,
        tracking?.rawValue,
        leading?.rawValue,
        decoration?.rawValue,
      ].compactMap { $0 }

    return Element(
      tag: self.tag,
      id: self.id,
      classes: updatedClasses,
      role: self.role,
      content: self.contentBuilder
    )
  }
}
