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
    let newClasses: [String]

    if modifiers.isEmpty {
      newClasses = [baseClass]
    } else {
      let combinedModifierPrefix = modifiers.map { $0.rawValue }.joined()
      newClasses = ["\(combinedModifierPrefix)\(baseClass)"]
    }

    return Element(
      tag: self.tag,
      config: ElementConfig(
        id: self.config.id,
        classes: (self.config.classes ?? []) + newClasses,
        role: self.config.role,
        label: self.config.label
      ),
      isSelfClosing: self.isSelfClosing,
      content: self.contentBuilder
    )
  }
}
