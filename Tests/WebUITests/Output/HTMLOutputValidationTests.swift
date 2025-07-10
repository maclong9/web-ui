import Foundation
import Testing

@testable import WebUI

@Suite("HTML Output Validation Tests")
struct HTMLOutputValidationTests {

  /// Validates that basic elements generate correct HTML structure
  @Test("Basic element HTML generation")
  func basicElementGeneration() {
    // Test Text element - single sentence becomes <span>
    let text = Text("Hello World")
    let htmlOutput = text.render()

    #expect(htmlOutput.contains("<span>Hello World</span>"))
    #expect(!htmlOutput.contains("undefined"))
    #expect(!htmlOutput.contains("null"))
  }

  /// Validates that elements with CSS classes generate correct output
  @Test("Element with CSS classes")
  func elementWithClasses() {
    let text = Text("Styled text", classes: ["primary", "bold"])
    let htmlOutput = text.render()

    #expect(htmlOutput.contains("class=\"primary bold\""))
    #expect(htmlOutput.contains("Styled text"))
  }

  /// Validates HTML escaping for security
  @Test("HTML escaping validation")
  func htmlEscaping() {
    let maliciousText = Text("<script>alert('xss')</script>")
    let htmlOutput = maliciousText.render()

    #expect(htmlOutput.contains("&lt;script&gt;"))
    #expect(htmlOutput.contains("&lt;/script&gt;"))
    #expect(!htmlOutput.contains("<script>"))
  }

  /// Validates heading elements with proper levels
  @Test("Heading element validation")
  func headingValidation() {
    let h1 = Heading(.largeTitle, "Main Title")
    let h2 = Heading(.title, "Section Title")
    let h3 = Heading(.headline, "Subtitle")

    let h1Output = h1.render()
    let h2Output = h2.render()
    let h3Output = h3.render()

    #expect(h1Output.contains("<h1>Main Title</h1>"))
    #expect(h2Output.contains("<h2>Section Title</h2>"))
    #expect(h3Output.contains("<h3>Subtitle</h3>"))
  }

  /// Validates link elements with proper attributes
  @Test("Link element validation")
  func linkValidation() {
    let link = Link(to: "/about") { "About Page" }
    let htmlOutput = link.render()

    #expect(htmlOutput.contains("<a href=\"/about\">About Page</a>"))
    #expect(!htmlOutput.contains("href=\"\""))
  }

  /// Validates button elements with proper attributes
  @Test("Button element validation")
  func buttonValidation() {
    let button = Button("Click Me", type: .submit)
    let htmlOutput = button.render()

    #expect(htmlOutput.contains("<button"))
    #expect(htmlOutput.contains("type=\"submit\""))
    #expect(htmlOutput.contains("Click Me"))
    #expect(htmlOutput.contains("</button>"))
  }

  /// Validates form elements structure
  @Test("Form element validation")
  func formValidation() {
    let form = Form {
      Input(name: "email", type: .email, placeholder: "Enter email")
      Button("Submit", type: .submit)
    }
    let htmlOutput = form.render()

    #expect(htmlOutput.contains("<form"))
    #expect(htmlOutput.contains("</form>"))
    #expect(htmlOutput.contains("input"))
    #expect(htmlOutput.contains("type=\"email\""))
    #expect(htmlOutput.contains("name=\"email\""))
  }

  /// Validates nested elements structure
  @Test("Nested elements validation")
  func nestedElementsValidation() {
    let section = Section {
      Heading(.headline, "Section Title")
      Text("Section content")
    }
    let htmlOutput = section.render()

    #expect(htmlOutput.contains("<section"))
    #expect(htmlOutput.contains("</section>"))
    #expect(htmlOutput.contains("<h3>Section Title</h3>"))
    #expect(htmlOutput.contains("<span>Section content</span>"))
  }

  /// Validates list elements structure
  @Test("List elements validation")
  func listValidation() {
    let list = List {
      Item { "First item" }
      Item { "Second item" }
    }
    let htmlOutput = list.render()

    #expect(htmlOutput.contains("<ul"))
    #expect(htmlOutput.contains("</ul>"))
    #expect(htmlOutput.contains("<li>First item</li>"))
    #expect(htmlOutput.contains("<li>Second item</li>"))
  }

  /// Validates image elements with proper attributes
  @Test("Image element validation")
  func imageValidation() {
    let image = Image(
      source: "/images/logo.png",
      description: "Company Logo"
    )
    let htmlOutput = image.render()

    #expect(htmlOutput.contains("<img"))
    #expect(htmlOutput.contains("src=\"/images/logo.png\""))
    #expect(htmlOutput.contains("alt=\"Company Logo\""))
  }

  /// Validates accessibility attributes
  @Test("Accessibility attributes validation")
  func accessibilityValidation() {
    let button = Button("Save", role: .button, label: "Save document")
    let htmlOutput = button.render()

    #expect(htmlOutput.contains("role=\"button\""))
    #expect(htmlOutput.contains("aria-label=\"Save document\""))
  }

  /// Validates data attributes
  @Test("Data attributes validation")
  func dataAttributesValidation() {
    let div = Section(data: [
      "component": "card",
      "variant": "primary",
    ]) {
      Text("Card content")
    }
    let htmlOutput = div.render()

    #expect(htmlOutput.contains("data-component=\"card\""))
    #expect(htmlOutput.contains("data-variant=\"primary\""))
  }

  /// Validates responsive classes generation
  @Test("Responsive classes validation")
  func responsiveClassesValidation() {
    // Test with actual classes parameter since style modifiers may not be implemented yet
    let text = Text("Responsive text", classes: ["text-lg", "md:text-xl", "p-4"])

    let htmlOutput = text.render()

    // Should contain responsive CSS classes
    #expect(htmlOutput.contains("class="))
    #expect(htmlOutput.contains("text-lg"))
    #expect(!htmlOutput.contains("undefined"))
  }
}
