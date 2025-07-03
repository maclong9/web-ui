import Foundation

// MARK: - Shared Extensions for DevServer

/// Thread-safe locking extension for NSLock
extension NSLock {
    /// Executes a closure while holding the lock
    func withLock<T>(_ closure: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try closure()
    }
}

// MARK: - ANSI Colors

/// ANSI color codes for terminal output
enum ANSIColor: String {
    case reset = "\u{001B}[0m"
    case red = "\u{001B}[31m"
    case green = "\u{001B}[32m"
    case yellow = "\u{001B}[33m"
    case blue = "\u{001B}[34m"
    case magenta = "\u{001B}[35m"
    case cyan = "\u{001B}[36m"
    case white = "\u{001B}[37m"
    case gray = "\u{001B}[90m"
    
    func colorize(_ text: String) -> String {
        return rawValue + text + ANSIColor.reset.rawValue
    }
}