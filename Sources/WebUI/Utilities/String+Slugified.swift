// Extension to make slug creation more readable
extension String {
  public func slugified() -> String {
    lowercased()
      .replacingOccurrences(of: "[^a-z0-9 ]", with: "", options: .regularExpression)
      .replacingOccurrences(of: " ", with: "-")
  }
}
