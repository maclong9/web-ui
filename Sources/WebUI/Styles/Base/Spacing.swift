extension Element {
  /// Applies margin styling to the element with one or more edges.
  ///
  /// - Parameters:
  ///   - length: The spacing value in `0.25rem` increments.
  ///   - edges: One or more edges to apply the margin to. Defaults to `.all`.
  ///   - auto: Whether to use automatic margins instead of a specific length.
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated margin classes.
  public func margins(
    of length: Int? = 4,
    at edges: Edge...,
    auto: Bool = false,
    on modifiers: Modifier...
  ) -> Element {
    let effectiveEdges = edges.isEmpty ? [Edge.all] : edges
    let baseClasses: [String]
    if auto {
      baseClasses = effectiveEdges.map { edge in
        let edgeValue = edge.rawValue
        return "m\(edgeValue)-auto"
      }
    } else {
      baseClasses =
        length.map { lengthValue in
          effectiveEdges.map { edge in
            let edgeValue = edge.rawValue
            return "m\(edgeValue)-\(lengthValue)"
          }
        } ?? []
    }

    let newClasses = combineClasses(baseClasses, withModifiers: modifiers)

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

  /// Applies padding styling to the element with one or more edges.
  ///
  /// - Parameters:
  ///   - length: The spacing value.
  ///   - edges: One or more edges to apply the padding to. Defaults to `.all`.
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated padding classes.
  public func padding(
    of length: Int? = 4,
    at edges: Edge...,
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

    let newClasses = combineClasses(baseClasses, withModifiers: modifiers)

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

  /// Applies spacing between child elements horizontally and/or vertically.
  ///
  /// - Parameters:
  ///   - length: The spacing value in `0.25rem` increments.
  ///   - direction: The direction(s) to apply spacing (`horizontal`, `vertical`, or both).
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated spacing classes.
  public func spacing(
    of length: Int? = 4,
    along direction: Axis = .both,
    on modifiers: Modifier...
  ) -> Element {
    let baseClasses: [String] =
      length.map { lengthValue in
        switch direction {
        case .x:
          return ["space-x-\(lengthValue)"]
        case .y:
          return ["space-y-\(lengthValue)"]
        case .both:
          return ["space-x-\(lengthValue)", "space-y-\(lengthValue)"]
        }
      } ?? []

    let newClasses = combineClasses(baseClasses, withModifiers: modifiers)

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
