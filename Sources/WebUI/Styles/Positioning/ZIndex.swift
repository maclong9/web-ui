extension Element {
  /// Applies a z-index to the element.
  ///
  /// Sets the stacking order of the element, optionally scoped to modifiers.
  ///
  /// - Parameters:
  ///   - value: Specifies the z-index value as an integer.
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated z-index classes.
  public func zIndex(
    _ value: Int,
    on modifiers: Modifier...
  ) -> Element {
    let baseClass = "z-\(value)"

    let newClasses: [String]
    if modifiers.isEmpty {
      newClasses = [baseClass]
    } else {
      newClasses = modifiers.map { modifier in
        "\(modifier.rawValue)\(baseClass)"
      }
    }

    return Element(
      tag: self.tag,
        id: self.id,
        classes: (self.classes ?? []) + newClasses,
        role: self.role,
        label: self.label,
      isSelfClosing: self.isSelfClosing,
      content: self.contentBuilder
    )
  }
}
