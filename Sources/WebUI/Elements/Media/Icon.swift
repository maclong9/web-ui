import Foundation

/// Creates HTML elements for Lucide icons using the Lucide icon font.
///
/// The Icon component provides a simple way to include Lucide icons in web interfaces.
/// It automatically generates the appropriate CSS classes for the Lucide icon font
/// and supports both enum-based type safety and string-based flexibility.
///
/// ## Usage
/// ```swift
/// Icon(.airplay)                              // Type-safe enum
/// Icon("airplay")                            // String identifier
/// Icon(.heart, classes: ["favorite-icon"])   // With custom styling
/// Icon(.settings, size: .large)              // With predefined size
/// ```
///
/// ## Requirements
/// The Lucide CSS must be included in your document head:
/// ```html
/// <link rel="stylesheet" href="https://unpkg.com/lucide-static@latest/font/lucide.css" />
/// ```
public struct Icon: Element {
  private let icon: LucideIcon
  private let size: IconSize?
  private let id: String?
  private let classes: [String]?
  private let role: AriaRole?
  private let label: String?
  private let data: [String: String]?

  /// Size presets for icons.
  public enum IconSize: String {
    case small = "lucide-sm"  // 16px
    case medium = "lucide-md"  // 20px (default)
    case large = "lucide-lg"  // 24px
    case extraLarge = "lucide-xl"  // 32px

    /// The CSS class name for this icon size.
    public var cssClass: String {
      self.rawValue
    }
  }

  /// Creates a new icon element using a LucideIcon enum value.
  ///
  /// This is the preferred type-safe way to create icons using predefined
  /// Lucide icon identifiers.
  ///
  /// - Parameters:
  ///   - icon: The Lucide icon to display.
  ///   - size: Optional size preset for the icon.
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames for styling the icon.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the icon for accessibility.
  ///   - data: Dictionary of `data-*` attributes for storing custom data.
  ///
  /// ## Example
  /// ```swift
  /// Icon(.airplay)
  /// Icon(.heart, size: .large, classes: ["text-red-500"])
  /// Icon(.settings, label: "Open settings menu")
  /// ```
  public init(
    _ icon: LucideIcon,
    size: IconSize? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil
  ) {
    self.icon = icon
    self.size = size
    self.id = id
    self.classes = classes
    self.role = role
    self.label = label
    self.data = data
  }

  /// Creates a new icon element using a string identifier.
  ///
  /// This initializer provides flexibility for custom or unlisted icons
  /// while maintaining the same API structure.
  ///
  /// - Parameters:
  ///   - iconName: The string identifier for the icon (e.g., "airplay").
  ///   - size: Optional size preset for the icon.
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames for styling the icon.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the icon for accessibility.
  ///   - data: Dictionary of `data-*` attributes for storing custom data.
  ///
  /// ## Example
  /// ```swift
  /// Icon("airplay")
  /// Icon("custom-icon", classes: ["my-custom-style"])
  /// Icon("brand-new-icon", size: .large)
  /// ```
  public init(
    _ iconName: String,
    size: IconSize? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil
  ) {
    self.icon = LucideIcon(rawValue: iconName) ?? LucideIcon.circle
    self.size = size
    self.id = id
    self.classes = classes
    self.role = role
    self.label = label
    self.data = data
  }

  public var body: some Markup {
    MarkupString(content: renderTag())
  }

  private func renderTag() -> String {
    // Build CSS classes for the icon
    var allClasses: [String] = []

    // Add base Lucide icon class
    allClasses.append("lucide")
    allClasses.append(icon.cssClass)

    // Add size class if specified
    if let size = size {
      allClasses.append(size.cssClass)
    }

    // Add custom classes
    if let classes = classes {
      allClasses.append(contentsOf: classes)
    }

    let attributes = AttributeBuilder.buildAttributes(
      id: id,
      classes: allClasses,
      role: role,
      label: label ?? icon.displayName,
      data: data
    )

    // Render as an inline element (i) for icon fonts
    // Using <i> is the standard convention for icon fonts
    return AttributeBuilder.buildMarkupTag(
      "i", attributes: attributes, content: ""
    )
  }
}

// MARK: - Convenience Extensions

extension Icon {
  /// Creates a small icon.
  ///
  /// - Parameters:
  ///   - icon: The Lucide icon to display.
  ///   - classes: Optional custom CSS classes.
  ///   - label: Optional ARIA label.
  /// - Returns: An Icon configured with small size.
  public static func small(
    _ icon: LucideIcon,
    classes: [String]? = nil,
    label: String? = nil
  ) -> Icon {
    Icon(icon, size: .small, classes: classes, label: label)
  }

  /// Creates a large icon.
  ///
  /// - Parameters:
  ///   - icon: The Lucide icon to display.
  ///   - classes: Optional custom CSS classes.
  ///   - label: Optional ARIA label.
  /// - Returns: An Icon configured with large size.
  public static func large(
    _ icon: LucideIcon,
    classes: [String]? = nil,
    label: String? = nil
  ) -> Icon {
    Icon(icon, size: .large, classes: classes, label: label)
  }

  /// Creates an extra large icon.
  ///
  /// - Parameters:
  ///   - icon: The Lucide icon to display.
  ///   - classes: Optional custom CSS classes.
  ///   - label: Optional ARIA label.
  /// - Returns: An Icon configured with extra large size.
  public static func extraLarge(
    _ icon: LucideIcon,
    classes: [String]? = nil,
    label: String? = nil
  ) -> Icon {
    Icon(icon, size: .extraLarge, classes: classes, label: label)
  }
}
