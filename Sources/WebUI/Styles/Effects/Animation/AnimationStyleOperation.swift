import Foundation

/// Style operation for CSS animation styling.
///
/// Provides a unified implementation for animation styling that supports both
/// Tailwind's built-in animations and custom keyframe animations.
public struct AnimationStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for animation styling
    public struct Parameters {
        /// The animation name/keyframe
        public let name: AnimationName?

        /// The animation duration in milliseconds
        public let duration: Int?

        /// The animation timing function
        public let timing: AnimationTiming?

        /// The animation delay in milliseconds
        public let delay: Int?

        /// The animation iteration count
        public let iterationCount: AnimationIterationCount?

        /// The animation direction
        public let direction: AnimationDirection?

        /// The animation fill mode
        public let fillMode: AnimationFillMode?

        /// The animation play state
        public let playState: AnimationPlayState?

        /// Creates parameters for animation styling
        ///
        /// - Parameters:
        ///   - name: The animation name/keyframe
        ///   - duration: The animation duration in milliseconds
        ///   - timing: The animation timing function
        ///   - delay: The animation delay in milliseconds
        ///   - iterationCount: How many times the animation should repeat
        ///   - direction: The direction of animation playback
        ///   - fillMode: How styles are applied before/after animation
        ///   - playState: Whether animation is running or paused
        public init(
            name: AnimationName? = nil,
            duration: Int? = nil,
            timing: AnimationTiming? = nil,
            delay: Int? = nil,
            iterationCount: AnimationIterationCount? = nil,
            direction: AnimationDirection? = nil,
            fillMode: AnimationFillMode? = nil,
            playState: AnimationPlayState? = nil
        ) {
            self.name = name
            self.duration = duration
            self.timing = timing
            self.delay = delay
            self.iterationCount = iterationCount
            self.direction = direction
            self.fillMode = fillMode
            self.playState = playState
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: AnimationStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                name: params.get("name"),
                duration: params.get("duration"),
                timing: params.get("timing"),
                delay: params.get("delay"),
                iterationCount: params.get("iterationCount"),
                direction: params.get("direction"),
                fillMode: params.get("fillMode"),
                playState: params.get("playState")
            )
        }
    }

    /// Applies the animation style and returns the appropriate stylesheet classes
    ///
    /// - Parameter params: The parameters for animation styling
    /// - Returns: An array of stylesheet class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        var classes: [String] = []

        // Handle Tailwind built-in animations
        if let name = params.name {
            switch name {
            case .spin, .pulse, .bounce, .ping:
                classes.append("animate-\(name.value)")
            case .fadeIn, .fadeOut, .slideUp, .slideDown, .slideLeft, .slideRight, .scaleUp, .scaleDown:
                // Custom animations - use animation-name class
                classes.append("animate-\(name.value)")
            case .custom:
                classes.append("animate-\(name.value)")
            }
        }

        // Duration (Tailwind doesn't have built-in animation-duration, so we use arbitrary values)
        if let duration = params.duration {
            classes.append("[animation-duration:\(duration)ms]")
        }

        // Timing function (arbitrary value)
        if let timing = params.timing {
            classes.append("[animation-timing-function:\(timing.value)]")
        }

        // Delay (arbitrary value)
        if let delay = params.delay {
            classes.append("[animation-delay:\(delay)ms]")
        }

        // Iteration count (arbitrary value)
        if let iterationCount = params.iterationCount {
            classes.append("[animation-iteration-count:\(iterationCount.value)]")
        }

        // Direction (arbitrary value)
        if let direction = params.direction {
            classes.append("[animation-direction:\(direction.rawValue)]")
        }

        // Fill mode (arbitrary value)
        if let fillMode = params.fillMode {
            classes.append("[animation-fill-mode:\(fillMode.rawValue)]")
        }

        // Play state (arbitrary value)
        if let playState = params.playState {
            classes.append("[animation-play-state:\(playState.rawValue)]")
        }

        return classes
    }

    /// Shared instance for use across the framework
    public static let shared = AnimationStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for Element to provide animation styling
extension Markup {
    /// Applies animation styling to the element.
    ///
    /// Adds classes for animating with keyframes, including duration, timing, delay, and iteration.
    ///
    /// - Parameters:
    ///   - name: The animation keyframe name (e.g., .spin, .pulse, .fadeIn, or .custom("myAnim")).
    ///   - duration: Sets the animation duration in milliseconds.
    ///   - timing: Defines the timing function (supports cubic-bezier).
    ///   - delay: Sets the delay before animation starts in milliseconds.
    ///   - iterationCount: How many times the animation repeats (.once, .infinite, .count(n)).
    ///   - direction: Direction of animation playback.
    ///   - fillMode: How styles are applied before/after animation.
    ///   - playState: Whether animation is running or paused.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the animation.
    /// - Returns: A new element with animation classes applied.
    public func animate(
        _ name: AnimationName,
        duration: Int? = nil,
        timing: AnimationTiming? = nil,
        delay: Int? = nil,
        iterationCount: AnimationIterationCount? = nil,
        direction: AnimationDirection? = nil,
        fillMode: AnimationFillMode? = nil,
        playState: AnimationPlayState? = nil,
        on modifiers: Modifier...
    ) -> some Markup {
        let params = AnimationStyleOperation.Parameters(
            name: name,
            duration: duration,
            timing: timing,
            delay: delay,
            iterationCount: iterationCount,
            direction: direction,
            fillMode: fillMode,
            playState: playState
        )

        return AnimationStyleOperation.shared.applyTo(
            self,
            params: params,
            modifiers: Array(modifiers)
        )
    }
}

// Extension for ResponsiveBuilder to provide animation styling
extension ResponsiveBuilder {
    /// Applies animation styling in a responsive context.
    ///
    /// - Parameters:
    ///   - name: The animation keyframe name.
    ///   - duration: The animation duration in milliseconds.
    ///   - timing: The animation timing function.
    ///   - delay: The animation delay in milliseconds.
    ///   - iterationCount: The animation iteration count.
    ///   - direction: The animation direction.
    ///   - fillMode: The animation fill mode.
    ///   - playState: The animation play state.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func animate(
        _ name: AnimationName,
        duration: Int? = nil,
        timing: AnimationTiming? = nil,
        delay: Int? = nil,
        iterationCount: AnimationIterationCount? = nil,
        direction: AnimationDirection? = nil,
        fillMode: AnimationFillMode? = nil,
        playState: AnimationPlayState? = nil
    ) -> ResponsiveBuilder {
        let params = AnimationStyleOperation.Parameters(
            name: name,
            duration: duration,
            timing: timing,
            delay: delay,
            iterationCount: iterationCount,
            direction: direction,
            fillMode: fillMode,
            playState: playState
        )

        return AnimationStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declarative DSL
/// Applies animation styling in the responsive context.
///
/// - Parameters:
///   - name: The animation keyframe name.
///   - duration: The animation duration in milliseconds.
///   - timing: The animation timing function.
///   - delay: The animation delay in milliseconds.
///   - iterationCount: The animation iteration count.
///   - direction: The animation direction.
///   - fillMode: The animation fill mode.
///   - playState: The animation play state.
/// - Returns: A responsive modification for animation.
public func animate(
    _ name: AnimationName,
    duration: Int? = nil,
    timing: AnimationTiming? = nil,
    delay: Int? = nil,
    iterationCount: AnimationIterationCount? = nil,
    direction: AnimationDirection? = nil,
    fillMode: AnimationFillMode? = nil,
    playState: AnimationPlayState? = nil
) -> ResponsiveModification {
    let params = AnimationStyleOperation.Parameters(
        name: name,
        duration: duration,
        timing: timing,
        delay: delay,
        iterationCount: iterationCount,
        direction: direction,
        fillMode: fillMode,
        playState: playState
    )

    return AnimationStyleOperation.shared.asModification(params: params)
}
