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
