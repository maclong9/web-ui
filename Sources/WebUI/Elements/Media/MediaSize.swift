import Foundation

/// Specifies dimensions for media elements such as images, videos, and audio visualizations.
///
/// This struct provides a consistent way to define width and height measurements for media elements,
/// helping ensure proper rendering and layout in HTML. Both dimensions are optional to accommodate
/// scenarios where only one dimension needs to be specified while maintaining aspect ratio.
///
/// ## Example
/// ```swift
/// let size = MediaSize(width: 800, height: 600)
/// Video(sources: [("movie.mp4", .mp4)], size: size)
/// ```
public struct MediaSize {
    /// The width of the media in pixels.
    public let width: Int?
    /// The height of the media in pixels.
    public let height: Int?

    /// Creates a new media size specification.
    ///
    /// - Parameters:
    ///   - width: Width dimension in pixels, optional.
    ///   - height: Height dimension in pixels, optional.
    public init(width: Int? = nil, height: Int? = nil) {
        self.width = width
        self.height = height
    }
}
