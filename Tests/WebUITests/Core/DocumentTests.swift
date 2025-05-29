import Foundation
import Testing

@testable import WebUI

// MARK: - Test Document Structures

struct NoDescriptionDocument: Document {
    var path: String { "no-description" }
    var metadata: Metadata {
        Metadata(
            site: "Test Site",
            title: "No Description",
            description: nil
        )
    }

    var body: some HTML {
        Text { "Test content" }
    }
}

struct BasicTestDocument: Document {
    var path: String { "index" }
    var metadata: Metadata {
        Metadata(
            site: "Test Site",
            title: "Hello World",
            titleSeparator: " | ",
            description: "A test description"
        )
    }

    var body: some HTML {
        Text { "Hello, world!" }
    }
}

struct FullMetadataDocument: Document {
    var path: String { "full-test" }
    var metadata: Metadata {
        Metadata(
            site: "Test Site",
            title: "Full Test",
            titleSeparator: " - ",
            description: "A complete metadata test",
            date: Date(),
            image: "https://example.com/image.png",
            author: "Test Author",
            keywords: ["test", "swift", "html"],
            twitter: "testhandle",
            locale: .ru,
            type: .article,
            themeColor: .init("#0099ff", dark: "#1c1c1c")
        )
    }

    var body: some HTML {
        Text { "Content" }
    }
}

struct FaviconTestDocument: Document {
    var path: String { "favicons" }
    var metadata: Metadata {
        Metadata(
            title: "Favicon Test",
            description: "Testing favicon rendering",
            favicons: [
                Favicon("/favicon.png", size: "32x32"),
                Favicon(
                    "/favicon-light.ico", dark: "/favicon-dark.ico", type: .icon
                ),
            ]
        )
    }

    var body: some HTML {
        Text { "Favicon Test" }
    }
}

struct StructuredDataDocument: Document {
    var path: String { "structured-data" }
    var metadata: Metadata {
        Metadata(
            title: "Structured Data Test",
            description: "Testing structured data rendering",
            structuredData: StructuredData.article(
                headline: "Test Article",
                image: "https://example.com/image.jpg",
                author: "Test Author",
                publisher: "Test Publisher",
                datePublished: Date(),
                description: "A test article"
            )
        )
    }

    var body: some HTML {
        Text { "Structured Data Test" }
    }
}

struct ScriptTestDocument: Document {
    var path: String { "scripts" }
    var metadata: Metadata {
        Metadata(
            title: "Script Test",
            description: "Testing script inclusion"
        )
    }

    var scripts: [Script]? {
        [
            Script(
                src: "https://cdn.example.com/script1.js", attribute: .async),
            Script(src: "/public/script2.js", attribute: .defer),
            Script(src: "/public/script3.js", placement: .head),
            Script { "console.log(\"Hello, world!\")" },
        ]
    }

    var body: some HTML {
        Text { "Script Test" }
    }
}

struct StylesheetTestDocument: Document {
    var path: String { "styles" }
    var metadata: Metadata {
        Metadata(
            title: "Stylesheet Test",
            description: "Testing stylesheet inclusion"
        )
    }

    var stylesheets: [String]? {
        [
            "https://cdn.example.com/style1.css",
            "/public/style2.css",
        ]
    }

    var body: some HTML {
        Text { "Stylesheet Test" }
    }
}

struct CustomHeadDocument: Document {
    var path: String { "custom-head" }
    var metadata: Metadata {
        Metadata(
            title: "Custom Head",
            description: "Testing custom head HTML"
        )
    }

    var head: String? {
        """
        <script>console.log('Custom head script');</script>
        <style>body { color: red; }</style>
        """
    }

    var body: some HTML {
        Text { "Custom Head Test" }
    }
}

// MARK: - Tests

@Suite("Document Tests")
struct DocumentTests {
    @Test("Document renders correctly with nil description")
    func testNilDescriptionDocument() throws {
        let document = NoDescriptionDocument()
        let rendered = document.head ?? ""

        #expect(
            !rendered.contains("<meta name=\"description\""),
            "Description meta tag should not be present"
        )
        #expect(
            !rendered.contains("<meta property=\"og:description\""),
            "OG description meta tag should not be present"
        )
    }

    @Test("Document renders basic metadata correctly")
    func testBasicDocumentRendering() throws {
        let document = BasicTestDocument()
        let rendered = try document.render()

        #expect(
            rendered.contains("<title>Hello World | Test Site</title>"),
            "Title not set correctly"
        )
        #expect(
            rendered.contains(
                "<meta property=\"og:title\" content=\"Hello World | Test Site\">"
            ),
            "OG title not set correctly"
        )
        #expect(
            rendered.contains(
                "<meta name=\"description\" content=\"A test description\">"),
            "Meta description not set correctly"
        )
        #expect(
            rendered.contains(
                "<meta property=\"og:description\" content=\"A test description\">"
            ),
            "OG description not set correctly"
        )
        #expect(
            rendered.contains("Hello, world!"), "Content not rendered correctly"
        )
        #expect(
            rendered.contains("<html lang=\"en\">"),
            "Default locale not set correctly")
    }

    @Test("Document renders all optional metadata correctly")
    func testFullMetadataRendering() throws {
        let document = FullMetadataDocument()
        let rendered = try document.render()

        #expect(rendered.contains("<title>Full Test - Test Site</title>"))
        #expect(
            rendered.contains(
                "<meta property=\"og:image\" content=\"https://example.com/image.png\">"
            )
        )
        #expect(
            rendered.contains("<meta name=\"author\" content=\"Test Author\">"))
        #expect(
            rendered.contains("<meta property=\"og:type\" content=\"article\">")
        )
        #expect(
            rendered.contains(
                "<meta name=\"twitter:creator\" content=\"@testhandle\">"))
        #expect(
            rendered.contains(
                "<meta name=\"keywords\" content=\"test, swift, html\">"))
        #expect(
            rendered.contains(
                "<meta name=\"theme-color\" content=\"#0099ff\" media=\"(prefers-color-scheme: light)\">"
            )
        )
        #expect(rendered.contains("<html lang=\"ru\">"))
    }

    @Test("Favicons are correctly added to document head")
    func testFaviconRendering() throws {
        let document = FaviconTestDocument()
        let rendered = try document.render()

        #expect(
            rendered.contains(
                "<link rel=\"icon\" type=\"image/png\" href=\"/favicon.png\" sizes=\"32x32\">"
            )
        )

        #expect(
            rendered.contains(
                "<link rel=\"apple-touch-icon\" sizes=\"32x32\" href=\"/favicon.png\">"
            )
        )

        #expect(
            rendered.contains(
                "<link rel=\"icon\" type=\"image/x-icon\" href=\"/favicon-light.ico\" media=\"(prefers-color-scheme: light)\">"
            )
        )
        #expect(
            rendered.contains(
                "<link rel=\"icon\" type=\"image/x-icon\" href=\"/favicon-dark.ico\" media=\"(prefers-color-scheme: dark)\">"
            )
        )
    }

    @Test("Structured data is correctly added to document head")
    func testStructuredDataRendering() throws {
        let document = StructuredDataDocument()
        let rendered = try document.render()

        #expect(rendered.contains("<script type=\"application/ld+json\">"))
        #expect(rendered.contains("\"@context\" : \"https://schema.org\""))
        #expect(rendered.contains("\"@type\" : \"Article\""))
        #expect(rendered.contains("\"headline\" : \"Test Article\""))
        #expect(
            rendered.contains("\"image\" : \"https://example.com/image.jpg\""))
    }

    @Test("Custom scripts are correctly added to document head")
    func testCustomScripts() throws {
        let document = ScriptTestDocument()
        let rendered = try document.render()

        #expect(
            rendered.contains(
                "<script async src=\"https://cdn.example.com/script1.js\"></script>"
            )
        )
        #expect(
            rendered.contains(
                "<script defer src=\"/public/script2.js\"></script>"))
        #expect(
            rendered.contains("<script src=\"/public/script3.js\"></script>"))
        #expect(rendered.contains("console.log(\"Hello, world!\")"))
    }

    @Test("Custom stylesheets are correctly added to document head")
    func testCustomStylesheets() throws {
        let document = StylesheetTestDocument()
        let rendered = try document.render()

        #expect(
            rendered.contains(
                "<link rel=\"stylesheet\" href=\"https://cdn.example.com/style1.css\">"
            )
        )
        #expect(
            rendered.contains(
                "<link rel=\"stylesheet\" href=\"/public/style2.css\">")
        )
    }

    @Test("Raw HTML can be added to document head")
    func testCustomHeadHTML() throws {
        let document = CustomHeadDocument()
        let rendered = try document.render()

        #expect(
            rendered.contains(
                "<script>console.log('Custom head script');</script>"))
        #expect(rendered.contains("<style>body { color: red; }</style>"))
    }
}
