import Testing

@testable import WebUI

@Suite("Behavior Tests") struct BehaviorTests {
  @Test("Toggle color behavior with click event using explicit select")
  func toggleColorBehavior() async throws {
    let element = Text(id: "el") { "Content goes here" }
      .script(select: "el", style: .color, toggle: true, value: "red", on: .click)

    let html = element.render()

    #expect(
      html == """
        <span id="el">Content goes here<script>let el = document.querySelector('#el');
        el.addEventListener('click', () => {
          document.querySelector('#el').style.color = document.querySelector('#el').style.color === 'red' ? '' : 'red';
        });</script></span>
        """
    )
  }

  @Test("Add class behavior immediately using explicit select")
  func addClassBehavior() async throws {
    let element = Text(id: "btn") { "Click me" }
      .script(select: "btn", className: "active", add: true, value: "highlight")

    let html = element.render()

    #expect(
      html == """
        <span id="btn">Click me<script>document.querySelector('#btn').classList.add('highlight');</script></span>
        """
    )
  }

  @Test("Remove attribute behavior with mouseenter event using explicit select")
  func removeAttributeBehavior() async throws {
    let element = Text(id: "hover") { "Hover here" }
      .script(select: "hover", attribute: .disabled, remove: true, value: "true", on: .mouseenter)

    let html = element.render()

    #expect(
      html == """
        <span id="hover">Hover here<script>let el = document.querySelector('#hover');
        el.addEventListener('mouseenter', () => {
          document.querySelector('#hover').removeAttribute('disabled');
        });</script></span>
        """
    )
  }

  @Test("Toggle class behavior with custom event using class selector")
  func toggleClassBehavior() async throws {
    let element = Text(id: "toggle") { "Toggle me" }
      .script(select: ".toggle", className: "visible", toggle: true, value: "show", on: .custom("myEvent"))

    let html = element.render()

    #expect(
      html == """
        <span id="toggle">Toggle me<script>let el = document.querySelector('.toggle');
        el.addEventListener('myEvent', () => {
          document.querySelector('.toggle').classList.toggle('show');
        });</script></span>
        """
    )
  }

  @Test("Add style behavior immediately using explicit select")
  func addStyleBehavior() async throws {
    let element = Text(id: "text") { "Styled text" }
      .script(select: "#text", style: .backgroundColor, add: true, value: "blue")

    let html = element.render()

    #expect(
      html == """
        <span id="text">Styled text<script>document.querySelector('#text').style.backgroundColor = 'blue';</script></span>
        """
    )
  }

  @Test("Remove class behavior immediately using explicit select")
  func removeClassBehavior() async throws {
    let element = Text(id: "remove") { "Remove class" }
      .script(select: "remove", className: "hidden", remove: true)

    let html = element.render()

    #expect(
      html == """
        <span id="remove">Remove class<script>document.querySelector('#remove').classList.remove('hidden');</script></span>
        """
    )
  }

  @Test("No manipulation target specified")
  func noTargetBehavior() async throws {
    let element = Text(id: "none") { "No change" }
      .script(select: "none", toggle: true, value: "something")

    let html = element.render()

    #expect(html == "<span id=\"none\">No change</span>")
  }

  @Test("Missing value for style toggle")
  func missingValueForStyle() async throws {
    let element = Text(id: "el") { "No script" }
      .script(select: "el", style: .fontSize, toggle: true)

    let html = element.render()

    #expect(html == "<span id=\"el\">No script</span>")
  }

  @Test("Generated ID when no ID is provided")
  func generatedIdBehavior() async throws {
    let element = Text { "Click to change" }
      .script(style: .color, add: true, value: "green", on: .click)

    let html = element.render()

    #expect(html.contains("id=\"gen"))
    #expect(html.contains(".style.color = 'green';"))
    #expect(html.contains("addEventListener('click'"))
  }

  @Test("Default targeting with no select parameter")
  func defaultTargetingBehavior() async throws {
    let element = Text(id: "self-target") { "Click me" }
      .script(className: "active", add: true, value: "highlight")

    let html = element.render()

    #expect(
      html == """
        <span id="self-target">Click me<script>document.querySelector('#self-target').classList.add('highlight');</script></span>
        """
    )
  }
}
