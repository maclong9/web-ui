import Foundation
import WebUI
import WebUIMarkdown

let portfolio = PortfolioWebsite()

print("🚀 Building Portfolio Website...")
try portfolio.build(to: URL(filePath: "dist"))
print("✅ Portfolio website built successfully to ./dist/")