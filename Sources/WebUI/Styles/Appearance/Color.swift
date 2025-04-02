/// Represents a color value for styling utilities.
///
/// Defines a palette of colors with shades, opacity, and a custom option for arbitrary values.
public enum Color {
  /// A slate gray color with varying intensity shades and optional opacity.
  case slate(Shade, opacity: Double? = nil)
  /// A neutral gray color with varying intensity shades and optional opacity.
  case gray(Shade, opacity: Double? = nil)
  /// A cool-toned gray color with varying intensity shades and optional opacity.
  case zinc(Shade, opacity: Double? = nil)
  /// A balanced neutral color with varying intensity shades and optional opacity.
  case neutral(Shade, opacity: Double? = nil)
  /// A warm-toned stone color with varying intensity shades and optional opacity.
  case stone(Shade, opacity: Double? = nil)
  /// A vibrant red color with varying intensity shades and optional opacity.
  case red(Shade, opacity: Double? = nil)
  /// A bright orange color with varying intensity shades and optional opacity.
  case orange(Shade, opacity: Double? = nil)
  /// A rich amber color with varying intensity shades and optional opacity.
  case amber(Shade, opacity: Double? = nil)
  /// A sunny yellow color with varying intensity shades and optional opacity.
  case yellow(Shade, opacity: Double? = nil)
  /// A fresh lime color with varying intensity shades and optional opacity.
  case lime(Shade, opacity: Double? = nil)
  /// A lush green color with varying intensity shades and optional opacity.
  case green(Shade, opacity: Double? = nil)
  /// A deep emerald color with varying intensity shades and optional opacity.
  case emerald(Shade, opacity: Double? = nil)
  /// A teal blue-green color with varying intensity shades and optional opacity.
  case teal(Shade, opacity: Double? = nil)
  /// A bright cyan color with varying intensity shades and optional opacity.
  case cyan(Shade, opacity: Double? = nil)
  /// A soft sky blue color with varying intensity shades and optional opacity.
  case sky(Shade, opacity: Double? = nil)
  /// A classic blue color with varying intensity shades and optional opacity.
  case blue(Shade, opacity: Double? = nil)
  /// A rich indigo color with varying intensity shades and optional opacity.
  case indigo(Shade, opacity: Double? = nil)
  /// A vibrant violet color with varying intensity shades and optional opacity.
  case violet(Shade, opacity: Double? = nil)
  /// A deep purple color with varying intensity shades and optional opacity.
  case purple(Shade, opacity: Double? = nil)
  /// A bold fuchsia color with varying intensity shades and optional opacity.
  case fuchsia(Shade, opacity: Double? = nil)
  /// A soft pink color with varying intensity shades and optional opacity.
  case pink(Shade, opacity: Double? = nil)
  /// A warm rose color with varying intensity shades and optional opacity.
  case rose(Shade, opacity: Double? = nil)
  /// A custom color defined by a raw CSS value with optional opacity
  case custom(String, opacity: Double? = nil)

  /// Defines shade intensity for colors.
  ///
  /// Specifies a range of shades from lightest (50) to darkest (950).
  public enum Shade: Int {
    /// The lightest shade, typically a very faint tint.
    case _50 = 50
    /// A light shade, slightly more pronounced than 50.
    case _100 = 100
    /// A subtle shade, often used for backgrounds or hover states.
    case _200 = 200
    /// A moderate shade, suitable for borders or accents.
    case _300 = 300
    /// A balanced shade, often used for text or UI elements.
    case _400 = 400
    /// A medium shade, commonly the default for a color family.
    case _500 = 500
    /// A slightly darker shade, good for emphasis.
    case _600 = 600
    /// A dark shade, often used for active states.
    case _700 = 700
    /// A very dark shade, suitable for strong contrast.
    case _800 = 800
    /// An almost black shade, often for deep backgrounds.
    case _900 = 900
    /// The darkest shade, nearly black with a hint of color.
    case _950 = 950
  }

  /// Provides the raw CSS class value for the color and opacity.
  public var rawValue: String {
    func formatOpacity(_ opacity: Double?) -> String {
      guard let opacity = opacity, (0...1).contains(opacity) else { return "" }
      return "/\(Int(opacity * 100))"
    }

    switch self {
      case .slate(let shade, let opacity):
        return "slate-\(shade.rawValue)\(formatOpacity(opacity))"
      case .gray(let shade, let opacity):
        return "gray-\(shade.rawValue)\(formatOpacity(opacity))"
      case .zinc(let shade, let opacity):
        return "zinc-\(shade.rawValue)\(formatOpacity(opacity))"
      case .neutral(let shade, let opacity):
        return "neutral-\(shade.rawValue)\(formatOpacity(opacity))"
      case .stone(let shade, let opacity):
        return "stone-\(shade.rawValue)\(formatOpacity(opacity))"
      case .red(let shade, let opacity):
        return "red-\(shade.rawValue)\(formatOpacity(opacity))"
      case .orange(let shade, let opacity):
        return "orange-\(shade.rawValue)\(formatOpacity(opacity))"
      case .amber(let shade, let opacity):
        return "amber-\(shade.rawValue)\(formatOpacity(opacity))"
      case .yellow(let shade, let opacity):
        return "yellow-\(shade.rawValue)\(formatOpacity(opacity))"
      case .lime(let shade, let opacity):
        return "lime-\(shade.rawValue)\(formatOpacity(opacity))"
      case .green(let shade, let opacity):
        return "green-\(shade.rawValue)\(formatOpacity(opacity))"
      case .emerald(let shade, let opacity):
        return "emerald-\(shade.rawValue)\(formatOpacity(opacity))"
      case .teal(let shade, let opacity):
        return "teal-\(shade.rawValue)\(formatOpacity(opacity))"
      case .cyan(let shade, let opacity):
        return "cyan-\(shade.rawValue)\(formatOpacity(opacity))"
      case .sky(let shade, let opacity):
        return "sky-\(shade.rawValue)\(formatOpacity(opacity))"
      case .blue(let shade, let opacity):
        return "blue-\(shade.rawValue)\(formatOpacity(opacity))"
      case .indigo(let shade, let opacity):
        return "indigo-\(shade.rawValue)\(formatOpacity(opacity))"
      case .violet(let shade, let opacity):
        return "violet-\(shade.rawValue)\(formatOpacity(opacity))"
      case .purple(let shade, let opacity):
        return "purple-\(shade.rawValue)\(formatOpacity(opacity))"
      case .fuchsia(let shade, let opacity):
        return "fuchsia-\(shade.rawValue)\(formatOpacity(opacity))"
      case .pink(let shade, let opacity):
        return "pink-\(shade.rawValue)\(formatOpacity(opacity))"
      case .rose(let shade, let opacity):
        return "rose-\(shade.rawValue)\(formatOpacity(opacity))"
      case .custom(let value, let opacity):
        let opacityStr = formatOpacity(opacity)
        return "[\(value)]\(opacityStr)"
    }
  }
}

extension Element {
  /// Applies a background color to the element.
  ///
  /// Adds a background color class based on the provided color and optional modifiers.
  ///
  /// - Parameters:
  ///   - color: Sets the background color from the palette or a custom value.
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated background classes.
  public func background(
    color: Color,
    on modifiers: Modifier...
  ) -> Element {
    let baseClass = "bg-\(color.rawValue)"
    let newClasses: [String]

    if modifiers.isEmpty {
      newClasses = [baseClass]
    } else {
      let combinedModifierPrefix = modifiers.map { $0.rawValue }.joined()
      newClasses = ["\(combinedModifierPrefix)\(baseClass)"]
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
