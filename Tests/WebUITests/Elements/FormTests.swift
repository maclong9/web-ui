import Testing

@testable import WebUI

@Suite("Form Element Tests") struct FormTests {
  @Test("The form element should render")
  func formElementShouldRender() throws {
    let html = Form(action: "/api/login") {
      Stack {
        Label(for: "email") { "Email Address" }
        Input(name: "email", type: .email, placeholder: "mac@mail.com")
      }
      Stack {
        Label(for: "password") { "Password" }
        Input(name: "password", type: .password, placeholder: "********")
      }
      Button(type: .submit) { "Login" }
    }.render()

    #expect(
      html == """
        <form action="/api/login" method="post"><div><label for="email">Email Address</label><input name="email" type="email" placeholder="mac@mail.com"></div><div><label for="password">Password</label><input name="password" type="password" placeholder="********"></div><button type="submit">Login</button></form>
        """)
  }

  @Test("The form element should render with get method")
  func renderWithGetMethod() throws {
    let html = Form(action: "/api/update", method: .get) {
      Button(type: .submit) { "Update" }
    }.render()

    #expect(
      html == """
        <form action="/api/update" method="get"><button type="submit">Update</button></form>
        """)
  }
  
  @Test("Should render a progess indicator correctly")
  func progressIndicatorRendersCorrectly() {
    let html = Progress(value: 65, max: 100).render()
    #expect(html == #"<progress value="65.0" max="100.0">"#)
  }
  
  @Test("Should render form input correctly")
  func formInputRendersCorrectly() {
    let html = Input(name: "name", type: .text).render()
    #expect(html == #"<input name="name" type="text">"#)
  }
}
