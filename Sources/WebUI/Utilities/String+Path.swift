extension String {
  /// Converts the string to a lowercase, hyphen-separated path representation.
  ///
  /// - Returns: The string as in lowercase with hyphens for spaces.
  public func pathFormatted() -> String {
    lowercased()
      .replacingOccurrences(of: "[^a-z0-9 ]", with: "", options: .regularExpression)
      .split(separator: " ")
      .filter { !$0.isEmpty }
      .joined(separator: "-")
      .trimmingCharacters(in: .whitespaces)
  }
}
