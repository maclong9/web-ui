import Foundation

/// Specifies the type of view transition to apply
public enum ViewTransitionType: String, CaseIterable, Sendable {
    case fade = "fade"
    case slide = "slide"
    case slideUp = "slide-up"
    case slideDown = "slide-down"
    case slideLeft = "slide-left"
    case slideRight = "slide-right"
    case scale = "scale"
    case scaleUp = "scale-up"
    case scaleDown = "scale-down"
    case flip = "flip"
    case flipHorizontal = "flip-horizontal"
    case flipVertical = "flip-vertical"
    case none = "none"
}

/// Specifies the direction for slide transitions
public enum SlideDirection: String, CaseIterable, Sendable {
    case up = "up"
    case down = "down"
    case left = "left"
    case right = "right"
}

/// Specifies the origin point for scale transitions
public enum ScaleOrigin: String, CaseIterable, Sendable {
    case center = "center"
    case top = "top"
    case bottom = "bottom"
    case left = "left"
    case right = "right"
    case topLeft = "top-left"
    case topRight = "top-right"
    case bottomLeft = "bottom-left"
    case bottomRight = "bottom-right"
}

/// Specifies timing function for view transitions
public enum ViewTransitionTiming: String, CaseIterable, Sendable {
    case linear = "linear"
    case easeIn = "ease-in"
    case easeOut = "ease-out"
    case easeInOut = "ease-in-out"
    case circIn = "cubic-bezier(0.55, 0, 1, 0.45)"
    case circOut = "cubic-bezier(0, 0.55, 0.45, 1)"
    case circInOut = "cubic-bezier(0.85, 0, 0.15, 1)"
    case backIn = "cubic-bezier(0.36, 0, 0.66, -0.56)"
    case backOut = "cubic-bezier(0.34, 1.56, 0.64, 1)"
    case backInOut = "cubic-bezier(0.68, -0.6, 0.32, 1.6)"
}

/// Specifies view transition behavior
public enum ViewTransitionBehavior: String, CaseIterable, Sendable {
    case auto = "auto"
    case smooth = "smooth"
    case instant = "instant"
}
