import Foundation

/// Result builder for composing animations in a SwiftUI-like syntax
///
/// `AnimationBuilder` enables declarative composition of multiple animations
/// using a clean, readable syntax similar to SwiftUI's view builders.
///
/// ## Usage
///
/// ```swift
/// @AnimationBuilder
/// var complexAnimation: [Animation] {
///     FadeInAnimation(duration: 0.5)
///     SlideInAnimation(direction: .fromLeft, duration: 0.3)
///     ScaleAnimation(from: 0.8, to: 1.0, duration: 0.4)
/// }
/// ```
@resultBuilder
public struct AnimationBuilder {
    
    /// Builds an array of animations from a single animation
    public static func buildBlock(_ animation: Animation) -> [Animation] {
        [animation]
    }
    
    /// Builds an array of animations from multiple animations
    public static func buildBlock(_ animations: Animation...) -> [Animation] {
        animations
    }
    
    /// Builds an array of animations from variadic animations
    public static func buildArray(_ components: [[Animation]]) -> [Animation] {
        components.flatMap { $0 }
    }
    
    /// Handles conditional animations with if statements
    public static func buildOptional(_ component: [Animation]?) -> [Animation] {
        component ?? []
    }
    
    /// Handles the first branch of conditional animations
    public static func buildEither(first component: [Animation]) -> [Animation] {
        component
    }
    
    /// Handles the second branch of conditional animations
    public static func buildEither(second component: [Animation]) -> [Animation] {
        component
    }
    
    /// Handles loops and repeated animations
    public static func buildArray(_ components: [Animation]) -> [Animation] {
        components
    }
    
    /// Builds an empty animation array
    public static func buildBlock() -> [Animation] {
        []
    }
}

// MARK: - Animation Sequence

/// A sequence of animations that can be executed in order or concurrently
public struct AnimationSequence: Animation {
    private let animations: [Animation]
    private let sequenceType: SequenceType
    
    public enum SequenceType: Sendable {
        case sequential  // Animations play one after another
        case concurrent  // Animations play at the same time
        case staggered(TimeInterval)  // Animations start with a delay between each
    }
    
    public init(_ sequenceType: SequenceType, @AnimationBuilder animations: () -> [Animation]) {
        self.sequenceType = sequenceType
        self.animations = animations()
    }
    
    public var duration: TimeInterval {
        switch sequenceType {
        case .sequential:
            return animations.reduce(0) { $0 + $1.duration }
        case .concurrent:
            return animations.map(\.duration).max() ?? 0
        case .staggered(let delay):
            let maxDuration = animations.map(\.duration).max() ?? 0
            let totalDelay = Double(animations.count - 1) * delay
            return maxDuration + totalDelay
        }
    }
    
    public var timing: AnimationTiming {
        let avgDuration = duration
        let commonEasing: EasingFunction
        
        // Try to find a common easing, default to ease-out
        let easings = animations.map(\.timing.easing.rawValue)
        if Set(easings).count == 1, let first = easings.first {
            commonEasing = EasingFunction(rawValue: first) ?? .easeOut
        } else {
            commonEasing = .easeOut
        }
        
        return AnimationTiming(duration: avgDuration, easing: commonEasing)
    }
    
    public var properties: [AnimationProperty] {
        animations.flatMap(\.properties)
    }
    
    public func generateCSS(for element: String) -> String {
        switch sequenceType {
        case .sequential:
            return generateSequentialCSS(for: element)
        case .concurrent:
            return generateConcurrentCSS(for: element)
        case .staggered(let delay):
            return generateStaggeredCSS(for: element, delay: delay)
        }
    }
    
    private func generateSequentialCSS(for element: String) -> String {
        var css = ""
        var currentDelay: TimeInterval = 0
        
        for (index, animation) in animations.enumerated() {
            let animationName = "\(element.dropFirst())-seq-\(index)"
            let timing = animation.timing.delayed(by: currentDelay)
            
            css += animation.generateCSS(for: ".\(animationName)")
            css += "\n"
            
            currentDelay += animation.duration
        }
        
        // Apply all animation classes to the element
        let animationClasses = animations.enumerated().map { index, _ in
            "\(element.dropFirst())-seq-\(index)"
        }.joined(separator: " ")
        
        css += "\(element) {\n"
        css += "  animation-name: \(animationClasses);\n"
        css += "}\n"
        
        return css
    }
    
    private func generateConcurrentCSS(for element: String) -> String {
        var css = ""
        
        for (index, animation) in animations.enumerated() {
            let animationName = "\(element.dropFirst())-conc-\(index)"
            css += animation.generateCSS(for: ".\(animationName)")
            css += "\n"
        }
        
        return css
    }
    
    private func generateStaggeredCSS(for element: String, delay: TimeInterval) -> String {
        var css = ""
        
        for (index, animation) in animations.enumerated() {
            let staggerDelay = Double(index) * delay
            let timing = animation.timing.delayed(by: staggerDelay)
            let animationName = "\(element.dropFirst())-stagger-\(index)"
            
            css += animation.generateCSS(for: ".\(animationName)")
            css += "\n"
        }
        
        return css
    }
}

// MARK: - Animation Group

/// Groups animations for easier management and composition
public struct AnimationGroup {
    public let name: String
    private let animations: [Animation]
    
    public init(name: String, @AnimationBuilder animations: () -> [Animation]) {
        self.name = name
        self.animations = animations()
    }
    
    /// Creates a sequential animation sequence from this group
    public func asSequence() -> AnimationSequence {
        AnimationSequence(.sequential) {
            for animation in animations {
                animation
            }
        }
    }
    
    /// Creates a concurrent animation sequence from this group
    public func asConcurrent() -> AnimationSequence {
        AnimationSequence(.concurrent) {
            for animation in animations {
                animation
            }
        }
    }
    
    /// Creates a staggered animation sequence from this group
    /// - Parameter delay: Delay between each animation start
    /// - Returns: Staggered animation sequence
    public func asStaggered(delay: TimeInterval) -> AnimationSequence {
        AnimationSequence(.staggered(delay)) {
            for animation in animations {
                animation
            }
        }
    }
}

// MARK: - Animation Modifiers

extension Animation {
    /// Delays this animation by the specified amount
    /// - Parameter delay: Delay in seconds
    /// - Returns: New animation with delay applied
    public func delayed(by delay: TimeInterval) -> DelayedAnimation {
        DelayedAnimation(animation: self, delay: delay)
    }
    
    /// Repeats this animation the specified number of times
    /// - Parameter count: Number of repetitions
    /// - Returns: New animation with repetition applied
    public func repeated(_ count: Int) -> RepeatedAnimation {
        RepeatedAnimation(animation: self, count: count)
    }
    
    /// Makes this animation repeat infinitely
    /// - Returns: New animation that repeats forever
    public func repeatedForever() -> RepeatedAnimation {
        RepeatedAnimation(animation: self, infinite: true)
    }
    
    /// Changes the easing function of this animation
    /// - Parameter easing: New easing function
    /// - Returns: New animation with updated easing
    public func easing(_ easing: EasingFunction) -> EasingModifiedAnimation {
        EasingModifiedAnimation(animation: self, easing: easing)
    }
    
    /// Changes the duration of this animation
    /// - Parameter duration: New duration in seconds
    /// - Returns: New animation with updated duration
    public func duration(_ duration: TimeInterval) -> DurationModifiedAnimation {
        DurationModifiedAnimation(animation: self, duration: duration)
    }
}

// MARK: - Animation Modifier Implementations

/// Animation wrapper that adds delay
public struct DelayedAnimation: Animation {
    private let animation: Animation
    private let additionalDelay: TimeInterval
    
    init(animation: Animation, delay: TimeInterval) {
        self.animation = animation
        self.additionalDelay = delay
    }
    
    public var duration: TimeInterval {
        animation.duration
    }
    
    public var timing: AnimationTiming {
        animation.timing.delayed(by: additionalDelay)
    }
    
    public var properties: [AnimationProperty] {
        animation.properties
    }
    
    public func generateCSS(for element: String) -> String {
        animation.generateCSS(for: element)
    }
}

/// Animation wrapper that adds repetition
public struct RepeatedAnimation: Animation {
    private let animation: Animation
    private let iterationCount: AnimationIterationCount
    
    init(animation: Animation, count: Int) {
        self.animation = animation
        self.iterationCount = .finite(count)
    }
    
    init(animation: Animation, infinite: Bool) {
        self.animation = animation
        self.iterationCount = .infinite
    }
    
    public var duration: TimeInterval {
        switch iterationCount {
        case .finite(let count):
            return animation.duration * Double(count)
        case .infinite:
            return .infinity
        }
    }
    
    public var timing: AnimationTiming {
        AnimationTiming(
            duration: animation.timing.duration,
            delay: animation.timing.delay,
            easing: animation.timing.easing,
            iterationCount: iterationCount,
            direction: animation.timing.direction,
            fillMode: animation.timing.fillMode,
            playState: animation.timing.playState
        )
    }
    
    public var properties: [AnimationProperty] {
        animation.properties
    }
    
    public func generateCSS(for element: String) -> String {
        animation.generateCSS(for: element)
    }
}

/// Animation wrapper that modifies easing
public struct EasingModifiedAnimation: Animation {
    private let animation: Animation
    private let newEasing: EasingFunction
    
    init(animation: Animation, easing: EasingFunction) {
        self.animation = animation
        self.newEasing = easing
    }
    
    public var duration: TimeInterval {
        animation.duration
    }
    
    public var timing: AnimationTiming {
        animation.timing.withEasing(newEasing)
    }
    
    public var properties: [AnimationProperty] {
        animation.properties
    }
    
    public func generateCSS(for element: String) -> String {
        animation.generateCSS(for: element)
    }
}

/// Animation wrapper that modifies duration
public struct DurationModifiedAnimation: Animation {
    private let animation: Animation
    private let newDuration: TimeInterval
    
    init(animation: Animation, duration: TimeInterval) {
        self.animation = animation
        self.newDuration = duration
    }
    
    public var duration: TimeInterval {
        newDuration
    }
    
    public var timing: AnimationTiming {
        animation.timing.withDuration(newDuration)
    }
    
    public var properties: [AnimationProperty] {
        animation.properties
    }
    
    public func generateCSS(for element: String) -> String {
        animation.generateCSS(for: element)
    }
}