import Foundation
import Testing

@testable import WebUI

@Suite("Base Element Tests") struct BaseTests {
  @Test("Element should render correctly")
  func shouldRenderCorrectly() {
    let el = Element(
      tag: "div",
      config: ElementConfig(
        id: "test-id",
        classes: ["test-class"],
        role: .contentinfo
      )
    ) { "Hello, world!" }.render()
    #expect(el == "<div id=\"test-id\" class=\"test-class\" role=\"contentinfo\">Hello, world!</div>")
  }

  @Test("Elements should be styled correctly")
  func testStyleRender() throws {
    let html = Stack {
      Text {
        "Hello, world!"
      }.font(size: .base, color: .cyan(._500))
    }.render()

    #expect(html.contains("<span class=\"text-base text-cyan-500\">Hello, world!</span>"))
  }

  @Test("Button should render correctly")
  func shouldRenderButtonCorrectly() {
    let button = Button { "Click me" }.render()
    let focusedButton = Button(type: .submit, autofocus: true) {
      "Click me"
    }.render()
    #expect(button == "<button>Click me</button>")
    #expect(focusedButton == "<button type=\"submit\" autofocus>Click me</button>")
  }

  @Test("Images should render correctly")
  func shouldRenderImageCorrectly() {
    let picture = Image(
      source: "hello.png",
      description: "Hello, world!",
      size: ImageSize(width: 100, height: 100)
    ).render()
    #expect(picture == "<img src=\"hello.png\" alt=\"Hello, world!\" width=\"100\" height=\"100\">")
  }

  @Test("Videos should render correctly with single source")
  func shouldRenderVideoCorrectlyWithSingleSource() {
    let video = Video(
      sources: ["hello.mp4"],
      controls: true,
      autoplay: true,
      loop: true
    ).render()
    #expect(video == "<video controls autoplay loop><source src=\"hello.mp4\"></video>")
  }

  @Test("Videos should render correctly with multiple sources")
  func shouldRenderVideoCorrectlyWithMultipleSources() {
    let video = Video(
      sources: ["hello.mp4", "hello.webm"],
      controls: true,
      autoplay: true,
      loop: true
    ).render()
    #expect(video == "<video controls autoplay loop><source src=\"hello.mp4\"><source src=\"hello.webm\"></video>")
  }

  @Test("Audio should render correctly with single source")
  func shouldRenderAudioCorrectlyWithSingleSource() {
    let audio = Audio(
      sources: ["hello.mp3"],
      controls: true,
      autoplay: true,
      loop: true
    ).render()
    #expect(audio == "<audio controls autoplay loop><source src=\"hello.mp3\"></audio>")
  }

  @Test("Audio should render correctly with multiple sources")
  func shouldRenderAudioCorrectlyWithMultipleSources() {
    let audio = Audio(
      sources: ["hello.mp3", "hello.ogg"],
      controls: true,
      autoplay: true,
      loop: true
    ).render()
    #expect(audio == "<audio controls autoplay loop><source src=\"hello.mp3\"><source src=\"hello.ogg\"></audio>")
  }

  @Test("Span tags should render for brief text")
  func shouldRenderSpanForBriefText() {
    let span = Text { "Hello, world!" }.render()
    #expect(span == "<span>Hello, world!</span>")
  }

  @Test("Paragraph tags for longer text")
  func shouldRenderParagraphForLongerText() {
    let paragraph = Text {
      "Hello world! Goodbye world!"
    }.render()
    #expect(paragraph == "<p>Hello world! Goodbye world!</p>")
  }

  @Test("Headings should render correctly")
  func shouldRenderHeadingsCorrectly() {
    let stack = Stack {
      Heading(level: .one) { "Hello, world!" }
      Heading(level: .two) { "Hello, world!" }
      Heading(level: .three) { "Hello, world!" }
      Heading(level: .four) { "Hello, world!" }
      Heading(level: .five) { "Hello, world!" }
      Heading(level: .six) { "Hello, world!" }
    }.render()
    #expect(
      stack
        == "<div><h1>Hello, world!</h1><h2>Hello, world!</h2><h3>Hello, world!</h3><h4>Hello, world!</h4><h5>Hello, world!</h5><h6>Hello, world!</h6></div>"
    )
  }

  @Test("Links should render correctly")
  func shouldRenderLinksCorrectly() {
    let link = Link(to: "https://example.com", newTab: true) { "Hello, world!" }.render()
    #expect(link == "<a href=\"https://example.com\" target=\"_blank\" rel=\"noreferrer\">Hello, world!</a>")
  }

  @Test("Semantic text elements should render correctly")
  func shouldRenderSemanticTextElementsCorrectly() {
    let strong = Strong { "Hello, world!" }.render()
    #expect(strong == "<strong>Hello, world!</strong>")

    let em = Emphasis { "Hello, world!" }.render()
    #expect(em == "<em>Hello, world!</em>")
  }

  @Test("List elements should render correctly")
  func shouldRenderListElementsCorrectly() {
    let unordered = List {
      Item { "Hello, world!" }
      Item { "Hello, world!" }
    }.render()
    let ordered = List(type: .ordered) {
      Item { "Hello, world!" }
      Item { "Hello, world!" }
    }.render()
    #expect(unordered == "<ul><li>Hello, world!</li><li>Hello, world!</li></ul>")
    #expect(ordered == "<ol><li>Hello, world!</li><li>Hello, world!</li></ol>")
  }
}
