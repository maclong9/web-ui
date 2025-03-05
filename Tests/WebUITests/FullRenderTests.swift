import Testing

@testable import WebUI

@Suite("Full Page Tests")
struct FullPageTests {
  @Test("Document renders complete page with all elements")
  func testCompletePageRender() throws {
    let config = Configuration(
      metadata: Metadata(
        site: "Test Site",
        title: "%s",
        twitter: "testuser",
        locale: "en-US"
      )
    )

    let document = Document(
      configuration: config,
      title: "Test Page",
      description: "A complete test page with all elements",
      keywords: ["test", "html", "web"],
      author: "Test Author",
      type: "website"
    ) {
      Header(id: "site-header") {
        Navigation {
          Stack { "Test Site" }
            .font(weight: .bold)
          Stack {
            Button(type: .submit) { "Home" }
            Button { "About" }
          }
        }
      }

      Main(id: "main-content") {
        Heading(level: .h1) { "Welcome to Test Site" }
        Article {
          Heading(level: .h2) { "Here is an article headline" }
          Section {
            Heading(level: .h3) { "Here is a section headline" }
              .flex(.column, justify: .center, align: .center)
              .font(
                weight: .bold,
                size: .xl3,
                alignment: .center,
                decoration: .underline
              )

            Text { "This is a test paragraph with styled text." }
              .font(size: .base, tracking: .normal, leading: .normal)
            
            Text { "This text is small on mobile and xl on desktop." }
              .font(size: .xs)
              .font(size: .xl5, on: .md)
          }

          Form(
            action: "/submit",
            method: .post,
            enctype: .multipartFormData
          ) {
            Stack {
              Input(
                type: .text,
                placeholder: "Enter your name"
              )
              Input(
                type: .email,
                placeholder: "Enter your email",
                autofocus: true
              )
              Textarea(placeholder: "Your message")
              Button(type: .submit) { "Submit" }
              Button(type: .reset) { "Reset" }
            }.flex(.column, justify: .between, align: .start)
          }
        }
      }

      Footer {
        Stack { "© 2025 Test Site. All rights reserved." }
          .flex(justify: .center)
          .font(size: .sm, alignment: .center)
      }
    }

    let html = document.render()
    print(html)

    // Basic structure tests
    #expect(html.contains("<!DOCTYPE html>"))
    #expect(html.contains("<html lang=\"en-US\">"))
    #expect(html.contains("<title>Test Page | Test Site</title>"))
    #expect(html.contains("<meta name=\"description\" content=\"A complete test page with all elements\">"))
    #expect(html.contains("<meta name=\"twitter:creator\" content=\"@testuser\">"))
    #expect(html.contains("<meta name=\"keywords\" content=\"test, html, web\">"))
    #expect(html.contains("<meta name=\"author\" content=\"Test Author\">"))

    // Header tests
    #expect(html.contains("<header id=\"site-header\">"))
    #expect(html.contains("<nav>"))

    // Main content tests
    #expect(html.contains("<main id=\"main-content\">"))
    #expect(html.contains("<article>"))
    #expect(html.contains("<section>"))
    #expect(html.contains("<h1>Welcome to Test Site</h1>"))
    #expect(html.contains("Here is an article headline</h2>"))
    #expect(html.contains("Here is a section headline</h3>"))

    // Flex and font styling tests
    #expect(
      html.contains(
        "class=\"flex flex-col justify-center items-center font-bold text-3xl text-center decoration-underline\""))
    #expect(html.contains("class=\"text-base tracking-normal leading-normal\""))

    // Form tests
    #expect(html.contains("<form action=\"/submit\" method=\"post\" enctype=\"multipart/form-data\">"))
    #expect(html.contains("<input type=\"text\" placeholder=\"Enter your name\">"))
    #expect(html.contains("<input type=\"email\" placeholder=\"Enter your email\" autofocus>"))
    #expect(html.contains("<textarea placeholder=\"Your message\"></textarea>"))
    #expect(html.contains("<button type=\"submit\">Submit</button>"))
    #expect(html.contains("<button type=\"reset\">Reset</button>"))

    // Footer tests
    #expect(html.contains("<footer>"))
    #expect(html.contains("class=\"flex justify-center text-sm text-center\""))
  }

  @Test("Document handles hidden elements")
  func testHiddenElements() throws {
    let document = Document(
      title: "Hidden Test",
      description: "Test with hidden elements"
    ) {
      Stack { "This should be hidden" }.hidden(true)
      Stack { "This should be visible" }.hidden(false)
    }

    let html = document.render()
    #expect(html.contains("class=\"hidden\">This should be hidden"))
    #expect(html.contains("This should be visible"))
  }
}
