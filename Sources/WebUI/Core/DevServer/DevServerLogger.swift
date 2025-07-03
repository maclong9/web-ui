import Foundation

/// A specialized logger for development server operations.
///
/// `DevServerLogger` provides formatted, colored output for development server
/// events with different log levels and timestamps:
/// - Info messages for general operations
/// - Success messages for completed operations
/// - Warning messages for non-critical issues
/// - Error messages for failures
/// - Debug messages for detailed tracing
///
/// ## Usage
///
/// ```swift
/// let logger = DevServerLogger()
/// logger.info("Server starting...")
/// logger.success("Build completed!")
/// logger.error("Connection failed")
/// ```
public final class DevServerLogger: @unchecked Sendable {
    
    /// Log level for controlling output verbosity
    public enum LogLevel: Int, CaseIterable {
        case debug = 0
        case info = 1
        case warning = 2
        case error = 3
        case success = 4
        
        var prefix: String {
            switch self {
            case .debug: return "🔍 DEBUG"
            case .info: return "ℹ️  INFO"
            case .warning: return "⚠️  WARN"
            case .error: return "❌ ERROR"
            case .success: return "✅ SUCCESS"
            }
        }
        
        fileprivate var color: ANSIColor {
            switch self {
            case .debug: return .gray
            case .info: return .blue
            case .warning: return .yellow
            case .error: return .red
            case .success: return .green
            }
        }
    }
    
    private let minimumLogLevel: LogLevel
    private let includeTimestamp: Bool
    private let useColors: Bool
    private let dateFormatter: DateFormatter
    private let lock = NSLock()
    
    /// Creates a new development server logger.
    ///
    /// - Parameters:
    ///   - minimumLogLevel: Minimum log level to output (defaults to .info)
    ///   - includeTimestamp: Whether to include timestamps in output (defaults to true)
    ///   - useColors: Whether to use ANSI colors in output (defaults to true)
    public init(
        minimumLogLevel: LogLevel = .info,
        includeTimestamp: Bool = true,
        useColors: Bool = true
    ) {
        self.minimumLogLevel = minimumLogLevel
        self.includeTimestamp = includeTimestamp
        self.useColors = useColors && Self.isTerminal()
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "HH:mm:ss.SSS"
    }
    
    /// Logs a debug message.
    ///
    /// Debug messages are used for detailed tracing and are typically only
    /// shown when debugging specific issues.
    ///
    /// - Parameter message: The message to log
    public func debug(_ message: String) {
        log(level: .debug, message: message)
    }
    
    /// Logs an informational message.
    ///
    /// Info messages are used for general operational information like
    /// server startup, file changes, and normal operations.
    ///
    /// - Parameter message: The message to log
    public func info(_ message: String) {
        log(level: .info, message: message)
    }
    
    /// Logs a warning message.
    ///
    /// Warning messages indicate non-critical issues that should be noted
    /// but don't prevent operation from continuing.
    ///
    /// - Parameter message: The message to log
    public func warning(_ message: String) {
        log(level: .warning, message: message)
    }
    
    /// Logs an error message.
    ///
    /// Error messages indicate failures or critical issues that prevent
    /// normal operation from continuing.
    ///
    /// - Parameter message: The message to log
    public func error(_ message: String) {
        log(level: .error, message: message)
    }
    
    /// Logs a success message.
    ///
    /// Success messages indicate successful completion of operations like
    /// builds, deployments, or other significant tasks.
    ///
    /// - Parameter message: The message to log
    public func success(_ message: String) {
        log(level: .success, message: message)
    }
    
    // MARK: - Private Methods
    
    private func log(level: LogLevel, message: String) {
        guard level.rawValue >= minimumLogLevel.rawValue else { return }
        
        lock.withLock {
            let timestamp = includeTimestamp ? "[\(dateFormatter.string(from: Date()))] " : ""
            let prefix = level.prefix
            let colorizedMessage = useColors ? level.color.colorize(message) : message
            let colorizedPrefix = useColors ? level.color.colorize(prefix) : prefix
            
            let logMessage = "\(timestamp)\(colorizedPrefix): \(colorizedMessage)"
            
            // Use stderr for errors and warnings, stdout for everything else
            if level == .error || level == .warning {
                fputs(logMessage + "\n", stderr)
                fflush(stderr)
            } else {
                print(logMessage)
                fflush(stdout)
            }
        }
    }
    
    private static func isTerminal() -> Bool {
        return isatty(STDOUT_FILENO) != 0
    }
}

