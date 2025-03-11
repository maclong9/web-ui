/// Represents dimensions for width and height.
public enum Dimension {
  /// Fixed size 
  case fixed(Int)
  /// Fractional size (e.g., 1/2 = 50%).
  case fraction(Int, Int)
  /// Full width or height (100%).
  case full
  /// Screen width or height (100vw or 100vh).
  case screen
  /// Auto width or height.
  case auto
  /// Minimum content size.
  case minContent
  /// Maximum content size.
  case maxContent
  /// Fit content size.
  case fitContent
  /// Arbitrary custom value (e.g., "200px" for `[200px]`).
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
  /// Sets the width and height of the element with an optional breakpoint.
  ///
  /// - Parameters:
  ///   - width: The width dimension (e.g., `.full`, `.fixed(4)`, `.custom("200px")`).
  ///   - height: The height dimension (e.g., `.screen`, `.fraction(1,2)`).
  ///   - breakpoint: Optional breakpoint prefix
  /// - Returns: A new `Element` with the updated sizing classes.
  func frame(width: Dimension? = nil, height: Dimension? = nil, on breakpoint: Breakpoint? = nil) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    if let width = width {
      newClasses.append("\(prefix)w-\(width.rawValue)")
    }
    if let height = height {
      newClasses.append("\(prefix)h-\(height.rawValue)")
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
