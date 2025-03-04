import Foundation

/// This extension provides a way to format a date into a year-only string.
/// The `formattedYear()` method takes a date and returns it as a four-digit year, such as "2025".
extension Date {
  func formattedYear() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return formatter.string(from: self)
  }
}
