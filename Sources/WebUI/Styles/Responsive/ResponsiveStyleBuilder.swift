import Foundation

/// A result builder for creating responsive styles with a clean, SwiftUI-like syntax.
///
/// This builder enables a more natural way to define responsive styles without using `$0` references.
///
/// ## Example
/// ```swift
/// Element(tag: "div")
///   .responsive {
///     sm {
///       font(size: .base)
///     }
///     md {
///       font(size: .lg)
///       background(color: .blue(._500))
///     }
///   }
/// ```
@resultBuilder
public struct ResponsiveStyleBuilder {
  /// Builds an empty responsive style.
  public static func buildBlock() -> ResponsiveModification {
    EmptyResponsiveModification()
  }

  /// Builds a responsive style from multiple modifications.
  public static func buildBlock(_ components: ResponsiveModification...)
    -> ResponsiveModification
  {
    CompositeResponsiveModification(modifications: components)
  }

  /// Builds a responsive modification from a modifier expression.
  public static func buildExpression(_ expression: ResponsiveModification) -> ResponsiveModification
  {
    expression
  }

  /// Transforms an optional into a responsive modification.
  public static func buildOptional(_ component: ResponsiveModification?)
    -> ResponsiveModification
  {
    component ?? EmptyResponsiveModification()
  }

  /// Transforms an either-or condition into a responsive modification.
  public static func buildEither(first component: ResponsiveModification)
    -> ResponsiveModification
  {
    component
  }

  /// Transforms an either-or condition into a responsive modification.
  public static func buildEither(second component: ResponsiveModification)
    -> ResponsiveModification
  {
    component
  }

  /// Transforms an array of responsive modifications into a single modification.
  public static func buildArray(_ components: [ResponsiveModification])
    -> ResponsiveModification
  {
    CompositeResponsiveModification(modifications: components)
  }
}

/// Protocol defining the interface for responsive style modifications.
public protocol ResponsiveModification {
  /// Applies the modification to the given responsive builder.
  func apply(to builder: ResponsiveBuilder)
}

/// Represents an empty responsive modification.
struct EmptyResponsiveModification: ResponsiveModification {
  func apply(to builder: ResponsiveBuilder) {
    // Do nothing for empty modifications
  }
}

/// Represents a composite of multiple responsive modifications.
struct CompositeResponsiveModification: ResponsiveModification {
  let modifications: [ResponsiveModification]

  func apply(to builder: ResponsiveBuilder) {
    for modification in modifications {
      modification.apply(to: builder)
    }
  }
}
