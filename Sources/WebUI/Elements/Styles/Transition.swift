/// Represents transition properties in TailwindCSS.
public enum TransitionProperty: String {
  case all
  case colors
  case opacity
  case shadow
  case transform
}

/// Represents easing functions for transitions in TailwindCSS.
public enum Easing: String {
  case linear
  case `in`
  case out
  case inOut = "in-out"
}

extension Element {
  /// Applies transition styling to the element with an optional breakpoint.
  ///
  /// - Parameters:
  ///   - property: The property to transition (e.g., `.colors`). If nil, uses default `transition`.
  ///   - duration: Duration in milliseconds (e.g., 300 for `duration-300`).
  ///   - easing: Easing function (e.g., `.inOut` for `ease-in-out`).
  ///   - delay: Delay in milliseconds (e.g., 150 for `delay-150`).
  ///   - breakpoint: Optional breakpoint prefix (e.g., `md:` applies styles at 768px and up).
  /// - Returns: A new `Element` with the updated transition classes.
  func transition(
    property: TransitionProperty? = nil,
    duration: Int? = nil,
    easing: Easing? = nil,
    delay: Int? = nil,
    on breakpoint: Breakpoint? = nil
  ) -> Element {
    let prefix = breakpoint?.rawValue ?? ""
    var newClasses: [String] = []

    if let property = property {
      newClasses.append("\(prefix)transition-\(property.rawValue)")
    } else {
      newClasses.append("\(prefix)transition")
    }
    if let duration = duration {
      newClasses.append("\(prefix)duration-\(duration)")
    }
    if let easing = easing {
      newClasses.append("\(prefix)ease-\(easing.rawValue)")
    }
    if let delay = delay {
      newClasses.append("\(prefix)delay-\(delay)")
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
