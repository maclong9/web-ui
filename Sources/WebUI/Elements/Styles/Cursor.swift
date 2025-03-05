/// Represents cursor types in TailwindCSS.
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
  /// Sets the cursor style of the element with an optional breakpoint.
  ///
  /// - Parameters:
  ///   - type: The cursor type (e.g., `.pointer`, `.wait`).
  ///   - breakpoint: Optional breakpoint prefix (e.g., `md:` applies styles at 768px and up).
  /// - Returns: A new `Element` with the updated cursor class.
  func cursor(_ type: CursorType, on breakpoint: Breakpoint? = nil) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    let className = "\(prefix)cursor-\(type.rawValue)"

    let updatedClasses = (self.classes ?? []) + [className]
    return Element(
      tag: self.tag,
      id: self.id,
      classes: updatedClasses,
      role: self.role,
      content: self.contentBuilder
    )
  }
}
