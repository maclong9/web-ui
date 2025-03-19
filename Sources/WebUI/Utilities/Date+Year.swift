import Foundation

/// Extends Date with year formatting functionality.
///
/// Provides a method to format dates as four-digit years.
extension Date {
  /// Formats the date as a four-digit year.
  ///
  /// Converts the date into a string representing its year (e.g., "2025").
  ///
  /// - Returns: The year as a string.
  func formattedYear() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return formatter.string(from: self)
  }
}
