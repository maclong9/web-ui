import Foundation

/// Creates HTML video elements for displaying video content.
///
/// Represents a video player that supports multiple source formats for cross-browser compatibility.
/// Video elements are fundamental for embedding video content such as tutorials, presentations, or promotional material.
///
/// ## Example
/// ```swift
/// Video(
///   sources: [
///     ("intro.webm", .webm),
///     ("intro.mp4", .mp4)
///   ],
///   controls: true,
///   autoplay: false
/// )
/// ```
public final class Video: Element {
    let sources: [(src: String, type: VideoType?)]
    let controls: Bool?
    let autoplay: Bool?
    let loop: Bool?
    let size: MediaSize?

    /// Creates a new HTML video player.
    ///
    /// - Parameters:
    ///   - sources: Array of tuples containing source URL and optional video MIME type.
    ///   - controls: Displays playback controls if true, optional.
    ///   - autoplay: Automatically starts playback if true, optional.
    ///   - loop: Repeats video playback if true, optional.
    ///   - size: Video size dimensions, optional.
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of CSS classnames for styling the video player.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the video player.
    ///
    /// ## Example
    /// ```swift
    /// Video(
    ///   sources: [
    ///     ("tutorial.webm", .webm),
    ///     ("tutorial.mp4", .mp4)
    ///   ],
    ///   controls: true,
    ///   loop: true,
    ///   size: MediaSize(width: 1280, height: 720),
    ///   id: "tutorial-video",
    ///   classes: ["responsive-video"]
    /// )
    /// ```
    public init(
        sources: [(src: String, type: VideoType?)],
        controls: Bool? = nil,
        autoplay: Bool? = nil,
        loop: Bool? = nil,
        size: MediaSize? = nil,
        id: String? = nil,
        classes: [String]? = nil,
        role: AriaRole? = nil,
        label: String? = nil,
        data: [String: String]? = nil
    ) {
        self.sources = sources
        self.controls = controls
        self.autoplay = autoplay
        self.loop = loop
        self.size = size
        let customAttributes = [
            Attribute.bool("controls", controls),
            Attribute.bool("autoplay", autoplay),
            Attribute.bool("loop", loop),
            Attribute.string("width", size?.width?.description),
            Attribute.string("height", size?.height?.description),
        ].compactMap { $0 }
        super.init(
            tag: "video",
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data,
            customAttributes: customAttributes.isEmpty ? nil : customAttributes,
            content: {
                for source in sources {
                    Source(src: source.src, type: source.type?.rawValue)
                }
                "Your browser does not support the video tag."
            }
        )
    }
}
