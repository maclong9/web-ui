/// Defines positioning types for elements.
///
/// Specifies how an element is positioned within its parent or viewport.
public enum PositionType: String {
  /// Positions the элемент using the normal document flow.
  case `static`
  /// Positions the element relative to its normal position.
  case relative
  /// Positions the element relative to its nearest positioned ancestor.
  case absolute
  /// Positions the element relative to the viewport and fixes it in place.
  case fixed
  /// Positions the element relative to its normal position and sticks on scroll.
  case sticky
}

extension Element {
  /// Applies positioning styling to the element.
  ///
  /// Sets the position type and optional inset values, scoped to a breakpoint if provided.
  ///
  /// - Parameters:
  ///   - type: Specifies the positioning method (e.g., absolute, fixed).
  ///   - inset: Sets the distance from all edges.
  ///   - top: Sets the distance from the top edge.
  ///   - right: Sets the distance from the right edge.
  ///   - bottom: Sets the distance from the bottom edge.
  ///   - left: Sets the distance from the left edge.
  ///   - breakpoint: Applies the styles at a specific screen size.
  /// - Returns: A new element with updated position classes.
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
