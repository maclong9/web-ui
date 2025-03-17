extension Element {
  /// Sets the opacity of the element with an optional breakpoint.
  ///
  /// - Parameters:
  ///   - value: The opacity value.
  ///   - breakpoint: Optional breakpoint prefix.
  /// - Returns: A new `Element` with the updated opacity class.
  func opacity(_ value: String, on breakpoint: Breakpoint? = nil) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    let className = "\(prefix)opacity-\(value)"

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
