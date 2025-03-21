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
  func flex(
    direction: Direction? = nil,
    justify: Justify? = nil,
    align: Align? = nil,
    grow: Grow? = nil,
    on modifiers: Modifier...
  ) -> Element {
    var baseClasses: [String] = ["flex"]
    if let directionValue = direction?.rawValue { baseClasses.append(directionValue) }
    if let justifyValue = justify?.rawValue { baseClasses.append(justifyValue) }
    if let alignValue = align?.rawValue { baseClasses.append(alignValue) }
    if let growValue = grow { baseClasses.append("flex-\(growValue.rawValue)") }

    let newClasses: [String]
    if modifiers.isEmpty {
      newClasses = baseClasses
    } else {
      let combinedModifierPrefix = modifiers.map { $0.rawValue }.joined()
      newClasses = baseClasses.map { "\(combinedModifierPrefix)\($0)" }
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

  func grid(
    justify: Justify? = nil,
    align: Align? = nil,
    columns: Int? = nil,
    on modifiers: Modifier...
  ) -> Element {
    var baseClasses: [String] = ["grid"]
    if let justifyValue = justify?.rawValue { baseClasses.append(justifyValue) }
    if let alignValue = align?.rawValue { baseClasses.append(alignValue) }
    if let columnsValue = columns { baseClasses.append("grid-cols-\(columnsValue)") }

    let newClasses: [String]
    if modifiers.isEmpty {
      newClasses = baseClasses
    } else {
      let combinedModifierPrefix = modifiers.map { $0.rawValue }.joined()
      newClasses = baseClasses.map { "\(combinedModifierPrefix)\($0)" }
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

  func hidden(
    _ isHidden: Bool = true,
    on modifiers: Modifier...
  ) -> Element {
    let baseClass = "hidden"
    let newClasses: [String]
    if isHidden {
      if modifiers.isEmpty {
        newClasses = [baseClass]
      } else {
        let combinedModifierPrefix = modifiers.map { $0.rawValue }.joined()
        newClasses = ["\(combinedModifierPrefix)\(baseClass)"]
      }
    } else {
      newClasses = []
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
