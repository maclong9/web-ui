/// Defines properties for CSS transitions.
///
/// Specifies which element properties are animated during transitions.
public enum TransitionProperty: String {
  /// Transitions all animatable properties.
  case all
  /// Transitions color-related properties.
  case colors
  /// Transitions opacity.
  case opacity
  /// Transitions box shadow.
  case shadow
  /// Transitions transform properties.
  case transform
}

/// Defines easing functions for transitions.
///
/// Specifies the timing curve for transition animations.
public enum Easing: String {
  /// Applies a linear timing function.
  case linear
  /// Applies an ease-in timing function.
  case `in`
  /// Applies an ease-out timing function.
  case out
  /// Applies an ease-in-out timing function.
  case inOut = "in-out"
}

extension Element {
  /// Applies transition styling to the element.
  ///
  /// Adds classes for animating properties with duration, easing, and delay.
  ///
  /// - Parameters:
  ///   - property: Specifies the property to animate (defaults to all if nil).
  ///   - duration: Sets the transition duration in milliseconds.
  ///   - easing: Defines the timing function for the transition.
  ///   - delay: Sets the delay before the transition starts in milliseconds.
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated transition classes.
  public func transition(
    property: TransitionProperty? = nil,
    duration: Int? = nil,
    easing: Easing? = nil,
    delay: Int? = nil,
    on modifiers: Modifier...
  ) -> Element {
    var baseClasses: [String] = []
    baseClasses.append(property != nil ? "transition-\(property!.rawValue)" : "transition")
    if let duration = duration { baseClasses.append("duration-\(duration)") }
    if let easing = easing { baseClasses.append("ease-\(easing.rawValue)") }
    if let delay = delay { baseClasses.append("delay-\(delay)") }

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
