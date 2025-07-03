import Foundation

/// Animation integration extensions for Markup and Element protocols
///
/// These extensions provide a SwiftUI-like API for adding animations to WebUI components.
/// They generate CSS animations and transitions that are automatically included in the
/// component's rendered output.
///
/// ## Usage
///
/// ```swift
/// Text("Hello World")
///     .fadeIn(duration: 0.5)
///     .slideIn(.fromLeft, duration: 0.3, delay: 0.1)
///     .transition(.opacity, duration: 0.2)
/// ```

// MARK: - Animation Extensions for Markup

extension Markup {
    
    /// Adds a fade-in animation to the element
    /// - Parameters:
    ///   - duration: Animation duration in seconds
    ///   - delay: Animation delay in seconds
    ///   - easing: Easing function for the animation
    /// - Returns: The element with fade-in animation applied
    public func fadeIn(
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        easing: EasingFunction = .easeOut
    ) -> some Markup {
        let animation = FadeInAnimation(
            duration: duration,
            delay: delay,
            easing: easing
        )
        return AnimatedMarkup(content: self, animations: [animation])
    }
    
    /// Adds a fade-out animation to the element
    /// - Parameters:
    ///   - duration: Animation duration in seconds
    ///   - delay: Animation delay in seconds
    ///   - easing: Easing function for the animation
    /// - Returns: The element with fade-out animation applied
    public func fadeOut(
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        easing: EasingFunction = .easeIn
    ) -> some Markup {
        let animation = FadeOutAnimation(
            duration: duration,
            delay: delay,
            easing: easing
        )
        return AnimatedMarkup(content: self, animations: [animation])
    }
    
    /// Adds a slide-in animation to the element
    /// - Parameters:
    ///   - direction: Direction to slide in from
    ///   - duration: Animation duration in seconds
    ///   - delay: Animation delay in seconds
    ///   - distance: Distance to slide (in pixels)
    ///   - easing: Easing function for the animation
    /// - Returns: The element with slide-in animation applied
    public func slideIn(
        _ direction: SlideDirection = .fromBottom,
        duration: TimeInterval = 0.5,
        delay: TimeInterval = 0,
        distance: Double = 100,
        easing: EasingFunction = .easeOut
    ) -> some Markup {
        let animation = SlideInAnimation(
            direction: direction,
            duration: duration,
            delay: delay,
            distance: distance,
            easing: easing
        )
        return AnimatedMarkup(content: self, animations: [animation])
    }
    
    /// Adds a scale animation to the element
    /// - Parameters:
    ///   - from: Starting scale (1.0 = normal size)
    ///   - to: Ending scale (1.0 = normal size)
    ///   - duration: Animation duration in seconds
    ///   - delay: Animation delay in seconds
    ///   - easing: Easing function for the animation
    /// - Returns: The element with scale animation applied
    public func scale(
        from: Double = 0,
        to: Double = 1,
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        easing: EasingFunction = .easeOut
    ) -> some Markup {
        let animation = ScaleAnimation(
            from: from,
            to: to,
            duration: duration,
            delay: delay,
            easing: easing
        )
        return AnimatedMarkup(content: self, animations: [animation])
    }
    
    /// Adds a rotate animation to the element
    /// - Parameters:
    ///   - from: Starting rotation in degrees
    ///   - to: Ending rotation in degrees
    ///   - duration: Animation duration in seconds
    ///   - delay: Animation delay in seconds
    ///   - easing: Easing function for the animation
    /// - Returns: The element with rotation animation applied
    public func rotate(
        from: Double = 0,
        to: Double = 360,
        duration: TimeInterval = 1.0,
        delay: TimeInterval = 0,
        easing: EasingFunction = .linear
    ) -> some Markup {
        let animation = RotateAnimation(
            from: from,
            to: to,
            duration: duration,
            delay: delay,
            easing: easing
        )
        return AnimatedMarkup(content: self, animations: [animation])
    }
    
    /// Adds a CSS transition to the element for hover and state changes
    /// - Parameters:
    ///   - properties: Properties to transition
    ///   - duration: Transition duration in seconds
    ///   - easing: Easing function for the transition
    /// - Returns: The element with transition applied
    public func animationTransition(
        _ properties: [AnimationTransitionProperty],
        duration: TimeInterval = 0.2,
        easing: EasingFunction = .ease
    ) -> some Markup {
        let animation = TransitionAnimation(
            properties: properties,
            duration: duration,
            easing: easing
        )
        return AnimatedMarkup(content: self, animations: [animation])
    }
    
    /// Adds a transition for a single property
    /// - Parameters:
    ///   - property: Property to transition
    ///   - duration: Transition duration in seconds
    ///   - easing: Easing function for the transition
    /// - Returns: The element with transition applied
    public func animationTransition(
        _ property: AnimationTransitionProperty,
        duration: TimeInterval = 0.2,
        easing: EasingFunction = .ease
    ) -> some Markup {
        animationTransition([property], duration: duration, easing: easing)
    }
    
    /// Adds a custom animation to the element
    /// - Parameter animation: Custom animation to apply
    /// - Returns: The element with custom animation applied
    public func animated(_ animation: Animation) -> some Markup {
        AnimatedMarkup(content: self, animations: [animation])
    }
    
    /// Adds multiple animations to the element
    /// - Parameter animations: Array of animations to apply
    /// - Returns: The element with all animations applied
    public func animated(_ animations: [Animation]) -> some Markup {
        AnimatedMarkup(content: self, animations: animations)
    }
}

// MARK: - Animated Markup Container

/// A container that applies animations to markup content
public struct AnimatedMarkup<Content: Markup>: Markup {
    private let content: Content
    private let animations: [Animation]
    
    public init(content: Content, animations: [Animation]) {
        self.content = content
        self.animations = animations
    }
    
    public var body: MarkupString {
        MarkupString(content: renderWithAnimations())
    }
    
    private func renderWithAnimations() -> String {
        guard !animations.isEmpty else {
            return content.render()
        }
        
        let renderedContent = content.render()
        let animationId = generateAnimationId()
        
        // Generate CSS for animations
        let css = generateAnimationCSS(for: animationId)
        
        // Apply animation classes to the content
        let animationClasses = animations.enumerated().map { index, _ in
            "\(animationId)-animation-\(index)"
        }
        
        let animatedContent = applyAnimationClasses(to: renderedContent, classes: animationClasses)
        
        return css + animatedContent
    }
    
    private func generateAnimationId() -> String {
        "webui-anim-\(UUID().uuidString.prefix(8))"
    }
    
    private func generateAnimationCSS(for id: String) -> String {
        var css = "<style>\n"
        
        for (index, animation) in animations.enumerated() {
            let className = ".\(id)-animation-\(index)"
            css += animation.generateCSS(for: className)
            css += "\n"
        }
        
        css += "</style>\n"
        return css
    }
    
    private func applyAnimationClasses(to content: String, classes: [String]) -> String {
        guard !classes.isEmpty else { return content }
        
        // Check if content starts with a markup tag
        guard let tagRange = content.range(of: "<[^>]+>", options: .regularExpression) else {
            // If not, wrap the content in a span with the classes
            return "<span class=\"\(classes.joined(separator: " "))\"> \(content)</span>"
        }
        
        // Extract the tag
        let tag = content[tagRange]
        let tagString = String(tag)
        
        // Check if the tag already has a class attribute
        if tagString.contains(" class=\"") {
            // Add to existing classes
            guard let classStart = tagString.range(of: " class=\""),
                  let classEnd = tagString.range(of: "\"", range: classStart.upperBound..<tagString.endIndex) else {
                return content
            }
            
            let existingClasses = String(tagString[classStart.upperBound..<classEnd.lowerBound])
            let allClasses = existingClasses.isEmpty 
                ? classes.joined(separator: " ")
                : "\(existingClasses) \(classes.joined(separator: " "))"
            
            let modifiedTag = tagString.replacingCharacters(
                in: classStart.upperBound..<classEnd.lowerBound,
                with: allClasses
            )
            
            return content.replacingCharacters(in: tagRange, with: modifiedTag)
        } else {
            // Insert a class attribute before the closing >
            let modifiedTag = tagString.replacingOccurrences(
                of: ">$",
                with: " class=\"\(classes.joined(separator: " "))\">",
                options: .regularExpression
            )
            
            return content.replacingCharacters(in: tagRange, with: modifiedTag)
        }
    }
}

// MARK: - Predefined Animations

/// Slide direction for slide animations
public enum SlideDirection: Sendable {
    case fromLeft
    case fromRight
    case fromTop
    case fromBottom
}

/// Animation transition property for CSS transitions
public enum AnimationTransitionProperty: String, Sendable {
    case opacity = "opacity"
    case transform = "transform"
    case backgroundColor = "background-color"
    case color = "color"
    case width = "width"
    case height = "height"
    case padding = "padding"
    case margin = "margin"
    case borderRadius = "border-radius"
    case boxShadow = "box-shadow"
    case all = "all"
}

// MARK: - Predefined Animation Implementations

/// Fade-in animation implementation
public struct FadeInAnimation: Animation {
    public let duration: TimeInterval
    public let delay: TimeInterval
    public let easing: EasingFunction
    
    public init(duration: TimeInterval, delay: TimeInterval = 0, easing: EasingFunction = .easeOut) {
        self.duration = duration
        self.delay = delay
        self.easing = easing
    }
    
    public var timing: AnimationTiming {
        AnimationTiming(
            duration: duration,
            delay: delay,
            easing: easing,
            fillMode: .both
        )
    }
    
    public var properties: [AnimationProperty] {
        [.opacity(1.0)]
    }
    
    public func generateCSS(for element: String) -> String {
        """
        @keyframes \(element.dropFirst())-fadein {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        \(element) {
            animation: \(element.dropFirst())-fadein \(timing.cssValue);
        }
        """
    }
}

/// Fade-out animation implementation
public struct FadeOutAnimation: Animation {
    public let duration: TimeInterval
    public let delay: TimeInterval
    public let easing: EasingFunction
    
    public init(duration: TimeInterval, delay: TimeInterval = 0, easing: EasingFunction = .easeIn) {
        self.duration = duration
        self.delay = delay
        self.easing = easing
    }
    
    public var timing: AnimationTiming {
        AnimationTiming(
            duration: duration,
            delay: delay,
            easing: easing,
            fillMode: .both
        )
    }
    
    public var properties: [AnimationProperty] {
        [.opacity(0.0)]
    }
    
    public func generateCSS(for element: String) -> String {
        """
        @keyframes \(element.dropFirst())-fadeout {
            from { opacity: 1; }
            to { opacity: 0; }
        }
        
        \(element) {
            animation: \(element.dropFirst())-fadeout \(timing.cssValue);
        }
        """
    }
}

/// Slide-in animation implementation
public struct SlideInAnimation: Animation {
    public let direction: SlideDirection
    public let duration: TimeInterval
    public let delay: TimeInterval
    public let distance: Double
    public let easing: EasingFunction
    
    public init(
        direction: SlideDirection,
        duration: TimeInterval,
        delay: TimeInterval = 0,
        distance: Double = 100,
        easing: EasingFunction = .easeOut
    ) {
        self.direction = direction
        self.duration = duration
        self.delay = delay
        self.distance = distance
        self.easing = easing
    }
    
    public var timing: AnimationTiming {
        AnimationTiming(
            duration: duration,
            delay: delay,
            easing: easing,
            fillMode: .both
        )
    }
    
    public var properties: [AnimationProperty] {
        [.transform(.translate(x: 0, y: 0))]
    }
    
    public func generateCSS(for element: String) -> String {
        let (fromTransform, toTransform) = getTransforms()
        
        return """
        @keyframes \(element.dropFirst())-slidein {
            from { transform: \(fromTransform); opacity: 0; }
            to { transform: \(toTransform); opacity: 1; }
        }
        
        \(element) {
            animation: \(element.dropFirst())-slidein \(timing.cssValue);
        }
        """
    }
    
    private func getTransforms() -> (String, String) {
        switch direction {
        case .fromLeft:
            return ("translateX(-\(distance)px)", "translateX(0)")
        case .fromRight:
            return ("translateX(\(distance)px)", "translateX(0)")
        case .fromTop:
            return ("translateY(-\(distance)px)", "translateY(0)")
        case .fromBottom:
            return ("translateY(\(distance)px)", "translateY(0)")
        }
    }
}

/// Scale animation implementation
public struct ScaleAnimation: Animation {
    public let fromScale: Double
    public let toScale: Double
    public let duration: TimeInterval
    public let delay: TimeInterval
    public let easing: EasingFunction
    
    public init(
        from: Double,
        to: Double,
        duration: TimeInterval,
        delay: TimeInterval = 0,
        easing: EasingFunction = .easeOut
    ) {
        self.fromScale = from
        self.toScale = to
        self.duration = duration
        self.delay = delay
        self.easing = easing
    }
    
    public var timing: AnimationTiming {
        AnimationTiming(
            duration: duration,
            delay: delay,
            easing: easing,
            fillMode: .both
        )
    }
    
    public var properties: [AnimationProperty] {
        [.transform(.scale(toScale))]
    }
    
    public func generateCSS(for element: String) -> String {
        """
        @keyframes \(element.dropFirst())-scale {
            from { transform: scale(\(fromScale)); }
            to { transform: scale(\(toScale)); }
        }
        
        \(element) {
            animation: \(element.dropFirst())-scale \(timing.cssValue);
        }
        """
    }
}

/// Rotate animation implementation
public struct RotateAnimation: Animation {
    public let fromRotation: Double
    public let toRotation: Double
    public let duration: TimeInterval
    public let delay: TimeInterval
    public let easing: EasingFunction
    
    public init(
        from: Double,
        to: Double,
        duration: TimeInterval,
        delay: TimeInterval = 0,
        easing: EasingFunction = .linear
    ) {
        self.fromRotation = from
        self.toRotation = to
        self.duration = duration
        self.delay = delay
        self.easing = easing
    }
    
    public var timing: AnimationTiming {
        AnimationTiming(
            duration: duration,
            delay: delay,
            easing: easing,
            fillMode: .both
        )
    }
    
    public var properties: [AnimationProperty] {
        [.transform(.rotate(toRotation))]
    }
    
    public func generateCSS(for element: String) -> String {
        """
        @keyframes \(element.dropFirst())-rotate {
            from { transform: rotate(\(fromRotation)deg); }
            to { transform: rotate(\(toRotation)deg); }
        }
        
        \(element) {
            animation: \(element.dropFirst())-rotate \(timing.cssValue);
        }
        """
    }
}

/// Transition animation implementation
public struct TransitionAnimation: Animation {
    public let properties: [AnimationTransitionProperty]
    public let duration: TimeInterval
    public let easing: EasingFunction
    
    public init(
        properties: [AnimationTransitionProperty],
        duration: TimeInterval,
        easing: EasingFunction = .ease
    ) {
        self.properties = properties
        self.duration = duration
        self.easing = easing
    }
    
    public var timing: AnimationTiming {
        AnimationTiming(
            duration: duration,
            easing: easing
        )
    }
    
    public var animationProperties: [AnimationProperty] {
        // Transitions don't use keyframe properties
        []
    }
    
    public func generateCSS(for element: String) -> String {
        let propertyList = properties.map(\.rawValue).joined(separator: ", ")
        let transitionValue = "\(propertyList) \(duration)s \(easing.rawValue)"
        
        return """
        \(element) {
            transition: \(transitionValue);
        }
        """
    }
}