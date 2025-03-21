/// Defines CSS breakpoints for responsive design.
///
/// - Note: You do not need redfine all styles on each breakpoint, just the ones that change.
public enum Breakpoint: String {
  /// Extra small breakpoint at 480px min-width.
  case xs
  /// Small breakpoint at 640px min-width.
  case sm
  /// Medium breakpoint at 768px min-width.
  case md
  /// Large breakpoint at 1024px min-width.
  case lg
  /// Extra-large breakpoint at 1280px min-width.
  case xl
  /// 2x extra-large breakpoint at 1536px min-width.
  case xl2
  
  public var rawValue: String {
    "\(self):"
  }
}

/// Represents edge options for spacing and positioning.
///
/// Used for margins, padding, and positioning insets with context-specific prefixes.
public enum Edge: String {
  /// Applies to all edges
  case all = ""
  /// Applies to the top edge
  case top = "t"
  /// Applies to the leading (left) edge
  case leading = "l"
  /// Applies to the trailing (right) edge
  case trailing = "r"
  /// Applies to the bottom edge
  case bottom = "b"
  /// Applies to both leading and trailing edges
  case horizontal = "x"
  /// Applies to both top and bottom edges
  case vertical = "y"
}

/// Defines axes for applying overflow behavior.
///
/// Represents the direction(s) in which overflow rules are applied.
public enum Axis: String {
  /// Applies to the horizontal axis.
  case x
  /// Applies to the vertical axis.
  case y
  /// Applies to both horizontal and vertical axes.
  case both = ""
}
