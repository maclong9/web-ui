import Foundation

/// Style operation for applying CSS View Transitions
public struct ViewTransitionStyleOperation: StyleOperation, Sendable {
  public static let shared = ViewTransitionStyleOperation()

  /// Parameters for configuring view transitions
  public struct Parameters: Sendable {
    public let transitionType: ViewTransitionType?
    public let name: String?
    public let duration: Int?
    public let timing: ViewTransitionTiming?
    public let delay: Int?
    public let slideDirection: SlideDirection?
    public let scaleOrigin: ScaleOrigin?
    public let behavior: ViewTransitionBehavior?

    /// Initialize view transition parameters.
    ///
    /// - Parameters:
    ///   - transitionType: The type of view transition to apply
    ///   - name: The view transition name for CSS View Transitions API
    ///   - duration: The duration of the transition in milliseconds
    ///   - timing: The timing function for the transition
    ///   - delay: The delay before the transition starts in milliseconds
    ///   - slideDirection: The direction for slide transitions
    ///   - scaleOrigin: The origin point for scale transitions
    ///   - behavior: The transition behavior
    public init(
      transitionType: ViewTransitionType? = nil,
      name: String? = nil,
      duration: Int? = nil,
      timing: ViewTransitionTiming? = nil,
      delay: Int? = nil,
      slideDirection: SlideDirection? = nil,
      scaleOrigin: ScaleOrigin? = nil,
      behavior: ViewTransitionBehavior? = nil
    ) {
      self.transitionType = transitionType
      self.name = name
      self.duration = duration
      self.timing = timing
      self.delay = delay
      self.slideDirection = slideDirection
      self.scaleOrigin = scaleOrigin
      self.behavior = behavior
    }

    /// Create parameters from StyleParameters.
    ///
    /// - Parameter params: The style parameters to convert
    /// - Returns: A new Parameters instance
    public static func from(_ params: StyleParameters) -> Parameters {
      Parameters(
        transitionType: params.get("viewTransitionType"),
        name: params.get("viewTransitionName"),
        duration: params.get("viewTransitionDuration"),
        timing: params.get("viewTransitionTiming"),
        delay: params.get("viewTransitionDelay"),
        slideDirection: params.get("viewTransitionSlideDirection"),
        scaleOrigin: params.get("viewTransitionScaleOrigin"),
        behavior: params.get("viewTransitionBehavior")
      )
    }
  }

  /// Apply view transition classes based on parameters.
  ///
  /// - Parameter params: The parameters containing view transition configuration
  /// - Returns: An array of CSS class names to apply
  public func applyClasses(params: Parameters) -> [String] {
    var classes: [String] = []

    // Apply view transition name for CSS View Transitions API
    if let name = params.name {
      classes.append("view-transition-name-\(name)")
    }

    // Apply transition type
    if let transitionType = params.transitionType {
      classes.append("view-transition-\(transitionType.rawValue)")

      // Apply direction-specific classes for slide transitions
      if transitionType == .slide, let direction = params.slideDirection {
        classes.append("view-transition-slide-\(direction.rawValue)")
      }

      // Apply origin-specific classes for scale transitions
      if transitionType == .scale || transitionType == .scaleUp || transitionType == .scaleDown,
        let origin = params.scaleOrigin
      {
        classes.append("view-transition-origin-\(origin.rawValue)")
      }
    }

    // Apply timing
    if let timing = params.timing {
      classes.append("view-transition-timing-\(timing.rawValue)")
    }

    // Apply duration
    if let duration = params.duration {
      classes.append("view-transition-duration-\(duration)")
    }

    // Apply delay
    if let delay = params.delay {
      classes.append("view-transition-delay-\(delay)")
    }

    // Apply behavior
    if let behavior = params.behavior {
      classes.append("view-transition-behavior-\(behavior.rawValue)")
    }

    return classes
  }

  /// Override applyTo to use separate modifier behavior for view transitions
  ///
  /// This ensures that each modifier applies to all view transition classes separately,
  /// which is the expected behavior for CSS View Transitions.
  ///
  /// - Parameters:
  ///   - content: The markup content to apply styles to
  ///   - params: The parameters for this style operation
  ///   - modifiers: The modifiers to apply (e.g., .hover, .md)
  /// - Returns: A new element with the styles applied
  public func applyTo<T: Markup>(
    _ content: T, params: Parameters, modifiers: [Modifier] = []
  ) -> StyleModifier<T> {
    let classes = applyClasses(params: params)
    let newClasses = StyleUtilities.combineClassesWithSeparateModifiers(
      classes, withModifiers: modifiers)

    return StyleModifier(content: content, classes: newClasses)
  }

  private init() {}
}

// MARK: - Markup Extension
extension Markup {
  /// Apply view transition configuration to this element.
  ///
  /// - Parameters:
  ///   - transitionType: The type of view transition to apply
  ///   - name: The view transition name for CSS View Transitions API
  ///   - duration: The duration of the transition in milliseconds
  ///   - timing: The timing function for the transition
  ///   - delay: The delay before the transition starts in milliseconds
  ///   - slideDirection: The direction for slide transitions
  ///   - scaleOrigin: The origin point for scale transitions
  ///   - behavior: The transition behavior
  ///   - modifiers: The modifiers to apply the transition on
  /// - Returns: A modified markup element with view transition applied
  public func viewTransition(
    _ transitionType: ViewTransitionType? = nil,
    name: String? = nil,
    duration: Int? = nil,
    timing: ViewTransitionTiming? = nil,
    delay: Int? = nil,
    slideDirection: SlideDirection? = nil,
    scaleOrigin: ScaleOrigin? = nil,
    behavior: ViewTransitionBehavior? = nil,
    on modifiers: Modifier...
  ) -> some Markup {
    let params = ViewTransitionStyleOperation.Parameters(
      transitionType: transitionType,
      name: name,
      duration: duration,
      timing: timing,
      delay: delay,
      slideDirection: slideDirection,
      scaleOrigin: scaleOrigin,
      behavior: behavior
    )
    return ViewTransitionStyleOperation.shared.applyTo(
      self, params: params, modifiers: Array(modifiers))
  }

  /// Apply named view transition for CSS View Transitions API.
  ///
  /// - Parameter name: The view transition name
  /// - Returns: A modified markup element with view transition name applied
  public func viewTransitionName(_ name: String) -> some Markup {
    viewTransition(name: name)
  }

  /// Apply fade transition.
  ///
  /// - Parameters:
  ///   - duration: The duration of the transition in milliseconds
  ///   - timing: The timing function for the transition
  ///   - delay: The delay before the transition starts in milliseconds
  /// - Returns: A modified markup element with fade transition applied
  public func fadeTransition(
    duration: Int? = nil, timing: ViewTransitionTiming? = nil, delay: Int? = nil
  )
    -> some Markup
  {
    viewTransition(.fade, duration: duration, timing: timing, delay: delay)
  }

  /// Apply slide transition with direction.
  ///
  /// - Parameters:
  ///   - direction: The direction for the slide transition
  ///   - duration: The duration of the transition in milliseconds
  ///   - timing: The timing function for the transition
  ///   - delay: The delay before the transition starts in milliseconds
  /// - Returns: A modified markup element with slide transition applied
  public func slideTransition(
    _ direction: SlideDirection,
    duration: Int? = nil,
    timing: ViewTransitionTiming? = nil,
    delay: Int? = nil
  ) -> some Markup {
    viewTransition(
      .slide, duration: duration, timing: timing, delay: delay, slideDirection: direction)
  }

  /// Apply scale transition with origin.
  ///
  /// - Parameters:
  ///   - scaleType: The type of scale transition
  ///   - origin: The origin point for the scale transition
  ///   - duration: The duration of the transition in milliseconds
  ///   - timing: The timing function for the transition
  ///   - delay: The delay before the transition starts in milliseconds
  /// - Returns: A modified markup element with scale transition applied
  public func scaleTransition(
    _ scaleType: ViewTransitionType = .scale,
    origin: ScaleOrigin? = nil,
    duration: Int? = nil,
    timing: ViewTransitionTiming? = nil,
    delay: Int? = nil
  ) -> some Markup {
    viewTransition(scaleType, duration: duration, timing: timing, delay: delay, scaleOrigin: origin)
  }
}

// MARK: - ResponsiveBuilder Extension
extension ResponsiveBuilder {
  /// Apply view transition configuration in responsive context.
  ///
  /// - Parameters:
  ///   - transitionType: The type of view transition to apply
  ///   - name: The view transition name for CSS View Transitions API
  ///   - duration: The duration of the transition in milliseconds
  ///   - timing: The timing function for the transition
  ///   - delay: The delay before the transition starts in milliseconds
  ///   - slideDirection: The direction for slide transitions
  ///   - scaleOrigin: The origin point for scale transitions
  ///   - behavior: The transition behavior
  /// - Returns: A modified responsive builder with view transition applied
  public func viewTransition(
    _ transitionType: ViewTransitionType? = nil,
    name: String? = nil,
    duration: Int? = nil,
    timing: ViewTransitionTiming? = nil,
    delay: Int? = nil,
    slideDirection: SlideDirection? = nil,
    scaleOrigin: ScaleOrigin? = nil,
    behavior: ViewTransitionBehavior? = nil
  ) -> ResponsiveBuilder {
    let params = ViewTransitionStyleOperation.Parameters(
      transitionType: transitionType,
      name: name,
      duration: duration,
      timing: timing,
      delay: delay,
      slideDirection: slideDirection,
      scaleOrigin: scaleOrigin,
      behavior: behavior
    )
    return ViewTransitionStyleOperation.shared.applyToBuilder(self, params: params)
  }

  /// Apply named view transition in responsive context.
  ///
  /// - Parameter name: The view transition name
  /// - Returns: A modified responsive builder with view transition name applied
  public func viewTransitionName(_ name: String) -> ResponsiveBuilder {
    viewTransition(name: name)
  }

  /// Apply fade transition in responsive context.
  ///
  /// - Parameters:
  ///   - duration: The duration of the transition in milliseconds
  ///   - timing: The timing function for the transition
  ///   - delay: The delay before the transition starts in milliseconds
  /// - Returns: A modified responsive builder with fade transition applied
  public func fadeTransition(
    duration: Int? = nil, timing: ViewTransitionTiming? = nil, delay: Int? = nil
  )
    -> ResponsiveBuilder
  {
    viewTransition(.fade, duration: duration, timing: timing, delay: delay)
  }

  /// Apply slide transition in responsive context.
  ///
  /// - Parameters:
  ///   - direction: The direction for the slide transition
  ///   - duration: The duration of the transition in milliseconds
  ///   - timing: The timing function for the transition
  ///   - delay: The delay before the transition starts in milliseconds
  /// - Returns: A modified responsive builder with slide transition applied
  public func slideTransition(
    _ direction: SlideDirection,
    duration: Int? = nil,
    timing: ViewTransitionTiming? = nil,
    delay: Int? = nil
  ) -> ResponsiveBuilder {
    viewTransition(
      .slide, duration: duration, timing: timing, delay: delay, slideDirection: direction)
  }

  /// Apply scale transition in responsive context.
  ///
  /// - Parameters:
  ///   - scaleType: The type of scale transition
  ///   - origin: The origin point for the scale transition
  ///   - duration: The duration of the transition in milliseconds
  ///   - timing: The timing function for the transition
  ///   - delay: The delay before the transition starts in milliseconds
  /// - Returns: A modified responsive builder with scale transition applied
  public func scaleTransition(
    _ scaleType: ViewTransitionType = .scale,
    origin: ScaleOrigin? = nil,
    duration: Int? = nil,
    timing: ViewTransitionTiming? = nil,
    delay: Int? = nil
  ) -> ResponsiveBuilder {
    viewTransition(scaleType, duration: duration, timing: timing, delay: delay, scaleOrigin: origin)
  }
}

// MARK: - Global DSL Functions
/// Apply view transition configuration declaratively.
///
/// - Parameters:
///   - transitionType: The type of view transition to apply
///   - name: The view transition name for CSS View Transitions API
///   - duration: The duration of the transition in milliseconds
///   - timing: The timing function for the transition
///   - delay: The delay before the transition starts in milliseconds
///   - slideDirection: The direction for slide transitions
///   - scaleOrigin: The origin point for scale transitions
///   - behavior: The transition behavior
/// - Returns: A responsive modification with view transition applied
public func viewTransition(
  _ transitionType: ViewTransitionType? = nil,
  name: String? = nil,
  duration: Int? = nil,
  timing: ViewTransitionTiming? = nil,
  delay: Int? = nil,
  slideDirection: SlideDirection? = nil,
  scaleOrigin: ScaleOrigin? = nil,
  behavior: ViewTransitionBehavior? = nil
) -> ResponsiveModification {
  let params = ViewTransitionStyleOperation.Parameters(
    transitionType: transitionType,
    name: name,
    duration: duration,
    timing: timing,
    delay: delay,
    slideDirection: slideDirection,
    scaleOrigin: scaleOrigin,
    behavior: behavior
  )
  return ViewTransitionStyleOperation.shared.asModification(params: params)
}

/// Apply named view transition declaratively.
///
/// - Parameter name: The view transition name
/// - Returns: A responsive modification with view transition name applied
public func viewTransitionName(_ name: String) -> ResponsiveModification {
  viewTransition(name: name)
}

/// Apply fade transition declaratively.
///
/// - Parameters:
///   - duration: The duration of the transition in milliseconds
///   - timing: The timing function for the transition
///   - delay: The delay before the transition starts in milliseconds
/// - Returns: A responsive modification with fade transition applied
public func fadeTransition(
  duration: Int? = nil, timing: ViewTransitionTiming? = nil, delay: Int? = nil
)
  -> ResponsiveModification
{
  viewTransition(.fade, duration: duration, timing: timing, delay: delay)
}

/// Apply slide transition declaratively.
///
/// - Parameters:
///   - direction: The direction for the slide transition
///   - duration: The duration of the transition in milliseconds
///   - timing: The timing function for the transition
///   - delay: The delay before the transition starts in milliseconds
/// - Returns: A responsive modification with slide transition applied
public func slideTransition(
  _ direction: SlideDirection,
  duration: Int? = nil,
  timing: ViewTransitionTiming? = nil,
  delay: Int? = nil
) -> ResponsiveModification {
  viewTransition(
    .slide, duration: duration, timing: timing, delay: delay, slideDirection: direction)
}

/// Apply scale transition declaratively.
///
/// - Parameters:
///   - scaleType: The type of scale transition
///   - origin: The origin point for the scale transition
///   - duration: The duration of the transition in milliseconds
///   - timing: The timing function for the transition
///   - delay: The delay before the transition starts in milliseconds
/// - Returns: A responsive modification with scale transition applied
public func scaleTransition(
  _ scaleType: ViewTransitionType = .scale,
  origin: ScaleOrigin? = nil,
  duration: Int? = nil,
  timing: ViewTransitionTiming? = nil,
  delay: Int? = nil
) -> ResponsiveModification {
  viewTransition(scaleType, duration: duration, timing: timing, delay: delay, scaleOrigin: origin)
}
