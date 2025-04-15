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

/// Text wrapping options
public enum Wrapping: String {
  case balance, pretty, wrap, nowrap
  var className: String { "text-\(rawValue)" }
}

extension Element {
  /// Applies font styling to the element with optional modifiers.
  ///
  /// - Parameters:
  ///   - size: The font size.
  ///   - weight: The font weight.
  ///   - alignment: The text alignment.
  ///   - tracking: The letter spacing.
  ///   - leading: The line height.
  ///   - decoration: The text decoration.
  ///   - wrapping: The text wrapping.
  ///   - color: The text color.
  ///   - family: The font family (e.g., "sans", "serif", "mono").
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated font styling classes.
  public func font(
    size: TextSize? = nil,
    weight: Weight? = nil,
    alignment: Alignment? = nil,
    tracking: Tracking? = nil,
    leading: Leading? = nil,
    decoration: Decoration? = nil,
    wrapping: Wrapping? = nil,
    color: Color? = nil,
    family: String? = nil,
    on modifiers: Modifier...
  ) -> Element {
    var baseClasses: [String] = []
    if let size = size { baseClasses.append(size.className) }
    if let weight = weight { baseClasses.append(weight.className) }
    if let alignment = alignment { baseClasses.append(alignment.className) }
    if let tracking = tracking { baseClasses.append(tracking.className) }
    if let leading = leading { baseClasses.append(leading.className) }
    if let decoration = decoration { baseClasses.append(decoration.className) }
    if let wrapping = wrapping { baseClasses.append(wrapping.className) }
    if let color = color { baseClasses.append("text-\(color.rawValue)") }
    if let family = family { baseClasses.append("font-[\(family)]") }

    let newClasses =
      modifiers.isEmpty
      ? baseClasses
      : baseClasses.flatMap { base in modifiers.map { "\($0.rawValue)\(base)" } }

    return Element(
      tag: self.tag,
      config: ElementConfig(
        id: self.config.id,
        classes: (self.config.classes ?? []) + newClasses,
        role: self.config.role,
        label: self.config.label
      ),
      isSelfClosing: self.isSelfClosing,
      content: self.contentBuilder
    )
  }

  public enum ProseSize: String {
    case sm, base, lg, xl
    case xl2 = "2xl"

    public var rawValue: String {
      "prose-\(self)"
    }
  }

  public enum ProseColor: String {
    case gray, slate, zinc, neutral

    public var rawValue: String {
      "prose-\(self)"
    }
  }
}
