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
  /// Applies positioning styling to the element with one or more edges.
  ///
  /// Sets the position type and optional inset values for specified edges, scoped to modifiers if provided.
  ///
  /// - Parameters:
  ///   - type: Specifies the positioning method (e.g., absolute, fixed).
  ///   - edges: One or more edges to apply the inset to. Defaults to `.all`.
  ///   - length: The distance value for the specified edges (e.g., "0", "4", "auto").
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated position classes.
  public func position(
    _ type: PositionType? = nil,
    edges: Edge...,
    length: Int? = nil,
    on modifiers: Modifier...
  ) -> Element {
    let effectiveEdges = edges.isEmpty ? [Edge.all] : edges
    var baseClasses: [String] = [type?.rawValue ?? ""]

    if let lengthValue = length {
      for edge in effectiveEdges {
        let edgePrefix: String
        switch edge {
          case .all: edgePrefix = "inset"
          case .top: edgePrefix = "top"
          case .leading: edgePrefix = "left"
          case .trailing: edgePrefix = "right"
          case .bottom: edgePrefix = "bottom"
          case .horizontal: edgePrefix = "inset-x"
          case .vertical: edgePrefix = "inset-y"
        }
        baseClasses.append("\(length != nil && length! >= 0 ? "" : "-")\(edgePrefix)-\(lengthValue)")
      }
    }

    let newClasses: [String]
    if modifiers.isEmpty {
      newClasses = baseClasses
    } else {
      newClasses = baseClasses.flatMap { base in
        modifiers.map { modifier in
          "\(modifier.rawValue)\(base)"
        }
      }
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
