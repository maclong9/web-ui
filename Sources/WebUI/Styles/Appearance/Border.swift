/// Defines sides for applying border radius.
///
/// Represents individual corners or groups of corners for styling border radius.
public enum RadiusSide: String {
  /// Applies radius to all corners
  case all = ""
  /// Applies radius to the top side (top-left and top-right)
  case top = "t"
  /// Applies radius to the right side (top-right and bottom-right)
  case right = "r"
  /// Applies radius to the bottom side (bottom-left and bottom-right)
  case bottom = "b"
  /// Applies radius to the left side (top-left and bottom-left)
  case left = "l"
  /// Applies radius to the top-left corner
  case topLeft = "tl"
  /// Applies radius to the top-right corner
  case topRight = "tr"
  /// Applies radius to the bottom-left corner
  case bottomLeft = "bl"
  /// Applies radius to the bottom-right corner
  case bottomRight = "br"
}

/// Specifies sizes for border radius.
///
/// Defines a range of radius values from none to full circular.
public enum RadiusSize: String {
  /// No border radius (0)
  case none = "none"
  /// Extra small radius (0.125rem)
  case xs = "xs"
  /// Small radius (0.25rem)
  case sm = "sm"
  /// Medium radius (0.375rem)
  case md = "md"
  /// Large radius (0.5rem)
  case lg = "lg"
  /// Extra large radius (0.75rem)
  case xl = "xl"
  /// 2x large radius (1rem)
  case xl2 = "2xl"
  /// 3x large radius (1.5rem)
  case xl3 = "3xl"
  /// Full radius (9999px, circular)
  case full = "full"

}

/// Defines styles for borders and outlines.
///
/// Provides options for solid, dashed, and other border appearances.
public enum BorderStyle: String {
  /// Solid line border
  case solid = "solid"
  /// Dashed line border
  case dashed = "dashed"
  /// Dotted line border
  case dotted = "dotted"
  /// Double line border
  case double = "double"
  /// Hidden border (none)
  case hidden = "hidden"
  /// No border (none)
  case none = "none"
  /// Divider style for child elements
  case divide = "divide"
}

/// Specifies sizes for box shadows.
///
/// Defines shadow sizes from none to extra-large.
public enum ShadowSize: String {
  /// No shadow
  case none = "none"
  /// Extra small shadow (2xs)
  case xs2 = "2xs"
  /// Extra small shadow (xs)
  case xs = "xs"
  /// Small shadow (sm)
  case sm = "sm"
  /// Medium shadow (default)
  case md = "md"
  /// Large shadow (lg)
  case lg = "lg"
  /// Extra large shadow (xl)
  case xl = "xl"
  /// 2x large shadow (2xl)
  case xl2 = "2xl"
}

extension Element {
  /// Applies border styling to the element with a single edge.
  ///
  /// Adds classes for border width, radius, style, and color on a specific edge,
  /// optionally scoped to a breakpoint. If radius is specified without a side,
  /// it applies to all corners.
  ///
  /// - Parameters:
  ///   - width: Sets the border width in pixels.
  ///   - edge: The edge to apply the border to. Defaults to `.all`.
  ///   - radius: Specifies the size of the border radius, with an optional side.
  ///             If side is omitted, applies to all corners.
  ///   - style: Defines the border style (e.g., solid, dashed).
  ///   - color: Sets the border color from the color palette.
  ///   - breakpoint: Applies the styles at a specific screen size.
  /// - Returns: A new element with updated border classes.
  func border(
    width: Int? = nil,
    edge: Edge = .all,
    radius: (side: RadiusSide?, size: RadiusSize)? = nil,
    style: BorderStyle? = nil,
    color: Color? = nil,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    border(width: width, edges: [edge], radius: radius, style: style, color: color, on: breakpoint)
  }

  /// Applies border styling to the element with multiple edges.
  ///
  /// Adds classes for border width, radius, style, and color on specified edges,
  /// optionally scoped to a breakpoint. If radius is specified without a side,
  /// it applies to all corners.
  ///
  /// - Parameters:
  ///   - width: Sets the border width in pixels.
  ///   - edges: Array of edges to apply the border to.
  ///   - radius: Specifies the size of the border radius, with an optional side.
  ///             If side is omitted, applies to all corners.
  ///   - style: Defines the border style (e.g., solid, dashed).
  ///   - color: Sets the border color from the color palette.
  ///   - breakpoint: Applies the styles at a specific screen size.
  /// - Returns: A new element with updated border classes.
  func border(
    width: Int? = nil,
    edges: [Edge],
    radius: (side: RadiusSide?, size: RadiusSize)? = nil,
    style: BorderStyle? = nil,
    color: Color? = nil,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    if let widthValue = width {
      if style == .divide {
        for edge in edges {
          let edgePrefix = edge == .horizontal ? "x" : edge == .vertical ? "y" : ""
          if !edgePrefix.isEmpty {
            newClasses.append("\(prefix)divide-\(edgePrefix)-\(widthValue)")
          }
        }
      } else {
        for edge in edges {
          let edgePrefix = edge.rawValue.isEmpty ? "" : "-\(edge.rawValue)"
          newClasses.append("\(prefix)border\(edgePrefix)-\(widthValue)")
        }
      }
    }

    if let (side, size) = radius {
      let sidePrefix = side?.rawValue ?? ""  // Default to empty string (all sides) if side is nil
      let sideClass = sidePrefix.isEmpty ? "" : "-\(sidePrefix)"
      let sizeSuffix = "-\(size.rawValue)"
      newClasses.append("\(prefix)rounded\(sideClass)\(sizeSuffix)")
    }

    if let styleValue = style, style != .divide {
      if edges.contains(.all) {
        newClasses.append("\(prefix)border-\(styleValue.rawValue)")
      } else {
        for edge in edges {
          let edgePrefix = edge.rawValue.isEmpty ? "" : "-\(edge.rawValue)"
          newClasses.append("\(prefix)border\(edgePrefix)-\(styleValue.rawValue)")
        }
      }
    }

    if let colorValue = color?.rawValue {
      if edges.contains(.all) {
        newClasses.append("\(prefix)border-\(colorValue)")
      } else {
        for edge in edges {
          let edgePrefix = edge.rawValue.isEmpty ? "" : "-\(edge.rawValue)"
          newClasses.append("\(prefix)border\(edgePrefix)-\(colorValue)")
        }
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

  /// Applies outline styling to the element.
  ///
  /// Adds classes for outline width, style, and color, optionally scoped to a breakpoint.
  ///
  /// - Parameters:
  ///   - width: Sets the outline width in pixels.
  ///   - style: Defines the outline style (e.g., solid, dashed).
  ///   - color: Sets the outline color from the color palette.
  ///   - breakpoint: Applies the styles at a specific screen size.
  /// - Returns: A new element with updated outline classes.
  func outline(
    width: Int? = nil,
    style: BorderStyle? = nil,
    color: Color? = nil,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    if let widthValue = width {
      newClasses.append("\(prefix)outline-\(widthValue)")
    }
    if let styleValue = style, style != .divide {
      newClasses.append("\(prefix)outline-\(styleValue.rawValue)")
    }
    if let color = color?.rawValue {
      newClasses.append("\(prefix)outline-\(color)")
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

  /// Applies box shadow styling to the element.
  ///
  /// Adds a shadow class based on size and optional color, scoped to a breakpoint if provided.
  ///
  /// - Parameters:
  ///   - size: Sets the shadow size (e.g., small, large).
  ///   - color: Applies a shadow color from the color palette.
  ///   - breakpoint: Applies the styles at a specific screen size.
  /// - Returns: A new element with updated shadow classes.
  func shadow(
    size: ShadowSize,
    color: Color? = nil,
    breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    newClasses.append("\(prefix)shadow-\(size.rawValue)")
    if let color = color?.rawValue {
      newClasses.append("\(prefix)shadow-\(color)")
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

  /// Applies a ring effect to the element.
  ///
  /// Adds a ring class with specified width and optional color, scoped to a breakpoint if provided.
  ///
  /// - Parameters:
  ///   - size: Sets the ring width in pixels (defaults to 1).
  ///   - color: Applies a ring color from the color palette.
  ///   - breakpoint: Applies the styles at a specific screen size.
  /// - Returns: A new element with updated ring classes.
  func ring(
    size: Int = 1,
    color: Color? = nil,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    newClasses.append("\(prefix)ring-\(size)")
    if let color = color?.rawValue {
      newClasses.append("\(prefix)ring-\(color)")
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
