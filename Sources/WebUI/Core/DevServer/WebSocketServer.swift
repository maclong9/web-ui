import Foundation
import Network

/// A WebSocket server for hot reload communication during development.
///
/// `WebSocketServer` provides real-time communication between the development server
/// and web browsers for hot reload functionality:
/// - Broadcasts reload notifications to all connected clients
/// - Sends build error messages to browsers
/// - Maintains connection health with ping/pong
/// - Handles multiple concurrent client connections
///
/// ## Usage
///
/// ```swift
/// let wsServer = WebSocketServer(
///     port: 3001,
///     host: "localhost"
/// )
/// try await wsServer.start()
/// 
/// // Notify all connected clients to reload
/// await wsServer.broadcastReload()
/// ```
public final class WebSocketServer: @unchecked Sendable {
    
    private let port: UInt16
    private let host: String
    private let logger: DevServerLogger
    
    private var listener: NWListener?
    private var connections: Set<WebSocketConnection> = []
    private let connectionsLock = NSLock()
    private var isRunning = false
    
    /// Creates a new WebSocket server instance.
    ///
    /// - Parameters:
    ///   - port: Port number to bind to
    ///   - host: Host address to bind to  
    ///   - logger: Logger instance for connection logging
    public init(
        port: UInt16,
        host: String,
        logger: DevServerLogger
    ) {
        self.port = port
        self.host = host
        self.logger = logger
    }
    
    /// Starts the WebSocket server and begins accepting connections.
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
            self?.handleNewConnection(connection)
        }
        
        listener.start(queue: .main)
        isRunning = true
        
        logger.info("WebSocket server started on \(host):\(port)")
    }
    
    /// Stops the WebSocket server and closes all connections.
    public func stop() async {
        guard isRunning else { return }
        
        listener?.cancel()
        listener = nil
        isRunning = false
        
        // Close all existing connections
        connectionsLock.withLock {
            for connection in connections {
                connection.close()
            }
            connections.removeAll()
        }
        
        logger.info("WebSocket server stopped")
    }
    
    /// Broadcasts a reload message to all connected clients.
    ///
    /// This causes all connected web browsers to refresh their pages,
    /// picking up the latest changes from the development server.
    public func broadcastReload() async {
        let message = WebSocketMessage.reload
        await broadcast(message: message)
        logger.info("Broadcast reload to \(connectionCount) clients")
    }
    
    /// Broadcasts an error message to all connected clients.
    ///
    /// This displays build errors in the browser console for debugging.
    ///
    /// - Parameter errorMessage: The error message to broadcast
    public func broadcastError(_ errorMessage: String) async {
        let message = WebSocketMessage.error(errorMessage)
        await broadcast(message: message)
        logger.info("Broadcast error to \(connectionCount) clients")
    }
    
    // MARK: - Private Methods
    
    private var connectionCount: Int {
        connectionsLock.withLock { connections.count }
    }
    
    private func handleNewConnection(_ nwConnection: NWConnection) {
        let wsConnection = WebSocketConnection(
            connection: nwConnection,
            onMessage: { [weak self] message in
                self?.handleMessage(message, from: nwConnection)
            },
            onClose: { [weak self] in
                self?.removeConnection(nwConnection)
            }
        )
        
        _ = connectionsLock.withLock {
            connections.insert(wsConnection)
        }
        
        wsConnection.start()
        logger.info("WebSocket client connected (\(connectionCount) total)")
    }
    
    private func removeConnection(_ nwConnection: NWConnection) {
        connectionsLock.withLock {
            if let connectionToRemove = connections.first(where: { $0.connection === nwConnection }) {
                connections.remove(connectionToRemove)
            }
        }
        logger.info("WebSocket client disconnected (\(connectionCount) total)")
    }
    
    private func handleMessage(_ message: WebSocketMessage, from connection: NWConnection) {
        switch message {
        case .ping:
            // Respond with pong to keep connection alive
            if let wsConnection = findConnection(connection) {
                Task {
                    await wsConnection.send(message: .pong)
                }
            }
        case .pong:
            // Ping response received - connection is healthy
            break
        default:
            logger.debug("Received message from client: \(message)")
        }
    }
    
    private func findConnection(_ nwConnection: NWConnection) -> WebSocketConnection? {
        return connectionsLock.withLock {
            connections.first { $0.connection === nwConnection }
        }
    }
    
    private func broadcast(message: WebSocketMessage) async {
        let currentConnections = connectionsLock.withLock { Array(connections) }
        
        await withTaskGroup(of: Void.self) { group in
            for connection in currentConnections {
                group.addTask {
                    await connection.send(message: message)
                }
            }
        }
    }
}

// MARK: - WebSocket Connection

private final class WebSocketConnection: @unchecked Sendable, Hashable {
    
    let connection: NWConnection
    private let onMessage: (WebSocketMessage) -> Void
    private let onClose: () -> Void
    
    init(
        connection: NWConnection,
        onMessage: @escaping (WebSocketMessage) -> Void,
        onClose: @escaping () -> Void
    ) {
        self.connection = connection
        self.onMessage = onMessage
        self.onClose = onClose
    }
    
    func start() {
        connection.start(queue: .global(qos: .userInitiated))
        receiveWebSocketHandshake()
    }
    
    func close() {
        connection.cancel()
    }
    
    func send(message: WebSocketMessage) async {
        let data = message.toData()
        let frame = createWebSocketFrame(data: data)
        
        await withCheckedContinuation { continuation in
            connection.send(content: frame, completion: .contentProcessed { _ in
                continuation.resume()
            })
        }
    }
    
    // MARK: - WebSocket Protocol Implementation
    
    private func receiveWebSocketHandshake() {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 8192) { [weak self] data, _, isComplete, error in
            if let error = error {
                print("WebSocket handshake error: \(error)")
                self?.onClose()
                return
            }
            
            if let data = data, !data.isEmpty {
                self?.processHandshake(data: data)
            }
            
            if isComplete {
                self?.onClose()
            }
        }
    }
    
    private func processHandshake(data: Data) {
        guard let request = String(data: data, encoding: .utf8) else {
            connection.cancel()
            return
        }
        
        // Parse WebSocket handshake
        let lines = request.components(separatedBy: "\r\n")
        var webSocketKey: String?
        
        for line in lines {
            if line.hasPrefix("Sec-WebSocket-Key:") {
                webSocketKey = String(line.dropFirst(18).trimmingCharacters(in: .whitespaces))
            }
        }
        
        guard let key = webSocketKey else {
            connection.cancel()
            return
        }
        
        // Generate WebSocket accept key
        let acceptKey = generateWebSocketAcceptKey(key: key)
        
        // Send handshake response
        let response = """
        HTTP/1.1 101 Switching Protocols\r
        Upgrade: websocket\r
        Connection: Upgrade\r
        Sec-WebSocket-Accept: \(acceptKey)\r
        \r\n
        """
        
        let responseData = response.data(using: .utf8)!
        connection.send(content: responseData, completion: .contentProcessed { [weak self] _ in
            self?.receiveWebSocketFrames()
        })
    }
    
    private func receiveWebSocketFrames() {
        connection.receive(minimumIncompleteLength: 2, maximumLength: 8192) { [weak self] data, _, isComplete, error in
            if let error = error {
                print("WebSocket frame error: \(error)")
                self?.onClose()
                return
            }
            
            if let data = data, !data.isEmpty {
                self?.processWebSocketFrame(data: data)
            }
            
            if isComplete {
                self?.onClose()
            } else {
                self?.receiveWebSocketFrames()
            }
        }
    }
    
    private func processWebSocketFrame(data: Data) {
        guard data.count >= 2 else { return }
        
        let firstByte = data[0]
        let secondByte = data[1]
        
        let opcode = firstByte & 0x0F
        let masked = (secondByte & 0x80) != 0
        let payloadLength = Int(secondByte & 0x7F)
        
        // Simple frame parsing - handle text frames (opcode 1) and close frames (opcode 8)
        if opcode == 1 { // Text frame
            var offset = 2
            
            // Handle masking
            if masked {
                offset += 4
            }
            
            if data.count > offset {
                let payload = data.subdata(in: offset..<min(data.count, offset + payloadLength))
                if let text = String(data: payload, encoding: .utf8) {
                    if let message = WebSocketMessage.fromJSON(text) {
                        onMessage(message)
                    }
                }
            }
        } else if opcode == 8 { // Close frame
            onClose()
        }
    }
    
    private func createWebSocketFrame(data: Data) -> Data {
        var frame = Data()
        
        // FIN bit set, opcode 1 (text frame)
        frame.append(0x81)
        
        // Payload length
        if data.count < 126 {
            frame.append(UInt8(data.count))
        } else if data.count <= 65535 {
            frame.append(126)
            frame.append(contentsOf: withUnsafeBytes(of: UInt16(data.count).bigEndian) { Array($0) })
        } else {
            frame.append(127)
            frame.append(contentsOf: withUnsafeBytes(of: UInt64(data.count).bigEndian) { Array($0) })
        }
        
        // Payload data
        frame.append(data)
        
        return frame
    }
    
    private func generateWebSocketAcceptKey(key: String) -> String {
        let webSocketMagicString = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
        let combined = key + webSocketMagicString
        let hash = combined.sha1()
        return Data(hash).base64EncodedString()
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(connection))
    }
    
    static func == (lhs: WebSocketConnection, rhs: WebSocketConnection) -> Bool {
        return lhs.connection === rhs.connection
    }
}

// MARK: - WebSocket Message

private enum WebSocketMessage {
    case reload
    case error(String)
    case ping
    case pong
    
    func toData() -> Data {
        let json: [String: Any]
        
        switch self {
        case .reload:
            json = ["type": "reload"]
        case .error(let message):
            json = ["type": "error", "message": message]
        case .ping:
            json = ["type": "ping"]
        case .pong:
            json = ["type": "pong"]
        }
        
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    static func fromJSON(_ jsonString: String) -> WebSocketMessage? {
        guard let data = jsonString.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let type = json["type"] as? String else {
            return nil
        }
        
        switch type {
        case "reload":
            return .reload
        case "error":
            if let message = json["message"] as? String {
                return .error(message)
            }
        case "ping":
            return .ping
        case "pong":
            return .pong
        default:
            break
        }
        
        return nil
    }
}

// MARK: - SHA1 Extension

extension String {
    func sha1() -> [UInt8] {
        let data = self.data(using: .utf8)!
        var digest = [UInt8](repeating: 0, count: 20)
        
        data.withUnsafeBytes { bytes in
            let ptr = bytes.bindMemory(to: UInt8.self)
            CC_SHA1(ptr.baseAddress, CC_LONG(data.count), &digest)
        }
        
        return digest
    }
}

// MARK: - CommonCrypto Import

#if canImport(CommonCrypto)
import CommonCrypto
#else
// Fallback implementation for platforms without CommonCrypto
private func CC_SHA1(_ data: UnsafeRawPointer?, _ len: CC_LONG, _ md: UnsafeMutablePointer<UInt8>?) -> UnsafeMutablePointer<UInt8>? {
    // This is a simplified fallback - in production, use a proper crypto library
    return nil
}
private typealias CC_LONG = UInt32
#endif