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
public struct Video: Element {
    private let sources: [(src: String, type: VideoType?)]
    private let controls: Bool?
    private let autoplay: Bool?
    private let loop: Bool?
    private let size: MediaSize?
    private let id: String?
    private let classes: [String]?
    private let role: AriaRole?
    private let label: String?
    private let data: [String: String]?
    
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
        if let width = size?.width {
            attributes.append("width=\"\(width)\"")
        }
        if let height = size?.height {
            attributes.append("height=\"\(height)\"")
        }
        let sourceElements = sources.map { source in
            let type = source.type?.rawValue
            return "<source src=\"\(source.src)\"\(type != nil ? " type=\"\(type!)\"" : "")>"
        }.joined()
        return AttributeBuilder.renderTag("video", attributes: attributes, content: "\(sourceElements)Your browser does not support the video tag.")
    }
}