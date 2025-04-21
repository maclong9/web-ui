// Represents image size by width and height
public struct ImageSize {
  let width: Int?
  let height: Int?
}

/// Generates an HTML image element.
public final class Image: Element {
  let source: String
  let description: String
  let size: ImageSize?

  /// Creates a new HTML image element.
  ///
  /// - Parameters:
  ///   - source: URL or path to the image file.
  ///   - description: Alt text for accessibility.
  ///   - size: Image size dimensions, optional.
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  public init(
    source: String,
    description: String,
    size: ImageSize? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
  ) {
    self.source = source
    self.description = description
    self.size = size
    super.init(tag: "img", id: id, classes: classes, role: role, label: label)
  }

  /// Provides image-specific attributes.
  public override func additionalAttributes() -> [String] {
    [
      attribute("src", source),
      attribute("alt", description),
      size?.width != nil ? "width=\"\(size!.width!)\"" : nil,
      size?.height != nil ? "height=\"\(size!.height!)\"" : nil,
    ]
    .compactMap { $0 }
  }
}

/// Generates an HTML video element with multiple source tags.
public final class Video: Element {
  let sourceURLs: [String]
  let controls: Bool?
  let autoplay: Bool?
  let loop: Bool?
  let size: ImageSize?

  /// Creates a new HTML video element with embedded sources.
  ///
  /// - Parameters:
  ///   - sources: Array of URLs or paths to video files (first valid source is used by browser).
  ///   - controls: Displays playback controls if true, optional.
  ///   - autoplay: Automatically starts playback if true, optional.
  ///   - loop: Repeats video playback if true, optional.
  ///   - size: Video size dimensions, optional.
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - content: Closure providing fallback content, defaults to empty.
  public init(
    sources: [String],
    controls: Bool? = nil,
    autoplay: Bool? = nil,
    loop: Bool? = nil,
    size: ImageSize? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    @HTMLBuilder content: @escaping  () -> [any HTML] = { [] }
  ) {
    self.sourceURLs = sources
    self.controls = controls
    self.autoplay = autoplay
    self.loop = loop
    self.size = size
    super.init(
      tag: "video", id: id, classes: classes, role: role, label: label,
      content: content)
  }

  /// Provides video-specific attributes.
  public override func additionalAttributes() -> [String] {
    [
      booleanAttribute("controls", controls),
      booleanAttribute("autoplay", autoplay),
      booleanAttribute("loop", loop),
      attribute("width", size?.width.map { String($0) }),
      attribute("height", size?.height.map { String($0) }),
    ]
    .compactMap { $0 }
  }
}

/// Generates an HTML audio element with multiple source tags.
public final class Audio: Element {
  let sourceURLs: [String]
  let controls: Bool?
  let autoplay: Bool?
  let loop: Bool?

  /// Creates a new HTML audio element with embedded sources.
  ///
  /// - Parameters:
  ///   - sources: Array of URLs or paths to audio files (first valid source is used by browser).
  ///   - controls: Displays playback controls if true, optional.
  ///   - autoplay: Automatically starts playback if true, optional.
  ///   - loop: Repeats audio playback if true, optional.
  ///   - id: Uniquie identifier for the html element.
  ///   - classes: An array of CSS classnames.
  ///   - role: Arial role of the element for accessibility.
  ///   - label: Aria label to describe the element.
  ///   - content: Closure providing fallback content, defaults to empty.
  public init(
    sources: [String],
    controls: Bool? = nil,
    autoplay: Bool? = nil,
    loop: Bool? = nil,
    id: String? = nil,
    classes: [String]? = nil,
    role: AriaRole? = nil,
    label: String? = nil,
    @HTMLBuilder content: @escaping  () -> [any HTML] = { [] }
  ) {
    self.sourceURLs = sources
    self.controls = controls
    self.autoplay = autoplay
    self.loop = loop
    super.init(
      tag: "audio", id: id, classes: classes, role: role, label: label,
      content: content)
  }

  /// Provides audio-specific attributes.
  public override func additionalAttributes() -> [String] {
    [
      booleanAttribute("controls", controls),
      booleanAttribute("autoplay", autoplay),
      booleanAttribute("loop", loop),
    ]
    .compactMap { $0 }
  }
}
