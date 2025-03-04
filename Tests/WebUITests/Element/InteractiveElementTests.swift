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

  // New tests for Button class with type and autofocus
  @Test("Button renders with type attribute when specified")
  func testButtonWithType() throws {
    let html = Button(type: .submit) {
      "Submit Form"
    }.render()
    #expect(html == "<button type=\"submit\">Submit Form</button>")

    let resetHtml = Button(id: "resetBtn", type: .reset) {
      "Reset"
    }.render()
    #expect(resetHtml == "<button id=\"resetBtn\" type=\"reset\">Reset</button>")
  }

  @Test("Button renders with autofocus attribute when enabled")
  func testButtonWithAutofocus() throws {
    let html = Button(autofocus: true) {
      "Focus Me"
    }.render()
    #expect(html == "<button autofocus>Focus Me</button>")
  }

  @Test("Button renders with both type and autofocus when specified")
  func testButtonWithTypeAndAutofocus() throws {
    let html = Button(id: "save", classes: ["btn"], role: .button, type: .submit, autofocus: true) {
      "Save"
    }.render()
    #expect(html == "<button id=\"save\" class=\"btn\" role=\"button\" type=\"submit\" autofocus>Save</button>")
  }

  @Test("Button renders without type or autofocus when unspecified")
  func testButtonWithoutTypeOrAutofocus() throws {
    let html = Button() {
      "Plain"
    }.render()
    #expect(html == "<button>Plain</button>")
  }
}
