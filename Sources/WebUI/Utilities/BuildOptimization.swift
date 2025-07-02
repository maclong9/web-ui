import Foundation

/// Build optimization utilities for WebUI framework.
///
/// This module provides tools and strategies for optimizing web assets during build time,
/// reducing runtime dependencies on external CDNs and improving performance.
///
/// ## Core Philosophy
///
/// The WebUI framework follows a **build-time optimization** strategy that:
/// - Downloads external assets during build rather than runtime
/// - Creates self-contained deployments with minimal external dependencies
/// - Provides automatic fallback strategies for asset loading
/// - Optimizes for performance, reliability, and offline capabilities
///
/// ## Performance Benefits
///
/// **Local Asset Hosting:**
/// - ⚡ **Faster loading**: No DNS resolution for external domains
/// - 🛡️ **Better reliability**: No dependency on third-party CDN uptime
/// - 📱 **Offline support**: Applications work without internet connectivity
/// - 🎯 **Custom caching**: Full control over cache headers and strategies
/// - 🔒 **Enhanced privacy**: No external tracking or fingerprinting
/// - 💰 **Reduced bandwidth costs**: Leverage edge CDN for your own domain
///
/// ## Usage
///
/// ```swift
/// // Check optimization status
/// let status = BuildOptimization.assessOptimizationLevel()
/// print(status.summary)
///
/// // Get recommendations
/// let recommendations = BuildOptimization.getOptimizationRecommendations()
/// for recommendation in recommendations {
///     print("💡 \(recommendation)")
/// }
/// ```
public enum BuildOptimization {
    
    // MARK: - Asset Categories
    
    /// Represents different categories of assets that can be optimized
    public enum AssetCategory: String, CaseIterable {
        case iconFonts = "Icon Fonts"
        case webFonts = "Web Fonts"
        case cssFrameworks = "CSS Frameworks"
        case javascriptLibraries = "JavaScript Libraries"
        case images = "Images"
        case other = "Other Assets"
        
        var description: String {
            return rawValue
        }
    }
    
    /// Represents the optimization status of an asset
    public struct AssetStatus {
        public let name: String
        public let category: AssetCategory
        public let isOptimized: Bool
        public let localPath: String?
        public let cdnPath: String?
        public let estimatedSizeKB: Double?
        public let priority: OptimizationPriority
        
        public init(
            name: String,
            category: AssetCategory,
            isOptimized: Bool,
            localPath: String? = nil,
            cdnPath: String? = nil,
            estimatedSizeKB: Double? = nil,
            priority: OptimizationPriority = .medium
        ) {
            self.name = name
            self.category = category
            self.isOptimized = isOptimized
            self.localPath = localPath
            self.cdnPath = cdnPath
            self.estimatedSizeKB = estimatedSizeKB
            self.priority = priority
        }
        
        public var statusIcon: String {
            return isOptimized ? "✅" : "⚠️"
        }
        
        public var sizeDescription: String {
            guard let size = estimatedSizeKB else { return "Unknown size" }
            if size < 1.0 {
                return "\(Int(size * 1000)) bytes"
            } else if size < 1024.0 {
                return "\(String(format: "%.1f", size)) KB"
            } else {
                return "\(String(format: "%.1f", size / 1024.0)) MB"
            }
        }
    }
    
    /// Priority levels for asset optimization
    public enum OptimizationPriority: String, CaseIterable, Comparable {
        case critical = "Critical"
        case high = "High"
        case medium = "Medium"
        case low = "Low"
        
        public static func < (lhs: OptimizationPriority, rhs: OptimizationPriority) -> Bool {
            let order: [OptimizationPriority] = [.critical, .high, .medium, .low]
            guard let lhsIndex = order.firstIndex(of: lhs),
                  let rhsIndex = order.firstIndex(of: rhs) else {
                return false
            }
            return lhsIndex < rhsIndex
        }
        
        var description: String {
            switch self {
            case .critical:
                return "🔴 Critical - Blocks rendering or core functionality"
            case .high:
                return "🟠 High - Significantly impacts user experience"
            case .medium:
                return "🟡 Medium - Moderate performance benefits"
            case .low:
                return "🟢 Low - Minor optimization opportunity"
            }
        }
    }
    
    // MARK: - Optimization Assessment
    
    /// Overall optimization status summary
    public struct OptimizationStatus {
        public let totalAssets: Int
        public let optimizedAssets: Int
        public let optimizationPercentage: Double
        public let estimatedSavingsKB: Double
        public let recommendations: [String]
        
        public var summary: String {
            let percentage = String(format: "%.1f", optimizationPercentage)
            let savings = estimatedSavingsKB > 0 ? " (Est. \(String(format: "%.1f", estimatedSavingsKB)) KB potential savings)" : ""
            
            return """
            📊 Asset Optimization Status
            ▪️ Optimized: \(optimizedAssets)/\(totalAssets) assets (\(percentage)%)\(savings)
            """
        }
        
        public var isFullyOptimized: Bool {
            return optimizationPercentage >= 100.0
        }
    }
    
    /// Assesses the current optimization level of all known assets
    public static func assessOptimizationLevel() -> OptimizationStatus {
        let assets = getAllKnownAssets()
        let optimizedCount = assets.filter { $0.isOptimized }.count
        let percentage = assets.isEmpty ? 100.0 : (Double(optimizedCount) / Double(assets.count)) * 100.0
        
        let potentialSavings = assets
            .filter { !$0.isOptimized }
            .compactMap { $0.estimatedSizeKB }
            .reduce(0, +)
        
        let recommendations = generateRecommendations(for: assets)
        
        return OptimizationStatus(
            totalAssets: assets.count,
            optimizedAssets: optimizedCount,
            optimizationPercentage: percentage,
            estimatedSavingsKB: potentialSavings,
            recommendations: recommendations
        )
    }
    
    /// Gets optimization recommendations based on current status
    public static func getOptimizationRecommendations() -> [String] {
        let assets = getAllKnownAssets()
        return generateRecommendations(for: assets)
    }
    
    /// Gets detailed information about all assets
    public static func getDetailedAssetReport() -> [AssetStatus] {
        return getAllKnownAssets()
    }
    
    // MARK: - Private Implementation
    
    /// Returns all known assets in the framework that can be optimized
    private static func getAllKnownAssets() -> [AssetStatus] {
        var assets: [AssetStatus] = []
        
        // Lucide Icons
        let lucideOptimized = LucideStyles.optimizationStatus.isOptimized
        assets.append(AssetStatus(
            name: "Lucide Icons",
            category: .iconFonts,
            isOptimized: lucideOptimized,
            localPath: lucideOptimized ? LucideStyles.localPath : nil,
            cdnPath: LucideStyles.cdnURL,
            estimatedSizeKB: 45.0, // Approximate size of Lucide CSS + fonts
            priority: .high
        ))
        
        // Add other potential assets here as they're discovered
        // This method should be extended as new external dependencies are added
        
        return assets
    }
    
    /// Generates recommendations based on asset status
    private static func generateRecommendations(for assets: [AssetStatus]) -> [String] {
        var recommendations: [String] = []
        
        let unoptimizedAssets = assets.filter { !$0.isOptimized }
        
        if unoptimizedAssets.isEmpty {
            recommendations.append("🎉 All assets are optimized! Your application has minimal external dependencies.")
        } else {
            // Sort by priority for better recommendations
            let sortedAssets = unoptimizedAssets.sorted { $0.priority < $1.priority }
            
            for asset in sortedAssets {
                switch asset.priority {
                case .critical, .high:
                    recommendations.append("🔥 Optimize \(asset.name) for significant performance gains")
                case .medium:
                    recommendations.append("⚡ Consider optimizing \(asset.name) for better load times")
                case .low:
                    recommendations.append("📈 Minor optimization opportunity: \(asset.name)")
                }
            }
            
            // General recommendations
            recommendations.append("🛠️ Run 'swift Scripts/optimize-assets.swift' to download assets locally")
            
            if unoptimizedAssets.count > 3 {
                recommendations.append("📋 Focus on high-priority assets first for maximum impact")
            }
            
            let totalPotentialSavings = unoptimizedAssets
                .compactMap { $0.estimatedSizeKB }
                .reduce(0, +)
            
            if totalPotentialSavings > 100 {
                recommendations.append("💾 Potential bandwidth savings: \(String(format: "%.1f", totalPotentialSavings)) KB per page load")
            }
        }
        
        return recommendations
    }
    
    // MARK: - Build Integration Helpers
    
    /// Checks if the build environment supports asset optimization
    public static func isBuildEnvironmentReady() -> Bool {
        // Check if we have write access to output directory
        let outputPaths = [".output", "public", "dist"]
        
        return outputPaths.contains { path in
            let url = URL(fileURLWithPath: path)
            return FileManager.default.isWritableFile(atPath: url.path)
        }
    }
    
    /// Gets the recommended output directory for optimized assets
    public static func getRecommendedOutputDirectory() -> String {
        let candidates = [".output/public", "public", "dist"]
        
        for candidate in candidates {
            if FileManager.default.fileExists(atPath: candidate) {
                return candidate
            }
        }
        
        return ".output/public" // Default fallback
    }
    
    /// Validates that required build tools are available
    public static func validateBuildTools() -> [String] {
        var missingTools: [String] = []
        
        let requiredTools = ["curl", "tar"]
        
        for tool in requiredTools {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/which")
            process.arguments = [tool]
            process.standardOutput = Pipe()
            process.standardError = Pipe()
            
            do {
                try process.run()
                process.waitUntilExit()
                
                if process.terminationStatus != 0 {
                    missingTools.append(tool)
                }
            } catch {
                missingTools.append(tool)
            }
        }
        
        return missingTools
    }
}

// MARK: - Document Integration

extension Document {
    /// Assessment of optimization opportunities for this document
    public var optimizationAssessment: BuildOptimization.OptimizationStatus {
        return BuildOptimization.assessOptimizationLevel()
    }
    
    /// Provides optimization recommendations specific to this document
    public var optimizationRecommendations: [String] {
        let content = (try? self.render()) ?? ""
        var recommendations: [String] = []
        
        // Check for Lucide icon usage
        if LucideStyles.containsLucideIcons(in: content) {
            let isOptimized = LucideStyles.optimizationStatus.isOptimized
            if !isOptimized {
                recommendations.append("🎯 This page uses Lucide icons - optimize for \(LucideStyles.optimizationStatus.recommendation)")
            }
        }
        
        return recommendations
    }
}