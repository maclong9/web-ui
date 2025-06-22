import Foundation

#if canImport(CoreGraphics)
import CoreGraphics
#endif

/// Style operation for sizing styling
///
/// Provides a unified implementation for sizing styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct SizingStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for frame styling
    public struct FrameParameters {
        /// The width value
        public let width: SizingValue?
        /// The height value
        public let height: SizingValue?
        /// The minimum width value
        public let minWidth: SizingValue?
        /// The maximum width value
        public let maxWidth: SizingValue?
        /// The minimum height value
        public let minHeight: SizingValue?
        /// The maximum height value
        public let maxHeight: SizingValue?

        /// Creates parameters for frame styling
        ///
        /// - Parameters:
        ///   - width: The width value
        ///   - height: The height value
        ///   - minWidth: The minimum width value
        ///   - maxWidth: The maximum width value
        ///   - minHeight: The minimum height value
        ///   - maxHeight: The maximum height value
        public init(
            width: SizingValue? = nil,
            height: SizingValue? = nil,
            minWidth: SizingValue? = nil,
            maxWidth: SizingValue? = nil,
            minHeight: SizingValue? = nil,
            maxHeight: SizingValue? = nil
        ) {
            self.width = width
            self.height = height
            self.minWidth = minWidth
            self.maxWidth = maxWidth
            self.minHeight = minHeight
            self.maxHeight = maxHeight
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: SizingStyleOperation.FrameParameters
        public static func from(_ params: StyleParameters) -> FrameParameters {
            FrameParameters(
                width: params.get("width"),
                height: params.get("height"),
                minWidth: params.get("minWidth"),
                maxWidth: params.get("maxWidth"),
                minHeight: params.get("minHeight"),
                maxHeight: params.get("maxHeight")
            )
        }
    }

    /// Parameters for size styling (uniform sizing)
    public struct SizeParameters {
        /// The size value to apply to both width and height
        public let value: SizingValue

        /// Creates parameters for size styling
        ///
        /// - Parameter value: The size value
        public init(value: SizingValue) {
            self.value = value
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: SizingStyleOperation.SizeParameters
        public static func from(_ params: StyleParameters) -> SizeParameters {
            SizeParameters(
                value: params.get("value")!
            )
        }
    }

    /// Parameters for aspect ratio styling
    public struct AspectRatioParameters {
        /// The width component of the aspect ratio
        public let width: Double?
        /// The height component of the aspect ratio
        public let height: Double?
        /// Whether to use a square (1:1) aspect ratio
        public let isSquare: Bool
        /// Whether to use a video (16:9) aspect ratio
        public let isVideo: Bool

        /// Creates parameters for aspect ratio styling
        ///
        /// - Parameters:
        ///   - width: The width component
        ///   - height: The height component
        ///   - isSquare: Whether to use a square aspect ratio
        ///   - isVideo: Whether to use a video aspect ratio
        public init(
            width: Double? = nil,
            height: Double? = nil,
            isSquare: Bool = false,
            isVideo: Bool = false
        ) {
            self.width = width
            self.height = height
            self.isSquare = isSquare
            self.isVideo = isVideo
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: SizingStyleOperation.AspectRatioParameters
        public static func from(_ params: StyleParameters)
            -> AspectRatioParameters
        {
            AspectRatioParameters(
                width: params.get("width"),
                height: params.get("height"),
                isSquare: params.get("isSquare", default: false),
                isVideo: params.get("isVideo", default: false)
            )
        }
    }

    /// Applies the frame style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for frame styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyClasses(params: FrameParameters) -> [String] {
        var classes: [String] = []

        if let width = params.width { classes.append("w-\(width.rawValue)") }
        if let height = params.height { classes.append("h-\(height.rawValue)") }
        if let minWidth = params.minWidth {
            classes.append("min-w-\(minWidth.rawValue)")
        }
        if let maxWidth = params.maxWidth {
            classes.append("max-w-\(maxWidth.rawValue)")
        }
        if let minHeight = params.minHeight {
            classes.append("min-h-\(minHeight.rawValue)")
        }
        if let maxHeight = params.maxHeight {
            classes.append("max-h-\(maxHeight.rawValue)")
        }

        return classes
    }

    /// Applies the size style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for size styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applySizeClasses(params: SizeParameters) -> [String] {
        ["size-\(params.value.rawValue)"]
    }

    /// Applies the aspect ratio style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for aspect ratio styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyAspectRatioClasses(params: AspectRatioParameters)
        -> [String]
    {
        if params.isSquare {
            return ["aspect-square"]
        } else if params.isVideo {
            return ["aspect-video"]
        } else if let width = params.width, let height = params.height {
            let ratio = width / height
            return ["aspect-[\(ratio)]"]
        }
        return []
    }

    /// Shared instance for use across the framework
    public static let shared = SizingStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for Element to provide sizing and layout styling
extension HTML {
    /// Sets the width and height of the element with comprehensive SwiftUI-like API.
    ///
    /// This method provides control over all width and height properties, supporting
    /// all Tailwind CSS sizing options including numeric values, fractions, container sizes,
    /// viewport units, constants, content-based sizing, and custom values.
    ///
    /// - Parameters:
    ///   - width: The width value.
    ///   - height: The height value.
    ///   - minWidth: The minimum width value.
    ///   - maxWidth: The maximum width value.
    ///   - minHeight: The minimum height value.
    ///   - maxHeight: The maximum height value.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated sizing classes.
    public func frame(
        width: SizingValue? = nil,
        height: SizingValue? = nil,
        minWidth: SizingValue? = nil,
        maxWidth: SizingValue? = nil,
        minHeight: SizingValue? = nil,
        maxHeight: SizingValue? = nil,
        on modifiers: Modifier...
    ) -> some HTML {
        let params = SizingStyleOperation.FrameParameters(
            width: width,
            height: height,
            minWidth: minWidth,
            maxWidth: maxWidth,
            minHeight: minHeight,
            maxHeight: maxHeight
        )

        return SizingStyleOperation.shared.applyTo(
            self,
            params: params,
            modifiers: Array(modifiers)
        )
    }

    /// Sets the width and height of the element using numeric values.
    ///
    /// This method provides a simplified SwiftUI-compatible signature for setting frame dimensions.
    ///
    /// - Parameters:
    ///   - width: The width in spacing units.
    ///   - height: The height in spacing units.
    ///   - minWidth: The minimum width in spacing units.
    ///   - maxWidth: The maximum width in spacing units.
    ///   - minHeight: The minimum height in spacing units.
    ///   - maxHeight: The maximum height in spacing units.
    /// - Returns: A new element with updated sizing classes.
    public func frame(
        width: Double? = nil,
        height: Double? = nil,
        minWidth: Double? = nil,
        maxWidth: Double? = nil,
        minHeight: Double? = nil,
        maxHeight: Double? = nil
    ) -> some HTML {
        frame(
            width: width.map { .spacing(Int($0)) },
            height: height.map { .spacing(Int($0)) },
            minWidth: minWidth.map { .spacing(Int($0)) },
            maxWidth: maxWidth.map { .spacing(Int($0)) },
            minHeight: minHeight.map { .spacing(Int($0)) },
            maxHeight: maxHeight.map { .spacing(Int($0)) }
        )
    }

    /// Sets both width and height to the same value, creating a square element.
    ///
    /// This method applies the same sizing value to both width and height dimensions.
    ///
    /// - Parameters:
    ///   - size: The size value to apply to both width and height.
    ///   - modifiers: Zero or more modifiers to scope the styles.
    /// - Returns: A new element with updated sizing classes.
    public func size(_ size: SizingValue, on modifiers: Modifier...)
        -> some HTML
    {
        let params = SizingStyleOperation.SizeParameters(value: size)
        let classes = SizingStyleOperation.shared.applySizeClasses(
            params: params)
        let newClasses = StyleUtilities.combineClasses(
            classes, withModifiers: modifiers)
        return StyleModifier(content: self, classes: newClasses)
    }

    /// Creates a frame that maintains the specified aspect ratio.
    ///
    /// Follows the SwiftUI pattern for creating frames with a fixed aspect ratio.
    ///
    /// - Parameters:
    ///   - width: The width for the aspect ratio calculation.
    ///   - height: The height for the aspect ratio calculation.
    ///   - modifiers: Zero or more modifiers to scope the styles.
    /// - Returns: A new element with aspect ratio classes.
    public func aspectRatio(
        _ width: Double, _ height: Double, on modifiers: Modifier...
    ) -> some HTML {
        let params = SizingStyleOperation.AspectRatioParameters(
            width: width, height: height)
        let classes = SizingStyleOperation.shared.applyAspectRatioClasses(
            params: params)
        let newClasses = StyleUtilities.combineClasses(
            classes, withModifiers: modifiers)
        return StyleModifier(content: self, classes: newClasses)
    }

    /// Sets the aspect ratio to square (1:1).
    ///
    /// - Parameters:
    ///   - modifiers: Zero or more modifiers to scope the styles.
    /// - Returns: A new element with square aspect ratio.
    public func aspectRatio(on modifiers: Modifier...) -> some HTML {
        let params = SizingStyleOperation.AspectRatioParameters(isSquare: true)
        let classes = SizingStyleOperation.shared.applyAspectRatioClasses(
            params: params)
        let newClasses = StyleUtilities.combineClasses(
            classes, withModifiers: modifiers)
        return StyleModifier(content: self, classes: newClasses)
    }

    /// Sets the aspect ratio to video dimensions (16:9).
    ///
    /// - Parameters:
    ///   - modifiers: Zero or more modifiers to scope the styles.
    /// - Returns: A new element with video aspect ratio.
    public func aspectRatioVideo(on modifiers: Modifier...) -> some HTML {
        let params = SizingStyleOperation.AspectRatioParameters(isVideo: true)
        let classes = SizingStyleOperation.shared.applyAspectRatioClasses(
            params: params)
        let newClasses = StyleUtilities.combineClasses(
            classes, withModifiers: modifiers)
        return StyleModifier(content: self, classes: newClasses)
    }
}

// Extension for ResponsiveBuilder to provide sizing and layout styling
extension ResponsiveBuilder {
    /// Applies frame styling in a responsive context.
    ///
    /// - Parameters:
    ///   - width: The width value.
    ///   - height: The height value.
    ///   - minWidth: The minimum width value.
    ///   - maxWidth: The maximum width value.
    ///   - minHeight: The minimum height value.
    ///   - maxHeight: The maximum height value.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func frame(
        width: SizingValue? = nil,
        height: SizingValue? = nil,
        minWidth: SizingValue? = nil,
        maxWidth: SizingValue? = nil,
        minHeight: SizingValue? = nil,
        maxHeight: SizingValue? = nil
    ) -> ResponsiveBuilder {
        let params = SizingStyleOperation.FrameParameters(
            width: width,
            height: height,
            minWidth: minWidth,
            maxWidth: maxWidth,
            minHeight: minHeight,
            maxHeight: maxHeight
        )

        return SizingStyleOperation.shared.applyToBuilder(self, params: params)
    }

    /// Applies size styling in a responsive context.
    ///
    /// - Parameter value: The size value.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func size(_ value: SizingValue) -> ResponsiveBuilder {
        let params = SizingStyleOperation.SizeParameters(value: value)
        let classes = SizingStyleOperation.shared.applySizeClasses(
            params: params)
        for className in classes {
            addClass(className)
        }
        return self
    }

    /// Applies aspect ratio styling in a responsive context.
    ///
    /// - Parameters:
    ///   - width: The width for the aspect ratio calculation.
    ///   - height: The height for the aspect ratio calculation.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func aspectRatio(_ width: Double, _ height: Double)
        -> ResponsiveBuilder
    {
        let params = SizingStyleOperation.AspectRatioParameters(
            width: width, height: height)
        let classes = SizingStyleOperation.shared.applyAspectRatioClasses(
            params: params)
        for className in classes {
            addClass(className)
        }
        return self
    }

    /// Applies square aspect ratio styling in a responsive context.
    ///
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func aspectRatio() -> ResponsiveBuilder {
        let params = SizingStyleOperation.AspectRatioParameters(isSquare: true)
        let classes = SizingStyleOperation.shared.applyAspectRatioClasses(
            params: params)
        for className in classes {
            addClass(className)
        }
        return self
    }

    /// Applies video aspect ratio styling in a responsive context.
    ///
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func aspectRatioVideo() -> ResponsiveBuilder {
        let params = SizingStyleOperation.AspectRatioParameters(isVideo: true)
        let classes = SizingStyleOperation.shared.applyAspectRatioClasses(
            params: params)
        for className in classes {
            addClass(className)
        }
        return self
    }
}

// Global functions for Declarative DSL

/// Applies frame styling in the responsive context.
///
/// - Parameters:
///   - width: The width value.
///   - height: The height value.
///   - minWidth: The minimum width value.
///   - maxWidth: The maximum width value.
///   - minHeight: The minimum height value.
///   - maxHeight: The maximum height value.
/// - Returns: A responsive modification for frame styling.
public func frame(
    width: SizingValue? = nil,
    height: SizingValue? = nil,
    minWidth: SizingValue? = nil,
    maxWidth: SizingValue? = nil,
    minHeight: SizingValue? = nil,
    maxHeight: SizingValue? = nil
) -> ResponsiveModification {
    let params = SizingStyleOperation.FrameParameters(
        width: width,
        height: height,
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight
    )
    return SizingStyleOperation.shared.asModification(params: params)
}

/// Applies size styling in the responsive context.
///
/// - Parameter value: The size value.
/// - Returns: A responsive modification for size styling.
public func size(_ value: SizingValue) -> ResponsiveModification {
    let params = SizingStyleOperation.SizeParameters(value: value)
    return StyleModification { builder in
        let classes = SizingStyleOperation.shared.applySizeClasses(
            params: params)
        for className in classes {
            builder.addClass(className)
        }
    }
}

/// Applies aspect ratio styling in the responsive context.
///
/// - Parameters:
///   - width: The width for the aspect ratio calculation.
///   - height: The height for the aspect ratio calculation.
/// - Returns: A responsive modification for aspect ratio styling.
public func aspectRatio(_ width: Double, _ height: Double)
    -> ResponsiveModification
{
    let params = SizingStyleOperation.AspectRatioParameters(
        width: width, height: height)
    return StyleModification { builder in
        let classes = SizingStyleOperation.shared.applyAspectRatioClasses(
            params: params)
        for className in classes {
            builder.addClass(className)
        }
    }
}

/// Applies square aspect ratio styling in the responsive context.
///
/// - Returns: A responsive modification for square aspect ratio styling.
public func aspectRatio() -> ResponsiveModification {
    let params = SizingStyleOperation.AspectRatioParameters(isSquare: true)
    return StyleModification { builder in
        let classes = SizingStyleOperation.shared.applyAspectRatioClasses(
            params: params)
        for className in classes {
            builder.addClass(className)
        }
    }
}

/// Applies video aspect ratio styling in the responsive context.
///
/// - Returns: A responsive modification for video aspect ratio styling.
public func aspectRatioVideo() -> ResponsiveModification {
    let params = SizingStyleOperation.AspectRatioParameters(isVideo: true)
    return StyleModification { builder in
        let classes = SizingStyleOperation.shared.applyAspectRatioClasses(
            params: params)
        for className in classes {
            builder.addClass(className)
        }
    }
}
