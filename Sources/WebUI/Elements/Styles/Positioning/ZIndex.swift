extension Element {
  /// Sets the z-index of the element with an optional breakpoint.
  ///
  /// - Parameters:
  ///   - value: The z-index value (e.g., "10", "auto", "[100]").
  ///   - breakpoint: Optional breakpoint prefix (e.g., `md:` applies styles at 768px and up).
  /// - Returns: A new `Element` with the updated z-index class.
  func zIndex(_ value: String, on breakpoint: Breakpoint? = nil) -> Element {
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
