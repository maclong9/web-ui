/// Defines scroll behavior for an element.
///
/// Specifies how scrolling behaves, either smoothly or instantly.
public enum ScrollBehavior: String {
  /// Smooth scrolling behavior
  case smooth = "smooth"
  /// Instant scrolling behavior
  case auto = "auto"
}

/// Defines scroll snap alignment options.
///
/// Specifies how an element aligns within a scroll container.
public enum ScrollSnapAlign: String {
  /// Aligns to the start of the snap container
  case start
  /// Aligns to the end of the snap container
  case end
  /// Aligns to the center of the snap container
  case center
}

/// Defines scroll snap stop behavior.
///
/// Controls whether scrolling can skip past snap points.
public enum ScrollSnapStop: String {
  /// Allows scrolling to skip snap points
  case normal = "normal"
  /// Forces scrolling to stop at snap points
  case always = "always"
}

/// Defines scroll snap type options.
///
/// Specifies the type and strictness of scroll snapping.
public enum ScrollSnapType: String {
  /// Snap along the x-axis
  case x = "x"
  /// Snap along the y-axis
  case y = "y"
  /// Snap along both axes
  case both = "both"
  /// Mandatory snapping with stricter enforcement
  case mandatory = "mandatory"
  /// Proximity snapping with looser enforcement
  case proximity = "proximity"
}

// Implementation has been moved to ScrollStyleOperation.swift
