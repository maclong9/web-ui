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
  case column
  /// Sets the main axis to horizontal (right to left)
  case rowReverse
  /// Sets the main axis to vertical (bottom to top)
  case colReverse

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

/// Represents a flex grow value; dictates whether the container should fill remaining space
public enum Grow: Int {
  /// Indicates the container should not fill remaining space
  case zero = 0
  /// Indicates the container should fill remaining space
  case one = 1
}

extension Element {
  /// Applies flexbox styling to the element with an optional breakpoint.
  ///
  /// This modifier adds the `flex` class to make the element a flex container, along with optional justification, alignment, and direction classes.
  ///
  /// - Parameters:
  ///   - direction: Sets the direction of the main axis (horizontal or vertical).
  ///   - justify: Controls how flex items are distributed along the main axis.
  ///   - align: Controls how flex items are aligned along the cross axis.
  ///   - breakpoint: Optional breakpoint prefix.
  /// - Returns: A new `Element` with the updated flexbox classes.
  func flex(
    _ direction: Direction? = nil,
    justify: Justify? = nil,
    align: Align? = nil,
    grow: Grow? = nil,
    breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    newClasses.append(prefix + "flex")
    if let directionValue = direction?.rawValue {
      newClasses.append(prefix + directionValue)
    }
    if let justifyValue = justify?.rawValue {
      newClasses.append(prefix + justifyValue)
    }
    if let alignValue = align?.rawValue {
      newClasses.append(prefix + alignValue)
    }
    if let growValue = grow {
      newClasses.append(prefix + "flex-\(growValue.rawValue)")
    }

    let updatedClasses = (self.classes ?? []) + newClasses
    return Element(
      tag: self.tag,
      id: self.id,
      classes: updatedClasses,
      role: self.role,
      content: self.contentBuilder
    )
  }

  /// Applies grid styling to the element with an optional breakpoint.
  ///
  /// This modifier adds the `grid` class to make the element a grid container, along with optional justification, alignment, and column classes.
  ///
  /// - Parameters:
  ///   - justify: Controls how grid items are distributed along the inline (row) axis.
  ///   - align: Controls how grid items are aligned along the block (column) axis.
  ///   - columns: Defines the number of columns in the grid layout.
  ///   - breakpoint: Which screen size to apply these styles to
  /// - Returns: A new `Element` with the updated grid classes.
  func grid(
    justify: Justify? = nil,
    align: Align? = nil,
    columns: Int? = nil,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    newClasses.append(prefix + "grid")  // Base grid class is always added
    if let justifyValue = justify?.rawValue {
      newClasses.append(prefix + justifyValue)
    }
    if let alignValue = align?.rawValue {
      newClasses.append(prefix + alignValue)
    }
    if let columnsValue = columns {
      newClasses.append(prefix + "grid-cols-\(columnsValue)")
    }

    let updatedClasses = (self.classes ?? []) + newClasses
    return Element(
      tag: self.tag,
      id: self.id,
      classes: updatedClasses,
      role: self.role,
      content: self.contentBuilder
    )
  }

  /// Toggles the visibility of the element with an optional breakpoint.
  ///
  /// This modifier adds or omits the `hidden` class, which sets `display: none` in CSS, hiding the element from the layout.
  ///
  /// - Parameters:
  ///   - isHidden: If `true` (default), adds the `hidden` class; if `false`, no class is added.
  ///   - breakpoint: Which screen size to apply these styles to
  /// - Returns: A new `Element` with the updated visibility class.
  func hidden(_ isHidden: Bool = true, breakpoint: Breakpoint? = nil) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    if isHidden {
      newClasses.append(prefix + "hidden")
    }

    let updatedClasses = (self.classes ?? []) + newClasses
    return Element(
      tag: self.tag,
      id: self.id,
      classes: updatedClasses,
      role: self.role,
      content: self.contentBuilder
    )
  }
}
