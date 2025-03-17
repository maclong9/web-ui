/// Represents transition properties
public enum TransitionProperty: String {
  case all
  case colors
  case opacity
  case shadow
  case transform
}

/// Represents easing functions for transitions
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
  ///   - property: The property to transition,
  ///   - duration: Duration in milliseconds.
  ///   - easing: Easing function.
  ///   - delay: Delay in milliseconds.
  ///   - breakpoint: Optional breakpoint prefix.
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
