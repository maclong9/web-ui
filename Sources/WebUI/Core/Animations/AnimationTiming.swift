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
public enum EasingFunction: Sendable {
    // Standard easing functions
    case linear
    case ease
    case easeIn
    case easeOut
    case easeInOut
    
    // Cubic bezier easing functions
    case easeInSine
    case easeOutSine
    case easeInOutSine
    
    case easeInQuad
    case easeOutQuad
    case easeInOutQuad
    
    case easeInCubic
    case easeOutCubic
    case easeInOutCubic
    
    case easeInQuart
    case easeOutQuart
    case easeInOutQuart
    
    case easeInQuint
    case easeOutQuint
    case easeInOutQuint
    
    case easeInExpo
    case easeOutExpo
    case easeInOutExpo
    
    case easeInCirc
    case easeOutCirc
    case easeInOutCirc
    
    case easeInBack
    case easeOutBack
    case easeInOutBack
    
    // Custom cubic bezier
    case custom(String)
    
    public var rawValue: String {
        switch self {
        case .linear: return "linear"
        case .ease: return "ease"
        case .easeIn: return "ease-in"
        case .easeOut: return "ease-out"
        case .easeInOut: return "ease-in-out"
        case .easeInSine: return "cubic-bezier(0.12, 0, 0.39, 0)"
        case .easeOutSine: return "cubic-bezier(0.61, 1, 0.88, 1)"
        case .easeInOutSine: return "cubic-bezier(0.37, 0, 0.63, 1)"
        case .easeInQuad: return "cubic-bezier(0.11, 0, 0.5, 0)"
        case .easeOutQuad: return "cubic-bezier(0.5, 1, 0.89, 1)"
        case .easeInOutQuad: return "cubic-bezier(0.45, 0, 0.55, 1)"
        case .easeInCubic: return "cubic-bezier(0.32, 0, 0.67, 0)"
        case .easeOutCubic: return "cubic-bezier(0.33, 1, 0.68, 1)"
        case .easeInOutCubic: return "cubic-bezier(0.65, 0, 0.35, 1)"
        case .easeInQuart: return "cubic-bezier(0.5, 0, 0.75, 0)"
        case .easeOutQuart: return "cubic-bezier(0.25, 1, 0.5, 1)"
        case .easeInOutQuart: return "cubic-bezier(0.76, 0, 0.24, 1)"
        case .easeInQuint: return "cubic-bezier(0.64, 0, 0.78, 0)"
        case .easeOutQuint: return "cubic-bezier(0.22, 1, 0.36, 1)"
        case .easeInOutQuint: return "cubic-bezier(0.83, 0, 0.17, 1)"
        case .easeInExpo: return "cubic-bezier(0.7, 0, 0.84, 0)"
        case .easeOutExpo: return "cubic-bezier(0.16, 1, 0.3, 1)"
        case .easeInOutExpo: return "cubic-bezier(0.87, 0, 0.13, 1)"
        case .easeInCirc: return "cubic-bezier(0.55, 0, 1, 0.45)"
        case .easeOutCirc: return "cubic-bezier(0, 0.55, 0.45, 1)"
        case .easeInOutCirc: return "cubic-bezier(0.85, 0, 0.15, 1)"
        case .easeInBack: return "cubic-bezier(0.36, 0, 0.66, -0.56)"
        case .easeOutBack: return "cubic-bezier(0.34, 1.56, 0.64, 1)"
        case .easeInOutBack: return "cubic-bezier(0.68, -0.6, 0.32, 1.6)"
        case .custom(let value): return value
        }
    }
    
    /// Create an EasingFunction from a raw value string
    public init?(rawValue: String) {
        switch rawValue {
        case "linear": self = .linear
        case "ease": self = .ease
        case "ease-in": self = .easeIn
        case "ease-out": self = .easeOut
        case "ease-in-out": self = .easeInOut
        case "cubic-bezier(0.12, 0, 0.39, 0)": self = .easeInSine
        case "cubic-bezier(0.61, 1, 0.88, 1)": self = .easeOutSine
        case "cubic-bezier(0.37, 0, 0.63, 1)": self = .easeInOutSine
        case "cubic-bezier(0.11, 0, 0.5, 0)": self = .easeInQuad
        case "cubic-bezier(0.5, 1, 0.89, 1)": self = .easeOutQuad
        case "cubic-bezier(0.45, 0, 0.55, 1)": self = .easeInOutQuad
        case "cubic-bezier(0.32, 0, 0.67, 0)": self = .easeInCubic
        case "cubic-bezier(0.33, 1, 0.68, 1)": self = .easeOutCubic
        case "cubic-bezier(0.65, 0, 0.35, 1)": self = .easeInOutCubic
        case "cubic-bezier(0.5, 0, 0.75, 0)": self = .easeInQuart
        case "cubic-bezier(0.25, 1, 0.5, 1)": self = .easeOutQuart
        case "cubic-bezier(0.76, 0, 0.24, 1)": self = .easeInOutQuart
        case "cubic-bezier(0.64, 0, 0.78, 0)": self = .easeInQuint
        case "cubic-bezier(0.22, 1, 0.36, 1)": self = .easeOutQuint
        case "cubic-bezier(0.83, 0, 0.17, 1)": self = .easeInOutQuint
        case "cubic-bezier(0.7, 0, 0.84, 0)": self = .easeInExpo
        case "cubic-bezier(0.16, 1, 0.3, 1)": self = .easeOutExpo
        case "cubic-bezier(0.87, 0, 0.13, 1)": self = .easeInOutExpo
        case "cubic-bezier(0.55, 0, 1, 0.45)": self = .easeInCirc
        case "cubic-bezier(0, 0.55, 0.45, 1)": self = .easeOutCirc
        case "cubic-bezier(0.85, 0, 0.15, 1)": self = .easeInOutCirc
        case "cubic-bezier(0.36, 0, 0.66, -0.56)": self = .easeInBack
        case "cubic-bezier(0.34, 1.56, 0.64, 1)": self = .easeOutBack
        case "cubic-bezier(0.68, -0.6, 0.32, 1.6)": self = .easeInOutBack
        default: 
            if rawValue.hasPrefix("cubic-bezier(") {
                self = .custom(rawValue)
            } else {
                return nil
            }
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