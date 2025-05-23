import Foundation

public enum CursorType: String {
    case auto
    case `default`
    case pointer
    case wait
    case text
    case move
    case notAllowed = "not-allowed"
}

/// Style operation for cursor styling
///
/// Provides a unified implementation for cursor styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct CursorStyleOperation: StyleOperation, @unchecked Sendable {
    /// Parameters for cursor styling
    public struct Parameters {
        /// The cursor type
        public let type: CursorType

        /// Creates parameters for cursor styling
        ///
        /// - Parameter type: The cursor type
        public init(type: CursorType) {
            self.type = type
        }

        /// Creates parameters from a StyleParameters container
        ///
        /// - Parameter params: The style parameters container
        /// - Returns: CursorStyleOperation.Parameters
        public static func from(_ params: StyleParameters) -> Parameters {
            Parameters(
                type: params.get("type")!
            )
        }
    }

    /// Applies the cursor style and returns the appropriate CSS classes
    ///
    /// - Parameter params: The parameters for cursor styling
    /// - Returns: An array of CSS class names to be applied to elements
    public func applyClasses(params: Parameters) -> [String] {
        ["cursor-\(params.type.rawValue)"]
    }

    /// Shared instance for use across the framework
    public static let shared = CursorStyleOperation()

    /// Private initializer to enforce singleton usage
    private init() {}
}

// Extension for Element to provide cursor styling
extension HTML {
    /// Sets the cursor style of the element with optional modifiers.
    ///
    /// - Parameters:
    ///   - type: The cursor type.
    ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
    /// - Returns: A new element with updated cursor classes.
    ///
    /// ## Example
    /// ```swift
    /// Link(to: "/contact") { "Contact Us" }
    ///   .cursor(.pointer)
    ///
    /// Button()
    ///   .cursor(.notAllowed, on: .hover)
    /// ```
    public func cursor(
        _ type: CursorType,
        on modifiers: Modifier...
    ) -> any Element {
        let params = CursorStyleOperation.Parameters(type: type)

        return CursorStyleOperation.shared.applyTo(
            self,
            params: params,
            modifiers: Array(modifiers)
        )
    }
}

// Extension for ResponsiveBuilder to provide cursor styling
extension ResponsiveBuilder {
    /// Applies cursor styling in a responsive context.
    ///
    /// - Parameter type: The cursor type.
    /// - Returns: The builder for method chaining.
    @discardableResult
    public func cursor(_ type: CursorType) -> ResponsiveBuilder {
        let params = CursorStyleOperation.Parameters(type: type)

        return CursorStyleOperation.shared.applyToBuilder(self, params: params)
    }
}

// Global function for Declarative DSL
/// Applies cursor styling in the responsive context.
///
/// - Parameter type: The cursor type.
/// - Returns: A responsive modification for cursor.
public func cursor(_ type: CursorType) -> ResponsiveModification {
    let params = CursorStyleOperation.Parameters(type: type)

    return CursorStyleOperation.shared.asModification(params: params)
}
