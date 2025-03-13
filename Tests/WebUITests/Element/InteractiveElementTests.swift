import Testing

@testable import WebUI

@Suite("Interactive Elements Tests")
struct InteractiveElementsTests {
  // From InteractiveElementTests
  @Test("Button renders as button tag")
  func testButtonRender() throws {
    let button = Button(id: "btn1") { "Click me" }
    let html = button.render()
    #expect(html == "<button id=\"btn1\">Click me</button>")
  }

  @Test("Link renders with href and optional target")
  func testLinkRender() throws {
    let link = Link(href: "/page", newTab: true, classes: ["nav"]) { "Go to page" }
    let html = link.render()
    #expect(html == "<a class=\"nav\" href=\"/page\" target=\"_blank\">Go to page</a>")

    let linkNoTarget = Link(href: "/home") { "Home" }
    let htmlNoTarget = linkNoTarget.render()
    #expect(htmlNoTarget == "<a href=\"/home\">Home</a>")
  }

  @Test("Button renders with type attribute when specified")
  func testButtonWithType() throws {
    let html = Button(type: .submit) { "Submit Form" }.render()
    #expect(html == "<button type=\"submit\">Submit Form</button>")

    let resetHtml = Button(id: "resetBtn", type: .reset) { "Reset" }.render()
    #expect(resetHtml == "<button id=\"resetBtn\" type=\"reset\">Reset</button>")
  }

  @Test("Button renders with autofocus attribute when enabled")
  func testButtonWithAutofocus() throws {
    let html = Button(autofocus: true) { "Focus Me" }.render()
    #expect(html == "<button autofocus>Focus Me</button>")
  }

  @Test("Button renders with both type and autofocus when specified")
  func testButtonWithTypeAndAutofocus() throws {
    let html = Button(id: "save", classes: ["btn"], type: .submit, autofocus: true) { "Save" }.render()
    #expect(html == "<button id=\"save\" class=\"btn\" type=\"submit\" autofocus>Save</button>")
  }

  @Test("Button renders without type or autofocus when unspecified")
  func testButtonWithoutTypeOrAutofocus() throws {
    let html = Button() { "Plain" }.render()
    #expect(html == "<button>Plain</button>")
  }

  @Test("Input element renders as self closing")
  func testInputRendersAsSelfClosing() throws {
    let html = Input(type: .number).render()
    #expect(html == "<input type=\"number\">")
  }

  @Test("Textarea element renders correctly")
  func testTextareaRendersCorrectly() throws {
    let html = Textarea(placeholder: "Add a message").render()
    #expect(html == "<textarea placeholder=\"Add a message\"></textarea>")
  }

  // From FormElementTests
  @Test("Form renders with required action and method")
  func testBasicFormRender() throws {
    let form = Form(action: "/submit", method: .post) { "Form content" }
    let html = form.render()
    #expect(html == "<form action=\"/submit\" method=\"post\">Form content</form>")
  }

  @Test("Form renders with optional id and classes")
  func testFormWithIdAndClasses() throws {
    let form = Form(action: "/login", method: .get, id: "login-form", classes: ["auth", "compact"]) {
      "Login fields"
    }
    let html = form.render()
    #expect(
      html == "<form id=\"login-form\" class=\"auth compact\" action=\"/login\" method=\"get\">Login fields</form>")
  }

  @Test("Form renders with enctype attribute when specified")
  func testFormWithEnctype() throws {
    let form = Form(action: "/upload", method: .post, enctype: .multipartFormData) { "File upload" }
    let html = form.render()
    #expect(html == "<form action=\"/upload\" method=\"post\" enctype=\"multipart/form-data\">File upload</form>")
  }

  @Test("Form renders without enctype when unspecified")
  func testFormWithoutEnctype() throws {
    let form = Form(action: "/data", method: .post) { "Data entry" }
    let html = form.render()
    #expect(html == "<form action=\"/data\" method=\"post\">Data entry</form>")
  }

  @Test("Form renders with nested input and button elements")
  func testFormWithNestedElements() throws {
    let form = Form(action: "/contact", method: .post, id: "contact-form") {
      Input(type: .text, placeholder: "Your name")
      Textarea(placeholder: "Your message")
      Button(type: .submit) { "Send" }
    }
    let html = form.render()
    #expect(
      html
        == "<form id=\"contact-form\" action=\"/contact\" method=\"post\"><input type=\"text\" placeholder=\"Your name\"><textarea placeholder=\"Your message\"></textarea><button type=\"submit\">Send</button></form>"
    )
  }

  @Test("Form renders with get method")
  func testFormWithGetMethod() throws {
    let form = Form(action: "/query", method: .get) {
      Input(type: .text, placeholder: "Search term")
      Button(type: .submit) { "Search" }
    }
    let html = form.render()
    #expect(
      html
        == "<form action=\"/query\" method=\"get\"><input type=\"text\" placeholder=\"Search term\"><button type=\"submit\">Search</button></form>"
    )
  }
  
  @Test("Label renders correctly")
  func testLabelRendersCorrectly() throws {
    let label = Label(for: "email") {
      "Email Address"
    }
    let html = label.render()
    #expect(html == "<label for=\"email\">Email Address</label>")
  }
}
