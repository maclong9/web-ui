/// Defines CSS animation names for type-safe animations.
///
/// Provides common animation keyframes that can be used across the framework.
public enum AnimationName {
    /// Fade in animation
    case fadeIn
    /// Fade out animation
    case fadeOut
    /// Slide up animation
    case slideUp
    /// Slide down animation
    case slideDown
    /// Slide left animation
    case slideLeft
    /// Slide right animation
    case slideRight
    /// Scale up animation
    case scaleUp
    /// Scale down animation
    case scaleDown
    /// Bounce animation
    case bounce
    /// Pulse animation
    case pulse
    /// Spin animation
    case spin
    /// Ping animation
    case ping
    /// Custom animation name
    case custom(String)

    public var value: String {
        switch self {
        case .fadeIn: return "fade-in"
        case .fadeOut: return "fade-out"
        case .slideUp: return "slide-up"
        case .slideDown: return "slide-down"
        case .slideLeft: return "slide-left"
        case .slideRight: return "slide-right"
        case .scaleUp: return "scale-up"
        case .scaleDown: return "scale-down"
        case .bounce: return "bounce"
        case .pulse: return "pulse"
        case .spin: return "spin"
        case .ping: return "ping"
        case .custom(let name): return name
        }
    }
}

/// Defines animation iteration behavior.
///
/// Specifies how many times an animation should repeat.
public enum AnimationIterationCount {
    /// Animation runs once
    case once
    /// Animation loops infinitely
    case infinite
    /// Animation runs a specific number of times
    case count(Int)

    public var value: String {
        switch self {
        case .once: return "1"
        case .infinite: return "infinite"
        case .count(let n): return "\(n)"
        }
    }
}

/// Defines animation direction.
///
/// Specifies whether the animation should play forwards, backwards, or alternate.
public enum AnimationDirection: String {
    /// Animation plays forward every iteration
    case normal
    /// Animation plays backward every iteration
    case reverse
    /// Animation alternates between forward and backward
    case alternate
    /// Animation alternates starting backwards
    case alternateReverse = "alternate-reverse"
}

/// Defines animation fill mode.
///
/// Specifies how the animation applies styles before and after execution.
public enum AnimationFillMode: String {
    /// No styles applied before or after
    case none
    /// Styles from first keyframe applied before animation
    case forwards
    /// Styles from last keyframe retained after animation
    case backwards
    /// Combination of both forwards and backwards
    case both
}

/// Defines animation play state.
///
/// Specifies whether the animation is running or paused.
public enum AnimationPlayState: String {
    /// Animation is running
    case running
    /// Animation is paused
    case paused
}

/// Defines animation timing functions with support for cubic-bezier.
///
/// Extends the basic Easing enum to include custom cubic-bezier curves.
public enum AnimationTiming {
    /// Linear timing
    case linear
    /// Ease-in timing
    case easeIn
    /// Ease-out timing
    case easeOut
    /// Ease-in-out timing
    case easeInOut
    /// Custom cubic-bezier curve
    case cubicBezier(Double, Double, Double, Double)

    public var value: String {
        switch self {
        case .linear: return "linear"
        case .easeIn: return "ease-in"
        case .easeOut: return "ease-out"
        case .easeInOut: return "ease-in-out"
        case .cubicBezier(let x1, let y1, let x2, let y2):
            return "cubic-bezier(\(x1), \(y1), \(x2), \(y2))"
        }
    }
}
