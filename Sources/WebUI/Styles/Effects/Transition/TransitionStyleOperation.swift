import Foundation

/// Style operation for transition styling
///
/// Provides a unified implementation for transition styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct TransitionStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for transition styling
    public struct Parameters {
        /// The transition property
        public let property: TransitionProperty?

        /// The transition duration in milliseconds
        public let duration: Int?

        /// The transition easing function
        public let easing: Easing?

        /// The transition delay in milliseconds
        public let delay: Int?

        /// Creates parameters for transition styling
        ///
        /// - Parameters:
        ///   - property: The transition property
        ///   - duration: The transition duration in milliseconds
        ///   - easing: The transition easing function
        ///   - delay: The transition delay in milliseconds
        public init(
            property: TransitionProperty? = nil,
            duration: Int? = nil,
            easing: Easing? = nil,
            delay: Int? = nil
        ) {
            self.property = property
            self.duration = duration
            self.easing = easing
            self.delay = delay
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: TransitionStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                property: params.get("property"),
                duration: params.get("duration"),
                easing: params.get("easing"),
                delay: params.get("delay")
            )
        }
    }

    /// Applies the transition style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for transition styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        var classes: [String] = []

        if let property = params.property {
            classes.append("transition-\(property.rawValue)")
        } else {
            classes.append("transition")
        }

        if let duration = params.duration {
            classes.append("duration-\(duration)")
        }

        if let easing = params.easing {
            classes.append("ease-\(easing.rawValue)")
        }

        if let delay = params.delay {
            classes.append("delay-\(delay)")
        }

        return classes
    }

    /// Shared instance for use across the framework
    public static let shared = TransitionStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for Element to provide transition styling
extension HTML {
    /// Applies transition styling to the element.
    ///
    /// Adds classes for animating properties with duration, easing, and delay.
    ///
    /// - Parameters:
    ///   - property: Specifies the property to animate (defaults to all if nil).
    ///   - duration: Sets the transition duration in milliseconds.
    ///   - easing: Defines the timing function for the transition.
    ///   - delay: Sets the delay before the transition starts in milliseconds.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated transition classes.
    public func transition(
        of property: TransitionProperty? = nil,
        for duration: Int? = nil,
        easing: Easing? = nil,
        delay: Int? = nil,
        on modifiers: Modifier...
    ) -> any Element {
        let params = TransitionStyleOperation.Parameters(
            property: property,
            duration: duration,
            easing: easing,
            delay: delay
        )

        return TransitionStyleOperation.shared.applyTo(
            self,
            params: params,
            modifiers: Array(modifiers)
        )
    }
}

// Extension for ResponsiveBuilder to provide transition styling
extension ResponsiveBuilder {
    /// Applies transition styling in a responsive context.
    ///
    /// - Parameters:
    ///   - property: The transition property.
    ///   - duration: The transition duration in milliseconds.
    ///   - easing: The transition easing function.
    ///   - delay: The transition delay in milliseconds.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func transition(
        of property: TransitionProperty? = nil,
        for duration: Int? = nil,
        easing: Easing? = nil,
        delay: Int? = nil
    ) -> ResponsiveBuilder {
        let params = TransitionStyleOperation.Parameters(
            property: property,
            duration: duration,
            easing: easing,
            delay: delay
        )

        return TransitionStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declarative DSL
/// Applies transition styling in the responsive context.
///
/// - Parameters:
///   - property: The transition property.
///   - duration: The transition duration in milliseconds.
///   - easing: The transition easing function.
///   - delay: The transition delay in milliseconds.
/// - Returns: A responsive modification for transition.
public func transition(
    of property: TransitionProperty? = nil,
    for duration: Int? = nil,
    easing: Easing? = nil,
    delay: Int? = nil
) -> ResponsiveModification {
    let params = TransitionStyleOperation.Parameters(
        property: property,
        duration: duration,
        easing: easing,
        delay: delay
    )

    return TransitionStyleOperation.shared.asModification(params: params)
}
