extension Element {
  /// Applies margin styling to the element with an optional breakpoint.
  ///
  /// - Parameters:
  ///   - edges: Single edge or array of edges to apply the margin to. Defaults to `.all`.
  ///   - length: The spacing value in `0.25rem` increments.
  ///   - breakpoint: Optional breakpoint prefix.
  /// - Returns: A new `Element` with the updated margin classes.
  func margins(
    _ edges: Edge? = .all,
    length: Int? = 4,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    margins([edges ?? .all], length: length, on: breakpoint)
  }

  /// Applies margin styling to multiple edges with an optional breakpoint.
  ///
  /// - Parameters:
  ///   - edges: Array of edges to apply the margin to.
  ///   - length: The spacing value in `0.25rem` increments.
  ///   - breakpoint: Optional breakpoint prefix.
  /// - Returns: A new `Element` with the updated margin classes.
  func margins(
    _ edges: [Edge],
    length: Int? = 4,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    if let lengthValue = length {
      for edge in edges {
        let edgeValue = edge.rawValue
        newClasses.append("\(prefix)m\(edgeValue)-\(lengthValue)")
      }
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

  /// Applies padding styling to the element with an optional breakpoint.
  ///
  /// - Parameters:
  ///   - edges: Single edge or array of edges to apply the padding to. Defaults to `.all`.
  ///   - length: The spacing value.
  ///   - breakpoint: Optional breakpoint prefix.
  /// - Returns: A new `Element` with the updated padding classes.
  func padding(
    _ edges: Edge? = .all,
    length: Int? = 4,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    padding([edges ?? .all], length: length, on: breakpoint)
  }

  /// Applies padding styling to multiple edges with an optional breakpoint.
  ///
  /// - Parameters:
  ///   - edges: Array of edges to apply the padding to.
  ///   - length: The spacing value.
  ///   - breakpoint: Optional breakpoint prefix.
  /// - Returns: A new `Element` with the updated padding classes.
  func padding(
    _ edges: [Edge],
    length: Int? = 4,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []
    
    if let lengthValue = length {
      for edge in edges {
        let edgeValue = edge.rawValue
        newClasses.append("\(prefix)p\(edgeValue)-\(lengthValue)")
      }
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
