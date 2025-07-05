import Foundation

/// Theme system for the WebUI component library providing consistent styling patterns.
///
/// `ComponentTheme` establishes a design system with minimal structural CSS that focuses on:
/// - Layout and positioning
/// - Spacing and sizing
/// - Structure without decoration
/// - Consistent design tokens
/// - Accessibility compliance
///
/// ## Design Tokens
///
/// The theme uses CSS custom properties (CSS variables) for consistency:
/// - Spacing scale (4px base unit)
/// - Typography scale 
/// - Border radius values
/// - Shadow definitions
/// - Z-index layering
///
/// ## Usage
///
/// ```swift
/// let theme = ComponentTheme.default
/// let buttonStyles = theme.button.primary.large
/// ```
public struct ComponentTheme: Sendable {
    /// Spacing scale using 4px base unit
    public let spacing: SpacingScale
    
    /// Typography definitions
    public let typography: TypographyScale
    
    /// Border radius values
    public let radius: RadiusScale
    
    /// Shadow definitions
    public let shadows: ShadowScale
    
    /// Z-index layering system
    public let zIndex: ZIndexScale
    
    /// Component-specific style definitions
    public let components: ComponentStyleDefinitions
    
    public init(
        spacing: SpacingScale = .default,
        typography: TypographyScale = .default,
        radius: RadiusScale = .default,
        shadows: ShadowScale = .default,
        zIndex: ZIndexScale = .default,
        components: ComponentStyleDefinitions = .default
    ) {
        self.spacing = spacing
        self.typography = typography
        self.radius = radius
        self.shadows = shadows
        self.zIndex = zIndex
        self.components = components
    }
    
    /// Default theme configuration
    public static let `default` = ComponentTheme()
    
    /// Generates CSS custom properties for this theme
    public func generateCSS() -> String {
        return """
        :root {
        \(spacing.cssVariables)
        \(typography.cssVariables)
        \(radius.cssVariables)
        \(shadows.cssVariables)
        \(zIndex.cssVariables)
        }
        
        \(components.generateCSS())
        """
    }
}

// MARK: - Spacing Scale

/// Spacing scale using 4px base unit (0, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 80, 96, 128)
public struct SpacingScale: Sendable {
    public let unit0: String = "0"
    public let unit1: String = "0.25rem"  // 4px
    public let unit2: String = "0.5rem"   // 8px
    public let unit3: String = "0.75rem"  // 12px
    public let unit4: String = "1rem"     // 16px
    public let unit5: String = "1.25rem"  // 20px
    public let unit6: String = "1.5rem"   // 24px
    public let unit8: String = "2rem"     // 32px
    public let unit10: String = "2.5rem"  // 40px
    public let unit12: String = "3rem"    // 48px
    public let unit16: String = "4rem"    // 64px
    public let unit20: String = "5rem"    // 80px
    public let unit24: String = "6rem"    // 96px
    public let unit32: String = "8rem"    // 128px
    
    public static let `default` = SpacingScale()
    
    public var cssVariables: String {
        return """
          --spacing-0: \(unit0);
          --spacing-1: \(unit1);
          --spacing-2: \(unit2);
          --spacing-3: \(unit3);
          --spacing-4: \(unit4);
          --spacing-5: \(unit5);
          --spacing-6: \(unit6);
          --spacing-8: \(unit8);
          --spacing-10: \(unit10);
          --spacing-12: \(unit12);
          --spacing-16: \(unit16);
          --spacing-20: \(unit20);
          --spacing-24: \(unit24);
          --spacing-32: \(unit32);
        """
    }
}

// MARK: - Typography Scale

/// Typography scale with consistent sizing and line heights
public struct TypographyScale: Sendable {
    public let textXs: TypographyDefinition = TypographyDefinition(fontSize: "0.75rem", lineHeight: "1rem")
    public let textSm: TypographyDefinition = TypographyDefinition(fontSize: "0.875rem", lineHeight: "1.25rem")
    public let textBase: TypographyDefinition = TypographyDefinition(fontSize: "1rem", lineHeight: "1.5rem")
    public let textLg: TypographyDefinition = TypographyDefinition(fontSize: "1.125rem", lineHeight: "1.75rem")
    public let textXl: TypographyDefinition = TypographyDefinition(fontSize: "1.25rem", lineHeight: "1.75rem")
    public let text2Xl: TypographyDefinition = TypographyDefinition(fontSize: "1.5rem", lineHeight: "2rem")
    public let text3Xl: TypographyDefinition = TypographyDefinition(fontSize: "1.875rem", lineHeight: "2.25rem")
    public let text4Xl: TypographyDefinition = TypographyDefinition(fontSize: "2.25rem", lineHeight: "2.5rem")
    
    public static let `default` = TypographyScale()
    
    public var cssVariables: String {
        return """
          --text-xs-size: \(textXs.fontSize);
          --text-xs-height: \(textXs.lineHeight);
          --text-sm-size: \(textSm.fontSize);
          --text-sm-height: \(textSm.lineHeight);
          --text-base-size: \(textBase.fontSize);
          --text-base-height: \(textBase.lineHeight);
          --text-lg-size: \(textLg.fontSize);
          --text-lg-height: \(textLg.lineHeight);
          --text-xl-size: \(textXl.fontSize);
          --text-xl-height: \(textXl.lineHeight);
          --text-2xl-size: \(text2Xl.fontSize);
          --text-2xl-height: \(text2Xl.lineHeight);
          --text-3xl-size: \(text3Xl.fontSize);
          --text-3xl-height: \(text3Xl.lineHeight);
          --text-4xl-size: \(text4Xl.fontSize);
          --text-4xl-height: \(text4Xl.lineHeight);
        """
    }
}

public struct TypographyDefinition: Sendable {
    public let fontSize: String
    public let lineHeight: String
    
    public init(fontSize: String, lineHeight: String) {
        self.fontSize = fontSize
        self.lineHeight = lineHeight
    }
}

// MARK: - Radius Scale

/// Border radius scale for consistent rounded corners
public struct RadiusScale: Sendable {
    public let none: String = "0"
    public let sm: String = "0.125rem"  // 2px
    public let base: String = "0.25rem" // 4px
    public let md: String = "0.375rem"  // 6px
    public let lg: String = "0.5rem"    // 8px
    public let xl: String = "0.75rem"   // 12px
    public let xl2: String = "1rem"     // 16px
    public let xl3: String = "1.5rem"   // 24px
    public let full: String = "9999px"
    
    public static let `default` = RadiusScale()
    
    public var cssVariables: String {
        return """
          --radius-none: \(none);
          --radius-sm: \(sm);
          --radius-base: \(base);
          --radius-md: \(md);
          --radius-lg: \(lg);
          --radius-xl: \(xl);
          --radius-2xl: \(xl2);
          --radius-3xl: \(xl3);
          --radius-full: \(full);
        """
    }
}

// MARK: - Shadow Scale

/// Shadow definitions for depth and elevation
public struct ShadowScale: Sendable {
    public let none: String = "none"
    public let sm: String = "0 1px 2px 0 rgba(0, 0, 0, 0.05)"
    public let base: String = "0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06)"
    public let md: String = "0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)"
    public let lg: String = "0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)"
    public let xl: String = "0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)"
    public let xl2: String = "0 25px 50px -12px rgba(0, 0, 0, 0.25)"
    public let inner: String = "inset 0 2px 4px 0 rgba(0, 0, 0, 0.06)"
    
    public static let `default` = ShadowScale()
    
    public var cssVariables: String {
        return """
          --shadow-none: \(none);
          --shadow-sm: \(sm);
          --shadow-base: \(base);
          --shadow-md: \(md);
          --shadow-lg: \(lg);
          --shadow-xl: \(xl);
          --shadow-2xl: \(xl2);
          --shadow-inner: \(inner);
        """
    }
}

// MARK: - Z-Index Scale

/// Z-index layering system for consistent stacking
public struct ZIndexScale: Sendable {
    public let base: Int = 0
    public let dropdown: Int = 1000
    public let sticky: Int = 1020
    public let fixed: Int = 1030
    public let backdrop: Int = 1040
    public let modal: Int = 1050
    public let popover: Int = 1060
    public let tooltip: Int = 1070
    public let toast: Int = 1080
    
    public static let `default` = ZIndexScale()
    
    public var cssVariables: String {
        return """
          --z-base: \(base);
          --z-dropdown: \(dropdown);
          --z-sticky: \(sticky);
          --z-fixed: \(fixed);
          --z-backdrop: \(backdrop);
          --z-modal: \(modal);
          --z-popover: \(popover);
          --z-tooltip: \(tooltip);
          --z-toast: \(toast);
        """
    }
}

// MARK: - Component Style Definitions

/// Container for all component-specific style definitions
public struct ComponentStyleDefinitions: Sendable {
    public let button: ButtonStyles
    public let input: InputStyles
    public let card: CardStyles
    public let badge: BadgeStyles
    public let alert: AlertStyles
    
    public init(
        button: ButtonStyles = .default,
        input: InputStyles = .default,
        card: CardStyles = .default,
        badge: BadgeStyles = .default,
        alert: AlertStyles = .default
    ) {
        self.button = button
        self.input = input
        self.card = card
        self.badge = badge
        self.alert = alert
    }
    
    public static let `default` = ComponentStyleDefinitions()
    
    public func generateCSS() -> String {
        return """
        \(button.generateCSS())
        \(input.generateCSS())
        \(card.generateCSS())
        \(badge.generateCSS())
        \(alert.generateCSS())
        """
    }
}

// MARK: - Button Styles

public struct ButtonStyles: Sendable {
    public static let `default` = ButtonStyles()
    
    public func generateCSS() -> String {
        return """
        /* Button Base Styles - Structure Only */
        .btn {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          position: relative;
          text-decoration: none;
          border: 1px solid transparent;
          cursor: pointer;
          user-select: none;
          transition: all 0.2s;
        }
        
        .btn:disabled {
          cursor: not-allowed;
          opacity: 0.5;
        }
        
        .btn:focus {
          outline: 2px solid transparent;
          outline-offset: 2px;
        }
        
        /* Button Sizes */
        .btn.size-xs {
          height: 1.5rem;
          padding: 0 var(--spacing-2);
          font-size: var(--text-xs-size);
          line-height: var(--text-xs-height);
          border-radius: var(--radius-sm);
        }
        
        .btn.size-sm {
          height: 2rem;
          padding: 0 var(--spacing-3);
          font-size: var(--text-sm-size);
          line-height: var(--text-sm-height);
          border-radius: var(--radius-base);
        }
        
        .btn.size-md {
          height: 2.5rem;
          padding: 0 var(--spacing-4);
          font-size: var(--text-base-size);
          line-height: var(--text-base-height);
          border-radius: var(--radius-md);
        }
        
        .btn.size-lg {
          height: 3rem;
          padding: 0 var(--spacing-6);
          font-size: var(--text-lg-size);
          line-height: var(--text-lg-height);
          border-radius: var(--radius-lg);
        }
        
        .btn.size-xl {
          height: 3.5rem;
          padding: 0 var(--spacing-8);
          font-size: var(--text-xl-size);
          line-height: var(--text-xl-height);
          border-radius: var(--radius-xl);
        }
        """
    }
}

// MARK: - Input Styles

public struct InputStyles: Sendable {
    public static let `default` = InputStyles()
    
    public func generateCSS() -> String {
        return """
        /* Input Base Styles - Structure Only */
        .input {
          display: block;
          width: 100%;
          border: 1px solid;
          border-radius: var(--radius-md);
          transition: all 0.2s;
        }
        
        .input:focus {
          outline: 2px solid transparent;
          outline-offset: 2px;
        }
        
        .input:disabled {
          cursor: not-allowed;
          opacity: 0.5;
        }
        
        /* Input Sizes */
        .input.size-sm {
          height: 2rem;
          padding: 0 var(--spacing-3);
          font-size: var(--text-sm-size);
        }
        
        .input.size-md {
          height: 2.5rem;
          padding: 0 var(--spacing-4);
          font-size: var(--text-base-size);
        }
        
        .input.size-lg {
          height: 3rem;
          padding: 0 var(--spacing-4);
          font-size: var(--text-lg-size);
        }
        """
    }
}

// MARK: - Card Styles

public struct CardStyles: Sendable {
    public static let `default` = CardStyles()
    
    public func generateCSS() -> String {
        return """
        /* Card Base Styles - Structure Only */
        .card {
          display: block;
          border: 1px solid;
          border-radius: var(--radius-lg);
          overflow: hidden;
        }
        
        .card-header {
          padding: var(--spacing-6);
          border-bottom: 1px solid;
        }
        
        .card-content {
          padding: var(--spacing-6);
        }
        
        .card-footer {
          padding: var(--spacing-6);
          border-top: 1px solid;
        }
        """
    }
}

// MARK: - Badge Styles

public struct BadgeStyles: Sendable {
    public static let `default` = BadgeStyles()
    
    public func generateCSS() -> String {
        return """
        /* Badge Base Styles - Structure Only */
        .badge {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          border-radius: var(--radius-full);
          font-weight: 500;
          line-height: 1;
        }
        
        .badge.size-sm {
          height: 1.25rem;
          padding: 0 var(--spacing-2);
          font-size: var(--text-xs-size);
        }
        
        .badge.size-md {
          height: 1.5rem;
          padding: 0 var(--spacing-3);
          font-size: var(--text-sm-size);
        }
        
        .badge.size-lg {
          height: 2rem;
          padding: 0 var(--spacing-4);
          font-size: var(--text-base-size);
        }
        """
    }
}

// MARK: - Alert Styles

public struct AlertStyles: Sendable {
    public static let `default` = AlertStyles()
    
    public func generateCSS() -> String {
        return """
        /* Alert Base Styles - Structure Only */
        .alert {
          display: flex;
          padding: var(--spacing-4);
          border: 1px solid;
          border-radius: var(--radius-md);
        }
        
        .alert-icon {
          flex-shrink: 0;
          margin-right: var(--spacing-3);
        }
        
        .alert-content {
          flex: 1;
          min-width: 0;
        }
        
        .alert-title {
          font-weight: 600;
          margin-bottom: var(--spacing-1);
        }
        
        .alert-description {
          font-size: var(--text-sm-size);
          line-height: var(--text-sm-height);
        }
        """
    }
}