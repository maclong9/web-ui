/// A structure that defines a theme configuration for generating CSS custom properties.
///
/// This is typically used to define design tokens (such as colors, spacing,
/// and typography settings) that can be consumed by a frontend through
/// generated CSS variables. The theme system provides a consistent way to
/// manage design tokens across an entire application.
///
/// The `Theme` struct is highly customizable and supports both standard
/// categories (like colors and spacing) and additional custom categories
/// through the `custom` parameter.
///
/// - Example:
///   ```swift
///   let theme = Theme(
///     colors: ["primary": "#ff0000", "background": "#ffffff"],
///     spacing: ["sm": "4px", "md": "8px"],
///     custom: ["zIndex": ["modal": "9999", "tooltip": "10000"]]
///   )
///   let css = theme.generateCSS()
///   ```
///
/// The generated CSS string will contain custom properties like:
///   ```css
///   --color-primary: #ff0000;
///   --spacing-sm: 4px;
///   --zindex-modal: 9999;
///   ```
///
/// You can use these CSS variables in your HTML elements by referencing them with the `var()` function:
///   ```html
///   <div style="color: var(--color-primary); padding: var(--spacing-sm);">
///     Themed content
///   </div>
///   ```
public struct Theme {
  /// Custom font definitions. Keys are font names or labels, values are CSS font strings.
  public let fonts: [String: String]
  /// Color tokens, using keys as names and values as any valid CSS color.
  public let colors: [String: String]
  /// Spacing values, such as padding and margin sizes.
  public let spacing: [String: String]
  /// Responsive breakpoints, defined as media query sizes (e.g. `768px`).
  public let breakpoints: [String: String]
  /// Container sizes or constraints for layout.
  public let container: [String: String]
  /// Text size tokens, corresponding to font-size values.
  public let textSizes: [String: String]
  /// Font weight tokens, using keys like `bold`, `light`, etc.
  public let fontWeights: [String: String]
  /// Letter spacing tokens.
  public let tracking: [String: String]
  /// Line height tokens.
  public let leading: [String: String]
  /// Border radius tokens.
  public let radius: [String: String]
  /// Standard shadow tokens.
  public let shadows: [String: String]
  /// Inset shadow tokens.
  public let insetShadows: [String: String]
  /// Drop shadow tokens, typically used in `filter` CSS.
  public let dropShadows: [String: String]
  /// Blur tokens, for use in `filter: blur(...)` rules.
  public let blur: [String: String]
  /// Perspective tokens, for 3D transforms.
  public let perspective: [String: String]
  /// Aspect ratio tokens.
  public let aspect: [String: String]
  /// Transition timing functions, like `ease-in`, `ease-out`.
  public let ease: [String: String]
  /// Custom categories of CSS variables, nested by category name.
  public let custom: [String: [String: String]]

  /// Creates a new `Theme` configuration.
  ///
  /// All parameters are optional and default to empty dictionaries. Each
  /// parameter represents a category of design tokens that can be referenced in your CSS.
  ///
  /// - Parameters:
  ///   - fonts: Custom font definitions, such as font families or font stacks.
  ///   - colors: Color tokens for brand colors, text, backgrounds, etc.
  ///   - spacing: Spacing values for margins, padding, and layout gaps.
  ///   - breakpoints: Media query breakpoint tokens for responsive design.
  ///   - container: Layout container sizes for consistent content widths.
  ///   - textSizes: Font size tokens for typography scale.
  ///   - fontWeights: Font weight tokens (e.g., light, normal, bold).
  ///   - tracking: Letter spacing tokens for typography refinement.
  ///   - leading: Line height tokens for text readability.
  ///   - radius: Border radius tokens for consistent corner rounding.
  ///   - shadows: Box shadow tokens for elevation effects.
  ///   - insetShadows: Inset box shadow tokens for inner shadows.
  ///   - dropShadows: Drop shadow tokens for filter-based shadows.
  ///   - blur: Blur effect tokens for glass/frosted effects.
  ///   - perspective: Perspective depth tokens for 3D transformations.
  ///   - aspect: Aspect ratio tokens for consistent media proportions.
  ///   - ease: Transition timing function tokens for animations.
  ///   - custom: Arbitrary custom token categories for any additional design tokens.
  ///
  /// - Example:
  ///   ```swift
  ///   let theme = Theme(
  ///     colors: [
  ///       "primary": "#4A7AFF",
  ///       "secondary": "#FF4A7A",
  ///       "text": "#222222"
  ///     ],
  ///     spacing: [
  ///       "xs": "0.25rem",
  ///       "sm": "0.5rem",
  ///       "md": "1rem",
  ///       "lg": "2rem"
  ///     ],
  ///     radius: [
  ///       "sm": "0.25rem",
  ///       "md": "0.5rem",
  ///       "pill": "9999px"
  ///     ]
  ///   )
  ///   ```
  public init(
    fonts: [String: String] = [:],
    colors: [String: String] = [:],
    spacing: [String: String] = [:],
    breakpoints: [String: String] = [:],
    container: [String: String] = [:],
    textSizes: [String: String] = [:],
    fontWeights: [String: String] = [:],
    tracking: [String: String] = [:],
    leading: [String: String] = [:],
    radius: [String: String] = [:],
    shadows: [String: String] = [:],
    insetShadows: [String: String] = [:],
    dropShadows: [String: String] = [:],
    blur: [String: String] = [:],
    perspective: [String: String] = [:],
    aspect: [String: String] = [:],
    ease: [String: String] = [:],
    custom: [String: [String: String]] = [:]
  ) {
    self.fonts = fonts
    self.colors = colors
    self.spacing = spacing
    self.breakpoints = breakpoints
    self.container = container
    self.textSizes = textSizes
    self.fontWeights = fontWeights
    self.tracking = tracking
    self.leading = leading
    self.radius = radius
    self.shadows = shadows
    self.insetShadows = insetShadows
    self.dropShadows = dropShadows
    self.blur = blur
    self.perspective = perspective
    self.aspect = aspect
    self.ease = ease
    self.custom = custom
  }

  // MARK: - CSS Generation

  /// Generates a CSS snippet containing all defined theme tokens.
  ///
  /// This method converts all the theme tokens into CSS custom properties
  /// (variables), organizing them by category. Each token becomes a
  /// `--variable-name: value;` line, namespaced by its category for clarity
  /// and to prevent naming conflicts.
  ///
  /// - Returns: A formatted `String` containing CSS variable definitions, or
  /// an empty string if no properties are defined.
  ///
  /// - Example output:
  ///   ```css
  ///   --color-primary: #ff0000;
  ///   --spacing-sm: 4px;
  ///   --font-weight-bold: 700;
  ///
  ///   /* Custom Category */
  ///   --custom-category-value: 123;
  ///   ```
  ///
  /// - Note: Custom categories are grouped with a comment header for better readability
  ///   in the generated CSS.
  public func generateCSS() -> String {

    guard
      !(fonts.isEmpty && colors.isEmpty && spacing.isEmpty
        && breakpoints.isEmpty
        && container.isEmpty && textSizes.isEmpty && fontWeights.isEmpty
        && tracking.isEmpty
        && leading.isEmpty && radius.isEmpty && shadows.isEmpty
        && insetShadows.isEmpty
        && dropShadows.isEmpty && blur.isEmpty && perspective.isEmpty
        && aspect.isEmpty
        && ease.isEmpty && custom.isEmpty)
    else {
      return ""
    }

    var css = ""
    var propertyCount = 0

    func appendVariables(prefix: String, from dict: [String: String]) {
      for (key, value) in dict {
        css += "  --\(prefix)-\(key.sanitizedForStyleSheet()): \(value);\n"
        propertyCount += 1
      }
    }

    appendVariables(prefix: "font", from: fonts)
    appendVariables(prefix: "color", from: colors)
    appendVariables(prefix: "spacing", from: spacing)
    appendVariables(prefix: "breakpoint", from: breakpoints)
    appendVariables(prefix: "container", from: container)
    appendVariables(prefix: "text-size", from: textSizes)
    appendVariables(prefix: "font-weight", from: fontWeights)
    appendVariables(prefix: "tracking", from: tracking)
    appendVariables(prefix: "leading", from: leading)
    appendVariables(prefix: "border-radius", from: radius)
    appendVariables(prefix: "shadow", from: shadows)
    appendVariables(prefix: "inset-shadow", from: insetShadows)
    appendVariables(prefix: "drop-shadow", from: dropShadows)
    appendVariables(prefix: "blur", from: blur)
    appendVariables(prefix: "perspective", from: perspective)
    appendVariables(prefix: "aspect", from: aspect)
    appendVariables(prefix: "ease", from: ease)

    if !custom.isEmpty {
      for (category, values) in custom {
        css += "\n  /* \(category.capitalized) */\n"
        appendVariables(
          prefix: category.sanitizedForStyleSheet(), from: values)
      }
    }

    return css
  }

  /// Generates a complete CSS file for the theme with default breakpoints
  /// and dark mode variant.
  ///
  /// This method creates a full CSS file structure that includes:
  /// - Default breakpoint definitions
  /// - All the theme's custom properties from `generateCSS()`
  /// - A dark mode variant selector for theme support
  ///
  /// - Returns: A complete CSS theme file as a String.
  ///
  /// - Example:
  ///   ```swift
  ///   let theme = Theme(colors: ["primary": "#0066ff"])
  ///   let cssFile = theme.generateFile()
  ///   // Write to a file or serve directly
  ///   ```
  public func generateFile() -> String {
    """
    @theme {
      --breakpoint-xs: 30rem;
      --breakpoint-3xl: 120rem;
      --breakpoint-4xl: 160rem;
      \(self.generateCSS())
      @custom-variant dark (&:where([data-theme=dark], [data-theme=dark] *));
    }
    """
  }
}
