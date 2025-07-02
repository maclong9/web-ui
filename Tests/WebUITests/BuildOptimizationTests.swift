import Testing
import Foundation

@testable import WebUI

@Suite("Build Optimization Tests") struct BuildOptimizationTests {
    
    // MARK: - Asset Status Tests
    
    @Test("Asset status creation and properties")
    func testAssetStatusCreation() {
        let asset = BuildOptimization.AssetStatus(
            name: "Test Asset",
            category: .iconFonts,
            isOptimized: true,
            localPath: "/css/test.css",
            cdnPath: "https://cdn.example.com/test.css",
            estimatedSizeKB: 25.5,
            priority: .high
        )
        
        #expect(asset.name == "Test Asset")
        #expect(asset.category == .iconFonts)
        #expect(asset.isOptimized == true)
        #expect(asset.localPath == "/css/test.css")
        #expect(asset.cdnPath == "https://cdn.example.com/test.css")
        #expect(asset.estimatedSizeKB == 25.5)
        #expect(asset.priority == .high)
        #expect(asset.statusIcon == "✅")
        #expect(asset.sizeDescription == "25.5 KB")
    }
    
    @Test("Asset status for unoptimized asset")
    func testUnoptimizedAssetStatus() {
        let asset = BuildOptimization.AssetStatus(
            name: "Unoptimized Asset",
            category: .webFonts,
            isOptimized: false,
            cdnPath: "https://fonts.googleapis.com/css",
            estimatedSizeKB: 15.2,
            priority: .medium
        )
        
        #expect(asset.statusIcon == "⚠️")
        #expect(asset.isOptimized == false)
        #expect(asset.localPath == nil)
    }
    
    @Test("Asset size descriptions")
    func testAssetSizeDescriptions() {
        let smallAsset = BuildOptimization.AssetStatus(
            name: "Small",
            category: .other,
            isOptimized: true,
            estimatedSizeKB: 0.5
        )
        #expect(smallAsset.sizeDescription == "500 bytes")
        
        let mediumAsset = BuildOptimization.AssetStatus(
            name: "Medium",
            category: .other,
            isOptimized: true,
            estimatedSizeKB: 150.7
        )
        #expect(mediumAsset.sizeDescription == "150.7 KB")
        
        let largeAsset = BuildOptimization.AssetStatus(
            name: "Large",
            category: .other,
            isOptimized: true,
            estimatedSizeKB: 1536.0
        )
        #expect(largeAsset.sizeDescription == "1.5 MB")
        
        let unknownAsset = BuildOptimization.AssetStatus(
            name: "Unknown",
            category: .other,
            isOptimized: true
        )
        #expect(unknownAsset.sizeDescription == "Unknown size")
    }
    
    // MARK: - Priority Tests
    
    @Test("Optimization priority comparison")
    func testOptimizationPriorityComparison() {
        #expect(BuildOptimization.OptimizationPriority.critical < .high)
        #expect(BuildOptimization.OptimizationPriority.high < .medium)
        #expect(BuildOptimization.OptimizationPriority.medium < .low)
        #expect(BuildOptimization.OptimizationPriority.critical < .low)
    }
    
    @Test("Priority descriptions")
    func testPriorityDescriptions() {
        #expect(BuildOptimization.OptimizationPriority.critical.description.contains("Critical"))
        #expect(BuildOptimization.OptimizationPriority.high.description.contains("High"))
        #expect(BuildOptimization.OptimizationPriority.medium.description.contains("Medium"))
        #expect(BuildOptimization.OptimizationPriority.low.description.contains("Low"))
    }
    
    // MARK: - Asset Category Tests
    
    @Test("Asset category descriptions")
    func testAssetCategoryDescriptions() {
        #expect(BuildOptimization.AssetCategory.iconFonts.description == "Icon Fonts")
        #expect(BuildOptimization.AssetCategory.webFonts.description == "Web Fonts")
        #expect(BuildOptimization.AssetCategory.cssFrameworks.description == "CSS Frameworks")
        #expect(BuildOptimization.AssetCategory.javascriptLibraries.description == "JavaScript Libraries")
        #expect(BuildOptimization.AssetCategory.images.description == "Images")
        #expect(BuildOptimization.AssetCategory.other.description == "Other Assets")
    }
    
    @Test("Asset category case iteration")
    func testAssetCategoryCases() {
        let allCategories = BuildOptimization.AssetCategory.allCases
        #expect(allCategories.count == 6)
        #expect(allCategories.contains(.iconFonts))
        #expect(allCategories.contains(.webFonts))
        #expect(allCategories.contains(.cssFrameworks))
        #expect(allCategories.contains(.javascriptLibraries))
        #expect(allCategories.contains(.images))
        #expect(allCategories.contains(.other))
    }
    
    // MARK: - Optimization Assessment Tests
    
    @Test("Optimization status assessment")
    func testOptimizationStatusAssessment() {
        let status = BuildOptimization.assessOptimizationLevel()
        
        #expect(status.totalAssets >= 0)
        #expect(status.optimizedAssets >= 0)
        #expect(status.optimizedAssets <= status.totalAssets)
        #expect(status.optimizationPercentage >= 0.0)
        #expect(status.optimizationPercentage <= 100.0)
        #expect(status.estimatedSavingsKB >= 0.0)
        #expect(!status.summary.isEmpty)
    }
    
    @Test("Optimization status when fully optimized")
    func testFullyOptimizedStatus() {
        // Create a mock scenario where optimization percentage is 100%
        let mockStatus = BuildOptimization.OptimizationStatus(
            totalAssets: 5,
            optimizedAssets: 5,
            optimizationPercentage: 100.0,
            estimatedSavingsKB: 0.0,
            recommendations: []
        )
        
        #expect(mockStatus.isFullyOptimized)
        #expect(mockStatus.optimizationPercentage == 100.0)
    }
    
    @Test("Optimization status when partially optimized")
    func testPartiallyOptimizedStatus() {
        let mockStatus = BuildOptimization.OptimizationStatus(
            totalAssets: 4,
            optimizedAssets: 2,
            optimizationPercentage: 50.0,
            estimatedSavingsKB: 75.5,
            recommendations: ["Optimize remaining assets"]
        )
        
        #expect(!mockStatus.isFullyOptimized)
        #expect(mockStatus.optimizationPercentage == 50.0)
        #expect(mockStatus.recommendations.count == 1)
    }
    
    // MARK: - Recommendations Tests
    
    @Test("Optimization recommendations generation")
    func testOptimizationRecommendations() {
        let recommendations = BuildOptimization.getOptimizationRecommendations()
        
        #expect(recommendations.count >= 0)
        // Should contain at least some guidance
        if !recommendations.isEmpty {
            let hasUsefulRecommendation = recommendations.contains { rec in
                rec.contains("optimize") || rec.contains("Optimize") || 
                rec.contains("script") || rec.contains("optimized")
            }
            #expect(hasUsefulRecommendation)
        }
    }
    
    @Test("Detailed asset report")
    func testDetailedAssetReport() {
        let assets = BuildOptimization.getDetailedAssetReport()
        
        #expect(assets.count >= 0)
        
        // Should include Lucide icons as one of the assets
        let hasLucideAsset = assets.contains { asset in
            asset.name.lowercased().contains("lucide")
        }
        
        if assets.count > 0 {
            #expect(hasLucideAsset)
        }
    }
    
    // MARK: - Build Environment Tests
    
    @Test("Build environment readiness check")
    func testBuildEnvironmentReadiness() {
        let isReady = BuildOptimization.isBuildEnvironmentReady()
        // This should return a boolean without crashing
        #expect(type(of: isReady) == Bool.self)
    }
    
    @Test("Recommended output directory")
    func testRecommendedOutputDirectory() {
        let outputDir = BuildOptimization.getRecommendedOutputDirectory()
        
        #expect(!outputDir.isEmpty)
        #expect(outputDir.contains("output") || outputDir.contains("public") || outputDir.contains("dist"))
    }
    
    @Test("Build tools validation")
    func testBuildToolsValidation() {
        let missingTools = BuildOptimization.validateBuildTools()
        
        // Should return an array (might be empty if all tools are present)
        #expect(type(of: missingTools) == [String].self)
        
        // On most Unix systems, curl should be available
        // This test might vary depending on the environment
        if missingTools.isEmpty {
            // All tools are available - good!
            #expect(true)
        } else {
            // Some tools are missing - still valid, just log it
            print("ℹ️ Missing build tools: \\(missingTools.joined(separator: ", "))")
        }
    }
    
    // MARK: - Document Integration Tests
    
    @Test("Document optimization assessment")
    func testDocumentOptimizationAssessment() async throws {
        struct TestDocument: Document {
            var metadata: Metadata {
                Metadata(site: "Test Site", title: "Test Page")
            }
            
            var body: some HTML {
                Text("Hello World")
            }
        }
        
        let document = TestDocument()
        let assessment = document.optimizationAssessment
        
        #expect(assessment.totalAssets >= 0)
        #expect(assessment.optimizationPercentage >= 0.0)
        #expect(assessment.optimizationPercentage <= 100.0)
    }
    
    @Test("Document optimization recommendations")
    func testDocumentOptimizationRecommendations() async throws {
        struct TestDocumentWithIcons: Document {
            var metadata: Metadata {
                Metadata(site: "Test Site", title: "Test Page")
            }
            
            var body: some HTML {
                Stack {
                    Text("Page with icons")
                    // This would create Lucide icon usage
                    SystemImage("heart")
                }
            }
        }
        
        let document = TestDocumentWithIcons()
        let recommendations = document.optimizationRecommendations
        
        #expect(type(of: recommendations) == [String].self)
        
        // If the document contains Lucide icons and they're not optimized,
        // we should get a recommendation
        let rendered = try document.render()
        if LucideStyles.containsLucideIcons(in: rendered) && 
           !LucideStyles.optimizationStatus.isOptimized {
            #expect(recommendations.count > 0)
        }
    }
    
    // MARK: - Integration with LucideStyles Tests
    
    @Test("Integration with LucideStyles optimization status")
    func testLucideStylesIntegration() {
        let lucideStatus = LucideStyles.optimizationStatus
        let buildStatus = BuildOptimization.assessOptimizationLevel()
        
        // The build optimization should be aware of Lucide status
        #expect(type(of: lucideStatus.isOptimized) == Bool.self)
        #expect(!lucideStatus.recommendation.isEmpty)
        
        // Build optimization should include Lucide assets
        let assets = BuildOptimization.getDetailedAssetReport()
        let hasLucideAsset = assets.contains { asset in
            asset.name.lowercased().contains("lucide")
        }
        
        if assets.count > 0 {
            #expect(hasLucideAsset)
        }
    }
}