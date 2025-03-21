extension Element {
  /// Sets the opacity of the element with optional modifiers.
  ///
  /// - Parameters:
  ///   - value: The opacity value, typically between 0 and 100.
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated opacity classes including applied modifiers.
  func opacity(
    _ value: Int,
    on modifiers: Modifier...
  ) -> Element {
    let baseClass = "opacity-\(value)"
    let newClasses: [String]

    if modifiers.isEmpty {
      newClasses = [baseClass]
    } else {
      let combinedModifierPrefix = modifiers.map { $0.rawValue }.joined()
      newClasses = ["\(combinedModifierPrefix)\(baseClass)"]
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
