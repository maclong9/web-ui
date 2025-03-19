/// Defines overflow behavior options.
///
/// Specifies how content exceeding an element's bounds is handled.
public enum OverflowType: String {
  /// Automatically adds scrollbars when content overflows.
  case auto
  /// Clips overflowing content and hides it.
  case hidden
  /// Displays overflowing content without clipping.
  case visible
  /// Always adds scrollbars, even if content fits.
  case scroll
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

extension Element {
  /// Applies overflow styling to the element.
  ///
  /// Sets how overflowing content is handled, optionally on a specific axis and breakpoint.
  ///
  /// - Parameters:
  ///   - type: Determines the overflow behavior (e.g., hidden, scroll).
  ///   - axis: Specifies the axis for overflow (defaults to both).
  ///   - breakpoint: Applies the styles at a specific screen size.
  /// - Returns: A new element with updated overflow classes.
  func overflow(_ type: OverflowType, axis: Axis = .both, on breakpoint: Breakpoint? = nil) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    let axisString = axis.rawValue.isEmpty ? "" : "-\(axis.rawValue)"
    let className = "\(prefix)overflow\(axisString)-\(type.rawValue)"

    let updatedClasses = (self.classes ?? []) + [className]
    return Element(
      tag: self.tag,
      id: self.id,
      classes: updatedClasses,
      role: self.role,
      content: self.contentBuilder
    )
  }
}
