/// Represents CSS modifiers that apply styles under specific conditions, such as hover or focus states.
///
/// This enum maps to Tailwind CSS prefixes like `hover:` and `focus:`, enabling conditional styling
/// when used with `Element` methods like `opacity` or `backgroundColor`. Also contains
/// optional breakpoint modifiers for applying styles to different screen sizes.
///
/// - Note: You do not need redfine all styles on each modifier, just the ones that change.
public enum Modifier: String {
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
  case xl2 = "2xl"
  /// Applies the style when the element is hovered over (e.g., `hover:`).
  case hover
  /// Applies the style when the element is focused (e.g., `focus:`).
  case focus
  /// Applies the style when the element is active (e.g., `active:`).
  case active
  /// Applies the style to a placeholder state (e.g., `placeholder:`).
  case placeholder
  /// Applies styles only on dark mode
  case dark

  public var rawValue: String {
    switch self {
    case .xs, .sm, .md, .lg, .xl, .hover, .focus, .active, .placeholder, .dark:
      return "\(self):"
    case .xl2:
      return "2xl:"
    }
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

/// Generates CSS classes with combined modifiers.
///
/// Combines a list of base classes with modifiers (e.g., `.hover`, `.xl`) to produce
/// classes like `hover:xl:class`. If no modifiers are provided, returns the base classes unchanged.
///
/// - Parameters:
///   - baseClasses: The base CSS classes (e.g., `["overflow-x-hidden"]`).
///   - modifiers: Zero or more modifiers to apply (e.g., `[.hover, .xl]`).
/// - Returns: An array of CSS classes with modifiers applied (e.g., `["hover:xl:overflow-x-hidden"]`).
public func combineClasses(_ baseClasses: [String], withModifiers modifiers: [Modifier]) -> [String]
{
  if modifiers.isEmpty {
    return baseClasses
  }
  let modifierPrefix = modifiers.map { $0.rawValue }.joined()
  return baseClasses.map { "\(modifierPrefix)\($0)" }
}
