import Foundation

/// Practical examples demonstrating WebUI animation capabilities
///
/// This file showcases common animation patterns and use cases that can be
/// implemented using the WebUI animations framework. Each example shows both
/// simple and advanced usage patterns.
///
/// ## Animation Categories
///
/// - **Entry Animations**: Fade-in, slide-in, scale-in effects
/// - **Interactive Animations**: Hover states, button feedback
/// - **Loading Animations**: Spinners, progress indicators
/// - **Layout Animations**: Accordion, modal, drawer effects
/// - **Scroll Animations**: Reveal effects, parallax scrolling

// MARK: - Entry Animations

/// Hero section with staggered entrance animations
public struct AnimatedHero: Element {
    public let title: String
    public let subtitle: String
    public let buttonText: String
    
    public init(title: String, subtitle: String, buttonText: String = "Get Started") {
        self.title = title
        self.subtitle = subtitle
        self.buttonText = buttonText
    }
    
    public var body: some Markup {
        Stack {
            Heading(.title) { title }
                .fadeIn(duration: 0.8, delay: 0.2)
                .slideIn(.fromTop, duration: 0.6, delay: 0.1)
            
            Text { subtitle }
                .fadeIn(duration: 0.8, delay: 0.5)
                .slideIn(.fromBottom, duration: 0.6, delay: 0.3)
            
            Text(buttonText)
            .scale(from: 0.8, to: 1.0, duration: 0.5, delay: 0.8)
            .fadeIn(duration: 0.6, delay: 0.7)
        }
        .padding(.xlarge)
        .textAlign(.center)
    }
}

/// Card component with hover animations
public struct AnimatedCard: Element {
    public let title: String
    public let content: String
    public let imageSrc: String?
    
    public init(title: String, content: String, imageSrc: String? = nil) {
        self.title = title
        self.content = content
        self.imageSrc = imageSrc
    }
    
    public var body: some Markup {
        Stack {
            if let imageSrc = imageSrc {
                Text("🖼️") // Placeholder for image
                    .scale(from: 1.0, to: 1.05, duration: 0.3)
                    .animationTransition(.transform, duration: 0.3)
            }
            
            Stack {
                Heading(.h3) { title }
                    .animationTransition(.color, duration: 0.2)
                
                Text { content }
                    .animationTransition(.opacity, duration: 0.2)
            }
            .padding(.medium)
        }
        .backgroundColor(.white)
        .rounded(.medium)
        .shadow(.medium)
        .animationTransition([.transform, .boxShadow], duration: 0.3)
        .fadeIn(duration: 0.5)
        .slideIn(.fromBottom, duration: 0.4, distance: 50)
    }
}

// MARK: - Interactive Components

/// Button with comprehensive animation feedback
public struct AnimatedButton: Element {
    public let text: String
    public let style: ButtonStyle
    public let isLoading: Bool
    
    public enum ButtonStyle {
        case primary
        case secondary
        case outline
    }
    
    public init(_ text: String, style: ButtonStyle = .primary, isLoading: Bool = false) {
        self.text = text
        self.style = style
        self.isLoading = isLoading
    }
    
    public var body: some Markup {
        Text {
            if isLoading {
                "⏳ Loading..." // Placeholder for spinner
            } else {
                text
            }
        }
        .padding(.medium)
        .rounded(.medium)
        .animationTransition([.backgroundColor, .transform, .boxShadow], duration: 0.2)
        .scale(from: 1.0, to: 0.95, duration: 0.1) // Press effect
    }
}

/// Loading spinner with rotation animation
public struct LoadingSpinner: Element {
    public let size: SpinnerSize
    
    public enum SpinnerSize {
        case small
        case medium
        case large
        
        var dimension: String {
            switch self {
            case .small: return "16px"
            case .medium: return "24px"
            case .large: return "32px"
            }
        }
    }
    
    public init(size: SpinnerSize = .medium) {
        self.size = size
    }
    
    public var body: some Markup {
        AnimatedDiv {
            ""
        }
        .customWidth(size.dimension)
        .customHeight(size.dimension)
        .customBorder("2px solid #f3f3f3")
        .customBorderTop("2px solid #3498db")
        .rounded(.full)
        .rotate(from: 0, to: 360, duration: 1.0)
        .animated(InfiniteRotation(duration: 1.0))
    }
}

/// Custom infinite rotation animation
public struct InfiniteRotation: Animation {
    public let duration: TimeInterval
    
    public init(duration: TimeInterval = 1.0) {
        self.duration = duration
    }
    
    public var timing: AnimationTiming {
        AnimationTiming(
            duration: duration,
            easing: .linear,
            iterationCount: .infinite
        )
    }
    
    public var properties: [AnimationProperty] {
        [.transform(.rotate(360))]
    }
    
    public func generateCSS(for element: String) -> String {
        """
        @keyframes \(element.dropFirst())-infinite-rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        
        \(element) {
            animation: \(element.dropFirst())-infinite-rotate \(timing.cssValue);
        }
        """
    }
}

// MARK: - Layout Animations

/// Animated accordion component
public struct AnimatedAccordion: Element {
    public let items: [AccordionItem]
    
    public struct AccordionItem {
        public let title: String
        public let content: String
        public let isExpanded: Bool
        
        public init(title: String, content: String, isExpanded: Bool = false) {
            self.title = title
            self.content = content
            self.isExpanded = isExpanded
        }
    }
    
    public init(items: [AccordionItem]) {
        self.items = items
    }
    
    public var body: some Markup {
        Stack {
            // Accordion sections would be dynamically generated in real implementation
            Text("Accordion content placeholder")
        }
        .gap(.small)
    }
}

/// Individual accordion section with expand/collapse animation
public struct AccordionSection: Element {
    public let item: AnimatedAccordion.AccordionItem
    public let index: Int
    
    public init(item: AnimatedAccordion.AccordionItem, index: Int) {
        self.item = item
        self.index = index
    }
    
    public var body: some Markup {
        Stack {
            // Header
            Stack {
                Text(item.title)
                    .fontWeight(.semibold)
                
                Text(item.isExpanded ? "−" : "+")
                    .rotate(
                        from: item.isExpanded ? 0 : 0,
                        to: item.isExpanded ? 180 : 0,
                        duration: 0.3
                    )
            }
            .padding(.medium)
            .backgroundColor(.gray100)
            .animationTransition(.backgroundColor, duration: 0.2)
            
            // Content
            if item.isExpanded {
                Text(item.content)
                    .padding(.medium)
                    .slideIn(.fromTop, duration: 0.3, distance: 20)
                    .fadeIn(duration: 0.3)
            }
        }
        .border("1px solid #e2e8f0")
        .rounded(.medium)
        .addingClasses(["overflow-hidden"])
    }
}

// MARK: - Scroll Animations

/// Content that animates when scrolled into view
public struct ScrollRevealContent: Element {
    public let content: String
    public let animationType: RevealAnimation
    
    public enum RevealAnimation {
        case fadeIn
        case slideUp
        case slideLeft
        case scale
    }
    
    public init(_ content: String, animation: RevealAnimation = .fadeIn) {
        self.content = content
        self.animationType = animation
    }
    
    public var body: some Markup {
        Text(content)
            .animated(ScrollTriggeredAnimation(type: animationType))
    }
}

/// Animation that triggers when element enters viewport
public struct ScrollTriggeredAnimation: Animation {
    public let type: ScrollRevealContent.RevealAnimation
    
    public init(type: ScrollRevealContent.RevealAnimation) {
        self.type = type
    }
    
    public var duration: TimeInterval { 0.6 }
    
    public var timing: AnimationTiming {
        AnimationTiming(
            duration: duration,
            easing: .easeOut
        )
    }
    
    public var properties: [AnimationProperty] {
        switch type {
        case .fadeIn:
            return [.opacity(1.0)]
        case .slideUp:
            return [.transform(.translate(x: 0, y: 0)), .opacity(1.0)]
        case .slideLeft:
            return [.transform(.translate(x: 0, y: 0)), .opacity(1.0)]
        case .scale:
            return [.transform(.scale(1.0)), .opacity(1.0)]
        }
    }
    
    public func generateCSS(for element: String) -> String {
        let animationName = "\(element.dropFirst())-scroll-reveal"
        
        let keyframes: String
        switch type {
        case .fadeIn:
            keyframes = """
            from { opacity: 0; }
            to { opacity: 1; }
            """
        case .slideUp:
            keyframes = """
            from { opacity: 0; transform: translateY(50px); }
            to { opacity: 1; transform: translateY(0); }
            """
        case .slideLeft:
            keyframes = """
            from { opacity: 0; transform: translateX(50px); }
            to { opacity: 1; transform: translateX(0); }
            """
        case .scale:
            keyframes = """
            from { opacity: 0; transform: scale(0.8); }
            to { opacity: 1; transform: scale(1.0); }
            """
        }
        
        return """
        @keyframes \(animationName) {
            \(keyframes)
        }
        
        \(element) {
            opacity: 0;
            animation: \(animationName) \(timing.cssValue);
            animation-fill-mode: forwards;
        }
        
        \(element).in-view {
            animation-play-state: running;
        }
        """
    }
}

// MARK: - Complex Animation Sequences

/// Multi-step animation sequence for feature highlights
public struct FeatureShowcase: Element {
    public let features: [Feature]
    
    public struct Feature {
        public let icon: String
        public let title: String
        public let description: String
        
        public init(icon: String, title: String, description: String) {
            self.icon = icon
            self.title = title
            self.description = description
        }
    }
    
    public init(features: [Feature]) {
        self.features = features
    }
    
    public var body: some Markup {
        Stack {
            // Feature cards would be dynamically generated in real implementation
            Text("Feature showcase placeholder")
        }
        .gap(.large)
        .padding(.xlarge)
    }
}

/// Individual feature card with coordinated animations
public struct FeatureCard: Element {
    public let feature: FeatureShowcase.Feature
    public let animationDelay: TimeInterval
    
    public init(feature: FeatureShowcase.Feature, animationDelay: TimeInterval = 0) {
        self.feature = feature
        self.animationDelay = animationDelay
    }
    
    public var body: some Markup {
        Stack {
            // Icon with bounce effect
            Text(feature.icon)
                .fontSize(.xlarge)
                .scale(from: 0, to: 1.0, duration: 0.6, delay: animationDelay)
                .animated(BounceAnimation(delay: animationDelay + 0.3))
            
            // Title with fade and slide
            Heading(.h3) { feature.title }
                .fadeIn(duration: 0.5, delay: animationDelay + 0.2)
                .slideIn(.fromLeft, duration: 0.4, delay: animationDelay + 0.1, distance: 30)
            
            // Description with delayed fade
            Text(feature.description)
                .fadeIn(duration: 0.5, delay: animationDelay + 0.4)
                .slideIn(.fromRight, duration: 0.4, delay: animationDelay + 0.3, distance: 30)
        }
        .textAlign(.center)
        .padding(.large)
        .backgroundColor(.white)
        .rounded(.large)
        .shadow(.medium)
        .animationTransition([.transform, .boxShadow], duration: 0.3)
    }
}

/// Bounce animation for icons and interactive elements
public struct BounceAnimation: Animation {
    public let delay: TimeInterval
    
    public init(delay: TimeInterval = 0) {
        self.delay = delay
    }
    
    public var duration: TimeInterval { 0.6 }
    
    public var timing: AnimationTiming {
        AnimationTiming(
            duration: duration,
            delay: delay,
            easing: .custom("cubic-bezier(0.68, -0.55, 0.265, 1.55)")
        )
    }
    
    public var properties: [AnimationProperty] {
        [.transform(.scale(1.0))]
    }
    
    public func generateCSS(for element: String) -> String {
        """
        @keyframes \(element.dropFirst())-bounce {
            0% { transform: scale(0); }
            50% { transform: scale(1.2); }
            100% { transform: scale(1.0); }
        }
        
        \(element) {
            animation: \(element.dropFirst())-bounce \(timing.cssValue);
        }
        """
    }
}

// MARK: - Animation Utilities

/// Helper for creating staggered animation sequences
public struct StaggeredAnimations {
    public static func fadeInSequence<T: Markup>(
        _ elements: [T],
        baseDelay: TimeInterval = 0,
        staggerDelay: TimeInterval = 0.1
    ) -> [some Markup] {
        elements.enumerated().map { index, element in
            element.fadeIn(
                duration: 0.5,
                delay: baseDelay + (Double(index) * staggerDelay)
            )
        }
    }
    
    public static func slideInSequence<T: Markup>(
        _ elements: [T],
        direction: SlideDirection = .fromBottom,
        baseDelay: TimeInterval = 0,
        staggerDelay: TimeInterval = 0.1
    ) -> [some Markup] {
        elements.enumerated().map { index, element in
            element.slideIn(
                direction,
                duration: 0.5,
                delay: baseDelay + (Double(index) * staggerDelay),
                distance: 50
            )
        }
    }
}

// MARK: - Animation Helper Components

/// Div container for custom animations
public struct AnimatedDiv: Element {
    private let content: String
    
    public init(@MarkupBuilder content: () -> String) {
        self.content = content()
    }
    
    public var body: MarkupString {
        MarkupString(content: "<div>\(content)</div>")
    }
}

// Helper extensions for animation examples
extension Markup {
    public func customWidth(_ value: String) -> some Markup {
        addingClasses(["width-\(value)"])
    }
    
    public func customHeight(_ value: String) -> some Markup {
        addingClasses(["height-\(value)"])
    }
    
    public func customBorder(_ value: String) -> some Markup {
        addingClasses(["border"])
    }
    
    public func customBorderTop(_ value: String) -> some Markup {
        addingClasses(["border-top"])
    }
}