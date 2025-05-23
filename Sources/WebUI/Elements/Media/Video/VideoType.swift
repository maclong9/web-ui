import Foundation

/// Defines video MIME types for use with video elements.
///
/// Used to specify the format of video files, ensuring browsers can properly interpret and play the content.
/// Different browsers support different video formats, so providing multiple source types improves compatibility.
///
/// ## Example
/// ```swift
/// Video(
///   sources: [
///     (src: "movie.mp4", type: .mp4),
///     (src: "movie.webm", type: .webm)
///   ],
///   controls: true
/// )
/// ```
public enum VideoType: String {
    case mp4 = "video/mp4"
    case webm = "video/webm"
    case ogg = "video/ogg"
}
