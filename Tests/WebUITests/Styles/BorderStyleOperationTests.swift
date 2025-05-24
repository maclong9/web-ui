import Testing

@testable import WebUI

@Suite("Border Style Operation Tests") struct BorderStyleOperationTests {
    // MARK: - Basic Style Operations Tests

    @Test("Border with default parameters")
    func testBorderWithDefaultParameters() async throws {
        let params = BorderStyleOperation.Parameters()
        let classes = BorderStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("border-1") || classes.contains("border"))
    }

    @Test("Border with specific width")
    func testBorderWithSpecificWidth() async throws {
        let params = BorderStyleOperation.Parameters(width: 2)
        let classes = BorderStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("border-2"))
    }

    @Test("Border with specific edge")
    func testBorderWithSpecificEdge() async throws {
        let params = BorderStyleOperation.Parameters(edges: [.top])
        let classes = BorderStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("border-t-1") || classes.contains("border-t"))
    }

    @Test("Border with style")
    func testBorderWithStyle() async throws {
        let params = BorderStyleOperation.Parameters(style: .dashed)
        let classes = BorderStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("border-dashed"))
    }

    @Test("Border with color")
    func testBorderWithColor() async throws {
        let params = BorderStyleOperation.Parameters(color: .blue(._500))
        let classes = BorderStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("border-blue-500"))
    }

    @Test("Border with divide style")
    func testBorderWithDivideStyle() async throws {
        let params = BorderStyleOperation.Parameters(
            width: 2,
            edges: [.horizontal],
            style: .divide
        )
        let classes = BorderStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("divide-x-2"))
    }

    // MARK: - Edge Cases

    @Test("Border with nil width")
    func testBorderWithNilWidth() async throws {
        let params = BorderStyleOperation.Parameters(
            width: nil, color: .blue(._500))
        let classes = BorderStyleOperation.shared.applyClasses(params: params)

        #expect(
            classes.contains("border") || classes.contains("border-blue-500"))
    }

    @Test("Border with empty edges")
    func testBorderWithEmptyEdges() async throws {
        let params = BorderStyleOperation.Parameters(edges: [])
        let classes = BorderStyleOperation.shared.applyClasses(params: params)

        #expect(classes.contains("border") || classes.contains("border-1"))
    }
}
