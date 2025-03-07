/// Represents different font sizes.
public enum Size: String {
  /// Represents an extra-small font size
  case xs
  /// Represents a small font size
  case sm
  /// Represents the base (default) font size
  case base
  /// Represents a large font size
  case lg
  /// Represents an extra-large font size
  case extralLarge
  /// Represents a 2x extra-large font size
  case extraLarge2
  /// Represents a 3x extra-large font size
  case extraLarge3
  /// Represents a 4x extra-large font size
  case extraLarge4
  /// Represents a 5x extra-large font size
  case extraLarge5
  /// Represents a 6x extra-large font size
  case extraLarge6
  /// Represents a 7x extra-large font size
  case extraLarge7
  /// Represents a 8x extra-large font size
  case extraLarge8
  /// Represents a 9x extra-large font size
  case extraLarge9

  public var rawValue: String {
    let raw = String(describing: self)
    if raw.hasPrefix("extraLarge"), let number = raw.dropFirst(10).first {
      return "text-\(number)xl"
    }
    return "text-\(raw)"
  }
}

/// Represents different text alignments.
public enum Alignment: String {
  /// Aligns text to the left
  case left
  /// Centers text horizontally
  case center
  /// Aligns text to the right
  case right

  public var rawValue: String {
    return "text-\(self)"
  }
}

/// Represents different font weights.
public enum Weight: String {
  /// Represents a thin font weight (100)
  case thin
  /// Represents an extra-light font weight (200)
  case extralight
  /// Represents a light font weight (300)
  case light
  /// Represents a normal font weight (400)
  case normal
  /// Represents a medium font weight (500)
  case medium
  /// Represents a semi-bold font weight (600)
  case semibold
  /// Represents a bold font weight (700)
  case bold
  /// Represents an extra-bold font weight (800)
  case extrabold
  /// Represents a black font weight (900)
  case black

  public var rawValue: String {
    return "font-\(self)"
  }
}

/// Represents different letter spacings (tracking).
public enum Tracking: String {
  /// Represents a very tight letter spacing
  case tighter
  /// Represents a tight letter spacing
  case tight
  /// Represents normal letter spacing
  case normal
  /// Represents a wide letter spacing
  case wide
  /// Represents a wider letter spacing
  case wider
  /// Represents the widest letter spacing
  case widest

  public var rawValue: String {
    return "tracking-\(self)"
  }
}

/// Represents different line heights (leading).
public enum Leading: String {
  /// Represents the tightest line height
  case tightest
  /// Represents a tighter line height
  case tighter
  /// Represents a tight line height
  case tight
  /// Represents a normal line height
  case normal
  /// Represents a relaxed line height
  case relaxed
  /// Represents a loose line height
  case loose

  public var rawValue: String {
    return "leading-\(self)"
  }
}

/// Represents different text decorations.
public enum Decoration: String {
  /// Represents an underline text decoration
  case underline
  /// Represents a line-through (strikethrough) text decoration
  case lineThrough
  /// Represents a double underline text decoration
  case double
  /// Represents a dotted underline text decoration
  case dotted
  /// Represents a dashed underline text decoration
  case dashed
  /// Represents a wavy underline text decoration
  case wavy

  public var rawValue: String {
    return "decoration-\(self)"
  }
}

extension Element {
  /// Adds font styling classes to the element with an optional breakpoint.
  ///
  /// - Parameters:
  ///   - weight: Font weight (e.g., bold).
  ///   - size: Font size (e.g., lg).
  ///   - alignment: Text alignment (e.g., center).
  ///   - tracking: Letter spacing (e.g., tight).
  ///   - leading: Line height (e.g., normal).
  ///   - decoration: Text decoration (e.g., underline).
  ///   - breakpoint: Which screen size to apply these styles to
  /// - Returns: A new Element with updated classes.
  func font(
    weight: Weight? = nil,
    size: Size? = nil,
    alignment: Alignment? = nil,
    tracking: Tracking? = nil,
    leading: Leading? = nil,
    decoration: Decoration? = nil,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix: String = breakpoint?.rawValue ?? ""

    var newClasses: [String] = []
    if let weightValue = weight?.rawValue {
      newClasses.append(prefix + weightValue)
    }
    if let sizeValue = size?.rawValue {
      newClasses.append(prefix + sizeValue)
    }
    if let alignmentValue = alignment?.rawValue {
      newClasses.append(prefix + alignmentValue)
    }
    if let trackingValue = tracking?.rawValue {
      newClasses.append(prefix + trackingValue)
    }
    if let leadingValue = leading?.rawValue {
      newClasses.append(prefix + leadingValue)
    }
    if let decorationValue = decoration?.rawValue {
      newClasses.append(prefix + decorationValue)
    }

    let updatedClasses = (self.classes ?? []) + newClasses

    return Element(
      tag: self.tag,
      id: self.id,
      classes: updatedClasses,
      role: self.role,
      content: self.contentBuilder
    )
  }
}
