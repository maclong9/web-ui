import Testing

@testable import WebUI

@Suite("Form Element Tests")
struct FormElementTests {
  @Test("Form renders with required action and method")
  func testBasicFormRender() throws {
    let form = Form(action: "/submit", method: .post) {
      "Form content"
    }
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
      html == "<form action=\"/login\" method=\"get\" id=\"login-form\" class=\"auth compact\">Login fields</form>")
  }

  @Test("Form renders with enctype attribute when specified")
  func testFormWithEnctype() throws {
    let form = Form(action: "/upload", method: .post, enctype: .multipartFormData) {
      "File upload"
    }
    let html = form.render()
    #expect(html == "<form action=\"/upload\" method=\"post\" enctype=\"multipart/form-data\">File upload</form>")
  }

  @Test("Form renders without enctype when unspecified")
  func testFormWithoutEnctype() throws {
    let form = Form(action: "/data", method: .post) {
      "Data entry"
    }
    let html = form.render()
    #expect(html == "<form action=\"/data\" method=\"post\">Data entry</form>")
  }

  @Test("Form renders with nested input and button elements")
  func testFormWithNestedElements() throws {
    let form = Form(action: "/contact", method: .post, id: "contact-form") {
      Input(type: .text, placeholder: "Your name")
      Textarea(placeholder: "Your message")
      Button(type: .submit) {
        "Send"
      }
    }
    let html = form.render()
    #expect(
      html
        == "<form action=\"/contact\" method=\"post\" id=\"contact-form\"><input type=\"text\" placeholder=\"Your name\"><textarea placeholder=\"Your message\"></textarea><button type=\"submit\">Send</button></form>"
    )
  }

  @Test("Form renders with get method")
  func testFormWithGetMethod() throws {
    let form = Form(action: "/query", method: .get) {
      Input(type: .text, placeholder: "Search term")
      Button(type: .submit) {
        "Search"
      }
    }
    let html = form.render()
    #expect(
      html
        == "<form action=\"/query\" method=\"get\"><input type=\"text\" placeholder=\"Search term\"><button type=\"submit\">Search</button></form>"
    )
  }
}
