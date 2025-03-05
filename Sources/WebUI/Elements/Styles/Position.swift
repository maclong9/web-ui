/// Represents position types
public enum PositionType: String {
  case `static`
  case relative
  case absolute
  case fixed
  case sticky
}

extension Element {
  /// Sets the position type, optional inset, and edge values of the element with an optional breakpoint.
  ///
  /// - Parameters:
  ///   - type: The position type (e.g., `.absolute`, `.relative`).
  ///   - inset: The value for all edges (e.g., "0", "auto", "[2rem]"). Applies `inset-{value}` if specified.
  ///   - top: The value for the top edge (e.g., "0", "4", "[2rem]").
  ///   - right: The value for the right edge (e.g., "auto", "1/2").
  ///   - bottom: The value for the bottom edge (e.g., "0", "[50%]").
  ///   - left: The value for the left edge (e.g., "4", "full").
  ///   - breakpoint: Optional breakpoint prefix (e.g., `md:` applies styles at 768px and up).
  /// - Returns: A new `Element` with the updated position, inset, and edge classes.
  func position(
    _ type: PositionType,
    inset: String? = nil,
    top: String? = nil,
    right: String? = nil,
    bottom: String? = nil,
    left: String? = nil,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = ["\(prefix)\(type.rawValue)"]

    if let inset = inset {
      newClasses.append("\(prefix)inset-\(inset)")
    }
    if let top = top {
      newClasses.append("\(prefix)top-\(top)")
    }
    if let right = right {
      newClasses.append("\(prefix)right-\(right)")
    }
    if let bottom = bottom {
      newClasses.append("\(prefix)bottom-\(bottom)")
    }
    if let left = left {
      newClasses.append("\(prefix)left-\(left)")
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
