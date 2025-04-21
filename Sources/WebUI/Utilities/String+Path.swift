extension String {
  /// Converts the string to a lowercase, hyphen-separated path representation.
  public func pathFormatted() -> String {
    lowercased()
      .replacingOccurrences(of: "[^a-z0-9 ]", with: "", options: .regularExpression)
      .split(separator: " ")
      .filter { !$0.isEmpty }
      .joined(separator: "-")
      .trimmingCharacters(in: .whitespaces)
  }
}
