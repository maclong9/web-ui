/// Represents CSS modifiers that apply styles under specific conditions, such as hover or focus states.
///
/// This enum maps to Tailwind CSS prefixes like `hover:` and `focus:`, enabling conditional styling
/// when used with `Element` methods like `opacity` or `background()`. It also contains
/// breakpoint modifiers for applying styles to specific screen sizes in responsive designs.
///
/// Modifiers can be combined with any styling method to create responsive or interactive designs
/// without writing custom media queries or JavaScript.
///
/// - Note: You do not need to redefine all styles on each modifier, just the ones that change.
///
/// - Example:
///   ```swift
///   Button() { "Click me" }
///     .background(color: .blue(._500))
///     .background(color: .blue(._600), on: .hover)
///     .font(color: .white)
///     .font(size: .lg, on: .md)  // Larger text on medium screens and up
///   ```
public enum Modifier: String {
  /// Extra small breakpoint modifier applying styles at 480px min-width and above.
  ///
  /// Use for small mobile device specific styles.
  case xs

  /// Small breakpoint modifier applying styles at 640px min-width and above.
  ///
  /// Use for larger mobile device specific styles.
  case sm

  /// Medium breakpoint modifier applying styles at 768px min-width and above.
  ///
  /// Use for tablet and small desktop specific styles.
  case md

  /// Large breakpoint modifier applying styles at 1024px min-width and above.
  ///
  /// Use for desktop specific styles.
  case lg

  /// Extra-large breakpoint modifier applying styles at 1280px min-width and above.
  ///
  /// Use for larger desktop specific styles.
  case xl

  /// 2x extra-large breakpoint modifier applying styles at 1536px min-width and above.
  ///
  /// Use for very large desktop and ultrawide monitor specific styles.
  case xl2 = "2xl"

  /// Applies the style when the element is hovered over with a mouse pointer.
  ///
  /// Use to create interactive hover effects and highlight interactive elements.
  case hover

  /// Applies the style when the element has keyboard focus.
  ///
  /// Use for accessibility to highlight the currently focused element.
  case focus

  /// Applies the style when the element is actively being pressed or clicked.
  ///
  /// Use to provide visual feedback during interaction.
  case active

  /// Applies the style to input placeholders within the element.
  ///
  /// Use to style placeholder text in input fields and text areas.
  case placeholder

  /// Applies styles only when dark mode is active.
  ///
  /// Use to create dark theme variants of your UI elements.
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
/// Each case corresponds to a specific edge or set of edges that styling can be applied to,
/// providing fine-grained control over layout spacing.
///
/// - Example:
///   ```swift
///   Stack()
///     .padding(.horizontal, length: 4)  // Adds padding to left and right sides
///     .margins(.top, length: 2)        // Adds margin to just the top edge
///   ```
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

/// Defines axes for applying overflow, scroll, or spacing behavior.
///
/// Represents the direction(s) in which various layout rules are applied,
/// such as overflow handling, scroll behavior, or spacing between child elements.
///
/// - Example:
///   ```swift
///   Stack()
///     .overflow(.hidden, axis: .x)  // Hide horizontal overflow only
///     .spacing(.y, length: 4)      // Add vertical spacing between children
///   ```
public enum Axis: String {
  /// Applies to the horizontal (x) axis only.
  ///
  /// Use when you need to control behavior along the left-right direction.
  case x

  /// Applies to the vertical (y) axis only.
  ///
  /// Use when you need to control behavior along the top-bottom direction.
  case y

  /// Applies to both horizontal and vertical axes simultaneously.
  ///
  /// Use when you need to apply the same behavior in both directions.
  case both = ""
}

/// Generates CSS classes with combined modifiers.
///
/// Combines a list of base classes with modifiers (e.g., `.hover`, `.xl`) to produce
/// classes like `hover:xl:class`. If no modifiers are provided, returns the base classes unchanged.
/// This is a core utility function used by style extension methods to support responsive
/// and state-based styling.
///
/// - Parameters:
///   - baseClasses: The base CSS classes (e.g., `["overflow-x-hidden"]`).
///   - modifiers: Zero or more modifiers to apply (e.g., `[.hover, .xl]`).
/// - Returns: An array of CSS classes with modifiers applied (e.g., `["hover:xl:overflow-x-hidden"]`).
///
/// - Example:
///   ```swift
///   // Without modifiers
///   let classes1 = combineClasses(["bg-blue-500"], withModifiers: [])
///   // Returns: ["bg-blue-500"]
///
///   // With a single modifier
///   let classes2 = combineClasses(["bg-blue-700"], withModifiers: [.hover])
///   // Returns: ["hover:bg-blue-700"]
///
///   // With multiple modifiers and classes
///   let classes3 = combineClasses(["text-lg", "font-bold"], withModifiers: [.md, .dark])
///   // Returns: ["md:dark:text-lg", "md:dark:font-bold"]
///   ```
public func combineClasses(_ baseClasses: [String], withModifiers modifiers: [Modifier]) -> [String] {
  if modifiers.isEmpty {
    return baseClasses
  }
  let modifierPrefix = modifiers.map { $0.rawValue }.joined()
  return baseClasses.map { "\(modifierPrefix)\($0)" }
}
