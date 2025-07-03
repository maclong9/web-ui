import Foundation

/// Core animation protocol for WebUI animations
///
/// `Animation` defines the interface for all animation implementations in WebUI.
/// It provides a unified way to describe animations that can be converted to CSS
/// and applied to HTML elements.
///
/// ## Usage
///
/// ```swift
/// struct CustomFade: Animation {
///     let duration: TimeInterval
///     
///     var timing: AnimationTiming {
///         AnimationTiming(duration: duration, easing: .easeOut)
///     }
///     
///     var properties: [AnimationProperty] {
///         [.opacity(1.0)]
///     }
///     
///     func generateCSS(for element: String) -> String {
///         "@keyframes fade { from { opacity: 0; } to { opacity: 1; } }"
///     }
/// }
/// ```
public protocol Animation: Sendable {
    /// The duration of the animation in seconds
    var duration: TimeInterval { get }
    
    /// Animation timing configuration including easing and delay
    var timing: AnimationTiming { get }
    
    /// Properties that this animation affects
    var properties: [AnimationProperty] { get }
    
    /// Generates CSS for this animation
    /// - Parameter element: CSS selector for the target element
    /// - Returns: CSS string containing keyframes and animation rules
    func generateCSS(for element: String) -> String
}

// MARK: - Animation State

/// Represents the current state of an animation
public enum AnimationState: Sendable {
    case idle
    case running
    case paused
    case finished
}

// MARK: - Animation Options

/// Configuration options for animations
public struct AnimationOptions: Sendable {
    public let fillMode: AnimationFillMode
    public let iterationCount: AnimationIterationCount
    public let direction: AnimationDirection
    public let playState: AnimationPlayState
    
    public init(
        fillMode: AnimationFillMode = .none,
        iterationCount: AnimationIterationCount = .finite(1),
        direction: AnimationDirection = .normal,
        playState: AnimationPlayState = .running
    ) {
        self.fillMode = fillMode
        self.iterationCount = iterationCount
        self.direction = direction
        self.playState = playState
    }
    
    public static let `default` = AnimationOptions()
}

/// Determines how an animation applies styles before and after execution
public enum AnimationFillMode: String, Sendable {
    /// Animation does not apply any styles before or after execution
    case none = "none"
    /// Animation retains the styles of the last keyframe after execution
    case forwards = "forwards"
    /// Animation applies the styles of the first keyframe before execution
    case backwards = "backwards"
    /// Animation applies both forwards and backwards behavior
    case both = "both"
}

/// Specifies how many times an animation should run
public enum AnimationIterationCount: Sendable {
    case finite(Int)
    case infinite
    
    var cssValue: String {
        switch self {
        case .finite(let count):
            return "\(count)"
        case .infinite:
            return "infinite"
        }
    }
}

/// Defines the direction of animation execution
public enum AnimationDirection: String, Sendable {
    /// Animation plays forward each iteration
    case normal = "normal"
    /// Animation plays backward each iteration
    case reverse = "reverse"
    /// Animation alternates between forward and backward
    case alternate = "alternate"
    /// Animation alternates, starting backward
    case alternateReverse = "alternate-reverse"
}

/// Controls whether an animation is running or paused
public enum AnimationPlayState: String, Sendable {
    case running = "running"
    case paused = "paused"
}

// MARK: - Default Implementation

extension Animation {
    /// Default duration of 0.3 seconds
    public var duration: TimeInterval {
        0.3
    }
    
    /// Default timing with ease-out easing
    public var timing: AnimationTiming {
        AnimationTiming(duration: duration, easing: .easeOut)
    }
}