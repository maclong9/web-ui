import Foundation
import Logging

/// Provides configuration for the application's logging system.
///
/// The `LoggingSetup` struct initializes and configures the Swift Logging system,
/// providing consistent log output formatting and control over log verbosity levels.
/// This centralized configuration ensures logs are handled consistently across the application.
///
/// - Example:
///   ```swift
///   // Configure logging with info level
///   LoggingSetup.bootstrap()
///
///   // Configure logging with debug level
///   LoggingSetup.bootstrap(logLevelString: "debug")
///   ```
public struct LoggingSetup {
    /// Configures and initializes the logging system for the application.
    ///
    /// This method bootstraps the Swift Logging system, setting up the appropriate log level
    /// and output formatting. It should be called early in the application lifecycle,
    /// typically during initialization.
    ///
    /// - Parameter logLevelString: The string representation of the desired log level from environment
    ///   (e.g., "trace", "debug", "info", "notice", "warning", "error", "critical").
    ///   Defaults to "info" if not specified.
    ///
    /// - Example:
    ///   ```swift
    ///   // In your application's startup code:
    ///   LoggingSetup.bootstrap(logLevelString: ProcessInfo.processInfo.environment["LOG_LEVEL"] ?? "info")
    ///   ```
    public static func bootstrap(logLevelString: String = "info") {
        let logLevel: Logger.Level
        switch logLevelString.lowercased() {
        case "trace": logLevel = .trace
        case "debug": logLevel = .debug
        case "notice": logLevel = .notice
        case "warning", "warn": logLevel = .warning
        case "error": logLevel = .error
        case "critical": logLevel = .critical
        default: logLevel = .info
        }

        LoggingSystem.bootstrap { label in
            var handler = StreamLogHandler.standardOutput(label: label)
            handler.logLevel = logLevel
            return handler
        }

        let logger = Logger(label: "com.webui.setup")
        logger.notice("Logging system initialized with log level: \(logLevel)")
    }
}
