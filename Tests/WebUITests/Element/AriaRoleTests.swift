import Testing

@testable import WebUI

@Suite("AriaRole Tests")
struct AriaRoleTests {
  @Test("AriaRole raw values match expected strings")
  func testRawValues() throws {
    #expect(AriaRole.button.rawValue == "button")
    #expect(AriaRole.checkbox.rawValue == "checkbox")
    #expect(AriaRole.main.rawValue == "main")
    #expect(AriaRole.navigation.rawValue == "navigation")
    #expect(AriaRole.search.rawValue == "search")
    #expect(AriaRole.listbox.rawValue == "listbox")
    #expect(AriaRole.menu.rawValue == "menu")
    #expect(AriaRole.contentinfo.rawValue == "contentinfo")
    #expect(AriaRole.dialog.rawValue == "dialog")
    #expect(AriaRole.article.rawValue == "article")
    #expect(AriaRole.heading.rawValue == "heading")
    #expect(AriaRole.complementary.rawValue == "complementary")
  }
}
