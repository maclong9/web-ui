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
