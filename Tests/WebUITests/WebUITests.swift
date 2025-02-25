import Testing

@testable import WebUI

@Suite("Configuration Tests") struct ConfigurationTests {
  @Test func shouldInitialize() async throws {
    let config = Configuration()
    #expect(config.metadata.locale == "en")
  }

  @Test func shouldInitializeWithCustomSite() async throws {
    let customSite = "Custom Site"
    let theme = Configuration(metadata: Metadata(site: customSite))
    #expect(theme.metadata.site == customSite)
  }
}

@Suite("Document Tests") struct DocumentTests {
  @Test func shouldInitialize() async throws {
    let config = Configuration()
    let testTitle = "Test Title"
    let testDescription = "Hello, world!"
    let document = Document(title: testTitle, description: testDescription, content: "")
    #expect(document.title == testTitle)
    #expect(document.description == testDescription)
    let html = document.render()
    #expect(html.contains("<title>\(testTitle) | \(config.metadata.site)</title>"))
    #expect(html.contains("<meta name=\"description\" content=\"\(testDescription)\">"))
  }

  @Test func shouldRenderAlternateHeaderandFooter() async throws {
    let config = Configuration(layout: Layout(header: .logoCentered, footer: .minimal))
    let documentOne = Document(title: "Test Title", description: "Hello, world!", content: "")
    let htmlOne = documentOne.render()
    let documentTwo = Document(configuration: config, title: "Test Title", description: "Hello, world!", content: "")
    let htmlTwo = documentTwo.render()
    #expect(htmlOne != htmlTwo)
    #expect(htmlTwo.contains("header-centered"))
    #expect(htmlTwo.contains("footer-minimal"))
  }

  @Test func shouldRenderOverrideHeaderandFooter() async throws {
    let config = Configuration(layout: Layout(header: .hidden, footer: .hidden))
    let documentOne = Document(
      configuration: config,
      title: "Test Title",
      description: "Hello, world!",
      content: ""
    )
    let htmlOne = documentOne.render()
    #expect(!htmlOne.contains("header-normal"))
    #expect(!htmlOne.contains("footer-normal"))
    let documentTwo = Document(
      configuration: config,
      title: "Test Title",
      description: "Hello, world!",
      content: "",
      headerOverride: .normal,
      footerOverride: .normal
    )
    let htmlTwo = documentTwo.render()
    #expect(htmlTwo.contains("header-normal"))
    #expect(htmlTwo.contains("footer-normal"))
  }
}

@Suite("Element Tests") struct ElementTests {
  let html = Article {
    Section(id: "main-content") {
      Stack(classes: ["container"]) {
        "This container has one class"
      }
      Stack(classes: ["container primary"]) {
        "This container has multiple classes"
      }
    }
    Section(id: "featured", classes: ["article featured"]) {
      Stack {
        "Hello, world!"
      }
    }
  }.render()

  @Test func shouldRenderBasicLayoutElements() async throws {
    print(html)
    #expect(html.contains("<article>"))
    #expect(html.contains("<div>"))
    #expect(html.contains("<section"))
  }

  @Test func shouldRenderElementWithID() async throws {
    #expect(html.contains("id=\"main-content\""))
  }

  @Test func shouldRenderElementWithClasses() async throws {
    #expect(html.contains("class=\"container\""))
    #expect(html.contains("class=\"container primary\""))
    #expect(html.contains("<div class=\"container\">This container has one class</div>"))
    #expect(html.contains("<div class=\"container primary\">This container has multiple classes</div></section>"))
  }

  @Test func shouldRenderElementWithBothIDAndClasses() async throws {
    #expect(html.contains("id=\"featured\""))
    #expect(html.contains("class=\"article featured\""))
  }
}
