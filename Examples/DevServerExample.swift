import Foundation
import WebUIDevServer

// MARK: - DevServer Example
//
// This example demonstrates how to use the WebUI DevServer for development.
// The DevServer provides hot reload functionality for web development.

@main
struct DevServerExample {
    static func main() async throws {
        print("🚀 Starting WebUI DevServer Example")
        
        // Create a temporary directory for the build output
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("webui-dev-example")
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        
        // Create a simple HTML file to serve
        let htmlContent = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>WebUI DevServer Example</title>
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                    max-width: 800px;
                    margin: 0 auto;
                    padding: 2rem;
                    line-height: 1.6;
                }
                .header {
                    text-align: center;
                    color: #2563eb;
                    margin-bottom: 2rem;
                }
                .features {
                    background: #f8fafc;
                    padding: 1.5rem;
                    border-radius: 8px;
                    margin: 1rem 0;
                }
                .feature {
                    margin: 0.5rem 0;
                    padding-left: 1rem;
                }
                .status {
                    background: #10b981;
                    color: white;
                    padding: 0.5rem 1rem;
                    border-radius: 4px;
                    display: inline-block;
                    margin-top: 1rem;
                }
            </style>
        </head>
        <body>
            <div class="header">
                <h1>🌐 WebUI DevServer</h1>
                <p>Hot reload development server is running!</p>
            </div>
            
            <div class="features">
                <h2>✨ Features</h2>
                <div class="feature">🔄 Hot reload on file changes</div>
                <div class="feature">📁 Static file serving</div>
                <div class="feature">🔌 WebSocket communication</div>
                <div class="feature">🏗️ Automatic build management</div>
                <div class="feature">📝 Development logging</div>
            </div>
            
            <div class="status">
                Server Status: Running
            </div>
            
            <p><strong>Try editing this file and watch it reload automatically!</strong></p>
            
            <script>
                console.log('🌐 WebUI DevServer Example loaded successfully!');
            </script>
        </body>
        </html>
        """
        
        let indexPath = tempDir.appendingPathComponent("index.html")
        try htmlContent.write(to: indexPath, atomically: true, encoding: .utf8)
        
        print("📁 Created example HTML file at: \(indexPath.path)")
        
        // Configure the DevServer
        let config = DevServer.Configuration(
            port: 3000,
            buildDirectory: tempDir.path,
            sourceDirectory: "./Sources", // Watch the Sources directory for changes
            buildCommand: "/bin/echo 'Build completed'", // Simple build command
            autoOpenBrowser: true,
            host: "localhost",
            websocketPort: 3001
        )
        
        // Create and start the DevServer
        let server = DevServer(configuration: config)
        
        print("🔧 DevServer configured:")
        print("   - HTTP Server: http://localhost:3000")
        print("   - WebSocket Server: ws://localhost:3001")
        print("   - Build Directory: \(tempDir.path)")
        print("   - Source Directory: ./Sources")
        
        // Handle graceful shutdown
        let signalSource = DispatchSource.makeSignalSource(signal: SIGINT, queue: .main)
        signalSource.setEventHandler {
            print("\n🛑 Received interrupt signal, shutting down...")
            Task {
                await server.stop()
                try? FileManager.default.removeItem(at: tempDir)
                print("✅ DevServer stopped gracefully")
                exit(0)
            }
        }
        signalSource.resume()
        
        // Start the server
        do {
            try await server.start()
        } catch let error as DevServerError {
            print("❌ DevServer error: \(error.errorDescription ?? error.localizedDescription)")
        } catch {
            print("❌ Unexpected error: \(error.localizedDescription)")
        }
    }
}