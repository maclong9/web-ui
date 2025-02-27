import Testing

@testable import WebUI

@Suite("Interactive Element Tests")
struct InteractiveElementTests {
  @Test("Button renders as button tag")
  func testButtonRender() throws {
    let button = Button(id: "btn1", role: .button) {
      "Click me"
    }
    let html = button.render()
    #expect(html == "<button id=\"btn1\" role=\"button\">Click me</button>")
  }

  @Test("Link renders with href and optional target")
  func testLinkRender() throws {
    let link = Link(href: "/page", newTab: true, classes: ["nav"]) {
      "Go to page"
    }
    let html = link.render()
    #expect(html == "<a class=\"nav\" href=\"/page\" target=\"_blank\">Go to page</a>")

    let linkNoTarget = Link(href: "/home") {
      "Home"
    }
    let htmlNoTarget = linkNoTarget.render()
    #expect(htmlNoTarget == "<a href=\"/home\">Home</a>")
  }
}
