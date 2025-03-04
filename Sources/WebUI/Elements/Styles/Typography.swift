/// Represents different font sizes.
/// Each case corresponds to a specific CSS text size class.
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

/// Represents different text alignments.
/// Each case corresponds to a specific CSS text alignment class.
enum Alignment: String {
  case left, center, right

  var rawValue: String {
    return "text-\(self)"
  }
}

/// Represents different font weights.
/// Each case corresponds to a specific Tailwind CSS font weight class.
enum Weight: String {
  case thin, extralight, light, normal, medium, semibold, bold, extrabold, black

  var rawValue: String {
    return "font-\(self)"
  }
}

/// Represents different letter spacings (tracking).
/// Each case corresponds to a specific Tailwind CSS tracking class.
enum Tracking: String {
  case tighter, tight, normal, wide, wider, widest

  var rawValue: String {
    return "tracking-\(self)"
  }
}

/// Represents different line heights (leading).
/// Each case corresponds to a specific CSS leading class.
enum Leading: String {
  case tightest, tighter, tight, normal, relaxed, loose

  var rawValue: String {
    return "leading-\(self)"
  }
}

/// Represents different text decorations.
/// Each case corresponds to a specific CSS decoration class.
enum Decoration: String {
  case underline, lineThrough, double, dotted, dashed, wavy

  var rawValue: String {
    return "decoration-\(self)"
  }
}

// MARK: - Element Modifiers
extension Element {
  /// Adds font styling classes to the element.
  /// - Parameters:
  ///   - weight: Font weight.
  ///   - size: Font size.
  ///   - alignment: Text alignment.
  ///   - tracking: Letter spacing.
  ///   - leading: Line height.
  ///   - decoration: Text decoration.
  /// - Returns: A new Element with updated classes.
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
