import Foundation

/// Extends `Date` with a method to format the year as a string.
extension Date {
  func formattedYear() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return formatter.string(from: self)
  }
}
