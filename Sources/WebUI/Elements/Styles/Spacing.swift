/// Represents edge options for spacing (margins and padding).
public enum Edge: String {
  /// Applies spacing to all edges
  case all = ""
  /// Applies spacing to the top edge
  case top = "t"
  /// Applies spacing to the leading (left) edge
  case leading = "l"
  /// Applies spacing to the trailing (right) edge
  case trailing = "r"
  /// Applies spacing to the bottom edge
  case bottom = "b"
  /// Applies spacing to both leading and trailing edges
  case horizontal = "x"
  /// Applies spacing to both top and bottom edges
  case vertical = "y"
}

extension Element {
  /// Applies margin styling to the element with an optional breakpoint.
  ///
  /// This modifier adds TailwindCSS margin classes in the format `m{edge}-{length}` (e.g., `mt-4` for top margin of 1rem).
  ///
  /// - Parameters:
  ///   - edges: Specifies which edges to apply the margin to. Defaults to `.all`.
  ///   - length: The spacing value in `0.25rem` increments (e.g., `4 = 1rem`). Defaults to `4`.
  ///   - breakpoint: Optional breakpoint prefix (e.g., `md:` applies styles at 768px and up).
  /// - Returns: A new `Element` with the updated margin classes.
  func margins(
    _ edges: Edge? = .all,
    length: Int? = 4,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    let edgeValue = edges?.rawValue ?? Edge.all.rawValue
    if let lengthValue = length {
      newClasses.append("\(prefix)m\(edgeValue)-\(lengthValue)")
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
  /// This modifier adds TailwindCSS padding classes in the format `p{edge}-{length}` (e.g., `pt-4` for top padding of 1rem).
  ///
  /// - Parameters:
  ///   - edges: Specifies which edges to apply the padding to. Defaults to `.all`.
  ///   - length: The spacing value in Tailwind units (0.25rem increments, e.g., 4 = 1rem). Defaults to 4.
  ///   - breakpoint: Optional breakpoint prefix (e.g., `md:` applies styles at 768px and up).
  /// - Returns: A new `Element` with the updated padding classes.
  func padding(
    _ edges: Edge? = .all,
    length: Int? = 4,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    let edgeValue = edges?.rawValue ?? Edge.all.rawValue
    if let lengthValue = length {
      newClasses.append("\(prefix)p\(edgeValue)-\(lengthValue)")
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
