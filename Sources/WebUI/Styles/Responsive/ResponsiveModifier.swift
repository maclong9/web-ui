import Foundation

/// Provides a block-based responsive design API for WebUI elements.
///
/// The on modifier allows developers to define responsive styles
/// across different breakpoints in a single, concise block, creating cleaner
/// and more maintainable code for responsive designs.
///
/// ## Example
/// ```swift
/// Text { "Responsive Content" }
///   .font(size: .sm)
///   .background(color: .neutral(._500))
///   .on {
///     md {
///       font(size: .lg)
///       background(color: .neutral(._700))
///       padding(of: 4)
///     }
///     lg {
///       font(size: .xl)
///       background(color: .neutral(._900))
///       font(alignment: .center)
///     }
///   }
/// ```
extension HTML {
    /// Applies responsive styling across different breakpoints with a declarative syntax.
    ///
    /// This method provides a clean, declarative way to define styles for multiple
    /// breakpoints in a single block, improving code readability and maintainability.
    ///
    /// - Parameter content: A closure defining responsive style configurations using the result builder.
    /// - Returns: An element with responsive styles applied.
    ///
    /// ## Example
    /// ```swift
    /// Button { "Submit" }
    ///   .background(color: .blue(._500))
    ///   .on {
    ///     sm {
    ///       padding(of: 2)
    ///       font(size: .sm)
    ///     }
    ///     md {
    ///       padding(of: 4)
    ///       font(size: .base)
    ///     }
    ///     lg {
    ///       padding(of: 6)
    ///       font(size: .lg)
    ///     }
    ///   }
    /// ```
    public func on(@ResponsiveStyleBuilder _ content: () -> ResponsiveModification) -> any Element {
        let builder = ResponsiveBuilder(element: self)
        let modification = content()
        modification.apply(to: builder)
        return builder.element
    }
}

/// Builds responsive style configurations for elements across different breakpoints.
///
/// `ResponsiveBuilder` provides a fluent, method-chaining API for applying style
/// modifications at specific screen sizes. Each method represents a breakpoint
/// and accepts a closure where style modifications can be defined.
///
/// This class is not typically created directly, but instead used through the
/// `Element.on(_:)` method.
public class ResponsiveBuilder {
    /// The current element being modified
    var element: any Element
    /// Keep track of responsive styles for each breakpoint
    internal var pendingClasses: [String] = []
    /// The current breakpoint being modified
    internal var currentBreakpoint: Modifier?

    /// Creates a new responsive builder for the given element.
    ///
    /// - Parameter element: The element to apply responsive styles to.
    init(element: any Element) {
        self.element = element
    }

    /// Applies styles at the extra-small breakpoint (480px+).
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func xs(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .xs
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles at the small breakpoint (640px+).
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func sm(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .sm
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles at the medium breakpoint (768px+).
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func md(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .md
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles at the large breakpoint (1024px+).
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func lg(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .lg
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles at the extra-large breakpoint (1280px+).
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func xl(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .xl
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies styles at the 2x-extra-large breakpoint (1536px+).
    ///
    /// - Parameter modifications: A closure containing style modifications.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func xl2(_ modifications: (ResponsiveBuilder) -> Void) -> ResponsiveBuilder {
        currentBreakpoint = .xl2
        modifications(self)
        applyBreakpoint()
        return self
    }

    /// Applies the breakpoint prefix to all pending classes and add them to the element
    internal func applyBreakpoint() {
        guard let breakpoint = currentBreakpoint else { return }

        // Apply the breakpoint prefix to all pending classes
        let responsiveClasses = pendingClasses.map {
            // Handle duplication for flex-*, justify-*, items-*
            if $0.starts(with: "flex-") || $0.starts(with: "justify-") || $0.starts(with: "items-")
                || $0.starts(with: "grid-")
            {
                return "\(breakpoint.rawValue)\($0)"
            } else if $0 == "flex" || $0 == "grid" {
                return "\(breakpoint.rawValue)\($0)"
            } else {
                return "\(breakpoint.rawValue)\($0)"
            }
        }

        // Add the responsive classes to the element
        self.element = StyleModifier(content: self.element, classes: responsiveClasses)

        // Clear pending classes for the next breakpoint
        pendingClasses = []
        currentBreakpoint = nil
    }

    /// Add a class to the pending list of classes
    public func addClass(_ className: String) {
        pendingClasses.append(className)
    }
}

// Font styling methods
extension ResponsiveBuilder {
    @discardableResult
    public func size(_ value: Int) -> ResponsiveBuilder {
        addClass("size-\(value)")
        return self
    }

    @discardableResult
    public func frame(
        width: Int? = nil,
        height: Int? = nil,
        minWidth: Int? = nil,
        maxWidth: Int? = nil,
        minHeight: Int? = nil,
        maxHeight: Int? = nil
    ) -> ResponsiveBuilder {
        if let width = width { addClass("w-\(width)") }
        if let height = height { addClass("h-\(height)") }
        if let minWidth = minWidth { addClass("min-w-\(minWidth)") }
        if let maxWidth = maxWidth { addClass("max-w-\(maxWidth)") }
        if let minHeight = minHeight { addClass("min-h-\(minHeight)") }
        if let maxHeight = maxHeight { addClass("max-h-\(maxHeight)") }
        return self
    }
}
