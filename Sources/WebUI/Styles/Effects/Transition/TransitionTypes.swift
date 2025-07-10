/// Defines properties for CSS transitions.
///
/// Specifies which element properties are animated during transitions.
public enum TransitionProperty: String {
  /// Transitions all animatable properties.
  case all
  /// Transitions color-related properties.
  case colors
  /// Transitions opacity.
  case opacity
  /// Transitions box shadow.
  case shadow
  /// Transitions transform properties.
  case transform
}

/// Defines easing functions for transitions.
///
/// Specifies the timing curve for transition animations.
public enum Easing: String {
  /// Applies a linear timing function.
  case linear
  /// Applies an ease-in timing function.
  case `in`
  /// Applies an ease-out timing function.
  case out
  /// Applies an ease-in-out timing function.
  case inOut = "in-out"
}

// Implementation has been moved to TransitionStyleOperation.swift
