/// Represents different font sizes.
public enum TextSize: String {
  /// Represents an extra-small font size
  case xs
  /// Represents a small font size
  case sm
  /// Represents the base (default) font size
  case base
  /// Represents a large font size
  case lg
  /// Represents an extra-large font size
  case xl
  /// Represents a 2x extra-large font size
  case xl2
  /// Represents a 3x extra-large font size
  case xl3
  /// Represents a 4x extra-large font size
  case xl4
  /// Represents a 5x extra-large font size
  case xl5
  /// Represents a 6x extra-large font size
  case xl6
  /// Represents a 7x extra-large font size
  case xl7
  /// Represents a 8x extra-large font size
  case xl8
  /// Represents a 9x extra-large font size
  case xl9

  public var className: String {
    let raw = String(describing: self)
    if raw.hasPrefix("xl"), let number = raw.dropFirst(2).first {
      return "text-\(number)xl"
    }
    return "text-\(raw)"
  }
}

/// Text alignment options
public enum Alignment: String {
  case left, center, right
  var className: String { "text-\(rawValue)" }
}

/// Font weight options
public enum Weight: String {
  case thin, extralight, light, normal
  case medium, semibold, bold, extrabold, black
  var className: String { "font-\(rawValue)" }
}

/// Letter spacing options
public enum Tracking: String {
  case tighter, tight, normal, wide, wider, widest
  var className: String { "tracking-\(rawValue)" }
}

/// Line height options
public enum Leading: String {
  case tightest, tighter, tight, normal, relaxed, loose
  var className: String { "leading-\(rawValue)" }
}

/// Text decoration options
public enum Decoration: String {
  case underline, lineThrough, double, dotted, dashed, wavy
  var className: String { "decoration-\(rawValue)" }
}

extension Element {
  /// Applies font styling to the element with an optional breakpoint.
  ///
  /// - Parameters:
  ///   - size: The font size.
  ///   - weight: The font weight.
  ///   - alignment: The text alignment.
  ///   - tracking: The letter spacing.
  ///   - leading: The line height.
  ///   - decoration: The text decoration.
  ///   - color: The text color.
  ///   - breakpoint: Optional breakpoint prefix.
  /// - Returns: A new `Element` with the updated font styling classes.
  func font(
    size: TextSize? = nil,
    weight: Weight? = nil,
    alignment: Alignment? = nil,
    tracking: Tracking? = nil,
    leading: Leading? = nil,
    decoration: Decoration? = nil,
    color: Color? = nil,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    if let size = size {
      newClasses.append("\(prefix)\(size.className)")
    }
    if let weight = weight {
      newClasses.append("\(prefix)\(weight.className)")
    }
    if let alignment = alignment {
      newClasses.append("\(prefix)\(alignment.className)")
    }
    if let tracking = tracking {
      newClasses.append("\(prefix)\(tracking.className)")
    }
    if let leading = leading {
      newClasses.append("\(prefix)\(leading.className)")
    }
    if let decoration = decoration {
      newClasses.append("\(prefix)\(decoration.className)")
    }
    if let color = color {
      newClasses.append("\(prefix)text-\(color.rawValue)")
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
