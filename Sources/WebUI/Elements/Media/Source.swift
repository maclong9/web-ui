import Foundation

/// Creates HTML source elements for multimedia content.
///
/// Specifies multiple media resources for the `<audio>`, `<video>`, and `<picture>` elements,
/// allowing browsers to choose the most suitable format based on device capabilities, network
/// conditions, and user preferences. Source elements facilitate responsive media delivery,
/// progressive enhancement, and backward compatibility across different browsers and devices.
///
/// ## Example
/// ```swift
/// Video {
///   Source(src: "movie.webm", type: "video/webm")
///   Source(src: "movie.mp4", type: "video/mp4")
///   "Your browser does not support the video tag."
/// }
/// ```
public struct Source: Element {
    private let src: String
    private let type: String?
    private let data: [String: String]?

    /// Creates a new HTML source element.
    ///
    /// - Parameters:
    ///   - src: The URL of the media resource. Can be absolute or relative path.
    ///   - type: The MIME type of the media resource, helping browsers determine compatibility
    ///     before downloading. Examples include "video/mp4", "audio/mpeg", "image/webp".
    ///   - data: Dictionary of `data-*` attributes for storing custom data relevant to the source.
    ///
    /// ## Example
    /// ```swift
    /// // For responsive images in a picture element
    /// Picture {
    ///   Source(src: "large.jpg", type: "image/jpeg", data: ["media": "(min-width: 800px)"])
    ///   Source(src: "medium.jpg", type: "image/jpeg", data: ["media": "(min-width: 600px)"])
    ///   Image(src: "small.jpg", alt: "A description of the image")
    /// }
    ///
    /// // For audio with multiple formats
    /// Audio {
    ///   Source(src: "audio.ogg", type: "audio/ogg")
    ///   Source(src: "audio.mp3", type: "audio/mpeg")
    ///   "Your browser does not support the audio element."
    /// }
    /// ```
    public init(
        src: String,
        type: String? = nil,
        data: [String: String]? = nil
    ) {
        self.src = src
        self.type = type
        self.data = data
    }

    public var body: some HTML {
        HTMLString(content: renderTag())
    }

    private func renderTag() -> String {
        var attributes = AttributeBuilder.buildAttributes(data: data)

        if let srcAttr = Attribute.string("src", src) {
            attributes.append(srcAttr)
        }

        if let type, let typeAttr = Attribute.string("type", type) {
            attributes.append(typeAttr)
        }

        return AttributeBuilder.renderTag("source", attributes: attributes, isSelfClosing: true)
    }
}
