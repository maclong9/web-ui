import Testing

@testable import WebUI

@Suite("Responsive Style Tests") struct NewResponsiveTests {
    @Test("Complex component with result builder syntax")
    func testComplexComponentNewSyntax() async throws {
        let button = Button(type: .submit) { "Submit" }
            .background(color: .blue(._500))
            .font(color: .blue(._50))
            .padding(of: 2)
            .rounded(.md)
            .on {
                sm {
                    padding(of: 3)
                }
                md {
                    padding(of: 4)
                    font(size: .lg)
                }
                lg {
                    padding(of: 6)
                    background(color: .blue(._600))
                }
            }

        let rendered = button.render()
        #expect(rendered.contains("type=\"submit\""))
        #expect(rendered.contains("bg-blue-500"))
        #expect(rendered.contains("text-blue-50"))
        #expect(rendered.contains("p-2"))
        #expect(rendered.contains("rounded-md"))
        #expect(rendered.contains("sm:p-3"))
        #expect(rendered.contains("md:p-4"))
        #expect(rendered.contains("md:text-lg"))
        #expect(rendered.contains("lg:p-6"))
        #expect(rendered.contains("lg:bg-blue-600"))
    }
}
