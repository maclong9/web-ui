extension Element {
  /// Applies margin styling to the element with one or more edges.
  ///
  /// - Parameters:
  ///   - edges: One or more edges to apply the margin to. Defaults to `.all`.
  ///   - length: The spacing value in `0.25rem` increments.
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated margin classes.
  public func margins(
    _ edges: Edge...,
    length: Int? = 4,
    on modifiers: Modifier...
  ) -> Element {
    let effectiveEdges = edges.isEmpty ? [Edge.all] : edges
    let baseClasses: [String] =
      length.map { lengthValue in
        effectiveEdges.map { edge in
          let edgeValue = edge.rawValue
          return "m\(edgeValue)-\(lengthValue)"
        }
      } ?? []

    let newClasses: [String]
    if modifiers.isEmpty {
      newClasses = baseClasses
    } else {
      newClasses = baseClasses.flatMap { base in
        modifiers.map { modifier in
          "\(modifier.rawValue)\(base)"
        }
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

  /// Applies padding styling to the element with one or more edges.
  ///
  /// - Parameters:
  ///   - edges: One or more edges to apply the padding to. Defaults to `.all`.
  ///   - length: The spacing value.
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated padding classes.
  public func padding(
    _ edges: Edge...,
    length: Int? = 4,
    on modifiers: Modifier...
  ) -> Element {
    let effectiveEdges = edges.isEmpty ? [Edge.all] : edges
    let baseClasses: [String] =
      length.map { lengthValue in
        effectiveEdges.map { edge in
          let edgeValue = edge.rawValue
          return "p\(edgeValue)-\(lengthValue)"
        }
      } ?? []

    let newClasses: [String]
    if modifiers.isEmpty {
      newClasses = baseClasses
    } else {
      newClasses = baseClasses.flatMap { base in
        modifiers.map { modifier in
          "\(modifier.rawValue)\(base)"
        }
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
