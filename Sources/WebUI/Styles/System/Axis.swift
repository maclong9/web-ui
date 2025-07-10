//
//  Axis.swift
//  web-ui
//
//  Created by Mac Long on 2025.05.25.
//

/// Defines axes for applying overflow, scroll, or spacing behavior.
///
/// Represents the direction(s) in which various layout rules are applied,
/// such as overflow handling, scroll behavior, or spacing between child elements.
///
/// ## Example
/// ```swift
/// Stack()
///   .overflow(.hidden, axis: .horizontal)  // Hide horizontal overflow only
///   .spacing(.y, length: 4)      // Add vertical spacing between children
/// ```
public enum Axis: String {
  /// Applies to the horizontal (x) axis only.
  ///
  /// Use when you need to control behavior along the left-right direction.
  case horizontal = "x"

  /// Applies to the vertical (y) axis only.
  ///
  /// Use when you need to control behavior along the top-bottom direction.
  case vertical = "y"

  /// Applies to both horizontal and vertical axes simultaneously.
  ///
  /// Use when you need to apply the same behavior in both directions.
  case both = ""
}
