/// Represents edge options for spacing and positioning.
///
/// Used for margins, padding, and positioning insets with context-specific prefixes.
/// Each case corresponds to a specific edge or set of edges that styling can be applied to,
/// providing fine-grained control over layout spacing.
///
/// ## Example
/// ```swift
/// Stack()
///   .padding(.horizontal, length: 4)  // Adds padding to left and right sides
///   .margins(.top, length: 2)        // Adds margin to just the top edge
/// ```
public enum Edge: String {
    /// Applies to all edges (top, right, bottom, and left).
    ///
    /// Use when you want uniform spacing on all sides of an element.
    case all = ""

    /// Applies to the top edge only.
    ///
    /// Use when you need to control spacing above an element.
    case top = "t"

    /// Applies to the leading (left) edge only.
    ///
    /// Use when you need to control spacing to the left of an element.
    case leading = "l"

    /// Applies to the trailing (right) edge only.
    ///
    /// Use when you need to control spacing to the right of an element.
    case trailing = "r"

    /// Applies to the bottom edge only.
    ///
    /// Use when you need to control spacing below an element.
    case bottom = "b"

    /// Applies to both leading and trailing edges (horizontal axis).
    ///
    /// Use when you want equal spacing on both left and right sides.
    case horizontal = "x"

    /// Applies to both top and bottom edges (vertical axis).
    ///
    /// Use when you want equal spacing on both top and bottom sides.
    case vertical = "y"
}