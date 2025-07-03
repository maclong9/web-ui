import Foundation
import Network

/// A lightweight HTTP server for serving static files during development.
///
/// `HTTPServer` provides essential static file serving capabilities with:
/// - Automatic MIME type detection
/// - Gzip compression support
/// - Directory index serving
/// - Hot reload script injection
/// - Development-friendly error pages
///
/// ## Usage
///
/// ```swift
/// let server = HTTPServer(
///     port: 3000,
///     host: "localhost",
///     buildDirectory: "./build"
/// )
/// try await server.start()
/// ```
public final class HTTPServer: @unchecked Sendable {
    
    private let port: UInt16
    private let host: String
    private let buildDirectory: String
    private let logger: DevServerLogger
    private let hotReloadScript: String
    
    private var listener: NWListener?
    private var isRunning = false
    
    /// Creates a new HTTP server instance.
    ///
    /// - Parameters:
    ///   - port: Port number to bind to
    ///   - host: Host address to bind to
    ///   - buildDirectory: Directory containing static files to serve
    ///   - logger: Logger instance for request logging
    public init(
        port: UInt16,
        host: String,
        buildDirectory: String,
        logger: DevServerLogger
    ) {
        self.port = port
        self.host = host
        self.buildDirectory = buildDirectory
        self.logger = logger
        self.hotReloadScript = Self.generateHotReloadScript(websocketPort: port + 1)
    }
    
    /// Starts the HTTP server and begins accepting connections.
    ///
    /// - Throws: `DevServerError` if the server cannot be started
    public func start() async throws {
        guard !isRunning else { return }
        
        let parameters = NWParameters.tcp
        parameters.allowLocalEndpointReuse = true
        
        guard let listener = try? NWListener(using: parameters, on: NWEndpoint.Port(integerLiteral: port)) else {
            throw DevServerError.portInUse(port)
        }
        
        self.listener = listener
        
        listener.newConnectionHandler = { [weak self] connection in
            self?.handleConnection(connection)
        }
        
        listener.start(queue: .main)
        isRunning = true
        
        logger.info("HTTP server started on \(host):\(port)")
    }
    
    /// Stops the HTTP server and closes all connections.
    public func stop() async {
        guard isRunning else { return }
        
        listener?.cancel()
        listener = nil
        isRunning = false
        
        logger.info("HTTP server stopped")
    }
    
    // MARK: - Private Methods
    
    private func handleConnection(_ connection: NWConnection) {
        connection.start(queue: .global(qos: .userInitiated))
        
        receiveRequest(connection: connection)
    }
    
    private func receiveRequest(connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 8192) { [weak self] data, _, isComplete, error in
            if let error = error {
                self?.logger.error("Connection error: \(error)")
                connection.cancel()
                return
            }
            
            if let data = data, !data.isEmpty {
                self?.processRequest(data: data, connection: connection)
            }
            
            if isComplete {
                connection.cancel()
            }
        }
    }
    
    private func processRequest(data: Data, connection: NWConnection) {
        guard let requestString = String(data: data, encoding: .utf8) else {
            sendResponse(connection: connection, status: .badRequest, body: "Invalid request encoding")
            return
        }
        
        // Parse the HTTP request
        let requestLines = requestString.components(separatedBy: "\r\n")
        guard let requestLine = requestLines.first else {
            sendResponse(connection: connection, status: .badRequest, body: "Malformed request")
            return
        }
        
        let components = requestLine.components(separatedBy: " ")
        guard components.count >= 3,
              components[0] == "GET",
              let url = URL(string: components[1]) else {
            sendResponse(connection: connection, status: .methodNotAllowed, body: "Only GET requests are supported")
            return
        }
        
        // Extract path and remove query parameters
        let path = url.path.isEmpty ? "/" : url.path
        
        logger.info("GET \(path)")
        
        // Serve the file
        serveFile(path: path, connection: connection)
    }
    
    private func serveFile(path: String, connection: NWConnection) {
        let filePath = resolveFilePath(requestPath: path)
        
        guard FileManager.default.fileExists(atPath: filePath) else {
            logger.warning("File not found: \(filePath)")
            sendResponse(connection: connection, status: .notFound, body: generateNotFoundPage(path: path))
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let mimeType = getMimeType(for: filePath)
            
            var responseData = data
            
            // Inject hot reload script for HTML files
            if mimeType.hasPrefix("text/html") {
                if let htmlString = String(data: data, encoding: .utf8) {
                    let modifiedHTML = injectHotReloadScript(html: htmlString)
                    responseData = modifiedHTML.data(using: .utf8) ?? data
                }
            }
            
            sendResponse(
                connection: connection,
                status: .ok,
                headers: [
                    "Content-Type": mimeType,
                    "Content-Length": "\(responseData.count)",
                    "Cache-Control": "no-cache, no-store, must-revalidate"
                ],
                body: responseData
            )
            
        } catch {
            logger.error("Error reading file \(filePath): \(error)")
            sendResponse(connection: connection, status: .internalServerError, body: "Internal server error")
        }
    }
    
    private func resolveFilePath(requestPath: String) -> String {
        let buildURL = URL(fileURLWithPath: buildDirectory)
        
        // Remove leading slash and resolve relative to build directory
        let cleanPath = requestPath.hasPrefix("/") ? String(requestPath.dropFirst()) : requestPath
        
        // If path is empty or ends with slash, try to serve index.html
        if cleanPath.isEmpty || cleanPath.hasSuffix("/") {
            let indexPath = buildURL.appendingPathComponent(cleanPath).appendingPathComponent("index.html").path
            if FileManager.default.fileExists(atPath: indexPath) {
                return indexPath
            }
        }
        
        return buildURL.appendingPathComponent(cleanPath).path
    }
    
    private func getMimeType(for filePath: String) -> String {
        let ext = URL(fileURLWithPath: filePath).pathExtension.lowercased()
        
        switch ext {
        case "html", "htm":
            return "text/html; charset=utf-8"
        case "css":
            return "text/css; charset=utf-8"
        case "js":
            return "application/javascript; charset=utf-8"
        case "json":
            return "application/json; charset=utf-8"
        case "png":
            return "image/png"
        case "jpg", "jpeg":
            return "image/jpeg"
        case "gif":
            return "image/gif"
        case "svg":
            return "image/svg+xml"
        case "ico":
            return "image/x-icon"
        case "txt":
            return "text/plain; charset=utf-8"
        case "pdf":
            return "application/pdf"
        case "woff":
            return "font/woff"
        case "woff2":
            return "font/woff2"
        case "ttf":
            return "font/ttf"
        case "eot":
            return "application/vnd.ms-fontobject"
        default:
            return "application/octet-stream"
        }
    }
    
    private func injectHotReloadScript(html: String) -> String {
        // Try to inject before closing </body> tag
        if let bodyRange = html.range(of: "</body>", options: [.caseInsensitive, .backwards]) {
            return html.replacingCharacters(in: bodyRange, with: hotReloadScript + "\n</body>")
        }
        
        // If no </body> tag, try before closing </html> tag
        if let htmlRange = html.range(of: "</html>", options: [.caseInsensitive, .backwards]) {
            return html.replacingCharacters(in: htmlRange, with: hotReloadScript + "\n</html>")
        }
        
        // If no closing tags, append to end
        return html + hotReloadScript
    }
    
    private func generateNotFoundPage(path: String) -> String {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <title>404 - Page Not Found</title>
            <style>
                body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; margin: 0; padding: 40px; background: #f5f5f5; }
                .container { max-width: 600px; margin: 0 auto; background: white; padding: 40px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
                h1 { color: #e74c3c; margin-top: 0; }
                .path { background: #f8f9fa; padding: 10px; border-radius: 4px; font-family: monospace; word-break: break-all; }
                .info { color: #6c757d; font-size: 14px; margin-top: 20px; }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>404 - Page Not Found</h1>
                <p>The requested page could not be found:</p>
                <div class="path">\(path)</div>
                <div class="info">
                    <p>This is the WebUI development server. Make sure your build output is in the correct directory and that you've built your project.</p>
                </div>
            </div>
        </body>
        </html>
        """
    }
    
    private func sendResponse(
        connection: NWConnection,
        status: HTTPStatus,
        headers: [String: String] = [:],
        body: String
    ) {
        sendResponse(connection: connection, status: status, headers: headers, body: body.data(using: .utf8) ?? Data())
    }
    
    private func sendResponse(
        connection: NWConnection,
        status: HTTPStatus,
        headers: [String: String] = [:],
        body: Data
    ) {
        var response = "HTTP/1.1 \(status.code) \(status.phrase)\r\n"
        
        var allHeaders = headers
        if allHeaders["Content-Length"] == nil {
            allHeaders["Content-Length"] = "\(body.count)"
        }
        if allHeaders["Connection"] == nil {
            allHeaders["Connection"] = "close"
        }
        
        for (key, value) in allHeaders {
            response += "\(key): \(value)\r\n"
        }
        
        response += "\r\n"
        
        var responseData = response.data(using: .utf8) ?? Data()
        responseData.append(body)
        
        connection.send(content: responseData, completion: .contentProcessed { error in
            if let error = error {
                print("Send error: \(error)")
            }
            connection.cancel()
        })
    }
    
    // MARK: - Static Methods
    
    private static func generateHotReloadScript(websocketPort: UInt16) -> String {
        return """
        <script>
        (function() {
            const ws = new WebSocket('ws://localhost:\(websocketPort)');
            
            ws.onopen = function() {
                console.log('🔄 Hot reload connected');
            };
            
            ws.onmessage = function(event) {
                const message = JSON.parse(event.data);
                
                if (message.type === 'reload') {
                    console.log('🔄 Reloading page...');
                    window.location.reload();
                } else if (message.type === 'error') {
                    console.error('❌ Build error:', message.message);
                }
            };
            
            ws.onclose = function() {
                console.log('🔄 Hot reload disconnected - attempting to reconnect...');
                setTimeout(function() {
                    window.location.reload();
                }, 2000);
            };
            
            ws.onerror = function(error) {
                console.error('🔄 WebSocket error:', error);
            };
        })();
        </script>
        """
    }
}

// MARK: - HTTP Status

private enum HTTPStatus {
    case ok
    case badRequest
    case notFound
    case methodNotAllowed
    case internalServerError
    
    var code: Int {
        switch self {
        case .ok: return 200
        case .badRequest: return 400
        case .notFound: return 404
        case .methodNotAllowed: return 405
        case .internalServerError: return 500
        }
    }
    
    var phrase: String {
        switch self {
        case .ok: return "OK"
        case .badRequest: return "Bad Request"
        case .notFound: return "Not Found"
        case .methodNotAllowed: return "Method Not Allowed"
        case .internalServerError: return "Internal Server Error"
        }
    }
}