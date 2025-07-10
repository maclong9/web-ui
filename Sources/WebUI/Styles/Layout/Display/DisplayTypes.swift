/// Defines CSS display types for controlling element rendering.
///
/// Specifies how an element is displayed in the layout.
public enum DisplayType: String {
  /// Makes the element not display at all (removed from layout flow).
  case none
  /// Standard block element (takes full width, creates new line).
  case block
  /// Inline element (flows with text, no line breaks).
  case inline
  /// Hybrid that allows width/height but flows inline.
  case inlineBlock = "inline-block"
  /// Creates a flex container.
  case flex
  /// Creates an inline flex container.
  case inlineFlex = "inline-flex"
  /// Creates a grid container.
  case grid
  /// Creates an inline grid container.
  case inlineGrid = "inline-grid"
  /// Creates a table element.
  case table
  /// Creates a table cell element.
  case tableCell = "table-cell"
  /// Creates a table row element.
  case tableRow = "table-row"
}

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

  /// Provides the raw stylesheet class value.
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
