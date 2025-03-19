import Foundation
import Testing

@testable import WebUI

@Suite("DOM Behavior Tests") struct BehaviorTests {
  @Test("Element should log to console immediately")
  func shouldLogImmediately() {
    let el = Element(tag: "div", id: "test-log") { "Test" }
      .script(.log, value: "Logging test")
      .render()
    #expect(el.contains("<div id=\"test-log\">Test<script>console.log('test-log:', 'Logging test');</script></div>"))
  }

  @Test("Element should add class on click")
  func shouldAddClassOnClick() {
    let el = Element(tag: "div", id: "test-click") { "Click me" }
      .script(.add, className: "active", value: "active", on: .click)
      .render()
    #expect(
      el.contains(
        "el.addEventListener('click', () => { document.querySelector('#test-click').classList.add('active'); });"))
  }

  @Test("Element should remove class on mouseenter")
  func shouldRemoveClassOnMouseenter() {
    let el = Element(tag: "div", id: "test-hover") { "Hover me" }
      .script(.remove, className: "hidden", on: .mouseenter)
      .render()
    #expect(
      el.contains(
        "el.addEventListener('mouseenter', () => { document.querySelector('#test-hover').classList.remove('hidden'); });"
      ))
  }

  @Test("Element should toggle class on focus")
  func shouldToggleClassOnFocus() {
    let el = Element(tag: "input", id: "test-focus") { "" }
      .script(.toggle, className: "focused", value: "focused", on: .focus)
      .render()
    #expect(
      el.contains(
        "el.addEventListener('focus', () => { document.querySelector('#test-focus').classList.toggle('focused'); });"))
  }

  @Test("Element should add attribute immediately")
  func shouldAddAttributeImmediately() {
    let el = Element(tag: "button", id: "test-btn") { "Click" }
      .script(.add, attribute: .disabled, value: "true")
      .render()
    #expect(
      el.contains(
        "<button id=\"test-btn\">Click<script>document.querySelector('#test-btn').setAttribute('disabled', 'true');</script></button>"
      ))
  }

  @Test("Element should remove attribute on blur")
  func shouldRemoveAttributeOnBlur() {
    let el = Element(tag: "input", id: "test-input")
      .script(.remove, attribute: .hidden, on: .blur)
      .render()
    #expect(
      el.contains(
        "el.addEventListener('blur', () => { document.querySelector('#test-input').removeAttribute('hidden'); });"))
  }

  @Test("Element should toggle attribute on custom event")
  func shouldToggleAttributeOnCustomEvent() {
    let el = Element(tag: "div", id: "test-custom") { "Test" }
      .script(.toggle, attribute: .data("test"), value: "value", on: .custom("testEvent"))
      .render()
    #expect(
      el.contains(
        "el.addEventListener('testEvent', () => { document.querySelector('#test-custom').hasAttribute('data-test') ? document.querySelector('#test-custom').removeAttribute('data-test') : document.querySelector('#test-custom').setAttribute('data-test', 'value'); });"
      ))
  }

  @Test("Element should use custom selector")
  func shouldUseCustomSelector() {
    let el = Element(tag: "div") { "Container" }
      .script(.add, select: ".target", className: "highlight", value: "highlight", on: .click)
      .render()
    #expect(
      el.contains(
        "el.addEventListener('click', () => { document.querySelector('.target').classList.add('highlight'); });"))
  }

  @Test("Element should handle multiple sources with script")
  func shouldHandleMultipleSourcesWithScript() {
    let video = Video(sources: ["test.mp4", "test.webm"], controls: true)
      .script(.add, attribute: .src, value: "test.mp4", on: .click)
      .render()
    #expect(video.contains("el.addEventListener('click', () => { document.querySelector('#gen"))
    #expect(video.contains("').setAttribute('src', 'test.mp4'); });"))
  }

  @Test("Element should not render invalid script without class or attribute")
  func shouldNotRenderInvalidScript() {
    let el = Element(tag: "div", id: "test-invalid") { "Test" }
      .script(.add)
      .render()
    #expect(el == "<div id=\"test-invalid\">Test</div>")
  }

  @Test("Element should not render toggle script without value")
  func shouldNotRenderToggleWithoutValue() {
    let el = Element(tag: "div", id: "test-toggle") { "Test" }
      .script(.toggle, className: "test")
      .render()
    #expect(el == "<div id=\"test-toggle\">Test</div>")
  }
}
