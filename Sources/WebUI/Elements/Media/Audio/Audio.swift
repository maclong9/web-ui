/// Creates HTML audio elements for playing sound content.
///
/// Represents an audio player that supports multiple source formats for cross-browser compatibility.
/// Audio elements are useful for embedding sound content such as music, podcasts, or sound effects.
///
/// ## Example
/// ```swift
/// Audio(
///   sources: [
///     ("background.mp3", .mp3),
///     ("background.ogg", .ogg)
///   ],
///   controls: true
/// )
/// ```
public final class Audio: Element {
    let sources: [(src: String, type: AudioType?)]
    let controls: Bool?
    let autoplay: Bool?
    let loop: Bool?

    /// Creates a new HTML audio player.
    ///
    /// - Parameters:
    ///   - sources: Array of tuples containing source URL and optional audio MIME type.
    ///   - controls: Displays playback controls if true, optional.
    ///   - autoplay: Automatically starts playback if true, optional.
    ///   - loop: Repeats audio playback if true, optional.
    ///   - id: Unique identifier for the HTML element, useful for JavaScript interaction and styling.
    ///   - classes: An array of CSS classnames for styling the audio player.
    ///   - role: ARIA role of the element for accessibility, enhancing screen reader interpretation.
    ///   - label: ARIA label to describe the element for accessibility when context isn't sufficient.
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the audio player.
    ///
    /// ## Example
    /// ```swift
    /// Audio(
    ///   sources: [
    ///     ("podcast.mp3", .mp3),
    ///     ("podcast.ogg", .ogg)
    ///   ],
    ///   controls: true,
    ///   id: "podcast-player",
    ///   label: "Episode 42: Web Development with Swift"
    /// )
    /// ```
    public init(
        sources: [(src: String, type: AudioType?)],
        controls: Bool? = nil,
        autoplay: Bool? = nil,
        loop: Bool? = nil,
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
        let customAttributes = [
            Attribute.bool("controls", controls),
            Attribute.bool("autoplay", autoplay),
            Attribute.bool("loop", loop),
        ].compactMap { $0 }
        super.init(
            tag: "audio",
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
                "Your browser does not support the audio element."
            }
        )
    }
}
