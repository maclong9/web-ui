import Foundation

/// Utility for creating and managing complex animation sequences
///
/// `AnimationSequence` provides advanced sequencing capabilities beyond
/// the basic AnimationBuilder, including timeline management, conditional
/// animations, and advanced synchronization.
///
/// ## Usage
///
/// ```swift
/// let sequence = AnimationSequence()
///     .add(fadeIn, at: 0.0)
///     .add(slideIn, at: 0.2)
///     .add(scaleUp, at: 0.4)
///     .build()
/// ```
public class AnimationSequenceBuilder {
    private var steps: [AnimationStep] = []
    private var currentTime: TimeInterval = 0
    
    public init() {}
    
    /// Adds an animation at a specific time
    /// - Parameters:
    ///   - animation: Animation to add
    ///   - time: Start time in seconds
    /// - Returns: Self for chaining
    @discardableResult
    public func add(_ animation: Animation, at time: TimeInterval) -> Self {
        steps.append(AnimationStep(animation: animation, startTime: time))
        return self
    }
    
    /// Adds an animation after the current time
    /// - Parameter animation: Animation to add
    /// - Returns: Self for chaining
    @discardableResult
    public func then(_ animation: Animation) -> Self {
        steps.append(AnimationStep(animation: animation, startTime: currentTime))
        currentTime += animation.duration
        return self
    }
    
    /// Adds an animation concurrently with the last animation
    /// - Parameter animation: Animation to add
    /// - Returns: Self for chaining
    @discardableResult
    public func with(_ animation: Animation) -> Self {
        let lastStartTime = steps.last?.startTime ?? 0
        steps.append(AnimationStep(animation: animation, startTime: lastStartTime))
        return self
    }
    
    /// Adds a delay to the sequence
    /// - Parameter duration: Delay duration in seconds
    /// - Returns: Self for chaining
    @discardableResult
    public func wait(_ duration: TimeInterval) -> Self {
        currentTime += duration
        return self
    }
    
    /// Adds multiple animations with staggered start times
    /// - Parameters:
    ///   - animations: Animations to stagger
    ///   - stagger: Delay between each animation start
    /// - Returns: Self for chaining
    @discardableResult
    public func stagger(_ animations: [Animation], by stagger: TimeInterval) -> Self {
        for (index, animation) in animations.enumerated() {
            let startTime = currentTime + (Double(index) * stagger)
            steps.append(AnimationStep(animation: animation, startTime: startTime))
        }
        currentTime += (Double(animations.count - 1) * stagger) + (animations.last?.duration ?? 0)
        return self
    }
    
    /// Builds the final animation sequence
    /// - Returns: Built animation sequence
    public func build() -> BuiltAnimationSequence {
        BuiltAnimationSequence(steps: steps)
    }
}

/// A step in an animation sequence
internal struct AnimationStep: Sendable {
    let animation: Animation
    let startTime: TimeInterval
}

/// A complete animation sequence ready for execution
public struct BuiltAnimationSequence: Animation {
    private let steps: [AnimationStep]
    
    internal init(steps: [AnimationStep]) {
        self.steps = steps
    }
    
    public var duration: TimeInterval {
        guard !steps.isEmpty else { return 0 }
        
        return steps.map { step in
            step.startTime + step.animation.duration
        }.max() ?? 0
    }
    
    public var timing: AnimationTiming {
        AnimationTiming(duration: duration, easing: .ease)
    }
    
    public var properties: [AnimationProperty] {
        steps.flatMap { $0.animation.properties }
    }
    
    public func generateCSS(for element: String) -> String {
        var css = ""
        
        for (index, step) in steps.enumerated() {
            let stepClass = "\(element.dropFirst())-step-\(index)"
            let delayedTiming = step.animation.timing.delayed(by: step.startTime)
            
            // Generate keyframes for this step
            css += step.animation.generateCSS(for: ".\(stepClass)")
            css += "\n"
        }
        
        // Combine all steps into a single animation
        let stepClasses = steps.enumerated().map { index, _ in
            "\(element.dropFirst())-step-\(index)"
        }.joined(separator: " ")
        
        css += "\(element) {\n"
        css += "  animation: \(stepClasses);\n"
        css += "}\n"
        
        return css
    }
}

// MARK: - Conditional Animations

/// Represents a conditional animation that can be enabled or disabled
public struct ConditionalAnimation: Animation {
    private let animation: Animation
    private let condition: () -> Bool
    
    public init(_ animation: Animation, when condition: @escaping () -> Bool) {
        self.animation = animation
        self.condition = condition
    }
    
    public var duration: TimeInterval {
        condition() ? animation.duration : 0
    }
    
    public var timing: AnimationTiming {
        condition() ? animation.timing : AnimationTiming(duration: 0)
    }
    
    public var properties: [AnimationProperty] {
        condition() ? animation.properties : []
    }
    
    public func generateCSS(for element: String) -> String {
        condition() ? animation.generateCSS(for: element) : ""
    }
}

// MARK: - Animation State Machine

/// Manages different animation states and transitions
public class AnimationStateMachine {
    public enum State {
        case idle
        case animating(Animation)
        case paused(Animation, TimeInterval) // animation and pause time
        case completed
    }
    
    private var currentState: State = .idle
    private var stateChangeHandlers: [(State) -> Void] = []
    
    public var state: State {
        currentState
    }
    
    public init() {}
    
    /// Starts an animation
    /// - Parameter animation: Animation to start
    public func start(_ animation: Animation) {
        transition(to: .animating(animation))
    }
    
    /// Pauses the current animation
    public func pause() {
        switch currentState {
        case .animating(let animation):
            transition(to: .paused(animation, 0)) // TODO: Calculate actual pause time
        default:
            break
        }
    }
    
    /// Resumes a paused animation
    public func resume() {
        switch currentState {
        case .paused(let animation, _):
            transition(to: .animating(animation))
        default:
            break
        }
    }
    
    /// Stops the current animation
    public func stop() {
        transition(to: .idle)
    }
    
    /// Completes the current animation
    public func complete() {
        transition(to: .completed)
    }
    
    /// Adds a handler for state changes
    /// - Parameter handler: Handler to call on state changes
    public func onStateChange(_ handler: @escaping (State) -> Void) {
        stateChangeHandlers.append(handler)
    }
    
    private func transition(to newState: State) {
        currentState = newState
        stateChangeHandlers.forEach { $0(newState) }
    }
}

// MARK: - Timeline Animation

/// Represents a timeline-based animation with keyframes at specific times
public struct TimelineAnimation: Animation {
    private let keyframes: [TimelineKeyframe]
    private let totalDuration: TimeInterval
    
    public struct TimelineKeyframe {
        let time: TimeInterval // 0.0 to 1.0
        let properties: [AnimationProperty]
        
        public init(at time: TimeInterval, properties: [AnimationProperty]) {
            self.time = max(0, min(1, time))
            self.properties = properties
        }
    }
    
    public init(duration: TimeInterval, keyframes: [TimelineKeyframe]) {
        self.totalDuration = duration
        self.keyframes = keyframes.sorted { $0.time < $1.time }
    }
    
    public var duration: TimeInterval {
        totalDuration
    }
    
    public var timing: AnimationTiming {
        AnimationTiming(duration: totalDuration, easing: .linear)
    }
    
    public var properties: [AnimationProperty] {
        Array(Set(keyframes.flatMap(\.properties).map(\.cssProperty))).map { property in
            .custom(property: property, value: "")
        }
    }
    
    public func generateCSS(for element: String) -> String {
        let animationName = "\(element.dropFirst())-timeline"
        
        var css = "@keyframes \(animationName) {\n"
        
        for keyframe in keyframes {
            let percentage = Int(keyframe.time * 100)
            css += "  \(percentage)% {\n"
            
            for property in keyframe.properties {
                css += "    \(property.cssDeclaration)\n"
            }
            
            css += "  }\n"
        }
        
        css += "}\n\n"
        css += "\(element) {\n"
        css += "  animation: \(animationName) \(timing.cssValue);\n"
        css += "}\n"
        
        return css
    }
}

// MARK: - Easing Preview Generator

/// Utility for generating CSS animations that demonstrate easing curves
public struct EasingPreview {
    public static func generateDemo(easing: EasingFunction, duration: TimeInterval = 2.0) -> String {
        let demoHTML = """
        <div class="easing-demo">
            <div class="ball \(easing.rawValue.replacingOccurrences(of: " ", with: "-"))"></div>
            <p>\(easing.rawValue)</p>
        </div>
        """
        
        let demoCSS = """
        <style>
        .easing-demo {
            width: 300px;
            height: 60px;
            border: 1px solid #ccc;
            position: relative;
            margin: 10px 0;
        }
        
        .ball {
            width: 20px;
            height: 20px;
            background: #3498db;
            border-radius: 50%;
            position: absolute;
            top: 20px;
            left: 0;
            animation: move-\(easing.rawValue.replacingOccurrences(of: " ", with: "-")) \(duration)s infinite;
        }
        
        @keyframes move-\(easing.rawValue.replacingOccurrences(of: " ", with: "-")) {
            0% { left: 0; }
            50% { left: 260px; }
            100% { left: 0; }
        }
        
        .ball.\(easing.rawValue.replacingOccurrences(of: " ", with: "-")) {
            animation-timing-function: \(easing.rawValue);
        }
        </style>
        """
        
        return demoCSS + demoHTML
    }
}