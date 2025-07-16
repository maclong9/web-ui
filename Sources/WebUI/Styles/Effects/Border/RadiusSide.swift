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
