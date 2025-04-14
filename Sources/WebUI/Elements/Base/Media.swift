// Represents image size by width and height
public struct ImageSize {
  let width: Int?
  let height: Int?
}

/// Generates an HTML figure element containing a picture with optional sources and caption.
public final class Figure: Element {
  let picture: Image
  let caption: String?

  /// Creates a new HTML figure element wrapping a picture with multiple sources.
  ///
  /// - Parameters:
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - source: URL or path to the image file.
  ///   - description: Alt text for accessibility on the fallback image.
  ///   - caption: Text for the optional `<figcaption>`, nil if omitted.
  ///   - size: Image size dimensions, optional.
  public init(
    config: ElementConfig = .init(),
    source: String,
    description: String,
    caption: String? = nil,
    size: ImageSize? = nil
  ) {
    self.picture = Image(
      source: source,
      description: description,
      size: size,
      config: config
    )
    self.caption = caption
    super.init(tag: "figure", config: config)
  }

  /// Provides custom content for the figure (image and optional caption).
  public override func customContent() -> String? {
    let captionString = caption.map { "<figcaption>\($0)</figcaption>" } ?? ""
    return picture.render() + captionString
  }
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
  ///   - config: Configuration for element attributes, defaults to empty.
  public init(
    source: String,
    description: String,
    size: ImageSize? = nil,
    config: ElementConfig = .init()
  ) {
    self.source = source
    self.description = description
    self.size = size
    super.init(tag: "img", config: config, isSelfClosing: true)
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
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - content: Closure providing fallback content, defaults to empty.
  public init(
    sources: [String],
    controls: Bool? = nil,
    autoplay: Bool? = nil,
    loop: Bool? = nil,
    size: ImageSize? = nil,
    config: ElementConfig = .init(),
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    self.sourceURLs = sources
    self.controls = controls
    self.autoplay = autoplay
    self.loop = loop
    self.size = size
    super.init(tag: "video", config: config, content: content)
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

  /// Provides custom content for source tags.
  public override func customContent() -> String? {
    sourceURLs.map { "<source src=\"\($0)\">" }.joined()
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
  ///   - config: Configuration for element attributes, defaults to empty.
  ///   - content: Closure providing fallback content, defaults to empty.
  public init(
    sources: [String],
    controls: Bool? = nil,
    autoplay: Bool? = nil,
    loop: Bool? = nil,
    config: ElementConfig = .init(),
    @HTMLBuilder content: @escaping @Sendable () -> [any HTML] = { [] }
  ) {
    self.sourceURLs = sources
    self.controls = controls
    self.autoplay = autoplay
    self.loop = loop
    super.init(tag: "audio", config: config, content: content)
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

  /// Provides custom content for source tags.
  public override func customContent() -> String? {
    sourceURLs.map { "<source src=\"\($0)\">" }.joined()
  }
}
