/// Defines positioning types for elements.
///
/// Specifies how an element is positioned within its parent or viewport.
public enum PositionType: String {
  /// Positions the element using the normal document flow.
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
  /// Applies positioning styling to the element with a single edge.
  ///
  /// Sets the position type and optional inset values for a specific edge, scoped to a breakpoint if provided.
  ///
  /// - Parameters:
  ///   - type: Specifies the positioning method (e.g., absolute, fixed).
  ///   - edge: The edge to apply the inset to. Defaults to `.all`.
  ///   - length: The distance value for the specified edge (e.g., "0", "4", "auto").
  ///   - breakpoint: Applies the styles at a specific screen size.
  /// - Returns: A new element with updated position classes.
  func position(
    _ type: PositionType,
    edge: Edge = .all,
    length: Int? = nil,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    position(type, edges: [edge], length: length, on: breakpoint)
  }

  /// Applies positioning styling to the element with multiple edges.
  ///
  /// Sets the position type and optional inset values for specified edges, scoped to a breakpoint if provided.
  ///
  /// - Parameters:
  ///   - type: Specifies the positioning method (e.g., absolute, fixed).
  ///   - edges: Array of edges to apply the inset to.
  ///   - length: The distance value for the specified edges (e.g., "0", "4", "auto").
  ///   - breakpoint: Applies the styles at a specific screen size.
  /// - Returns: A new element with updated position classes.
  func position(
    _ type: PositionType,
    edges: [Edge],
    length: Int? = nil,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = ["\(prefix)\(type.rawValue)"]

    if let lengthValue = length {
      for edge in edges {
        let edgePrefix: String
        switch edge {
          case .all:
            edgePrefix = "inset"
          case .top:
            edgePrefix = "top"
          case .leading:
            edgePrefix = "left"
          case .trailing:
            edgePrefix = "right"
          case .bottom:
            edgePrefix = "bottom"
          case .horizontal:
            edgePrefix = "inset-x"
          case .vertical:
            edgePrefix = "inset-y"
        }
        newClasses.append("\(prefix)\(edgePrefix)-\(lengthValue)")
      }
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
