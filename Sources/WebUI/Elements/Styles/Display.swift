/// Represents justification options for flexbox or grid layouts.
/// Each case maps to a CSS `justify-*` utility class, controlling how items are distributed along the main axis.
enum Justify: String {
  case start, end, center, between, around, evenly
  var rawValue: String { "justify-\(self)" }
}

/// Represents alignment options for flexbox or grid items.
/// Each case maps to a Tailwind CSS `items-*` utility class, controlling how items align along the cross axis (e.g., vertically in row layouts).
enum Align: String {
  case start, end, center, baseline, stretch
  var rawValue: String { "items-\(self)" }
}

/// Represents flexbox direction options.
/// Each case maps to a Tailwind CSS `flex-*` utility class, controlling the main axis direction of a flex container.
enum Direction: String {
  case row
  case column = "col"
  case rowReverse = "row-reverse"
  case colReverse = "col-reverse"

  var rawValue: String {
    switch self {
      case .row:
        return "flex-row"
      case .column:
        return "flex-col"
      case .rowReverse:
        return "flex-row-reverse"
      case .colReverse:
        return "flex-col-reverse"
    }
  }
}
extension Element {
  /// Applies flexbox styling to the element.
  /// This modifier adds the `flex` class to make the element a flex container, along with optional justification, alignment, and direction classes.
  /// - Parameters:
  ///   - justify: Controls how flex items are distributed along the main axis (e.g., horizontally in `row` direction). Maps to Tailwind's `justify-*` classes.
  ///   - align: Controls how flex items are aligned along the cross axis (e.g., vertically in `row` direction). Maps to Tailwind's `items-*` classes.
  ///   - direction: Sets the direction of the main axis (horizontal or vertical). Maps to Tailwind's `flex-*` classes like `flex-row`.
  /// - Returns: A new `Element` with the updated flexbox classes.
  func flex(
    _ direction: Direction? = nil,
    justify: Justify? = nil,
    align: Align? = nil
  ) -> Element {
    let updatedClasses: [String] =
      (self.classes ?? [])
      + ["flex", justify?.rawValue, align?.rawValue, direction?.rawValue].compactMap { $0 }
    return Element(
      tag: self.tag,
      id: self.id,
      classes: updatedClasses,
      role: self.role,
      content: self.contentBuilder
    )
  }

  /// Applies grid styling to the element.
  /// This modifier adds the `grid` class to make the element a grid container, along with optional justification, alignment, and column classes.
  /// - Parameters:
  ///   - justify: Controls how grid items are distributed along the inline (row) axis. Maps to Tailwind's `justify-*` classes.
  ///   - align: Controls how grid items are aligned along the block (column) axis. Maps to Tailwind's `items-*` classes.
  ///   - columns: Defines the number of columns in the grid layout. Maps to Tailwind's `grid-cols-*` classes.
  /// - Returns: A new `Element` with the updated grid classes.
  func grid(
    justify: Justify? = nil,
    align: Align? = nil,
    columns: Int? = nil
  ) -> Element {
    let updatedClasses: [String] =
      (self.classes ?? [])
      + ["grid", justify?.rawValue, align?.rawValue, "grid-cols-\(columns ?? 1)"].compactMap { $0 }
    return Element(
      tag: self.tag,
      id: self.id,
      classes: updatedClasses,
      role: self.role,
      content: self.contentBuilder
    )
  }

  /// Toggles the visibility of the element.
  /// This modifier adds or omits the `hidden` class, which sets `display: none` in CSS, hiding the element from the layout.
  /// - Parameter isHidden: If `true` (default), adds the `hidden` class; if `false`, no class is added.
  /// - Returns: A new `Element` with the updated visibility class.
  func hidden(_ isHidden: Bool = true) -> Element {
    let updatedClasses: [String] =
      (self.classes ?? [])
      + (isHidden ? ["hidden"] : [])
    return Element(
      tag: self.tag,
      id: self.id,
      classes: updatedClasses,
      role: self.role,
      content: self.contentBuilder
    )
  }
}
