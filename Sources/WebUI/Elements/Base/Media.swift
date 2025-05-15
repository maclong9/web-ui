import Foundation

/// Represents media size by width and height
///
/// ## Example
/// ```swift
/// let size = MediaSize(width: 800, height: 600)
/// Image(source: "/images/hero.jpg", description: "Hero image", size: size)
/// ```
public struct MediaSize {
  let width: Int?
  let height: Int?
}

/// Enum for image MIME types
///
/// ## Example
/// ```swift
/// Picture(
///   sources: [
///     ("image.webp", .webp),
///     ("image.jpg", .jpeg)
///   ],
///   description: "Responsive image"
/// )
/// ```
public enum ImageType: String {
  case jpeg = "image/jpeg"
  case png = "image/png"
  case webp = "image/webp"
  case gif = "image/gif"
}

/// Enum for video MIME types
///
/// ## Example
/// ```swift
/// Video(
///   sources: [
///     ("video.webm", .webm),
///     ("video.mp4", .mp4)
///   ],
///   controls: true
/// )
/// ```
public enum VideoType: String {
  case mp4 = "video/mp4"
  case webm = "video/webm"
  case ogg = "video/ogg"
}

/// Enum for audio MIME types
///
/// ## Example
/// ```swift
/// Audio(
///   sources: [
///     ("music.mp3", .mp3),
///     ("music.ogg", .ogg)
///   ],
///   controls: true,
///   loop: true
/// )
/// ```
public enum AudioType: String {
  case mp3 = "audio/mpeg"
  case ogg = "audio/ogg"
  case wav = "audio/wav"
}

/// Generates an HTML source element for media tags.
///
/// ## Example
/// ```swift
/// Source(src: "video.mp4", type: "video/mp4")
/// ```
public final class Source: Element {
  let src: String
  let type: String?

  /// Creates a new HTML source element.
  ///
  /// - Parameters:
  ///   - src: Source URL.
  ///   - type: MIME type, optional.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
  ///
  /// ## Example
  /// ```swift
  /// Source(src: "image.webp", type: "image/webp")
  /// ```
  public init(
    src: String,
    type: String? = nil,
    data: [String: String]? = nil
  ) {
    self.src = src
    self.type = type
    let customAttributes = [
      Attribute.string("src", src),
      Attribute.string("type", type),
    ].compactMap { $0 }
    super.init(
      tag: "source",
      data: data,
      isSelfClosing: true,
      customAttributes: customAttributes.isEmpty ? nil : customAttributes
    )
  }
}

/// Generates an HTML img element.
///
/// ## Example
/// ```swift
/// Image(source: "/images/logo.png", description: "Company Logo")
///   .rounded(.lg)
/// ```
public final class Image: Element {
  let source: String
  let description: String
  let size: MediaSize?

  /// Creates a new HTML img element.
  ///
  /// - Parameters:
  ///   - source: Where the image is located.
  ///   - description: Alt text for accessibility.
  ///   - size: Image size dimensions, optional.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
  ///
  /// ## Example
  /// ```swift
  /// Image(
  ///   source: "/images/profile.jpg",
  ///   description: "User Profile Photo",
  ///   size: MediaSize(width: 200, height: 200)
  /// )
  /// .rounded(.full)
  /// ```
  public init(
    source: String,
    description: String,
    size: MediaSize? = nil,
    data: [String: String]? = nil
  ) {
    self.source = source
    self.description = description
    self.size = size
    let customAttributes = [
      Attribute.string("src", source),
      Attribute.string("alt", description),
      Attribute.string("width", size?.width?.description),
      Attribute.string("height", size?.height?.description),
    ].compactMap { $0 }
    super.init(
      tag: "img",
      data: data,
      isSelfClosing: true,
      customAttributes: customAttributes.isEmpty ? nil : customAttributes
    )
  }
}

/// Generates an HTML picture element with multiple source tags.
/// Styles and attributes applied to this element are also passed to the nested Image element.
///
/// ## Example
/// ```swift
/// Picture(
///   sources: [
///     ("banner.webp", .webp),
///     ("banner.jpg", .jpeg)
///   ],
///   description: "Website banner image"
/// )
/// ```
public final class Picture: Element {
  let sources: [(src: String, type: ImageType?)]
  let description: String
  let size: MediaSize?

  /// Creates a new HTML picture element.
  ///
  /// - Parameters:
  ///   - sources: Array of tuples containing source URL and optional image MIME type.
  ///   - description: Alt text for accessibility.
  ///   - size: Picture size dimensions, optional.
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
  ///
  /// All style attributes (id, classes, role, label, data) are passed to the nested Image element
  /// to ensure proper styling, as the Picture element itself is invisible in the rendered output.
  ///
  /// ## Example
  /// ```swift
  /// Picture(
  ///   sources: [
  ///     ("hero-large.webp", .webp),
  ///     ("hero-large.jpg", .jpeg)
  ///   ],
  ///   description: "Hero Banner",
  ///   id: "hero-image",
  ///   classes: ["responsive-image"]
  /// )
  /// ```
  public init(
    sources: [(src: String, type: ImageType?)],
    description: String,
    size: MediaSize? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil
  ) {
    self.sources = sources
    self.description = description
    self.size = size
    super.init(
      tag: "picture",
      id: id,
      classes: classes,
      role: role,
      label: label,
      data: data,
      content: {
        for source in sources {
          Source(src: source.src, type: source.type?.rawValue)
        }
        Image(
          source: sources[0].src,
          description: description,
          size: size,
          data: data
        )
      }
    )
  }
}

/// Generates an HTML figure element with a picture and figcaption.
/// Styles and attributes applied to this element are passed to the nested Picture element,
/// which further passes them to its nested Image element.
///
/// ## Example
/// ```swift
/// Figure(
///   sources: [
///     ("chart.webp", .webp),
///     ("chart.png", .png)
///   ],
///   description: "Annual revenue growth chart"
/// )
/// ```
public final class Figure: Element {
  let sources: [(src: String, type: ImageType?)]
  let description: String
  let size: MediaSize?

  /// Creates a new HTML figure element containing a picture and figcaption.
  ///
  /// - Parameters:
  ///   - sources: Array of tuples containing source URL and optional image MIME type.
  ///   - description: Text for the figcaption and alt text for accessibility.
  ///   - size: Picture size dimensions, optional.
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
  ///
  /// All style attributes (id, classes, role, label, data) are passed to the nested Picture element
  /// and ultimately to the Image element, ensuring proper styling throughout the hierarchy.
  ///
  /// ## Example
  /// ```swift
  /// Figure(
  ///   sources: [
  ///     ("product.webp", .webp),
  ///     ("product.jpg", .jpeg)
  ///   ],
  ///   description: "Product XYZ with special features",
  ///   classes: ["product-figure", "bordered"]
  /// )
  /// ```
  public init(
    sources: [(src: String, type: ImageType?)],
    description: String,
    size: MediaSize? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    data: [String: String]? = nil
  ) {
    self.sources = sources
    self.description = description
    self.size = size
    super.init(
      tag: "figure",
      id: id,
      classes: classes,
      role: role,
      label: label,
      data: data,
      content: {
        Picture(
          sources: sources,
          description: description,
          size: size,
          id: id,
          classes: classes,
          role: role,
          label: label,
          data: data
        )
        Element(
          tag: "figcaption",
          content: { description }
        )
      }
    )
  }
}

/// Generates an HTML video element with multiple source tags.
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

  /// Creates a new HTML video element with embedded sources.
  ///
  /// - Parameters:
  ///   - sources: Array of tuples containing source URL and optional video MIME type.
  ///   - controls: Displays playback controls if true, optional.
  ///   - autoplay: Automatically starts playback if true, optional.
  ///   - loop: Repeats video playback if true, optional.
  ///   - size: Video size dimensions, optional.
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
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

/// Generates an HTML audio element with multiple source tags.
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

  /// Creates a new HTML audio element with sources.
  ///
  /// - Parameters:
  ///   - sources: Array of tuples containing source URL and optional audio MIME type.
  ///   - controls: Displays playback controls if true, optional.
  ///   - autoplay: Automatically starts playback if true, optional.
  ///   - loop: Repeats audio playback if true, optional.
  ///   - id: Unique identifier for the HTML element.
  ///   - classes: An array of CSS classnames.
  ///   - role: ARIA role of the element for accessibility.
  ///   - label: ARIA label to describe the element.
  ///   - data: Dictionary of `data-*` attributes for element relevant storing data.
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
