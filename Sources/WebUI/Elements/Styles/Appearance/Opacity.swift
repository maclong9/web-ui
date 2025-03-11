extension Element {
  /// Sets the opacity of the element with an optional breakpoint.
  ///
  /// - Parameters:
  ///   - value: The opacity value (e.g., "50" for 50%, "[0.5]" for 0.5).
  ///   - breakpoint: Optional breakpoint prefix (e.g., `md:` applies styles at 768px and up).
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
