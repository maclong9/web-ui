import Foundation

/// Represents an animatable CSS property with type safety
///
/// `AnimationProperty` defines which CSS properties can be animated and provides
/// type-safe value handling for common animation targets.
///
/// ## Usage
///
/// ```swift
/// let fadeAnimation: [AnimationProperty] = [
///     .opacity(1.0),
///     .transform(.scale(1.1))
/// ]
/// ```
public enum AnimationProperty: Sendable {
    case opacity(Double)
    case transform(Transform)
    case backgroundColor(String)
    case color(String)
    case width(String)
    case height(String)
    case padding(String)
    case margin(String)
    case borderRadius(String)
    case boxShadow(String)
    case filter(String)
    case custom(property: String, value: String)
}

// MARK: - Transform Values

/// Represents CSS transform functions
public enum Transform: Sendable {
    case translate(x: Double, y: Double)
    case translateX(Double)
    case translateY(Double)
    case scale(Double)
    case scaleX(Double)
    case scaleY(Double)
    case rotate(Double) // degrees
    case skew(x: Double, y: Double) // degrees
    case matrix(a: Double, b: Double, c: Double, d: Double, tx: Double, ty: Double)
    case combine([Transform])
    
    /// Converts transform to CSS string
    public var cssValue: String {
        switch self {
        case .translate(let x, let y):
            return "translate(\(x)px, \(y)px)"
        case .translateX(let x):
            return "translateX(\(x)px)"
        case .translateY(let y):
            return "translateY(\(y)px)"
        case .scale(let scale):
            return "scale(\(scale))"
        case .scaleX(let scale):
            return "scaleX(\(scale))"
        case .scaleY(let scale):
            return "scaleY(\(scale))"
        case .rotate(let degrees):
            return "rotate(\(degrees)deg)"
        case .skew(let x, let y):
            return "skew(\(x)deg, \(y)deg)"
        case .matrix(let a, let b, let c, let d, let tx, let ty):
            return "matrix(\(a), \(b), \(c), \(d), \(tx), \(ty))"
        case .combine(let transforms):
            return transforms.map(\.cssValue).joined(separator: " ")
        }
    }
}

// MARK: - Property CSS Generation

extension AnimationProperty {
    /// The CSS property name for this animation property
    public var cssProperty: String {
        switch self {
        case .opacity:
            return "opacity"
        case .transform:
            return "transform"
        case .backgroundColor:
            return "background-color"
        case .color:
            return "color"
        case .width:
            return "width"
        case .height:
            return "height"
        case .padding:
            return "padding"
        case .margin:
            return "margin"
        case .borderRadius:
            return "border-radius"
        case .boxShadow:
            return "box-shadow"
        case .filter:
            return "filter"
        case .custom(let property, _):
            return property
        }
    }
    
    /// The CSS value for this animation property
    public var cssValue: String {
        switch self {
        case .opacity(let value):
            return "\(value)"
        case .transform(let transform):
            return transform.cssValue
        case .backgroundColor(let color):
            return color
        case .color(let color):
            return color
        case .width(let width):
            return width
        case .height(let height):
            return height
        case .padding(let padding):
            return padding
        case .margin(let margin):
            return margin
        case .borderRadius(let radius):
            return radius
        case .boxShadow(let shadow):
            return shadow
        case .filter(let filter):
            return filter
        case .custom(_, let value):
            return value
        }
    }
    
    /// Generates a CSS property declaration
    public var cssDeclaration: String {
        "\(cssProperty): \(cssValue);"
    }
}

// MARK: - Common Property Builders

extension AnimationProperty {
    /// Creates an opacity animation property
    /// - Parameter value: Opacity value between 0.0 and 1.0
    /// - Returns: Opacity animation property
    public static func opacityValue(_ value: Double) -> AnimationProperty {
        .opacity(max(0.0, min(1.0, value)))
    }
    
    /// Creates a translation transform
    /// - Parameters:
    ///   - x: X-axis translation in pixels
    ///   - y: Y-axis translation in pixels
    /// - Returns: Transform animation property
    public static func translate(x: Double = 0, y: Double = 0) -> AnimationProperty {
        .transform(.translate(x: x, y: y))
    }
    
    /// Creates a scale transform
    /// - Parameter scale: Scale factor (1.0 = normal size)
    /// - Returns: Transform animation property
    public static func scale(_ scale: Double) -> AnimationProperty {
        .transform(.scale(scale))
    }
    
    /// Creates a rotation transform
    /// - Parameter degrees: Rotation angle in degrees
    /// - Returns: Transform animation property
    public static func rotate(_ degrees: Double) -> AnimationProperty {
        .transform(.rotate(degrees))
    }
    
    /// Creates a background color property
    /// - Parameter color: CSS color value
    /// - Returns: Background color animation property
    public static func backgroundColorValue(_ color: String) -> AnimationProperty {
        .backgroundColor(color)
    }
    
    /// Creates a text color property
    /// - Parameter color: CSS color value
    /// - Returns: Color animation property
    public static func textColor(_ color: String) -> AnimationProperty {
        .color(color)
    }
}