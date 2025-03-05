/// Represents justification options for flexbox or grid layouts.
public enum Justify: String {
  /// Aligns items to the start of the horizontal axis
  case start
  /// Aligns items to the end of the horizontal axis
  case end
  /// Centers items along the horizontal axis
  case center
  /// Distributes items with equal space between them
  case between
  /// Distributes items with equal space around them
  case around
  /// Distributes items with equal space between and around them
  case evenly

  public var rawValue: String { "justify-\(self)" }
}

/// Represents alignment options for flexbox or grid items.
public enum Align: String {
  /// Aligns items to the start of the vertical axis
  case start
  /// Aligns items to the end of the vertical axis
  case end
  /// Centers items along the vertical axis
  case center
  /// Aligns items to their baseline
  case baseline
  /// Stretches items to fill the vertical axis
  case stretch

  public var rawValue: String { "items-\(self)" }
}

/// Represents flexbox direction options.
public enum Direction: String {
  /// Sets the main axis to horizontal (left to right)
  case row
  /// Sets the main axis to vertical (top to bottom)
  case column = "col"
  /// Sets the main axis to horizontal (right to left)
  case rowReverse = "row-reverse"
  /// Sets the main axis to vertical (bottom to top)
  case colReverse = "col-reverse"

  public var rawValue: String {
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
  ///
  /// This modifier adds the `flex` class to make the element a flex container, along with optional justification, alignment, and direction classes.
  ///
  /// - Parameters:
  ///   - justify: Controls how flex items are distributed along the main axis (e.g., horizontally in `row` direction). Maps to 's `justify-*` classes.
  ///   - align: Controls how flex items are aligned along the vertical axis (e.g., vertically in `row` direction). Maps to 's `items-*` classes.
  ///   - direction: Sets the direction of the main axis (horizontal or vertical). Maps to 's `flex-*` classes like `flex-row`.
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
  ///
  /// This modifier adds the `grid` class to make the element a grid container, along with optional justification, alignment, and column classes.
  ///
  /// - Parameters:
  ///   - justify: Controls how grid items are distributed along the inline (row) axis. Maps to 's `justify-*` classes.
  ///   - align: Controls how grid items are aligned along the block (column) axis. Maps to 's `items-*` classes.
  ///   - columns: Defines the number of columns in the grid layout. Maps to 's `grid-cols-*` classes.
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
  ///
  /// This modifier adds or omits the `hidden` class, which sets `display: none` in CSS, hiding the element from the layout.
  /// 
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
