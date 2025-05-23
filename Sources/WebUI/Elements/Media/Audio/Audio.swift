import Foundation

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
public struct Audio: Element {
    private let sources: [(src: String, type: AudioType?)]
    private let controls: Bool?
    private let autoplay: Bool?
    private let loop: Bool?
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?

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
        self.id = id
        self.classes = classes
        self.role = role
        self.label = label
        self.data = data
    }
    
    public var body: some HTML {
        HTMLString(content: renderTag())
    }
    
    private func renderTag() -> String {
        var attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data
        )
        if let controls = controls, controls {
            attributes.append("controls")
        }
        if let autoplay = autoplay, autoplay {
            attributes.append("autoplay")
        }
        if let loop = loop, loop {
            attributes.append("loop")
        }
        let sourceElements = sources.map { source in
            let type = source.type?.rawValue
            return "<source src=\"\(source.src)\"\(type != nil ? " type=\"\(type!)\"" : "")>"
        }.joined()
        return AttributeBuilder.renderTag("audio", attributes: attributes, content: "\(sourceElements)Your browser does not support the audio element.")
    }
}