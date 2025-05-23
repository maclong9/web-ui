/// Defines audio MIME types for use with audio elements.
///
/// Used to specify the format of audio files, ensuring browsers can properly interpret and play the content.
/// Different browsers support different audio formats, so providing multiple source types improves compatibility.
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
