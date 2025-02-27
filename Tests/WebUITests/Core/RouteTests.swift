import Testing

@testable import WebUI

@Suite("Route Tests")
struct RouteTests {
  @Test("Route initializes correctly")
  func testInitialization() throws {
    let route = Route(label: "Home", path: "/", newTab: true)
    #expect(route.label == "Home")
    #expect(route.path == "/")
    #expect(route.newTab == true)
  }

  @Test("Route defaults newTab to false")
  func testDefaultNewTab() throws {
    let route = Route(label: "About", path: "/about")
    #expect(route.newTab == false)
  }
}
