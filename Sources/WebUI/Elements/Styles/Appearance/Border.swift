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
  case extraSmall2 = "2xs"
  /// Extra small shadow (xs)
  case extraSmall = "xs"
  /// Small shadow (sm)
  case small = "sm"
  /// Medium shadow (default)
  case medium = "md"
  /// Large shadow (lg)
  case large = "lg"
  /// Extra large shadow (xl)
  case extraLarge = "xl"
  /// 2x large shadow (2xl)
  case extraLarge2 = "2xl"
}

extension Element {
  /// Applies border styling to the element.
  ///
  /// Adds classes for border width, radius, style, and color, optionally scoped to a breakpoint.
  ///
  /// - Parameters:
  ///   - width: Sets the border width in pixels.
  ///   - radius: Specifies the side and size of the border radius.
  ///   - style: Defines the border style (e.g., solid, dashed).
  ///   - color: Sets the border color from the color palette.
  ///   - breakpoint: Applies the styles at a specific screen size.
  /// - Returns: A new element with updated border classes.
  func border(
    width: Int? = nil,
    radius: (side: RadiusSide, size: RadiusSize)? = nil,
    style: BorderStyle? = nil,
    color: Color? = nil,
    breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    if let widthValue = width {
      if style == .divide {
        newClasses.append("\(prefix)divide-x-\(widthValue)")
      } else {
        newClasses.append("\(prefix)border-\(widthValue)")
      }
    }
    if let (side, size) = radius {
      let sidePrefix = side.rawValue.isEmpty ? "" : "-\(side.rawValue)"
      let sizeSuffix = "-\(size.rawValue)"
      newClasses.append("\(prefix)rounded\(sidePrefix)\(sizeSuffix)")
    }
    if let styleValue = style, style != .divide {
      newClasses.append("\(prefix)border-\(styleValue.rawValue)")
    }
    if let color = color?.rawValue {
      newClasses.append("\(prefix)border-\(color)")
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
    breakpoint: Breakpoint? = nil
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
  func boxShadow(
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
    breakpoint: Breakpoint? = nil
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
