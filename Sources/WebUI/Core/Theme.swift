import Logging

/// A structure that defines a theme configuration for generating CSS custom properties.
///
/// This is typically used to define design tokens (such as colors, spacing, and typography settings) that
/// can be consumed by a frontend through generated CSS variables.
///
/// The `Theme` struct is highly customizable and supports both standard categories and additional custom ones.
///
/// Example:
///
/// ```swift
/// let theme = Theme(
///   colors: ["primary": "#ff0000", "background": "#ffffff"],
///   spacing: ["sm": "4px", "md": "8px"],
///   custom: ["zIndex": ["modal": "9999", "tooltip": "10000"]]
/// )
/// let css = theme.generateCSS()
/// ```
///
/// The generated CSS string will contain custom properties like:
/// ```css
/// --color-primary: #ff0000;
/// --spacing-sm: 4px;
/// --zindex-modal: 9999;
/// ```
public struct Theme {
  private let logger = Logger(label: "com.webui.theme")

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
  /// All parameters are optional and default to empty dictionaries.
  ///
  /// - Parameters:
  ///   - fonts: Custom font definitions.
  ///   - colors: Color tokens.
  ///   - spacing: Spacing values.
  ///   - breakpoints: Media query breakpoint tokens.
  ///   - container: Layout container sizes.
  ///   - textSizes: Font size tokens.
  ///   - fontWeights: Font weight tokens.
  ///   - tracking: Letter spacing tokens.
  ///   - leading: Line height tokens.
  ///   - radius: Border radius tokens.
  ///   - shadows: Box shadow tokens.
  ///   - insetShadows: Inset box shadow tokens.
  ///   - dropShadows: Drop shadow tokens.
  ///   - blur: Blur effect tokens.
  ///   - perspective: Perspective depth tokens.
  ///   - aspect: Aspect ratio tokens.
  ///   - ease: Transition timing function tokens.
  ///   - custom: Arbitrary custom token categories.
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

    let nonEmptyCount =
      [
        fonts, colors, spacing, breakpoints, container,
        textSizes, fontWeights, tracking, leading, radius,
        shadows, insetShadows, dropShadows, blur, perspective,
        aspect, ease,
      ].filter { !$0.isEmpty }.count + (custom.isEmpty ? 0 : 1)
    logger.debug(
      "Theme initialized with \(nonEmptyCount) non-empty config properties"
    )
  }

  // MARK: - CSS Generation

  /// Generates a CSS snippet containing all defined theme tokens.
  ///
  /// Each token becomes a `--variable-name: value;` line, namespaced by category.
  ///
  /// Example output:
  /// ```css
  /// --color-primary: #ff0000;
  /// --spacing-sm: 4px;
  /// --font-weight-bold: 700;
  /// ```
  ///
  /// - Returns: A formatted `String` containing CSS variable definitions, or an empty string if no properties are defined.
  public func generateCSS() -> String {
    logger.debug("Generating CSS for theme")

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
      logger.trace("No CSS generated due to empty config")
      return ""
    }

    var css = ""
    var propertyCount = 0

    func appendVariables(prefix: String, from dict: [String: String]) {
      for (key, value) in dict {
        css += "  --\(prefix)-\(key.sanitizedForCSS()): \(value);\n"
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
        appendVariables(prefix: category.sanitizedForCSS(), from: values)
      }
    }

    logger.debug("CSS generation completed with \(propertyCount) properties")
    return css
  }

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
