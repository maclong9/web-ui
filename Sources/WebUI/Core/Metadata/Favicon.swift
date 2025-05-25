import Foundation

/// Represents favicon configuration with optional dark mode variant.
///
/// Used to specify different favicon images for light and dark mode.
public struct Favicon {
    /// The path to the favicon for light mode.
    public let light: String
    /// The optional path to the favicon for dark mode.
    public let dark: String?
    /// The type of the favicon (e.g., "image/png").
    public let type: ImageType
    /// The size of the favicon (e.g., "32x32").
    public let size: String?

    /// Creates a new favicon configuration with optional dark mode variant.
    ///
    /// - Parameters:
    ///   - light: The path to the favicon for light mode.
    ///   - dark: The optional path to the favicon for dark mode.
    ///   - type: The MIME type of the favicon (defaults to "image/png").
    ///   - size: The size of the favicon in pixels (e.g., "32x32").
    ///
    /// - Example:
    ///   ```swift
    ///   let icon = Favicon("/icons/favicon.png", dark: "/icons/favicon-dark.png", size: "32x32")
    ///   ```
    public init(
        _ light: String,
        dark: String? = nil,
        type: ImageType = .png,
        size: String? = nil
    ) {
        self.light = light
        self.dark = dark
        self.type = type
        self.size = size
    }
}
