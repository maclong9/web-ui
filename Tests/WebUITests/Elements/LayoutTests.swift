import Testing

@testable import WebUI

@Suite("Structural Element Tests") struct StructuralElementTests {
  @Test("Article should render correctly")
  func shouldRenderArticleCorrectly() {
    let article = Article(
      id: "article-id",
      classes: ["article-class"]
    ) { "This is an article" }.render()
    #expect(article == "<article id=\"article-id\" class=\"article-class\">This is an article</article>")
  }

  @Test("Section should render correctly")
  func shouldRenderSectionCorrectly() {
    let section = Section(
      id: "section-id",
      classes: ["section-class"]
    ) { "This is a section" }.render()
    #expect(section == "<section id=\"section-id\" class=\"section-class\">This is a section</section>")
  }

  @Test("Stack should render correctly")
  func shouldRenderStackCorrectly() {
    let stack = Stack(
      id: "stack-id",
      classes: ["stack-class"]
    ) { "This is a stack" }.render()
    #expect(stack == "<div id=\"stack-id\" class=\"stack-class\">This is a stack</div>")
  }

  @Test("Header should render correctly")
  func shouldRenderHeaderCorrectly() {
    let header = Header(
      id: "header-id",
      classes: ["header-class"]
    ) { "This is a header" }.render()
    #expect(header == "<header id=\"header-id\" class=\"header-class\">This is a header</header>")
  }

  @Test("Navigation should render correctly")
  func shouldRenderNavigationCorrectly() {
    let navigation = Navigation(
      id: "nav-id",
      classes: ["nav-class"]
    ) { "This is navigation" }.render()
    #expect(navigation == "<nav id=\"nav-id\" class=\"nav-class\">This is navigation</nav>")
  }

  @Test("Aside should render correctly")
  func shouldRenderAsideCorrectly() {
    let aside = Aside(
      id: "aside-id",
      classes: ["aside-class"]
    ) { "This is an aside" }.render()
    #expect(aside == "<aside id=\"aside-id\" class=\"aside-class\">This is an aside</aside>")
  }

  @Test("Main should render correctly")
  func shouldRenderMainCorrectly() {
    let main = Main(
      id: "main-id",
      classes: ["main-class"]
    ) { "This is the main content" }.render()
    #expect(main == "<main id=\"main-id\" class=\"main-class\">This is the main content</main>")
  }

  @Test("Footer should render correctly")
  func shouldRenderFooterCorrectly() {
    let footer = Footer(
      id: "footer-id",
      classes: ["footer-class"]
    ) { "This is a footer" }.render()
    #expect(footer == "<footer id=\"footer-id\" class=\"footer-class\">This is a footer</footer>")
  }

  @Test("Structural elements should render with nested content")
  func shouldRenderStructuralElementsWithNestedContent() {
    let stack = Stack {
      Header { "Header content" }
      Main {
        Article { "Article content" }
        Section { "Section content" }
      }
      Footer { "Footer content" }
    }.render()
    #expect(
      stack == "<div><header>Header content</header><main><article>Article content</article><section>Section content</section></main><footer>Footer content</footer></div>"
    )
  }

  @Test("Structural elements should render without optional attributes")
  func shouldRenderStructuralElementsWithoutOptionalAttributes() {
    let article = Article { "Simple article" }.render()
    let section = Section { "Simple section" }.render()
    let stack = Stack { "Simple stack" }.render()
    let header = Header { "Simple header" }.render()
    let navigation = Navigation { "Simple navigation" }.render()
    let aside = Aside { "Simple aside" }.render()
    let main = Main { "Simple main" }.render()
    let footer = Footer { "Simple footer" }.render()

    #expect(article == "<article>Simple article</article>")
    #expect(section == "<section>Simple section</section>")
    #expect(stack == "<div>Simple stack</div>")
    #expect(header == "<header>Simple header</header>")
    #expect(navigation == "<nav>Simple navigation</nav>")
    #expect(aside == "<aside>Simple aside</aside>")
    #expect(main == "<main>Simple main</main>")
    #expect(footer == "<footer>Simple footer</footer>")
  }
}
