/// Represents dimensions for width and height.
public enum Dimension {
  /// Fixed size
  case fixed(Int)
  /// Fractional size.
  case fraction(Int, Int)
  /// Full width or height.
  case full
  /// Screen width or height.
  case screen
  /// Auto width or height.
  case auto
  /// Minimum content size.
  case minContent
  /// Maximum content size.
  case maxContent
  /// Fit content size.
  case fitContent
  /// Character width (e.g., 60ch)
  case character(Int)
  /// Arbitrary custom value.
  case custom(String)

  public var rawValue: String {
    switch self {
      case .fixed(let value):
        return "\(value)"
      case .fraction(let numerator, let denominator):
        return "\(numerator)/\(denominator)"
      case .full:
        return "full"
      case .screen:
        return "screen"
      case .auto:
        return "auto"
      case .minContent:
        return "min"
      case .maxContent:
        return "max"
      case .fitContent:
        return "fit"
      case .character(let value):
        return "[\(value)ch]"
      case .custom(let value):
        return "[\(value)]"
    }
  }
}

extension Element {
  /// Sets the width and height of the element with optional modifiers.
  ///
  /// - Parameters:
  ///   - width: The width dimension.
  ///   - height: The height dimension.
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated sizing classes.
  public func frame(
    width: Dimension? = nil,
    minWidth: Dimension? = nil,
    maxWidth: Dimension? = nil,
    height: Dimension? = nil,
    minHeight: Dimension? = nil,
    maxHeight: Dimension? = nil,
    on modifiers: Modifier...
  ) -> Element {
    var baseClasses: [String] = []
    if let width = width { baseClasses.append("w-\(width.rawValue)") }
    if let minWidth = minWidth { baseClasses.append("min-w-\(minWidth.rawValue)") }
    if let maxWidth = maxWidth { baseClasses.append("max-w-\(maxWidth.rawValue)") }
    if let height = height { baseClasses.append("h-\(height.rawValue)") }
    if let minHeight = minHeight { baseClasses.append("min-h-\(minHeight.rawValue)") }
    if let maxHeight = maxHeight { baseClasses.append("max-h-\(maxHeight.rawValue)") }

    let newClasses: [String]

    if modifiers.isEmpty {
      newClasses = baseClasses
    } else {
      let combinedModifierPrefix = modifiers.map { $0.rawValue }.joined()
      newClasses = baseClasses.map { "\(combinedModifierPrefix)\($0)" }
    }

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
}
