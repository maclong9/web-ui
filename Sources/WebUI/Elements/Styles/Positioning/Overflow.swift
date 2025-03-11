/// Represents overflow behavior types
public enum OverflowType: String {
  case auto
  case hidden
  case visible
  case scroll
}

/// Represents the axis for overflow application.
public enum Axis: String {
  case x
  case y
  case both = ""
}

extension Element {
  /// Sets the overflow behavior of the element with an optional breakpoint.
  ///
  /// - Parameters:
  ///   - type: The overflow behavior (e.g., `.hidden`, `.scroll`).
  ///   - axis: The axis to apply the overflow to (`.x`, `.y`, `.both`). Defaults to `.both`.
  ///   - breakpoint: Optional breakpoint prefix
  /// - Returns: A new `Element` with the updated overflow classes.
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
