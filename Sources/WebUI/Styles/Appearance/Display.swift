/// Defines justification options for layout alignment.
///
/// Specifies how items are distributed along the main axis in flexbox or grid layouts.
public enum Justify: String {
  /// Aligns items to the start of the horizontal axis.
  case start
  /// Aligns items to the end of the horizontal axis.
  case end
  /// Centers items along the horizontal axis.
  case center
  /// Distributes items with equal space between them.
  case between
  /// Distributes items with equal space around them.
  case around
  /// Distributes items with equal space between and around them.
  case evenly

  /// Provides the raw CSS class value.
  public var rawValue: String { "justify-\(self)" }
}

/// Represents alignment options for flexbox or grid items.
///
/// Specifies how items are aligned along the secondary axis in flexbox or grid layouts.
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
///
/// Dictates the direction elements flow in a flexbox layout.
public enum Direction: String {
  /// Sets the main axis to horizontal (left to right)
  case row = "flex-row"
  /// Sets the main axis to vertical (top to bottom)
  case column = "flex-col"
  /// Sets the main axis to horizontal (right to left)
  case rowReverse = "flex-row-reverse"
  /// Sets the main axis to vertical (bottom to top)
  case colReverse = "flex-col-reverse"
}

/// Represents a flex grow value; dictates whether the container should fill remaining space
public enum Grow: Int {
  /// Indicates the container should not fill remaining space
  case zero = 0
  /// Indicates the container should fill remaining space
  case one = 1
}

extension Element {
  /// Applies flexbox styling to the element.
  ///
  /// Configures the element as a flex container with direction, justification, and alignment.
  ///
  /// - Parameters:
  ///   - direction: Sets the main axis direction (e.g., row, column).
  ///   - justify: Distributes items along the main axis.
  ///   - align: Aligns items along the cross axis.
  ///   - grow: Determines if the element fills remaining space.
  ///   - breakpoint: Applies the styles at a specific screen size.
  /// - Returns: A new element with updated flexbox classes.
  func flex(
    direction: Direction? = nil,
    justify: Justify? = nil,
    align: Align? = nil,
    grow: Grow? = nil,
    on breakpoint: Breakpoint? = nil
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

  /// Applies grid styling to the element.
  ///
  /// Configures the element as a grid container with justification, alignment, and column count.
  ///
  /// - Parameters:
  ///   - justify: Distributes items along the row axis.
  ///   - align: Aligns items along the column axis.
  ///   - columns: Sets the number of grid columns.
  ///   - breakpoint: Applies the styles at a specific screen size.
  /// - Returns: A new element with updated grid classes.
  func grid(
    justify: Justify? = nil,
    align: Align? = nil,
    columns: Int? = nil,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    newClasses.append(prefix + "grid")
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

  /// Toggles visibility of the element.
  ///
  /// Hides or shows the element by adding or omitting the `hidden` class.
  ///
  /// - Parameters:
  ///   - isHidden: Hides the element if true (defaults to true).
  ///   - breakpoint: Applies the visibility at a specific screen size.
  /// - Returns: A new element with updated visibility classes.
  func hidden(
    _ isHidden: Bool = true,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
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
