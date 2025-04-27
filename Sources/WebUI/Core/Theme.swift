public struct ThemeConfig {
  let fonts: [String: String]
  let colors: [String: String]
  let spacing: [String: String]
  let breakpoints: [String: String]
  let container: [String: String]
  let textSizes: [String: String]
  let fontWeights: [String: String]
  let tracking: [String: String]
  let leading: [String: String]
  let radius: [String: String]
  let shadows: [String: String]
  let insetShadows: [String: String]
  let dropShadows: [String: String]
  let blur: [String: String]
  let perspective: [String: String]
  let aspect: [String: String]
  let ease: [String: String]
  let custom: [String: [String: String]]

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
}

public struct Theme {
  let config: ThemeConfig

  public init(config: ThemeConfig = ThemeConfig()) {
    self.config = config
  }

  // MARK: - CSS Generation

  /// Generates a CSS snippet with custom properties for the theme
  public func generateCSS() -> String {
    guard
      !(config.fonts.isEmpty && config.colors.isEmpty && config.spacing.isEmpty && config.breakpoints.isEmpty && config.container.isEmpty
        && config.textSizes.isEmpty && config.fontWeights.isEmpty && config.tracking.isEmpty && config.leading.isEmpty
        && config.radius.isEmpty && config.shadows.isEmpty && config.insetShadows.isEmpty && config.dropShadows.isEmpty
        && config.blur.isEmpty && config.perspective.isEmpty && config.aspect.isEmpty && config.ease.isEmpty && config.custom.isEmpty)
    else {
      return ""
    }

    var css = "@theme {\n"

    // Fonts
    for (key, value) in config.fonts {
      css += "  --font-\(key.sanitizedForCSS()): \(value);\n"
    }

    // Colors
    for (key, value) in config.colors {
      css += "  --color-\(key.sanitizedForCSS()): \(value);\n"
    }

    // Spacing
    for (key, value) in config.spacing {
      css += "  --spacing-\(key.sanitizedForCSS()): \(value);\n"
    }

    // Breakpoints
    for (key, value) in config.breakpoints {
      css += "  --breakpoint-\(key.sanitizedForCSS()): \(value);\n"
    }

    // Container
    for (key, value) in config.container {
      css += "  --container-\(key.sanitizedForCSS()): \(value);\n"
    }

    // Text Sizes
    for (key, value) in config.textSizes {
      css += "  --text-size-\(key.sanitizedForCSS()): \(value);\n"
    }

    // Font Weights
    for (key, value) in config.fontWeights {
      css += "  --font-weight-\(key.sanitizedForCSS()): \(value);\n"
    }

    // Tracking (Letter Spacing)
    for (key, value) in config.tracking {
      css += "  --tracking-\(key.sanitizedForCSS()): \(value);\n"
    }

    // Leading (Line Height)
    for (key, value) in config.leading {
      css += "  --leading-\(key.sanitizedForCSS()): \(value);\n"
    }

    // Radius (Border Radius)
    for (key, value) in config.radius {
      css += "  --border-radius-\(key.sanitizedForCSS()): \(value);\n"
    }

    // Shadows (Box Shadow)
    for (key, value) in config.shadows {
      css += "  --shadow-\(key.sanitizedForCSS()): \(value);\n"
    }

    // Inset Shadows
    for (key, value) in config.insetShadows {
      css += "  --inset-shadow-\(key.sanitizedForCSS()): \(value);\n"
    }

    // Drop Shadows
    for (key, value) in config.dropShadows {
      css += "  --drop-shadow-\(key.sanitizedForCSS()): \(value);\n"
    }

    // Blur
    for (key, value) in config.blur {
      css += "  --blur-\(key.sanitizedForCSS()): \(value);\n"
    }

    // Perspective
    for (key, value) in config.perspective {
      css += "  --perspective-\(key.sanitizedForCSS()): \(value);\n"
    }

    // Aspect Ratio
    for (key, value) in config.aspect {
      css += "  --aspect-\(key.sanitizedForCSS()): \(value);\n"
    }

    // Ease (Transition Timing Function)
    for (key, value) in config.ease {
      css += "  --ease-\(key.sanitizedForCSS()): \(value);\n"
    }

    // Custom Categories
    if !config.custom.isEmpty {
      for (category, values) in config.custom {
        css += "\n  /* \(category.capitalized) */\n"
        for (key, value) in values {
          css += "  --\(category.sanitizedForCSS())-\(key.sanitizedForCSS()): \(value);\n"
        }
      }
    }

    css += "}"
    return css
  }
}
