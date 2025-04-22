import Foundation
import Logging

/// Provides configuration for the logging system.
public struct LoggingSetup {
  /// Configures the logging system for the application.
  /// - Parameter logLevel: The minimum log level to display. Defaults to `.info`.
  public static func bootstrap(logLevel: Logger.Level = .info) {
    LoggingSystem.bootstrap { label in
      var handler = StreamLogHandler.standardOutput(label: label)
      handler.logLevel = logLevel
      return handler
    }

    let logger = Logger(label: "com.webui.setup")
    logger.notice("Logging system initialized with log level: \(logLevel)")
  }
}
