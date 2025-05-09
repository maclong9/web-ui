import Foundation
import Logging

/// Provides configuration for the logging system.
public struct LoggingSetup {
  /// Configures the logging system for the application.
  /// - Parameter logLevelString: The string representation of the log level from environment (e.g., "info", "debug"). Defaults to "info".
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
