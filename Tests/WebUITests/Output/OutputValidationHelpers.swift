import Foundation

@testable import WebUI

// MARK: - Test Helpers for Output Validation

extension Element {
  /// Renders the element to HTML string for testing
  func render() -> String {
    // Use the built-in render method from Markup protocol
    self.body.render()
  }

  /// Extracts CSS classes from the rendered HTML
  func extractCSSClasses() -> [String] {
    let htmlOutput = self.render()
    return extractCSSClassesFromHTML(htmlOutput)
  }
}

extension Markup {
  /// Extracts CSS classes from the rendered HTML
  func extractCSSClasses() -> [String] {
    let htmlOutput = self.render()
    return extractCSSClassesFromHTML(htmlOutput)
  }
}

/// Helper function to extract CSS classes from HTML string
func extractCSSClassesFromHTML(_ html: String) -> [String] {
  var classes: [String] = []

  // Use regex to find class attributes
  let classPattern = #"class\s*=\s*[\"']([^\"']*)[\"']"#

  do {
    let regex = try NSRegularExpression(pattern: classPattern, options: .caseInsensitive)
    let matches = regex.matches(
      in: html, options: [], range: NSRange(location: 0, length: html.count))

    for match in matches {
      if let range = Range(match.range(at: 1), in: html) {
        let classString = String(html[range])
        let classList = classString.split(separator: " ").map(String.init)
        classes.append(contentsOf: classList)
      }
    }
  } catch {
    print("Regex error: \(error)")
  }

  return classes.filter { !$0.isEmpty }
}

/// String extension for pattern matching
extension String {
  func matches(pattern: String) -> Bool {
    do {
      let regex = try NSRegularExpression(pattern: pattern, options: [])
      let range = NSRange(location: 0, length: self.count)
      return regex.firstMatch(in: self, options: [], range: range) != nil
    } catch {
      return false
    }
  }
}

// MARK: - Test Modifier Extensions

extension Element {
  /// Test method for custom CSS properties
  func customCSS(_ property: String, value: String) -> some Element {
    // This would need to be implemented in the actual Element protocol
    // For now, return self for compilation
    self
  }

  /// Test method for click handlers
  func onClick(_ handler: String) -> some Element {
    // This would need to be implemented in the actual Element protocol
    self
  }

  /// Test method for data attributes
  func data(_ key: String, _ value: String) -> some Element {
    // This would need to be implemented in the actual Element protocol
    self
  }
}

// MARK: - Color Test Helpers

enum TestColor {
  case blue
  case darkBlue
  case gray
  case white
}

enum TestHoverState {
  case hover
  case focus
  case active
}

// MARK: - Size Test Helpers

enum TestSize {
  case small
  case medium
  case large
  case extraLarge
  case full
  case screen
  case container
}

enum TestFontWeight {
  case bold
  case normal
  case light
}

enum TestTextAlign {
  case center
  case left
  case right
}

enum TestLineHeight {
  case relaxed
  case normal
  case tight
}

enum TestDisplay {
  case block
  case flex
  case grid
  case inline
}

enum TestJustifyContent {
  case spaceBetween
  case center
  case start
  case end
}

enum TestAlignItems {
  case center
  case start
  case end
}

enum TestFlexDirection {
  case row
  case column
}

enum TestGridColumns {
  case count(Int)
  case auto
}

enum TestBreakpoint {
  case mobile
  case tablet
  case desktop
}

// MARK: - Placeholder Modifier Extensions

extension Element {
  func padding(_ size: TestSize, at edge: Edge = .all) -> some Element { self }
  func padding(_ size: TestSize, on breakpoint: TestBreakpoint) -> some Element { self }
  func margin(_ size: TestSize, at edge: Edge = .all) -> some Element { self }
  func backgroundColor(_ color: TestColor) -> some Element { self }
  func backgroundColor(_ color: TestColor, on state: TestHoverState) -> some Element { self }
  func textColor(_ color: TestColor) -> some Element { self }
  func borderColor(_ color: TestColor) -> some Element { self }
  func borderRadius(_ size: TestSize) -> some Element { self }
  func shadow(_ size: TestSize) -> some Element { self }
  func width(_ size: TestSize) -> some Element { self }
  func height(_ size: TestSize) -> some Element { self }
  func maxWidth(_ size: TestSize) -> some Element { self }
  func fontSize(_ size: TestSize) -> some Element { self }
  func fontSize(_ size: TestSize, on breakpoint: TestBreakpoint) -> some Element { self }
  func fontWeight(_ weight: TestFontWeight) -> some Element { self }
  func textAlign(_ align: TestTextAlign) -> some Element { self }
  func lineHeight(_ height: TestLineHeight) -> some Element { self }
  // NOTE: display() methods removed to avoid conflict with actual DisplayStyleOperation.swift implementation
  // func display(_ display: TestDisplay) -> some Element { self }
  // func display(_ display: TestDisplay, on breakpoint: TestBreakpoint) -> some Element { self }
  func justifyContent(_ justify: TestJustifyContent) -> some Element { self }
  func alignItems(_ align: TestAlignItems) -> some Element { self }
  func flexDirection(_ direction: TestFlexDirection) -> some Element { self }
  func gridColumns(_ columns: TestGridColumns) -> some Element { self }
  func gap(_ size: TestSize) -> some Element { self }
  func transform(_ transform: TestTransform, on state: TestHoverState) -> some Element { self }
}

enum TestTransform {
  case scale(Double)
  case rotate(Double)
  case translate(x: Double, y: Double)
}

// MARK: - Edge enum for testing

enum Edge {
  case all
  case top
  case bottom
  case left
  case right
  case horizontal
  case vertical
}
