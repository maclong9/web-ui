import Foundation

/// Defines image MIME types for use with image elements.
///
/// Used to specify the format of image files, ensuring browsers can properly interpret and display the content.
/// Different browsers support different image formats, so providing multiple source types improves compatibility.
///
/// ## Example
/// ```swift
/// Image(
///   source: "photo.jpg",
///   description: "A beautiful landscape",
///   type: .jpeg
/// )
/// ```
public enum ImageType: String {
    case jpeg = "image/jpeg"
    case png = "image/png"
    case webp = "image/webp"
    case gif = "image/gif"
}
