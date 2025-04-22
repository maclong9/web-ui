/// Represents cursor types.
public enum CursorType: String {
  case auto
  case `default`
  case pointer
  case wait
  case text
  case move
  case notAllowed = "not-allowed"
}

extension Element {
  /// Sets the cursor style of the element with optional modifiers.
  ///
  /// - Parameters:
  ///   - type: The cursor type.
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated cursor classes.
  public func cursor(
    _ type: CursorType,
    on modifiers: Modifier...
  ) -> Element {
    let baseClass = "cursor-\(type.rawValue)"
    let newClasses = combineClasses([baseClass], withModifiers: modifiers)

    return Element(
      tag: self.tag,
      id: self.id,
      classes: (self.classes ?? []) + newClasses,
      role: self.role,
      label: self.label,
      isSelfClosing: self.isSelfClosing,
      customAttributes: self.customAttributes,
      content: self.contentBuilder
    )
  }
}
