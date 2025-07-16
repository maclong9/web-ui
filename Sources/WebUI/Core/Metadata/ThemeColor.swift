import Foundation

/// Represents a theme color with optional dark mode variant.
///
/// Used to specify the browser theme color for the document, supporting both light and dark mode.
public struct ThemeColor {
    /// The color value for light mode.
    public let light: String

    /// The optional color value for dark mode.
    public let dark: String?

    /// Creates a new theme color with optional dark mode variant.
    ///
    /// - Parameters:
    ///   - light: The color value for light mode (can be any valid CSS color).
    ///   - dark: The optional color value for dark mode (can be any valid CSS color).
    ///
    /// - Example:
    ///   ```swift
    ///   let brandColor = ThemeColor("#0077ff", dark: "#3399ff")
    ///   ```
    public init(_ light: String, dark: String? = nil) {
        self.light = light
        self.dark = dark
    }
}
