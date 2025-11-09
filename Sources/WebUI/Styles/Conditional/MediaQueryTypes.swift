/// Defines media query conditions for responsive and accessibility-aware styling.
///
/// Provides type-safe media query conditions including user preferences and device capabilities.
public enum MediaQuery {
    // MARK: - User Preferences

    /// Matches when user prefers reduced motion
    case prefersReducedMotion

    /// Matches when user has no motion preference
    case prefersMotion

    /// Matches when user prefers dark color scheme
    case prefersDark

    /// Matches when user prefers light color scheme
    case prefersLight

    /// Matches when user prefers high contrast
    case prefersContrast

    // MARK: - Screen Size

    /// Matches screens with minimum width
    case minWidth(Int)

    /// Matches screens with maximum width
    case maxWidth(Int)

    /// Matches screens with minimum height
    case minHeight(Int)

    /// Matches screens with maximum height
    case maxHeight(Int)

    // MARK: - Device Capabilities

    /// Matches devices with hover capability
    case canHover

    /// Matches devices without hover capability
    case cannotHover

    /// Matches high-resolution displays (retina, etc.)
    case highResolution

    /// Matches print media
    case print

    /// Matches screen media
    case screen

    // MARK: - Orientation

    /// Matches portrait orientation
    case portrait

    /// Matches landscape orientation
    case landscape

    // MARK: - Custom

    /// Custom media query string
    case custom(String)

    /// Renders the media query as a CSS media query string
    public var query: String {
        switch self {
        // User Preferences
        case .prefersReducedMotion:
            return "(prefers-reduced-motion: reduce)"
        case .prefersMotion:
            return "(prefers-reduced-motion: no-preference)"
        case .prefersDark:
            return "(prefers-color-scheme: dark)"
        case .prefersLight:
            return "(prefers-color-scheme: light)"
        case .prefersContrast:
            return "(prefers-contrast: more)"

        // Screen Size
        case .minWidth(let px):
            return "(min-width: \(px)px)"
        case .maxWidth(let px):
            return "(max-width: \(px)px)"
        case .minHeight(let px):
            return "(min-height: \(px)px)"
        case .maxHeight(let px):
            return "(max-height: \(px)px)"

        // Device Capabilities
        case .canHover:
            return "(hover: hover)"
        case .cannotHover:
            return "(hover: none)"
        case .highResolution:
            return "(min-resolution: 2dppx)"
        case .print:
            return "print"
        case .screen:
            return "screen"

        // Orientation
        case .portrait:
            return "(orientation: portrait)"
        case .landscape:
            return "(orientation: landscape)"

        // Custom
        case .custom(let query):
            return query
        }
    }
}

/// Defines feature query conditions for CSS feature detection.
///
/// Provides type-safe @supports feature queries for progressive enhancement.
public enum FeatureQuery {
    /// Check if backdrop-filter is supported
    case backdropFilter

    /// Check if CSS grid is supported
    case grid

    /// Check if flexbox is supported
    case flexbox

    /// Check if sticky positioning is supported
    case sticky

    /// Check if custom properties (CSS variables) are supported
    case customProperties

    /// Check if aspect-ratio is supported
    case aspectRatio

    /// Check if container queries are supported
    case containerQueries

    /// Check if a specific CSS property with value is supported
    case property(name: String, value: String)

    /// Custom feature query
    case custom(String)

    /// Renders the feature query as a CSS @supports query string
    public var query: String {
        switch self {
        case .backdropFilter:
            return "(backdrop-filter: blur(1px)) or (-webkit-backdrop-filter: blur(1px))"
        case .grid:
            return "(display: grid)"
        case .flexbox:
            return "(display: flex)"
        case .sticky:
            return "(position: sticky)"
        case .customProperties:
            return "(--custom: value)"
        case .aspectRatio:
            return "(aspect-ratio: 1/1)"
        case .containerQueries:
            return "(container-type: inline-size)"
        case .property(let name, let value):
            return "(\(name): \(value))"
        case .custom(let query):
            return query
        }
    }
}
