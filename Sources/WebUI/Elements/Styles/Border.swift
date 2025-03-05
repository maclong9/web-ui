/// Represents the sides for border radius, including individual corners.
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

/// Represents the size options for border radius.
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

/// Represents the style options for borders and outlines.
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
  /// Divider style for child elements (e.g., divide-x)
  case divide = "divide"
}

/// Represents the size options for box shadow.
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
  /// Applies border styling to the element with an optional breakpoint.
  ///
  /// This modifier adds TailwindCSS border classes for width (e.g., `border-2`), radius (e.g., `rounded-md` or `rounded-tl-lg`),
  /// and style (e.g., `border-dashed`). If `style` is `.divide`, it applies a divider class (e.g., `divide-x-2`) instead of a
  /// standard border.
  ///
  /// - Parameters:
  ///   - width: The border width in Tailwind units (e.g., 2 = 2px). Optional, defaults to nil (no width class).
  ///   - radius: A tuple of `(side, size)` to specify border radius (e.g., `(.all, .md)` for `rounded-md`, `(.topLeft, .lg)` for `rounded-tl-lg`). Optional.
  ///   - style: The border style (e.g., `.solid`, `.dashed`). Optional, defaults to nil (no style class).
  ///   - breakpoint: Optional breakpoint prefix (e.g., `md:` applies styles at 768px and up).
  /// - Returns: A new `Element` with the updated border classes.
  func border(
    width: Int? = nil,
    radius: (side: RadiusSide, size: RadiusSize)? = nil,
    style: BorderStyle? = nil,
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

    let updatedClasses = (self.classes ?? []) + newClasses
    return Element(
      tag: self.tag,
      id: self.id,
      classes: updatedClasses,
      role: self.role,
      content: self.contentBuilder
    )
  }

  /// Applies outline styling to the element with an optional breakpoint.
  ///
  /// This modifier adds TailwindCSS outline classes for width (e.g., `outline-2`) and style (e.g., `outline-dashed`).
  ///
  /// - Parameters:
  ///   - width: The outline width in Tailwind units (e.g., 2 = 2px). Optional, defaults to nil (no width class).
  ///   - style: The outline style (e.g., `.solid`, `.dashed`). Optional, defaults to nil (no style class).
  ///   - breakpoint: Optional breakpoint prefix (e.g., `md:` applies styles at 768px and up).
  /// - Returns: A new `Element` with the updated outline classes.
  func outline(
    width: Int? = nil,
    style: BorderStyle? = nil,
    breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    if let widthValue = width {
      newClasses.append("\(prefix)outline-\(widthValue)")  // Example: outline-2
    }
    if let styleValue = style, style != .divide {  // Divide not applicable for outline
      newClasses.append("\(prefix)outline-\(styleValue.rawValue)")
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

  /// Applies box shadow styling to the element with an optional breakpoint.
  ///
  /// This modifier adds TailwindCSS shadow classes (e.g., `shadow-md`, `shadow-none`).
  ///
  /// - Parameters:
  ///   - size: The shadow size (e.g., `.md` for medium, `.none` for no shadow). Required.
  ///   - breakpoint: Optional breakpoint prefix (e.g., `md:` applies styles at 768px and up).
  /// - Returns: A new `Element` with the updated shadow class.
  func boxShadow(
    size: ShadowSize,
    breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    newClasses.append("\(prefix)shadow-\(size.rawValue)")  // Example: shadow-md

    let updatedClasses = (self.classes ?? []) + newClasses
    return Element(
      tag: self.tag,
      id: self.id,
      classes: updatedClasses,
      role: self.role,
      content: self.contentBuilder
    )
  }

  /// Applies a ring effect to the element with an optional breakpoint.
  ///
  /// This modifier adds TailwindCSS ring classes (e.g., `ring-2`) to create an outline-like effect using shadows.
  ///
  /// - Parameters:
  ///   - size: The ring width in Tailwind units (e.g., 2 = 2px). Required.
  ///   - breakpoint: Optional breakpoint prefix (e.g., `md:` applies styles at 768px and up).
  /// - Returns: A new `Element` with the updated ring class.
  func ring(
    size: Int,
    breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    newClasses.append("\(prefix)ring-\(size)")  // Example: ring-2

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
