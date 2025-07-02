#!/usr/bin/env swift

import Foundation

/// Asset optimization script for WebUI framework.
/// Downloads external CDN assets locally for improved performance and reliability.

enum AssetOptimizationError: Error, CustomStringConvertible {
    case downloadFailed(String)
    case directoryCreationFailed(String)
    case fileWriteFailed(String)
    case assetNotFound(String)
    case networkError(Error)
    
    var description: String {
        switch self {
        case .downloadFailed(let url):
            return "Failed to download asset from: \(url)"
        case .directoryCreationFailed(let path):
            return "Failed to create directory: \(path)"
        case .fileWriteFailed(let path):
            return "Failed to write file: \(path)"
        case .assetNotFound(let asset):
            return "Asset not found: \(asset)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

struct Asset {
    let name: String
    let url: String
    let localPath: String
    let version: String?
    
    init(name: String, url: String, localPath: String, version: String? = nil) {
        self.name = name
        self.url = url
        self.localPath = localPath
        self.version = version
    }
}

class AssetOptimizer {
    private let outputDirectory: String
    private let publicDirectory: String
    
    init(outputDirectory: String = ".output", publicDirectory: String = "public") {
        self.outputDirectory = outputDirectory
        self.publicDirectory = publicDirectory
    }
    
    /// Downloads an asset and saves it locally
    func downloadAsset(_ asset: Asset) async throws {
        print("📦 Downloading \(asset.name)...")
        
        guard let url = URL(string: asset.url) else {
            throw AssetOptimizationError.downloadFailed(asset.url)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw AssetOptimizationError.downloadFailed(asset.url)
            }
            
            try await saveAsset(data: data, to: asset.localPath, name: asset.name)
            
            let sizeKB = Double(data.count) / 1024.0
            print("✅ Downloaded \(asset.name) (\(String(format: "%.1f", sizeKB)) KB)")
            
        } catch {
            throw AssetOptimizationError.networkError(error)
        }
    }
    
    /// Saves asset data to the local file system
    private func saveAsset(data: Data, to localPath: String, name: String) async throws {
        let fullPath = "\(outputDirectory)/\(publicDirectory)/\(localPath)"
        let fileURL = URL(fileURLWithPath: fullPath)
        let directoryURL = fileURL.deletingLastPathComponent()
        
        // Create directory structure if it doesn't exist
        do {
            try FileManager.default.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            throw AssetOptimizationError.directoryCreationFailed(directoryURL.path)
        }
        
        // Write the file
        do {
            try data.write(to: fileURL)
        } catch {
            throw AssetOptimizationError.fileWriteFailed(fullPath)
        }
    }
    
    /// Downloads all assets defined in the assets list
    func downloadAllAssets() async throws {
        let assets = getAssetList()
        
        print("🚀 Starting asset optimization...")
        print("📁 Output directory: \(outputDirectory)/\(publicDirectory)")
        print("🔢 Total assets: \(assets.count)")
        print("")
        
        for asset in assets {
            do {
                try await downloadAsset(asset)
            } catch {
                print("❌ Failed to download \(asset.name): \(error)")
                // Continue with other assets instead of failing completely
            }
        }
        
        print("")
        print("🎉 Asset optimization complete!")
        print("💡 Update your code to use local paths instead of CDN URLs")
    }
    
    /// Returns the list of assets to be optimized
    private func getAssetList() -> [Asset] {
        return [
            // Lucide Icons CSS
            Asset(
                name: "Lucide Icons CSS",
                url: "https://unpkg.com/lucide-static@latest/font/lucide.css",
                localPath: "css/lucide.css"
            ),
            
            // Lucide Icons Font Files (WOFF2)
            Asset(
                name: "Lucide Icons Font (WOFF2)",
                url: "https://unpkg.com/lucide-static@latest/font/lucide.woff2",
                localPath: "fonts/lucide.woff2"
            ),
            
            // Lucide Icons Font Files (WOFF)
            Asset(
                name: "Lucide Icons Font (WOFF)",
                url: "https://unpkg.com/lucide-static@latest/font/lucide.woff",
                localPath: "fonts/lucide.woff"
            ),
            
            // Lucide Icons Font Files (TTF)
            Asset(
                name: "Lucide Icons Font (TTF)",
                url: "https://unpkg.com/lucide-static@latest/font/lucide.ttf",
                localPath: "fonts/lucide.ttf"
            )
        ]
    }
}

// MARK: - Main execution

func main() async {
    let args = CommandLine.arguments
    
    // Parse command line arguments
    var outputDir = ".output"
    var publicDir = "public"
    var showHelp = false
    
    var i = 1
    while i < args.count {
        switch args[i] {
        case "--output", "-o":
            if i + 1 < args.count {
                outputDir = args[i + 1]
                i += 1
            }
        case "--public", "-p":
            if i + 1 < args.count {
                publicDir = args[i + 1]
                i += 1
            }
        case "--help", "-h":
            showHelp = true
        default:
            print("Unknown option: \(args[i])")
            showHelp = true
        }
        i += 1
    }
    
    if showHelp {
        print("""
        Asset Optimization Script for WebUI
        
        Downloads external CDN assets locally for improved performance.
        
        Usage: swift Scripts/optimize-assets.swift [options]
        
        Options:
          --output, -o    Output directory (default: .output)
          --public, -p    Public subdirectory (default: public)
          --help, -h      Show this help message
        
        Examples:
          swift Scripts/optimize-assets.swift
          swift Scripts/optimize-assets.swift --output build --public assets
        """)
        return
    }
    
    let optimizer = AssetOptimizer(outputDirectory: outputDir, publicDirectory: publicDir)
    
    do {
        try await optimizer.downloadAllAssets()
    } catch {
        print("❌ Asset optimization failed: \(error)")
        exit(1)
    }
}

// Run the main function
await main()