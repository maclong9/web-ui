import Testing
import Foundation

@testable import WebUI

@Suite("Performance Tests") struct PerformanceTests {
    
    // MARK: - String Initializer Performance
    
    @Test("Text string initializer performance")
    func testTextStringInitializerPerformance() async throws {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Test creating and rendering 1000 Text elements with string initializer
        for i in 0..<1000 {
            let text = Text("Performance test content \(i)")
            _ = text.render()
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let executionTime = (endTime - startTime) * 1000 // Convert to milliseconds
        
        print("Text string initializer: \(executionTime)ms for 1000 elements")
        
        // Should complete within reasonable time (< 100ms on modern hardware)
        #expect(executionTime < 200.0)
    }
    
    @Test("Button string initializer performance")
    func testButtonStringInitializerPerformance() async throws {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Test creating and rendering 1000 Button elements with string initializer
        for i in 0..<1000 {
            let button = Button("Button \(i)", type: .submit)
            _ = button.render()
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let executionTime = (endTime - startTime) * 1000
        
        print("Button string initializer: \(executionTime)ms for 1000 elements")
        #expect(executionTime < 200.0)
    }
    
    @Test("Heading string initializer performance")
    func testHeadingStringInitializerPerformance() async throws {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Test creating and rendering 1000 Heading elements with string initializer
        for i in 0..<1000 {
            let heading = Heading(.title, "Heading \(i)")
            _ = heading.render()
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let executionTime = (endTime - startTime) * 1000
        
        print("Heading string initializer: \(executionTime)ms for 1000 elements")
        #expect(executionTime < 200.0)
    }
    
    @Test("Link string initializer performance")
    func testLinkStringInitializerPerformance() async throws {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Test creating and rendering 1000 Link elements with string initializer
        for i in 0..<1000 {
            let link = Link("Link \(i)", destination: "/page\(i)")
            _ = link.render()
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let executionTime = (endTime - startTime) * 1000
        
        print("Link string initializer: \(executionTime)ms for 1000 elements")
        #expect(executionTime < 200.0)
    }
    
    // MARK: - Conditional Modifier Performance
    
    @Test("Conditional if modifier performance")
    func testConditionalIfModifierPerformance() async throws {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Test 1000 conditional modifiers
        for i in 0..<1000 {
            let isHighlighted = i % 2 == 0
            let element = Text("Content \(i)")
                .if(isHighlighted) { $0.addClass("highlight") }
            _ = element.render()
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let executionTime = (endTime - startTime) * 1000
        
        print("Conditional if modifier: \(executionTime)ms for 1000 elements")
        #expect(executionTime < 300.0)
    }
    
    @Test("Hidden when modifier performance")
    func testHiddenWhenModifierPerformance() async throws {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Test 1000 hidden when modifiers
        for i in 0..<1000 {
            let shouldHide = i % 3 == 0
            let element = Text("Content \(i)")
                .hidden(when: shouldHide)
            _ = element.render()
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let executionTime = (endTime - startTime) * 1000
        
        print("Hidden when modifier: \(executionTime)ms for 1000 elements")
        #expect(executionTime < 300.0)
    }
    
    // MARK: - Complex Structure Performance
    
    @Test("Complex structure with new APIs performance")
    func testComplexStructurePerformance() async throws {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Test creating complex structures using new APIs
        for i in 0..<100 {
            let page = Stack {
                Header {
                    Heading(.largeTitle, "Page \(i)")
                    Navigation {
                        Link("Home", destination: "/")
                        Link("About", destination: "/about")
                        Link("Contact", destination: "/contact")
                    }
                }
                
                Main {
                    Article {
                        Heading(.title, "Article Title \(i)")
                        Text("Article content goes here. This is paragraph \(i).")
                            .if(i % 2 == 0) { $0.addClass("highlighted") }
                        
                        Button("Read More")
                            .hidden(when: i > 50)
                    }
                }
                
                Footer {
                    Text("Copyright © 2025")
                }
            }
            
            _ = page.render()
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let executionTime = (endTime - startTime) * 1000
        
        print("Complex structure: \(executionTime)ms for 100 pages")
        #expect(executionTime < 500.0)
    }
    
    // MARK: - Memory Usage Test
    
    @Test("Memory usage with large structures")
    func testMemoryUsage() async throws {
        // Create a large structure and ensure it doesn't consume excessive memory
        let largeStructure = Stack {
            for i in 0..<1000 {
                Text("Item \(i)")
                    .if(i % 2 == 0) { $0.addClass("even") }
                    .hidden(when: i > 900)
            }
        }
        
        let startTime = CFAbsoluteTimeGetCurrent()
        let rendered = largeStructure.render()
        let endTime = CFAbsoluteTimeGetCurrent()
        let executionTime = (endTime - startTime) * 1000
        
        print("Large structure render: \(executionTime)ms for 1000 nested elements")
        
        // Verify output contains expected content
        #expect(rendered.contains("Item 0"))
        #expect(rendered.contains("Item 999"))
        
        // Should complete within reasonable time
        #expect(executionTime < 1000.0)
    }
    
    // MARK: - Comparison Tests
    
    @Test("New vs old API performance comparison")
    func testAPIPerformanceComparison() async throws {
        let iterations = 1000
        
        // Test new string initializer performance
        let newAPIStartTime = CFAbsoluteTimeGetCurrent()
        for i in 0..<iterations {
            let text = Text("Content \(i)")
            _ = text.render()
        }
        let newAPIEndTime = CFAbsoluteTimeGetCurrent()
        let newAPITime = (newAPIEndTime - newAPIStartTime) * 1000
        
        // Test old HTMLBuilder performance (using deprecated API for comparison)
        let oldAPIStartTime = CFAbsoluteTimeGetCurrent()
        for i in 0..<iterations {
            let text = Text { "Content \(i)" }
            _ = text.render()
        }
        let oldAPIEndTime = CFAbsoluteTimeGetCurrent()
        let oldAPITime = (oldAPIEndTime - oldAPIStartTime) * 1000
        
        print("New API time: \(newAPITime)ms")
        print("Old API time: \(oldAPITime)ms")
        print("Performance ratio: \(oldAPITime / newAPITime)x")
        
        // New API should be comparable or faster (within 2x)
        #expect(newAPITime <= oldAPITime * 2.0)
    }
}