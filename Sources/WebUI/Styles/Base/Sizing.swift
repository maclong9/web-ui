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
  /// Arbitrary custom value.
  case custom(String)
}

extension Dimension {
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
  func frame(
    width: Dimension? = nil,
    height: Dimension? = nil,
    on modifiers: Modifier...
  ) -> Element {
    var baseClasses: [String] = []
    if let width = width { baseClasses.append("w-\(width.rawValue)") }
    if let height = height { baseClasses.append("h-\(height.rawValue)") }

    let newClasses: [String]

    if modifiers.isEmpty {
      newClasses = baseClasses
    } else {
      let combinedModifierPrefix = modifiers.map { $0.rawValue }.joined()
      // newClasses = ["\(combinedModifierPrefix)\(baseClasses.map { "\($0)" }.joined(separator: " "))"]
      newClasses = baseClasses.map { "\(combinedModifierPrefix)\($0)" }
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
