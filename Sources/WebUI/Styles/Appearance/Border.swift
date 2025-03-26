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
  public func border(
    width: Int? = nil,
    edges: Edge...,
    radius: (side: RadiusSide?, size: RadiusSize)? = nil,
    style: BorderStyle? = nil,
    color: Color? = nil,
    on modifiers: Modifier...
  ) -> Element {
    let effectiveEdges = edges.isEmpty ? [Edge.all] : edges
    var baseClasses: [String] = []

    if let widthValue = width {
      if style == .divide {
        for edge in effectiveEdges {
          let edgePrefix = edge == .horizontal ? "x" : edge == .vertical ? "y" : ""
          if !edgePrefix.isEmpty {
            baseClasses.append("divide-\(edgePrefix)-\(widthValue)")
          }
        }
      } else {
        baseClasses.append(
          contentsOf: effectiveEdges.map { edge in
            let edgePrefix = edge.rawValue.isEmpty ? "" : "-\(edge.rawValue)"
            return "border\(edgePrefix)-\(widthValue)"
          })
      }
    }

    if let (side, size) = radius {
      let sidePrefix = side?.rawValue ?? ""
      let sideClass = sidePrefix.isEmpty ? "" : "-\(sidePrefix)"
      baseClasses.append("rounded\(sideClass)-\(size.rawValue)")
    }

    if let styleValue = style, style != .divide {
      baseClasses.append(
        contentsOf: effectiveEdges.map { edge in
          let edgePrefix = edge.rawValue.isEmpty ? "" : "-\(edge.rawValue)"
          return "border\(edgePrefix)-\(styleValue.rawValue)"
        })
    }

    if let colorValue = color?.rawValue {
      baseClasses.append(
        contentsOf: effectiveEdges.map { edge in
          let edgePrefix = edge.rawValue.isEmpty ? "" : "-\(edge.rawValue)"
          return "border\(edgePrefix)-\(colorValue)"
        })
    }

    let newClasses: [String]
    if modifiers.isEmpty {
      newClasses = baseClasses
    } else {
      let combinedModifierPrefix = modifiers.map { $0.rawValue }.joined()
      newClasses = baseClasses.map { "\(combinedModifierPrefix)\($0)" }
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

  public func outline(
    width: Int? = nil,
    style: BorderStyle? = nil,
    color: Color? = nil,
    on modifiers: Modifier...
  ) -> Element {
    var baseClasses: [String] = []
    if let widthValue = width { baseClasses.append("outline-\(widthValue)") }
    if let styleValue = style, style != .divide { baseClasses.append("outline-\(styleValue.rawValue)") }
    if let colorValue = color?.rawValue { baseClasses.append("outline-\(colorValue)") }

    let newClasses: [String]
    if modifiers.isEmpty {
      newClasses = baseClasses
    } else {
      let combinedModifierPrefix = modifiers.map { $0.rawValue }.joined()
      newClasses = baseClasses.map { "\(combinedModifierPrefix)\($0)" }
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

  public func shadow(
    size: ShadowSize,
    color: Color? = nil,
    on modifiers: Modifier...
  ) -> Element {
    var baseClasses: [String] = ["shadow-\(size.rawValue)"]
    if let colorValue = color?.rawValue { baseClasses.append("shadow-\(colorValue)") }

    let newClasses: [String]
    if modifiers.isEmpty {
      newClasses = baseClasses
    } else {
      let combinedModifierPrefix = modifiers.map { $0.rawValue }.joined()
      newClasses = baseClasses.map { "\(combinedModifierPrefix)\($0)" }
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

  public func ring(
    size: Int = 1,
    color: Color? = nil,
    on modifiers: Modifier...
  ) -> Element {
    var baseClasses: [String] = ["ring-\(size)"]
    if let colorValue = color?.rawValue { baseClasses.append("ring-\(colorValue)") }

    let newClasses: [String]
    if modifiers.isEmpty {
      newClasses = baseClasses
    } else {
      let combinedModifierPrefix = modifiers.map { $0.rawValue }.joined()
      newClasses = baseClasses.map { "\(combinedModifierPrefix)\($0)" }
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
