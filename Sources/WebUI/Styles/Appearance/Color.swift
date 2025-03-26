/// Represents a color value for styling utilities.
///
/// Defines a palette of colors with shades and a custom option for arbitrary values.
public enum Color {
  /// A slate gray color with varying intensity shades.
  case slate(Shade)
  /// A neutral gray color with varying intensity shades.
  case gray(Shade)
  /// A cool-toned gray color with varying intensity shades.
  case zinc(Shade)
  /// A balanced neutral color with varying intensity shades.
  case neutral(Shade)
  /// A warm-toned stone color with varying intensity shades.
  case stone(Shade)
  /// A vibrant red color with varying intensity shades.
  case red(Shade)
  /// A bright orange color with varying intensity shades.
  case orange(Shade)
  /// A rich amber color with varying intensity shades.
  case amber(Shade)
  /// A sunny yellow color with varying intensity shades.
  case yellow(Shade)
  /// A fresh lime color with varying intensity shades.
  case lime(Shade)
  /// A lush green color with varying intensity shades.
  case green(Shade)
  /// A deep emerald color with varying intensity shades.
  case emerald(Shade)
  /// A teal blue-green color with varying intensity shades.
  case teal(Shade)
  /// A bright cyan color with varying intensity shades.
  case cyan(Shade)
  /// A soft sky blue color with varying intensity shades.
  case sky(Shade)
  /// A classic blue color with varying intensity shades.
  case blue(Shade)
  /// A rich indigo color with varying intensity shades.
  case indigo(Shade)
  /// A vibrant violet color with varying intensity shades.
  case violet(Shade)
  /// A deep purple color with varying intensity shades.
  case purple(Shade)
  /// A bold fuchsia color with varying intensity shades.
  case fuchsia(Shade)
  /// A soft pink color with varying intensity shades.
  case pink(Shade)
  /// A warm rose color with varying intensity shades.
  case rose(Shade)
  /// A custom color defined by a raw CSS value
  case custom(String)

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

  /// Provides the raw CSS class value for the color.
  public var rawValue: String {
    switch self {
      case .slate(let shade):
        return "slate-\(shade.rawValue)"
      case .gray(let shade):
        return "gray-\(shade.rawValue)"
      case .zinc(let shade):
        return "zinc-\(shade.rawValue)"
      case .neutral(let shade):
        return "neutral-\(shade.rawValue)"
      case .stone(let shade):
        return "stone-\(shade.rawValue)"
      case .red(let shade):
        return "red-\(shade.rawValue)"
      case .orange(let shade):
        return "orange-\(shade.rawValue)"
      case .amber(let shade):
        return "amber-\(shade.rawValue)"
      case .yellow(let shade):
        return "yellow-\(shade.rawValue)"
      case .lime(let shade):
        return "lime-\(shade.rawValue)"
      case .green(let shade):
        return "green-\(shade.rawValue)"
      case .emerald(let shade):
        return "emerald-\(shade.rawValue)"
      case .teal(let shade):
        return "teal-\(shade.rawValue)"
      case .cyan(let shade):
        return "cyan-\(shade.rawValue)"
      case .sky(let shade):
        return "sky-\(shade.rawValue)"
      case .blue(let shade):
        return "blue-\(shade.rawValue)"
      case .indigo(let shade):
        return "indigo-\(shade.rawValue)"
      case .violet(let shade):
        return "violet-\(shade.rawValue)"
      case .purple(let shade):
        return "purple-\(shade.rawValue)"
      case .fuchsia(let shade):
        return "fuchsia-\(shade.rawValue)"
      case .pink(let shade):
        return "pink-\(shade.rawValue)"
      case .rose(let shade):
        return "rose-\(shade.rawValue)"
      case .custom(let value):
        return "[\(value)]"
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
