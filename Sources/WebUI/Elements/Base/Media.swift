import Foundation

/// Represents media size by width and height
public struct MediaSize {
  let width: Int?
  let height: Int?
}

/// Enum for image MIME types
public enum ImageType: String {
  case jpeg = "image/jpeg"
  case png = "image/png"
  case webp = "image/webp"
  case gif = "image/gif"
}

/// Enum for video MIME types
public enum VideoType: String {
  case mp4 = "video/mp4"
  case webm = "video/webm"
  case ogg = "video/ogg"
}

/// Enum for audio MIME types
public enum AudioType: String {
  case mp3 = "audio/mpeg"
  case ogg = "audio/ogg"
  case wav = "audio/wav"
}

/// Generates an HTML source element for media tags.
public final class Source: Element {
  let src: String
  let type: String?

  /// Creates a new HTML source element.
  ///
  /// - Parameters:
  ///   - src: Source URL.
  ///   - type: MIME type, optional.
  public init(src: String, type: String? = nil) {
    self.src = src
    self.type = type
    super.init(tag: "source", isSelfClosing: true)
  }

  /// Provides source-specific attributes.
  public override func additionalAttributes() -> [String] {
    [
      attribute("src", src),
      attribute("type", type),
    ].compactMap { $0 }
  }
}

/// Generates an HTML img element.
public final class Image: Element {
  let description: String
  let size: MediaSize?

  /// Creates a new HTML img element.
  ///
  /// - Parameters:
  ///   - description: Alt text for accessibility.
  ///   - size: Image size dimensions, optional.
  public init(description: String, size: MediaSize? = nil) {
    self.description = description
    self.size = size
    super.init(tag: "img", isSelfClosing: true)
  }

  /// Provides img-specific attributes.
  public override func additionalAttributes() -> [String] {
    [
      attribute("alt", description),
      attribute("width", size?.width.map { String($0) }),
      attribute("height", size?.height.map { String($0) }),
    ].compactMap { $0 }
  }
}

/// Generates an HTML picture element with multiple source tags.
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
  public init(
    sources: [(src: String, type: ImageType?)],
    description: String,
    size: MediaSize? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil
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
      content: {
        for source in sources {
          Source(src: source.src, type: source.type?.rawValue)
        }
        Image(description: description, size: size)
      }
    )
  }
}

/// Generates an HTML figure element with a picture and figcaption.
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
  public init(
    sources: [(src: String, type: ImageType?)],
    description: String,
    size: MediaSize? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil
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
      content: {
        Picture(
          sources: sources,
          description: description,
          size: size
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
  public init(
    sources: [(src: String, type: VideoType?)],
    controls: Bool? = nil,
    autoplay: Bool? = nil,
    loop: Bool? = nil,
    size: MediaSize? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil
  ) {
    self.sources = sources
    self.controls = controls
    self.autoplay = autoplay
    self.loop = loop
    self.size = size
    super.init(
      tag: "video",
      id: id,
      classes: classes,
      role: role,
      label: label,
      content: {
        for source in sources {
          Source(src: source.src, type: source.type?.rawValue)
        }
        "Your browser does not support the video tag."
      }
    )
  }

  /// Provides video-specific attributes.
  public override func additionalAttributes() -> [String] {
    if tag == "video" {
      return [
        booleanAttribute("controls", controls),
        booleanAttribute("autoplay", autoplay),
        booleanAttribute("loop", loop),
        attribute("width", size?.width.map { String($0) }),
        attribute("height", size?.height.map { String($0) }),
      ].compactMap { $0 }
    }
    return []
  }
}

/// Generates an HTML audio element with multiple source tags.
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
  public init(
    sources: [(src: String, type: AudioType?)],
    controls: Bool? = nil,
    autoplay: Bool? = nil,
    loop: Bool? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil
  ) {
    self.sources = sources
    self.controls = controls
    self.autoplay = autoplay
    self.loop = loop
    super.init(
      tag: "audio",
      id: id,
      classes: classes,
      role: role,
      label: label,
      content: {
        for source in sources {
          Source(src: source.src, type: source.type?.rawValue)
        }
        "Your browser does not support the audio element."
      }
    )
  }

  /// Provides audio-specific attributes.
  public override func additionalAttributes() -> [String] {
    if tag == "audio" {
      return [
        booleanAttribute("controls", controls),
        booleanAttribute("autoplay", autoplay),
        booleanAttribute("loop", loop),
      ].compactMap { $0 }
    }
    return []
  }
}
