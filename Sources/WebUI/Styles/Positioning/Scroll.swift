/// Defines scroll behavior for an element.
///
/// Specifies how scrolling behaves, either smoothly or instantly.
public enum ScrollBehavior: String {
  /// Smooth scrolling behavior
  case smooth = "smooth"
  /// Instant scrolling behavior
  case auto = "auto"
}

/// Defines scroll snap alignment options.
///
/// Specifies how an element aligns within a scroll container.
public enum ScrollSnapAlign: String {
  /// Aligns to the start of the snap container
  case start
  /// Aligns to the end of the snap container
  case end
  /// Aligns to the center of the snap container
  case center
}

/// Defines scroll snap stop behavior.
///
/// Controls whether scrolling can skip past snap points.
public enum ScrollSnapStop: String {
  /// Allows scrolling to skip snap points
  case normal = "normal"
  /// Forces scrolling to stop at snap points
  case always = "always"
}

/// Defines scroll snap type options.
///
/// Specifies the type and strictness of scroll snapping.
public enum ScrollSnapType: String {
  /// Snap along the x-axis
  case x = "x"
  /// Snap along the y-axis
  case y = "y"
  /// Snap along both axes
  case both = "both"
  /// Mandatory snapping with stricter enforcement
  case mandatory = "mandatory"
  /// Proximity snapping with looser enforcement
  case proximity = "proximity"
}

extension Element {
  /// Applies scroll-related styles to the element.
  ///
  /// Adds Tailwind CSS classes for scroll behavior, margin, padding, and snap properties.
  ///
  /// - Parameters:
  ///   - behavior: Sets the scroll behavior (smooth or auto).
  ///   - margin: Sets the scroll margin in 0.25rem increments for all sides or specific edges.
  ///   - padding: Sets the scroll padding in 0.25rem increments for all sides or specific edges.
  ///   - snapAlign: Sets the scroll snap alignment (start, end, center).
  ///   - snapStop: Sets the scroll snap stop behavior (normal, always).
  ///   - snapType: Sets the scroll snap type (x, y, both, mandatory, proximity).
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated scroll-related classes.
  public func scroll(
    behavior: ScrollBehavior? = nil,
    margin: (value: Int, edges: [Edge])? = nil,
    padding: (value: Int, edges: [Edge])? = nil,
    snapAlign: ScrollSnapAlign? = nil,
    snapStop: ScrollSnapStop? = nil,
    snapType: ScrollSnapType? = nil,
    on modifiers: Modifier...
  ) -> Element {
    var baseClasses: [String] = []

    // Scroll Behavior
    if let behaviorValue = behavior {
      baseClasses.append("scroll-\(behaviorValue.rawValue)")
    }

    // Scroll Margin
    if let (value, edges) = margin {
      let effectiveEdges = edges.isEmpty ? [Edge.all] : edges
      baseClasses.append(
        contentsOf: effectiveEdges.map { edge in
          let edgePrefix: String
          switch edge {
            case .all: edgePrefix = ""
            case .top: edgePrefix = "t"
            case .bottom: edgePrefix = "b"
            case .leading: edgePrefix = "s"
            case .trailing: edgePrefix = "e"
            case .horizontal: edgePrefix = "x"
            case .vertical: edgePrefix = "y"
          }

          return "scroll-m\(edgePrefix.isEmpty ? "" : "\(edgePrefix)")-\(value)"
        })
    }

    // Scroll Padding
    if let (value, edges) = padding {
      let effectiveEdges = edges.isEmpty ? [Edge.all] : edges
      baseClasses.append(
        contentsOf: effectiveEdges.map { edge in
          let edgePrefix: String
          switch edge {
            case .all: edgePrefix = ""
            case .top: edgePrefix = "t"
            case .bottom: edgePrefix = "b"
            case .leading: edgePrefix = "s"
            case .trailing: edgePrefix = "e"
            case .horizontal: edgePrefix = "x"
            case .vertical: edgePrefix = "y"
          }
          return "scroll-p\(edgePrefix.isEmpty ? "" : "\(edgePrefix)")-\(value)"
        })
    }

    // Scroll Snap Align
    if let snapAlignValue = snapAlign {
      baseClasses.append("snap-\(snapAlignValue.rawValue)")
    }

    // Scroll Snap Stop
    if let snapStopValue = snapStop {
      baseClasses.append("snap-\(snapStopValue.rawValue)")
    }

    // Scroll Snap Type
    if let snapTypeValue = snapType {
      baseClasses.append("snap-\(snapTypeValue.rawValue)")
    }

    let newClasses = combineClasses(baseClasses, withModifiers: modifiers)

    return Element(
      tag: self.tag,
      id: self.id,
      classes: (self.classes ?? []) + newClasses,
      role: self.role,
      label: self.label,
      isSelfClosing: self.isSelfClosing,
      customAttributes: self.customAttributes,
      content: self.contentBuilder
    )
  }
}
