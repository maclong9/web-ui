import Foundation

/// Style operation for scroll styling
///
/// Provides a unified implementation for scroll styling that can be used across
/// Element methods and the Declarative DSL functions.
public struct ScrollStyleOperation: StyleOperation, @unchecked Sendable {
  /// Parameters for scroll styling
  public struct Parameters {
    /// The scroll behavior
    public let behavior: ScrollBehavior?

    /// The scroll margin value and edges
    public let margin: (value: Int, edges: [Edge])?

    /// The scroll padding value and edges
    public let padding: (value: Int, edges: [Edge])?

    /// The scroll snap alignment
    public let snapAlign: ScrollSnapAlign?

    /// The scroll snap stop behavior
    public let snapStop: ScrollSnapStop?

    /// The scroll snap type
    public let snapType: ScrollSnapType?

    /// Creates parameters for scroll styling
    ///
    /// - Parameters:
    ///   - behavior: The scroll behavior
    ///   - margin: The scroll margin value and edges
    ///   - padding: The scroll padding value and edges
    ///   - snapAlign: The scroll snap alignment
    ///   - snapStop: The scroll snap stop behavior
    ///   - snapType: The scroll snap type
    public init(
      behavior: ScrollBehavior? = nil,
      margin: (value: Int, edges: [Edge])? = nil,
      padding: (value: Int, edges: [Edge])? = nil,
      snapAlign: ScrollSnapAlign? = nil,
      snapStop: ScrollSnapStop? = nil,
      snapType: ScrollSnapType? = nil
    ) {
      self.behavior = behavior
      self.margin = margin
      self.padding = padding
      self.snapAlign = snapAlign
      self.snapStop = snapStop
      self.snapType = snapType
    }

    /// Creates parameters from a StyleParameters container
    ///
    /// - Parameter params: The style parameters container
    /// - Returns: ScrollStyleOperation.Parameters
    public static func from(_ params: StyleParameters) -> Parameters {
      Parameters(
        behavior: params.get("behavior"),
        margin: params.get("margin"),
        padding: params.get("padding"),
        snapAlign: params.get("snapAlign"),
        snapStop: params.get("snapStop"),
        snapType: params.get("snapType")
      )
    }
  }

  /// Applies the scroll style and returns the appropriate stylesheet classes
  ///
  /// - Parameter params: The parameters for scroll styling
  /// - Returns: An array of stylesheet class names to be applied to elements
  public func applyClasses(params: Parameters) -> [String] {
    var classes: [String] = []

    // Scroll Behavior
    if let behavior = params.behavior {
      classes.append("scroll-\(behavior.rawValue)")
    }

    // Scroll Margin
    if let (value, edges) = params.margin {
      let effectiveEdges = edges.isEmpty ? [Edge.all] : edges
      for edge in effectiveEdges {
        let edgePrefix: String
        switch edge {
        case .all: edgePrefix = ""
        case .top: edgePrefix = "t"
        case .bottom: edgePrefix = "b"
        case .leading: edgePrefix = "s"
        case .trailing: edgePrefix = "e"
        case .horizontal: edgePrefix = "x"
        case .vertical: edgePrefix = "y"
        }

        classes.append(
          "scroll-m\(edgePrefix.isEmpty ? "" : "\(edgePrefix)")-\(value)"
        )
      }
    }

    // Scroll Padding
    if let (value, edges) = params.padding {
      let effectiveEdges = edges.isEmpty ? [Edge.all] : edges
      for edge in effectiveEdges {
        let edgePrefix: String
        switch edge {
        case .all: edgePrefix = ""
        case .top: edgePrefix = "t"
        case .bottom: edgePrefix = "b"
        case .leading: edgePrefix = "s"
        case .trailing: edgePrefix = "e"
        case .horizontal: edgePrefix = "x"
        case .vertical: edgePrefix = "y"
        }

        classes.append(
          "scroll-p\(edgePrefix.isEmpty ? "" : "\(edgePrefix)")-\(value)"
        )
      }
    }

    // Scroll Snap Align
    if let snapAlign = params.snapAlign {
      classes.append("snap-\(snapAlign.rawValue)")
    }

    // Scroll Snap Stop
    if let snapStop = params.snapStop {
      classes.append("snap-\(snapStop.rawValue)")
    }

    // Scroll Snap Type
    if let snapType = params.snapType {
      classes.append("snap-\(snapType.rawValue)")
    }

    return classes
  }

  /// Shared instance for use across the framework
  public static let shared = ScrollStyleOperation()

  /// Private initializer to enforce singleton usage
  private init() {}
}

// Extension for Element to provide scroll styling
extension Markup {
  /// Applies scroll-related styles to the element.
  ///
  /// Adds Tailwind stylesheet classes for scroll behavior, margin, padding, and snap properties.
  ///
  /// - Parameters:
  ///   - behavior: Sets the scroll behavior (smooth or auto).
  ///   - margin: Sets the scroll margin in 0.25rem increments for all sides or specific edges.
  ///   - padding: Sets the scroll padding in 0.25rem increments for all sides or specific edges.
  ///   - snapAlign: Sets the scroll snap alignment (start, end, center).
  ///   - snapStop: Sets the scroll snap stop behavior (normal, always).
  ///   - snapType: Sets the scroll snap type (x, y, both, mandatory, proximity).
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated scroll-related classes.
  public func scroll(
    behavior: ScrollBehavior? = nil,
    margin: (value: Int, edges: [Edge])? = nil,
    padding: (value: Int, edges: [Edge])? = nil,
    snapAlign: ScrollSnapAlign? = nil,
    snapStop: ScrollSnapStop? = nil,
    snapType: ScrollSnapType? = nil,
    on modifiers: Modifier...
  ) -> some Markup {
    let params = ScrollStyleOperation.Parameters(
      behavior: behavior,
      margin: margin,
      padding: padding,
      snapAlign: snapAlign,
      snapStop: snapStop,
      snapType: snapType
    )

    return ScrollStyleOperation.shared.applyTo(
      self,
      params: params,
      modifiers: Array(modifiers)
    )
  }
}

// Extension for ResponsiveBuilder to provide scroll styling
extension ResponsiveBuilder {
  /// Applies scroll styling in a responsive context.
  ///
  /// - Parameters:
  ///   - behavior: The scroll behavior.
  ///   - margin: The scroll margin value and edges.
  ///   - padding: The scroll padding value and edges.
  ///   - snapAlign: The scroll snap alignment.
  ///   - snapStop: The scroll snap stop behavior.
  ///   - snapType: The scroll snap type.
  /// - Returns: The builder for method chaining.
  @discardableResult
  public func scroll(
    behavior: ScrollBehavior? = nil,
    margin: (value: Int, edges: [Edge])? = nil,
    padding: (value: Int, edges: [Edge])? = nil,
    snapAlign: ScrollSnapAlign? = nil,
    snapStop: ScrollSnapStop? = nil,
    snapType: ScrollSnapType? = nil
  ) -> ResponsiveBuilder {
    let params = ScrollStyleOperation.Parameters(
      behavior: behavior,
      margin: margin,
      padding: padding,
      snapAlign: snapAlign,
      snapStop: snapStop,
      snapType: snapType
    )

    return ScrollStyleOperation.shared.applyToBuilder(self, params: params)
  }
}

// Global function for Declarative DSL
/// Applies scroll styling in the responsive context.
///
/// - Parameters:
///   - behavior: The scroll behavior.
///   - margin: The scroll margin value and edges.
///   - padding: The scroll padding value and edges.
///   - snapAlign: The scroll snap alignment.
///   - snapStop: The scroll snap stop behavior.
///   - snapType: The scroll snap type.
/// - Returns: A responsive modification for scroll.
public func scroll(
  behavior: ScrollBehavior? = nil,
  margin: (value: Int, edges: [Edge])? = nil,
  padding: (value: Int, edges: [Edge])? = nil,
  snapAlign: ScrollSnapAlign? = nil,
  snapStop: ScrollSnapStop? = nil,
  snapType: ScrollSnapType? = nil
) -> ResponsiveModification {
  let params = ScrollStyleOperation.Parameters(
    behavior: behavior,
    margin: margin,
    padding: padding,
    snapAlign: snapAlign,
    snapStop: snapStop,
    snapType: snapType
  )

  return ScrollStyleOperation.shared.asModification(params: params)
}
