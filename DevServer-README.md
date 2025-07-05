# WebUI DevServer

The WebUI DevServer is a lightweight, standalone development server designed for modern web development workflows. It provides hot reload capabilities, static file serving, and automatic build management within the WebUI framework.

## Features

- 🔄 **Hot Reload**: Automatic browser refresh when source files change
- 📁 **Static File Serving**: Efficient serving of HTML, CSS, JS, and other assets
- 🔌 **WebSocket Communication**: Real-time communication between server and browser
- 🏗️ **Build Management**: Automatic project builds on file changes
- 📝 **Development Logging**: Colored, structured logging for debugging
- 🎯 **Cross-Platform**: Works on macOS, Linux, and other Swift-supported platforms

## External Dependencies

The DevServer uses only Apple's standard libraries and frameworks:

### Required System Frameworks
- **Foundation**: Core functionality and file system operations
- **Network**: HTTP and WebSocket server implementation using NWListener
- **CoreServices** (macOS only): FSEvents for efficient file watching
- **CommonCrypto**: SHA1 hashing for WebSocket protocol implementation

### Optional Dependencies
- **FoundationNetworking**: For Linux compatibility (imported conditionally)

### No Third-Party Dependencies
The DevServer is designed to be completely self-contained with no external package dependencies, making it lightweight and easy to integrate.

## Architecture

The DevServer consists of several key components:

```
DevServer
├── HTTPServer          - Static file serving with MIME type detection
├── WebSocketServer     - Real-time communication for hot reload
├── FileWatcher         - File system monitoring (FSEvents on macOS, polling fallback)
├── BuildManager        - Build command execution and output management
└── DevServerLogger     - Structured logging with ANSI colors
```

## Building and Testing

### Building the DevServer Standalone

The DevServer can be built independently from the UI components:

```bash
# Build just the DevServer library
swift build --target WebUIDevServer

# Build and run the example
swift run DevServerExample
```

### Running Tests

```bash
# Run DevServer-specific tests
swift test --filter WebUIDevServerTests
```

All tests pass and verify:
- Component initialization
- Configuration validation
- Build process execution
- File watching setup
- Error handling
- Server instantiation

## Usage Examples

### Basic Usage

```swift
import WebUIDevServer

// Create server with default configuration
let server = DevServer()

// Start the server
try await server.start()
```

### Custom Configuration

```swift
import WebUIDevServer

// Create custom configuration
let config = DevServer.Configuration(
    port: 8080,
    buildDirectory: "./dist",
    sourceDirectory: "./src",
    buildCommand: "swift build",
    autoOpenBrowser: true,
    host: "localhost",
    websocketPort: 8081
)

// Create server with custom config
let server = DevServer(configuration: config)

// Start the server
try await server.start()

// Stop gracefully when done
await server.stop()
```

### Integration with Build Systems

```swift
import WebUIDevServer

// Configure for Swift project
let swiftConfig = DevServer.Configuration(
    buildDirectory: "./.build/debug",
    sourceDirectory: "./Sources",
    buildCommand: "swift build",
    autoOpenBrowser: false
)

// Configure for npm project
let npmConfig = DevServer.Configuration(
    buildDirectory: "./dist",
    sourceDirectory: "./src",
    buildCommand: "npm run build",
    autoOpenBrowser: true
)
```

## Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `port` | `UInt16` | `3000` | HTTP server port |
| `buildDirectory` | `String` | `"./build"` | Directory containing static files |
| `sourceDirectory` | `String` | `"./Sources"` | Directory to watch for changes |
| `buildCommand` | `String` | `"swift run"` | Command to execute on file changes |
| `autoOpenBrowser` | `Bool` | `true` | Automatically open browser on start |
| `host` | `String` | `"localhost"` | Host address to bind to |
| `websocketPort` | `UInt16` | `3001` | WebSocket server port |

## File Watching

The DevServer uses platform-optimized file watching:

- **macOS**: FSEvents API for high-performance monitoring
- **Linux/Other**: Polling-based fallback with configurable intervals

### Supported File Extensions

By default, the FileWatcher monitors `.swift` files, but can be configured for any extensions:

```swift
let watcher = FileWatcher(
    directory: "./src",
    extensions: [".swift", ".html", ".css", ".js", ".md"]
)
```

## HTTP Server Features

- **MIME Type Detection**: Automatic content-type headers
- **Hot Reload Script Injection**: Automatically injects WebSocket client code
- **Directory Index**: Serves `index.html` for directory requests
- **Development Error Pages**: User-friendly 404 and error pages
- **Cache Headers**: No-cache headers for development

### Supported MIME Types

- HTML, CSS, JavaScript
- Images: PNG, JPEG, GIF, SVG, ICO
- Fonts: WOFF, WOFF2, TTF, EOT
- Documents: PDF, TXT, JSON
- And more...

## WebSocket Communication

The WebSocket server handles:

- **Connection Management**: Multiple concurrent client connections
- **Message Broadcasting**: Reload and error notifications to all clients
- **Protocol Compliance**: Full WebSocket protocol implementation
- **Connection Health**: Ping/pong for connection monitoring

### Message Types

```javascript
// Reload notification
{ "type": "reload" }

// Build error notification
{ "type": "error", "message": "Build failed: ..." }

// Ping/pong for connection health
{ "type": "ping" }
{ "type": "pong" }
```

## Build Management

The BuildManager provides:

- **Command Execution**: Secure process spawning with timeout
- **Output Capture**: Both stdout and stderr capture
- **Concurrent Safety**: Prevents multiple simultaneous builds
- **Error Handling**: Detailed error reporting and logging

### Build Process Flow

1. **Debounce**: Wait for file changes to settle
2. **Execute**: Run the configured build command
3. **Capture**: Collect build output and exit code
4. **Notify**: Send reload or error messages to clients
5. **Log**: Record build results with timing

## Error Handling

The DevServer defines comprehensive error types:

```swift
public enum DevServerError: Error {
    case portInUse(UInt16)
    case buildFailed(String)
    case fileSystemError(String)
    case networkError(String)
}
```

Each error provides descriptive messages for debugging.

## Performance Considerations

- **Memory Efficient**: Streaming file serving without loading entire files
- **CPU Optimized**: FSEvents on macOS avoid polling overhead
- **Network Optimized**: Efficient WebSocket frame handling
- **Concurrent**: Async/await throughout for non-blocking operations

## Platform Support

### Minimum Requirements

- **macOS**: 15.0+ (uses FSEvents, DispatchQueue)
- **iOS**: 13.0+
- **tvOS**: 13.0+
- **watchOS**: 6.0+
- **visionOS**: 2.0+
- **Linux**: Ubuntu 20.04+ (uses polling file watcher)

### Platform-Specific Features

- **macOS**: FSEvents file watching, process launching
- **Linux**: Polling file watcher, inotify support (future)
- **All Platforms**: Network framework, Foundation

## Security Considerations

- **Local Development Only**: Designed for localhost development
- **No Authentication**: Should not be exposed to public networks
- **File Access**: Limited to configured build directory
- **Process Execution**: Validates and sanitizes build commands

## Integration with WebUI Framework

The DevServer is designed to work seamlessly with WebUI:

1. **Standalone Operation**: Can run independently of UI components
2. **Optional Integration**: UI components can be excluded during build issues
3. **Shared Dependencies**: Uses same Foundation and Network frameworks
4. **Consistent Patterns**: Follows WebUI architectural patterns

## Troubleshooting

### Common Issues

1. **Port Already in Use**
   ```swift
   // Try different port
   let config = DevServer.Configuration(port: 8080)
   ```

2. **Build Command Not Found**
   ```swift
   // Use full path
   let config = DevServer.Configuration(buildCommand: "/usr/bin/swift build")
   ```

3. **File Watching Not Working**
   ```swift
   // Check directory exists and permissions
   let fileManager = FileManager.default
   guard fileManager.fileExists(atPath: sourceDirectory) else {
       // Handle missing directory
   }
   ```

### Debug Logging

```swift
// Enable debug logging
let logger = DevServerLogger(minimumLogLevel: .debug)
```

## Extending the DevServer

The DevServer is designed for extensibility:

### Custom Build Commands

```swift
// Multi-step builds
let config = DevServer.Configuration(
    buildCommand: "npm run build && swift build"
)

// Conditional builds
let config = DevServer.Configuration(
    buildCommand: "test -f package.json && npm run build || swift build"
)
```

### Custom File Extensions

```swift
// Watch additional file types
let watcher = FileWatcher(
    directory: "./",
    extensions: [".swift", ".html", ".css", ".js", ".json", ".md"]
)
```

### Custom Logging

```swift
// Custom logger configuration
let logger = DevServerLogger(
    minimumLogLevel: .info,
    includeTimestamp: true,
    useColors: true
)
```

## Contributing

The DevServer follows Swift best practices:

- Comprehensive error handling
- Async/await for concurrency
- Protocol-oriented design
- Unit test coverage
- Documentation comments
- Memory safety

### Testing Guidelines

- All public APIs have test coverage
- Error conditions are tested
- Platform-specific code has appropriate fallbacks
- Integration tests verify end-to-end functionality

## License

The DevServer is part of the WebUI framework and follows the same licensing terms.