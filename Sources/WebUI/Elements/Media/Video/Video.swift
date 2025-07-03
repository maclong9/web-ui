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
    ///   - classes: An array of stylesheet classnames for styling the video player.
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

    public var body: some Markup {
        MarkupString(content: buildMarkupTag())
    }

    private func buildMarkupTag() -> String {
        var attributes = AttributeBuilder.buildAttributes(
            id: id,
            classes: classes,
            role: role,
            label: label,
            data: data
        )
        if let controls, controls {
            attributes.append("controls")
        }
        if let autoplay, autoplay {
            attributes.append("autoplay")
        }
        if let loop, loop {
            attributes.append("loop")
        }
        if let width = size?.width,
            let widthAttr = Attribute.string("width", "\(width)")
        {
            attributes.append(widthAttr)
        }
        if let height = size?.height,
            let heightAttr = Attribute.string("height", "\(height)")
        {
            attributes.append(heightAttr)
        }
        let sourceElements = sources.map { source in
            var sourceAttributes: [String] = []
            if let srcAttr = Attribute.string("src", source.src) {
                sourceAttributes.append(srcAttr)
            }
            if let type = source.type,
                let typeAttr = Attribute.string("type", type.rawValue)
            {
                sourceAttributes.append(typeAttr)
            }
            return AttributeBuilder.buildMarkupTag(
                "source", attributes: sourceAttributes, hasNoClosingTag: true)
        }.joined()
        return AttributeBuilder.buildMarkupTag(
            "video",
            attributes: attributes,
            content:
                "\(sourceElements)Your browser does not support the video tag."
        )
    }
}
