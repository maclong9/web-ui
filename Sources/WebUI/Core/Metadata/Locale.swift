/// Defines supported language locales for content.
///
/// Used to specify the language of the document for accessibility and SEO purposes.
/// The codes follow the ISO 639-1 standard for language codes.
public struct Locale: Sendable, Equatable {
    /// The raw string value of the locale.
    public let rawValue: String

    // European languages
    /// English locale.
    public static let en = Locale(rawValue: "en")
    /// Spanish locale.
    public static let es = Locale(rawValue: "es")
    /// Portuguese locale.
    public static let pt = Locale(rawValue: "pt")
    /// French locale.
    public static let fr = Locale(rawValue: "fr")
    /// German locale.
    public static let de = Locale(rawValue: "de")
    /// Italian locale.
    public static let it = Locale(rawValue: "it")
    /// Dutch locale.
    public static let nl = Locale(rawValue: "nl")
    /// Polish locale.
    public static let pl = Locale(rawValue: "pl")
    /// Russian locale.
    public static let ru = Locale(rawValue: "ru")
    /// Swedish locale.
    public static let sv = Locale(rawValue: "sv")
    /// Danish locale.
    public static let da = Locale(rawValue: "da")
    /// Norwegian locale.
    public static let no = Locale(rawValue: "no")
    /// Finnish locale.
    public static let fi = Locale(rawValue: "fi")

    // Asian languages
    /// Japanese locale.
    public static let ja = Locale(rawValue: "ja")
    /// Chinese (Simplified) locale.
    public static let zhCN = Locale(rawValue: "zh-CN")
    /// Chinese (Traditional) locale.
    public static let zhTW = Locale(rawValue: "zh-TW")
    /// Korean locale.
    public static let ko = Locale(rawValue: "ko")
    /// Thai locale.
    public static let th = Locale(rawValue: "th")
    /// Vietnamese locale.
    public static let vi = Locale(rawValue: "vi")
    /// Hindi locale.
    public static let hi = Locale(rawValue: "hi")

    // Middle Eastern languages
    /// Arabic locale.
    public static let ar = Locale(rawValue: "ar")
    /// Hebrew locale.
    public static let he = Locale(rawValue: "he")
    /// Turkish locale.
    public static let tr = Locale(rawValue: "tr")

    // Other major languages
    /// Indonesian locale.
    public static let id = Locale(rawValue: "id")
    /// Malay locale.
    public static let ms = Locale(rawValue: "ms")
    /// Bengali locale.
    public static let bn = Locale(rawValue: "bn")
    /// Urdu locale.
    public static let ur = Locale(rawValue: "ur")

    /// Custom locale allows specifying any valid BCP 47 language tag not included in the predefined list.
    /// - Parameter code: A valid BCP 47 language tag (e.g., "fr-CA" for Canadian French)
    /// - Returns: A custom Locale instance with the provided code
    public static func custom(_ code: String) -> Locale {
        Locale(rawValue: code)
    }
}
