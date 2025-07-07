import Foundation

/// Represents Lucide icons with their string identifiers.
///
/// This enum provides type-safe access to Lucide icons, ensuring consistent
/// naming and reducing the chance of typos. Each case corresponds to the
/// official Lucide icon name as defined in the Lucide icon library.
///
/// ## Usage
/// ```swift
/// Icon(.airplay)
/// Button("Save", systemImage: .check)
/// SystemImage(.heart, classes: ["favorite-icon"])
/// ```
///
/// Reference: https://lucide.dev/icons/
public enum LucideIcon: String, CaseIterable, Sendable {
    // MARK: - Navigation & UI
    case arrowLeft = "arrow-left"
    case arrowRight = "arrow-right"
    case arrowUp = "arrow-up"
    case arrowDown = "arrow-down"
    case chevronLeft = "chevron-left"
    case chevronRight = "chevron-right"
    case chevronUp = "chevron-up"
    case chevronDown = "chevron-down"
    case menu = "menu"
    case x = "x"
    case plus = "plus"
    case minus = "minus"
    case moreHorizontal = "more-horizontal"
    case moreVertical = "more-vertical"
    
    // MARK: - Actions & States
    case check = "check"
    case checkCircle = "check-circle"
    case xCircle = "x-circle"
    case alertCircle = "alert-circle"
    case alertTriangle = "alert-triangle"
    case info = "info"
    case helpCircle = "help-circle"
    case edit = "edit"
    case edit2 = "edit-2"
    case edit3 = "edit-3"
    case trash = "trash"
    case trash2 = "trash-2"
    case copy = "copy"
    case clipboard = "clipboard"
    case save = "save"
    case download = "download"
    case upload = "upload"
    case refresh = "refresh-cw"
    case rotate = "rotate-cw"
    case undo = "undo"
    case redo = "redo"
    
    // MARK: - Media & Content
    case play = "play"
    case pause = "pause"
    case stop = "stop"
    case skipForward = "skip-forward"
    case skipBack = "skip-back"
    case volume = "volume-2"
    case volumeOff = "volume-x"
    case image = "image"
    case video = "video"
    case music = "music"
    case file = "file"
    case fileText = "file-text"
    case folder = "folder"
    case folderOpen = "folder-open"
    
    // MARK: - Communication
    case mail = "mail"
    case phone = "phone"
    case messageSquare = "message-square"
    case messageCircle = "message-circle"
    case send = "send"
    case share = "share"
    case share2 = "share-2"
    case bell = "bell"
    case bellOff = "bell-off"
    
    // MARK: - User & Profile
    case user = "user"
    case users = "users"
    case userPlus = "user-plus"
    case userMinus = "user-minus"
    case userCheck = "user-check"
    case userX = "user-x"
    case heart = "heart"
    case star = "star"
    case bookmark = "bookmark"
    case thumbsUp = "thumbs-up"
    case thumbsDown = "thumbs-down"
    
    // MARK: - Layout & View
    case grid = "grid-3x3"
    case list = "list"
    case columns = "columns"
    case sidebar = "sidebar"
    case maximize = "maximize"
    case minimize = "minimize"
    case maximize2 = "maximize-2"
    case minimize2 = "minimize-2"
    case eye = "eye"
    case eyeOff = "eye-off"
    case layout = "layout"
    case layoutGrid = "layout-grid"
    
    // MARK: - Settings & Configuration
    case settings = "settings"
    case sliders = "sliders"
    case filter = "filter"
    case search = "search"
    case zoom = "zoom-in"
    case zoomOut = "zoom-out"
    case tool = "tool"
    case wrench = "wrench"
    case gear = "gear"
    case lock = "lock"
    case unlock = "unlock"
    case key = "key"
    
    // MARK: - Data & Statistics
    case barChart = "bar-chart"
    case lineChart = "line-chart"
    case pieChart = "pie-chart"
    case trendingUp = "trending-up"
    case trendingDown = "trending-down"
    case activity = "activity"
    case analytics = "bar-chart-3"
    case database = "database"
    case server = "server"
    case hardDrive = "hard-drive"
    
    // MARK: - E-commerce & Shopping
    case shoppingCart = "shopping-cart"
    case shoppingBag = "shopping-bag"
    case creditCard = "credit-card"
    case dollarSign = "dollar-sign"
    case tag = "tag"
    case package = "package"
    case gift = "gift"
    
    // MARK: - Social & External
    case github = "github"
    case twitter = "twitter"
    case linkedin = "linkedin"
    case facebook = "facebook"
    case instagram = "instagram"
    case youtube = "youtube"
    case externalLink = "external-link"
    case link = "link"
    case linkOff = "link-off"
    
    // MARK: - Device & System
    case smartphone = "smartphone"
    case tablet = "tablet"
    case laptop = "laptop"
    case monitor = "monitor"
    case wifi = "wifi"
    case wifiOff = "wifi-off"
    case bluetooth = "bluetooth"
    case battery = "battery"
    case power = "power"
    case cpu = "cpu"
    case memory = "memory-stick"
    
    // MARK: - Weather & Location
    case sun = "sun"
    case moon = "moon"
    case cloud = "cloud"
    case cloudRain = "cloud-rain"
    case cloudSnow = "cloud-snow"
    case mapPin = "map-pin"
    case map = "map"
    case navigation = "navigation"
    case compass = "compass"
    case globe = "globe"
    
    // MARK: - Time & Calendar
    case clock = "clock"
    case calendar = "calendar"
    case calendarDays = "calendar-days"
    case timer = "timer"
    case stopwatch = "stopwatch"
    case hourglass = "hourglass"
    
    // MARK: - Shapes & Graphics
    case circle = "circle"
    case square = "square"
    case triangle = "triangle"
    case hexagon = "hexagon"
    case diamond = "diamond"
    case droplet = "droplet"
    case flame = "flame"
    case zap = "zap"
    case shield = "shield"
    case shieldCheck = "shield-check"
    
    // MARK: - Transportation
    case car = "car"
    case truck = "truck"
    case plane = "plane"
    case train = "train"
    case bike = "bike"
    case bus = "bus"
    case ship = "ship"
    
    // MARK: - Multimedia & Entertainment
    case airplay = "airplay"
    case cast = "cast"
    case headphones = "headphones"
    case mic = "mic"
    case micOff = "mic-off"
    case camera = "camera"
    case cameraOff = "camera-off"
    case film = "film"
    case gamepad = "gamepad-2"
    
    // MARK: - Additional Icons
    case home = "home"
    case loader2 = "loader-2"
    
    /// Returns the CSS class name for this Lucide icon.
    ///
    /// The class name follows the Lucide convention of "lucide-{icon-name}".
    /// This can be used directly in HTML class attributes when the Lucide
    /// CSS is included in the document.
    ///
    /// - Returns: The CSS class name (e.g., "lucide-airplay")
    public var cssClass: String {
        return "lucide-\(self.rawValue)"
    }
    
    /// Returns the icon identifier string.
    ///
    /// This is the same as the rawValue but provides a more semantic
    /// property name for when you need the string identifier.
    ///
    /// - Returns: The icon identifier (e.g., "airplay")
    public var identifier: String {
        return self.rawValue
    }
    
    /// Returns a human-readable name for the icon.
    ///
    /// Converts the kebab-case identifier to a title-case name
    /// suitable for display purposes.
    ///
    /// - Returns: A title-case name (e.g., "Air Play")
    public var displayName: String {
        return self.rawValue
            .split(separator: "-")
            .map { $0.capitalized }
            .joined(separator: " ")
    }
}

// MARK: - ExpressibleByStringLiteral

extension LucideIcon: ExpressibleByStringLiteral {
    /// Creates a LucideIcon from a string literal.
    ///
    /// This allows using string literals where LucideIcon is expected,
    /// providing a convenient way to specify icons while maintaining
    /// type safety for known icons.
    ///
    /// ## Example
    /// ```swift
    /// let icon: LucideIcon = "airplay"  // Creates LucideIcon.airplay
    /// let customIcon: LucideIcon = "custom-icon"  // Creates a custom case
    /// ```
    ///
    /// - Parameter value: The string literal representing the icon identifier
    public init(stringLiteral value: String) {
        self = LucideIcon(rawValue: value) ?? .circle  // Default fallback
    }
}

// MARK: - CustomStringConvertible

extension LucideIcon: CustomStringConvertible {
    /// A textual representation of the icon.
    ///
    /// Returns the raw identifier string, making it easy to use
    /// LucideIcon values in string contexts.
    public var description: String {
        return self.rawValue
    }
}