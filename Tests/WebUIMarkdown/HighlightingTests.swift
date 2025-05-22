import Logging
import Testing

@testable import WebUIMarkdown

@Suite("HighlightingTests")
struct HighlightingTests {
    let logger = Logger(label: "test")

    func renderHTML(markdown: String, language: String) -> String {
        let renderer = HtmlRenderer(
            logger: logger,
            showCodeFilename: false,
            showCopyButton: false,
            showLineNumbers: false,
            enableSyntaxHighlighting: true
        )
        let codeBlock = Markdown.CodeBlock(language: language, code: markdown)
        var mutableRenderer = renderer
        mutableRenderer.visitCodeBlock(codeBlock)
        return mutableRenderer.html
    }

    @Test("Shell highlighting")
    func testShellHighlighting() {
        let code = """
            # comment
            if [ $FOO -eq 1 ]; then
              echo "hello" && exit 0
            fi
            """
        let html = renderHTML(markdown: code, language: "sh")
        #expect(html.contains("hl-comment"))
        #expect(html.contains("hl-keyword"))
        #expect(html.contains("hl-variable"))
        #expect(html.contains("hl-number"))
        #expect(html.contains("hl-operator"))
        #expect(!html.contains("hl-literal"))  // no literal in this code
    }

    @Test("Swift highlighting")
    func testSwiftHighlighting() {
        let code = """
            // comment
            let x: Int = 42
            func greet(name: String) -> String {
                print("Hello, \\(name)")
                return "ok"
            }
            """
        let html = renderHTML(markdown: code, language: "swift")
        #expect(html.contains("hl-comment"))
        #expect(html.contains("hl-keyword"))
        #expect(html.contains("hl-type"))
        #expect(html.contains("hl-number"))
        #expect(html.contains("hl-string"))
        #expect(html.contains("hl-function"))
        #expect(html.contains("hl-built_in"))
    }

    @Test("YAML highlighting")
    func testYAMLHighlighting() {
        let code = """
            # comment
            name: "John"
            age: 30
            active: true
            """
        let html = renderHTML(markdown: code, language: "yml")
        #expect(html.contains("hl-comment"))
        #expect(html.contains("hl-attribute"))
        #expect(html.contains("hl-string"))
        #expect(html.contains("hl-number"))
        #expect(html.contains("hl-literal"))
    }

    @Test("No highlighting when disabled")
    func testNoHighlightingWhenDisabled() {
        let renderer = HtmlRenderer(
            logger: logger,
            showCodeFilename: false,
            showCopyButton: false,
            showLineNumbers: false,
            enableSyntaxHighlighting: false
        )
        let codeBlock = Markdown.CodeBlock(language: "swift", code: "let x = 1 // comment")
        var mutableRenderer = renderer
        mutableRenderer.visitCodeBlock(codeBlock)
        let html = mutableRenderer.html
        #expect(!html.contains("hl-keyword"))
        #expect(!html.contains("hl-comment"))
    }
}
