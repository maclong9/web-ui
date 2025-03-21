extension Element {
  /// Applies a z-index to the element.
  ///
  /// Sets the stacking order of the element, optionally scoped to a breakpoint.
  ///
  /// - Parameters:
  ///   - value: Specifies the z-index value as a string.
  ///   - breakpoint: Applies the z-index at a specific screen size.
  /// - Returns: A new element with updated z-index classes.
  func zIndex(_ value: Int, on breakpoint: Breakpoint? = nil) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    let className = "\(prefix)z-\(value)"

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
