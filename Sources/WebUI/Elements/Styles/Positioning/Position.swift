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
  ///   - type: The position type.
  ///   - inset: The value for all edges. Applies `inset-{value}` if specified.
  ///   - top: The value for the top edge.
  ///   - right: The value for the right edge.
  ///   - bottom: The value for the bottom edge.
  ///   - left: The value for the left edge.
  ///   - breakpoint: Optional breakpoint prefix.
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
