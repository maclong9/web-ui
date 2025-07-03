import Foundation

/// Timing configuration for animations including easing and duration
///
/// `AnimationTiming` encapsulates all timing-related aspects of an animation,
/// including duration, delay, easing functions, and advanced options like
/// iteration count and fill mode.
///
/// ## Usage
///
/// ```swift
/// let timing = AnimationTiming(
///     duration: 0.5,
///     delay: 0.1,
///     easing: .easeInOut,
///     iterationCount: .finite(2),
///     fillMode: .both
/// )
/// ```
public struct AnimationTiming: Sendable {
    public let duration: TimeInterval
    public let delay: TimeInterval
    public let easing: EasingFunction
    public let iterationCount: AnimationIterationCount
    public let direction: AnimationDirection
    public let fillMode: AnimationFillMode
    public let playState: AnimationPlayState
    
    public init(
        duration: TimeInterval,
        delay: TimeInterval = 0,
        easing: EasingFunction = .ease,
        iterationCount: AnimationIterationCount = .finite(1),
        direction: AnimationDirection = .normal,
        fillMode: AnimationFillMode = .none,
        playState: AnimationPlayState = .running
    ) {
        self.duration = duration
        self.delay = delay
        self.easing = easing
        self.iterationCount = iterationCount
        self.direction = direction
        self.fillMode = fillMode
        self.playState = playState
    }
    
    /// Generates CSS animation timing value
    public var cssValue: String {
        let parts = [
            "\(duration)s",
            easing.rawValue,
            delay > 0 ? "\(delay)s" : nil,
            iterationCount.cssValue,
            direction.rawValue,
            fillMode.rawValue,
            playState.rawValue
        ].compactMap { $0 }
        
        return parts.joined(separator: " ")
    }
    
    /// Short CSS value for simple animations (duration + easing)
    public var shortCssValue: String {
        "\(duration)s \(easing.rawValue)"
    }
}

// MARK: - Easing Functions

/// CSS easing functions for animation timing
public enum EasingFunction: String, Sendable {
    // Standard easing functions
    case linear = "linear"
    case ease = "ease"
    case easeIn = "ease-in"
    case easeOut = "ease-out"
    case easeInOut = "ease-in-out"
    
    // Cubic bezier easing functions
    case easeInSine = "cubic-bezier(0.12, 0, 0.39, 0)"
    case easeOutSine = "cubic-bezier(0.61, 1, 0.88, 1)"
    case easeInOutSine = "cubic-bezier(0.37, 0, 0.63, 1)"
    
    case easeInQuad = "cubic-bezier(0.11, 0, 0.5, 0)"
    case easeOutQuad = "cubic-bezier(0.5, 1, 0.89, 1)"
    case easeInOutQuad = "cubic-bezier(0.45, 0, 0.55, 1)"
    
    case easeInCubic = "cubic-bezier(0.32, 0, 0.67, 0)"
    case easeOutCubic = "cubic-bezier(0.33, 1, 0.68, 1)"
    case easeInOutCubic = "cubic-bezier(0.65, 0, 0.35, 1)"
    
    case easeInQuart = "cubic-bezier(0.5, 0, 0.75, 0)"
    case easeOutQuart = "cubic-bezier(0.25, 1, 0.5, 1)"
    case easeInOutQuart = "cubic-bezier(0.76, 0, 0.24, 1)"
    
    case easeInQuint = "cubic-bezier(0.64, 0, 0.78, 0)"
    case easeOutQuint = "cubic-bezier(0.22, 1, 0.36, 1)"
    case easeInOutQuint = "cubic-bezier(0.83, 0, 0.17, 1)"
    
    case easeInExpo = "cubic-bezier(0.7, 0, 0.84, 0)"
    case easeOutExpo = "cubic-bezier(0.16, 1, 0.3, 1)"
    case easeInOutExpo = "cubic-bezier(0.87, 0, 0.13, 1)"
    
    case easeInCirc = "cubic-bezier(0.55, 0, 1, 0.45)"
    case easeOutCirc = "cubic-bezier(0, 0.55, 0.45, 1)"
    case easeInOutCirc = "cubic-bezier(0.85, 0, 0.15, 1)"
    
    case easeInBack = "cubic-bezier(0.36, 0, 0.66, -0.56)"
    case easeOutBack = "cubic-bezier(0.34, 1.56, 0.64, 1)"
    case easeInOutBack = "cubic-bezier(0.68, -0.6, 0.32, 1.6)"
    
    // Custom cubic bezier
    case custom(String)
    
    public var rawValue: String {
        switch self {
        case .custom(let value):
            return value
        default:
            return (Mirror(reflecting: self).children.first?.value as? String) ?? "ease"
        }
    }
}

// MARK: - Timing Presets

extension AnimationTiming {
    /// Fast animation (0.15s)
    public static let fast = AnimationTiming(duration: 0.15, easing: .easeOut)
    
    /// Normal animation (0.3s)
    public static let normal = AnimationTiming(duration: 0.3, easing: .easeOut)
    
    /// Slow animation (0.5s)
    public static let slow = AnimationTiming(duration: 0.5, easing: .easeInOut)
    
    /// Spring-like animation
    public static let spring = AnimationTiming(
        duration: 0.6,
        easing: .custom("cubic-bezier(0.68, -0.55, 0.265, 1.55)")
    )
    
    /// Bounce animation
    public static let bounce = AnimationTiming(
        duration: 0.8,
        easing: .custom("cubic-bezier(0.68, -0.6, 0.32, 1.6)")
    )
    
    /// Smooth fade
    public static let fade = AnimationTiming(duration: 0.3, easing: .easeInOut)
    
    /// Quick scale
    public static let scale = AnimationTiming(duration: 0.2, easing: .easeOut)
    
    /// Slide motion
    public static let slide = AnimationTiming(duration: 0.4, easing: .easeOut)
}

// MARK: - Timing Utilities

extension AnimationTiming {
    /// Creates a delayed version of this timing
    /// - Parameter delay: Additional delay in seconds
    /// - Returns: New timing with added delay
    public func delayed(by delay: TimeInterval) -> AnimationTiming {
        AnimationTiming(
            duration: duration,
            delay: self.delay + delay,
            easing: easing,
            iterationCount: iterationCount,
            direction: direction,
            fillMode: fillMode,
            playState: playState
        )
    }
    
    /// Creates a version with different duration
    /// - Parameter duration: New duration in seconds
    /// - Returns: New timing with updated duration
    public func withDuration(_ duration: TimeInterval) -> AnimationTiming {
        AnimationTiming(
            duration: duration,
            delay: delay,
            easing: easing,
            iterationCount: iterationCount,
            direction: direction,
            fillMode: fillMode,
            playState: playState
        )
    }
    
    /// Creates a version with different easing
    /// - Parameter easing: New easing function
    /// - Returns: New timing with updated easing
    public func withEasing(_ easing: EasingFunction) -> AnimationTiming {
        AnimationTiming(
            duration: duration,
            delay: delay,
            easing: easing,
            iterationCount: iterationCount,
            direction: direction,
            fillMode: fillMode,
            playState: playState
        )
    }
    
    /// Creates a repeating version of this timing
    /// - Parameter count: Number of iterations
    /// - Returns: New timing with specified iteration count
    public func repeating(_ count: Int) -> AnimationTiming {
        AnimationTiming(
            duration: duration,
            delay: delay,
            easing: easing,
            iterationCount: .finite(count),
            direction: direction,
            fillMode: fillMode,
            playState: playState
        )
    }
    
    /// Creates an infinitely repeating version
    /// - Returns: New timing that repeats infinitely
    public func repeatingForever() -> AnimationTiming {
        AnimationTiming(
            duration: duration,
            delay: delay,
            easing: easing,
            iterationCount: .infinite,
            direction: direction,
            fillMode: fillMode,
            playState: playState
        )
    }
}