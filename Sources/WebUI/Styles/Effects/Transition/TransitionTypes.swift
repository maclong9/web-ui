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
/// Specifies the timing curve for transition animations, including custom cubic-bezier curves.
public enum Easing {
    /// Applies a linear timing function.
    case linear
    /// Applies an ease-in timing function.
    case `in`
    /// Applies an ease-out timing function.
    case out
    /// Applies an ease-in-out timing function.
    case inOut
    /// Custom cubic-bezier timing function (x1, y1, x2, y2)
    case cubicBezier(Double, Double, Double, Double)

    public var value: String {
        switch self {
        case .linear: return "linear"
        case .in: return "in"
        case .out: return "out"
        case .inOut: return "in-out"
        case .cubicBezier(let x1, let y1, let x2, let y2):
            return "cubic-bezier(\(x1),\(y1),\(x2),\(y2))"
        }
    }
}

// Implementation has been moved to TransitionStyleOperation.swift
