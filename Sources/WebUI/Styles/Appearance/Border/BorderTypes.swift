/// Defines sides for applying border radius.
///
/// Represents individual corners or groups of corners for styling border radius.
///
/// ## Example
/// ```swift
/// Button() { "Sign Up" }
///   .rounded(.lg, .top)
/// ```
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
///
/// ## Example
/// ```swift
/// Stack(classes: ["card"])
///   .rounded(.xl)
/// ```
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
///
/// ## Example
/// ```swift
/// Stack()
///   .border(width: 1, style: .dashed, color: .gray(._300))
/// ```
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
///
/// ## Example
/// ```swift
/// Stack(classes: ["card"])
///   .shadow(size: .lg, color: .gray(._300, opacity: 0.5))
/// ```
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
