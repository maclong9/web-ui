import CoreGraphics

/// Represents sizing options for elements.
public enum SizingValue: Sendable {
  /// Fixed size in spacing units (e.g., w-4)
  case spacing(Int)
  /// Fractional size (e.g., w-1/2)
  case fraction(Int, Int)
  /// Container width presets
  case container(ContainerSize)
  /// Special viewport units
  case viewport(ViewportUnit)
  /// Predefined size constants
  case constant(SizeConstant)
  /// Content-based sizing
  case content(ContentSize)
  /// Character-based width (e.g., 60ch)
  case character(Int)
  /// Custom CSS value
  case custom(String)

  /// Represents container size presets available in Tailwind CSS
  public enum ContainerSize: String, Sendable {
    case threeExtraSmall = "3xs"
    case twoExtraSmall = "2xs"
    case extraSmall = "xs"
    case small = "sm"
    case medium = "md"
    case large = "lg"
    case extraLarge = "xl"
    case twoExtraLarge = "2xl"
    case threeExtraLarge = "3xl"
    case fourExtraLarge = "4xl"
    case fiveExtraLarge = "5xl"
    case sixExtraLarge = "6xl"
    case sevenExtraLarge = "7xl"
  }

  /// Represents viewport sizing units available in Tailwind CSS
  public enum ViewportUnit: String, Sendable {
    case viewWidth = "screen"
    case dynamicViewWidth = "dvw"
    case largeViewWidth = "lvw"
    case smallViewWidth = "svw"
    case dynamicViewHeight = "dvh"
    case largeViewHeight = "lvh"
    case smallViewHeight = "svh"
  }

  /// Represents constant size values available in Tailwind CSS
  public enum SizeConstant: String, Sendable {
    case auto = "auto"
    case px = "px"
    case full = "full"
  }

  /// Represents content-based sizing available in Tailwind CSS
  public enum ContentSize: String, Sendable {
    case min = "min"
    case max = "max"
    case fit = "fit"
  }

  public var rawValue: String {
    switch self {
    case .spacing(let value):
      return "\(value)"
    case .fraction(let numerator, let denominator):
      return "\(numerator)/\(denominator)"
    case .container(let size):
      return size.rawValue
    case .viewport(let unit):
      return unit.rawValue
    case .constant(let constant):
      return constant.rawValue
    case .content(let content):
      return content.rawValue
    case .character(let value):
      return "[\(value)ch]"
    case .custom(let value):
      return "[\(value)]"
    }
  }
}

extension Element {
  /// Sets the width and height of the element with comprehensive SwiftUI-like API.
  ///
  /// This method provides control over all width and height properties, supporting
  /// all Tailwind CSS sizing options including numeric values, fractions, container sizes,
  /// viewport units, constants, content-based sizing, and custom values.
  ///
  /// - Parameters:
  ///   - width: The width value.
  ///   - height: The height value.
  ///   - minWidth: The minimum width value.
  ///   - maxWidth: The maximum width value.
  ///   - minHeight: The minimum height value.
  ///   - maxHeight: The maximum height value.
  ///   - modifiers: Zero or more modifiers (e.g., `.hover`, `.md`) to scope the styles.
  /// - Returns: A new element with updated sizing classes.
  public func frame(
    width: SizingValue? = nil,
    height: SizingValue? = nil,
    minWidth: SizingValue? = nil,
    maxWidth: SizingValue? = nil,
    minHeight: SizingValue? = nil,
    maxHeight: SizingValue? = nil,
    on modifiers: Modifier...
  ) -> Element {
    var baseClasses: [String] = []

    if let width = width { baseClasses.append("w-\(width.rawValue)") }
    if let height = height { baseClasses.append("h-\(height.rawValue)") }
    if let minWidth = minWidth { baseClasses.append("min-w-\(minWidth.rawValue)") }
    if let maxWidth = maxWidth { baseClasses.append("max-w-\(maxWidth.rawValue)") }
    if let minHeight = minHeight { baseClasses.append("min-h-\(minHeight.rawValue)") }
    if let maxHeight = maxHeight { baseClasses.append("max-h-\(maxHeight.rawValue)") }

    let newClasses = combineClasses(baseClasses, withModifiers: modifiers)

    return Element(
      tag: self.tag,
      id: self.id,
      classes: (self.classes ?? []) + newClasses,
      role: self.role,
      label: self.label,
      isSelfClosing: self.isSelfClosing,
      customAttributes: self.customAttributes,
      content: self.contentBuilder
    )
  }

  /// Sets both width and height to the same value, creating a square element.
  ///
  /// This method applies the same sizing value to both width and height dimensions.
  ///
  /// - Parameters:
  ///   - size: The size value to apply to both width and height.
  ///   - modifiers: Zero or more modifiers to scope the styles.
  /// - Returns: A new element with updated sizing classes.
  public func size(_ size: SizingValue, on modifiers: Modifier...) -> Element {
    var baseClasses: [String] = []
    baseClasses.append("size-\(size.rawValue)")

    let newClasses = combineClasses(baseClasses, withModifiers: modifiers)

    return Element(
      tag: self.tag,
      id: self.id,
      classes: (self.classes ?? []) + newClasses,
      role: self.role,
      label: self.label,
      isSelfClosing: self.isSelfClosing,
      customAttributes: self.customAttributes,
      content: self.contentBuilder
    )
  }

  /// Sets the width and height of the element using numeric values.
  ///
  /// This method provides a simplified SwiftUI-compatible signature for setting frame dimensions.
  ///
  /// - Parameters:
  ///   - width: The width in spacing units.
  ///   - height: The height in spacing units.
  ///   - minWidth: The minimum width in spacing units.
  ///   - maxWidth: The maximum width in spacing units.
  ///   - minHeight: The minimum height in spacing units.
  ///   - maxHeight: The maximum height in spacing units.
  /// - Returns: A new element with updated sizing classes.
  public func frame(
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    minWidth: CGFloat? = nil,
    maxWidth: CGFloat? = nil,
    minHeight: CGFloat? = nil,
    maxHeight: CGFloat? = nil
  ) -> Element {
    frame(
      width: width.map { .spacing(Int($0)) },
      height: height.map { .spacing(Int($0)) },
      minWidth: minWidth.map { .spacing(Int($0)) },
      maxWidth: maxWidth.map { .spacing(Int($0)) },
      minHeight: minHeight.map { .spacing(Int($0)) },
      maxHeight: maxHeight.map { .spacing(Int($0)) }
    )
  }

  /// Creates a frame that maintains the specified aspect ratio.
  ///
  /// Follows the SwiftUI pattern for creating frames with a fixed aspect ratio.
  ///
  /// - Parameters:
  ///   - width: The width for the aspect ratio calculation.
  ///   - height: The height for the aspect ratio calculation.
  ///   - modifiers: Zero or more modifiers to scope the styles.
  /// - Returns: A new element with aspect ratio classes.
  public func aspectRatio(_ width: CGFloat, _ height: CGFloat, on modifiers: Modifier...) -> Element {
    let ratio = width / height
    let baseClass = "aspect-[\(ratio)]"
    let newClasses = combineClasses([baseClass], withModifiers: modifiers)

    return Element(
      tag: self.tag,
      id: self.id,
      classes: (self.classes ?? []) + newClasses,
      role: self.role,
      label: self.label,
      isSelfClosing: self.isSelfClosing,
      customAttributes: self.customAttributes,
      content: self.contentBuilder
    )
  }

  /// Sets the aspect ratio to square (1:1).
  ///
  /// - Parameters:
  ///   - modifiers: Zero or more modifiers to scope the styles.
  /// - Returns: A new element with square aspect ratio.
  public func aspectRatio(on modifiers: Modifier...) -> Element {
    let baseClass = "aspect-square"
    let newClasses = combineClasses([baseClass], withModifiers: modifiers)

    return Element(
      tag: self.tag,
      id: self.id,
      classes: (self.classes ?? []) + newClasses,
      role: self.role,
      label: self.label,
      isSelfClosing: self.isSelfClosing,
      customAttributes: self.customAttributes,
      content: self.contentBuilder
    )
  }

  /// Sets the aspect ratio to video dimensions (16:9).
  ///
  /// - Parameters:
  ///   - modifiers: Zero or more modifiers to scope the styles.
  /// - Returns: A new element with video aspect ratio.
  public func aspectRatioVideo(on modifiers: Modifier...) -> Element {
    let baseClass = "aspect-video"
    let newClasses = combineClasses([baseClass], withModifiers: modifiers)

    return Element(
      tag: self.tag,
      id: self.id,
      classes: (self.classes ?? []) + newClasses,
      role: self.role,
      label: self.label,
      isSelfClosing: self.isSelfClosing,
      customAttributes: self.customAttributes,
      content: self.contentBuilder
    )
  }
}

// MARK: - Convenience Extensions for Improved SwiftUI-like Experience

extension CGFloat {
  /// Converts the CGFloat to a fixed spacing SizingValue.
  public var spacing: SizingValue {
    .spacing(Int(self))
  }
}

extension Int {
  /// Converts the Int to a fixed spacing SizingValue.
  public var spacing: SizingValue {
    .spacing(self)
  }

  /// Creates a fraction SizingValue with this int as the numerator.
  ///
  /// - Parameter denominator: The denominator of the fraction.
  /// - Returns: A SizingValue representing the fraction.
  public func fraction(_ denominator: Int) -> SizingValue {
    .fraction(self, denominator)
  }

  /// Creates a character width SizingValue.
  public var ch: SizingValue {
    .character(self)
  }
}

// MARK: - Static Sizing Constants for SwiftUI-like API

extension SizingValue {
  /// Width/height set to auto
  public static let auto: SizingValue = .constant(.auto)

  /// Width/height set to 1px
  public static let px: SizingValue = .constant(.px)

  /// Width/height set to 100%
  public static let full: SizingValue = .constant(.full)

  /// Width/height set to screen viewport
  public static let screen: SizingValue = .viewport(.viewWidth)

  /// Width/height set to dynamic viewport width
  public static let dvw: SizingValue = .viewport(.dynamicViewWidth)

  /// Width/height set to dynamic viewport height
  public static let dvh: SizingValue = .viewport(.dynamicViewHeight)

  /// Width/height set to large viewport width
  public static let lvw: SizingValue = .viewport(.largeViewWidth)

  /// Width/height set to large viewport height
  public static let lvh: SizingValue = .viewport(.largeViewHeight)

  /// Width/height set to small viewport width
  public static let svw: SizingValue = .viewport(.smallViewWidth)

  /// Width/height set to small viewport height
  public static let svh: SizingValue = .viewport(.smallViewHeight)

  /// Width/height set to min-content
  public static let min: SizingValue = .content(.min)

  /// Width/height set to max-content
  public static let max: SizingValue = .content(.max)

  /// Width/height set to fit-content
  public static let fit: SizingValue = .content(.fit)

  // Container size presets
  public static let xs3: SizingValue = .container(.threeExtraSmall)
  public static let xs2: SizingValue = .container(.twoExtraSmall)
  public static let xs: SizingValue = .container(.extraSmall)
  public static let sm: SizingValue = .container(.small)
  public static let md: SizingValue = .container(.medium)
  public static let lg: SizingValue = .container(.large)
  public static let xl: SizingValue = .container(.extraLarge)
  public static let xl2: SizingValue = .container(.twoExtraLarge)
  public static let xl3: SizingValue = .container(.threeExtraLarge)
  public static let xl4: SizingValue = .container(.fourExtraLarge)
  public static let xl5: SizingValue = .container(.fiveExtraLarge)
  public static let xl6: SizingValue = .container(.sixExtraLarge)
  public static let xl7: SizingValue = .container(.sevenExtraLarge)
}
