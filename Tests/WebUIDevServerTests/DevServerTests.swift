import XCTest
import Foundation
import Network
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import WebUIDevServer

final class DevServerTests: XCTestCase {
    
    func testDevServerInitialization() throws {
        // Test that DevServer can be initialized with default configuration
        let server = DevServer()
        XCTAssertNotNil(server)
    }
    
    func testDevServerCustomConfiguration() throws {
        // Test that DevServer can be initialized with custom configuration
        let config = DevServer.Configuration(
            port: 8080,
            buildDirectory: "./test-build",
            sourceDirectory: "./test-src",
            buildCommand: "echo 'test build'",
            autoOpenBrowser: false,
            host: "127.0.0.1",
            websocketPort: 8081
        )
        
        let server = DevServer(configuration: config)
        XCTAssertNotNil(server)
    }
    
    func testDevServerLogger() throws {
        // Test that DevServerLogger can be instantiated and used
        let logger = DevServerLogger()
        
        // These should not throw exceptions
        logger.info("Test info message")
        logger.debug("Test debug message")
        logger.warning("Test warning message")
        logger.error("Test error message")
        logger.success("Test success message")
        
        XCTAssertNotNil(logger)
    }
    
    func testFileWatcher() throws {
        // Test that FileWatcher can be instantiated
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("test-watch")
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        
        let watcher = FileWatcher(
            directory: tempDir.path,
            extensions: [".swift", ".txt"]
        )
        
        XCTAssertNotNil(watcher)
        
        // Clean up
        try FileManager.default.removeItem(at: tempDir)
    }
    
    func testBuildManager() throws {
        // Test that BuildManager can be instantiated
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("test-build")
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        
        let buildManager = BuildManager(
            buildCommand: "/bin/echo 'test build successful'",
            buildDirectory: tempDir.path,
            logger: DevServerLogger()
        )
        
        XCTAssertNotNil(buildManager)
        XCTAssertFalse(buildManager.isBuildInProgress)
        XCTAssertNil(buildManager.lastSuccessfulBuild)
        
        // Clean up
        try FileManager.default.removeItem(at: tempDir)
    }
    
    func testBuildManagerBuildOperation() async throws {
        // Test that BuildManager can perform a simple build
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("test-build-operation")
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        
        let buildManager = BuildManager(
            buildCommand: "/bin/echo 'build successful'",
            buildDirectory: tempDir.path,
            logger: DevServerLogger()
        )
        
        // This should succeed since 'echo' always returns 0
        try await buildManager.performBuild()
        
        XCTAssertFalse(buildManager.isBuildInProgress)
        XCTAssertNotNil(buildManager.lastSuccessfulBuild)
        
        // Clean up
        try FileManager.default.removeItem(at: tempDir)
    }
    
    func testBuildManagerFailedBuild() async throws {
        // Test that BuildManager handles failed builds properly
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("test-build-failure")
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        
        let buildManager = BuildManager(
            buildCommand: "/bin/bash -c 'exit 1'", // This will fail
            buildDirectory: tempDir.path,
            logger: DevServerLogger()
        )
        
        // This should throw a DevServerError.buildFailed
        do {
            try await buildManager.performBuild()
            XCTFail("Expected build to fail")
        } catch let error as DevServerError {
            switch error {
            case .buildFailed:
                // This is expected
                break
            default:
                XCTFail("Expected buildFailed error, got \(error)")
            }
        }
        
        XCTAssertFalse(buildManager.isBuildInProgress)
        XCTAssertNil(buildManager.lastSuccessfulBuild)
        
        // Clean up
        try FileManager.default.removeItem(at: tempDir)
    }
    
    func testHTTPServer() throws {
        // Test that HTTPServer can be instantiated
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("test-http")
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        
        let httpServer = HTTPServer(
            port: 0, // Use port 0 for testing to avoid conflicts
            host: "localhost",
            buildDirectory: tempDir.path,
            logger: DevServerLogger()
        )
        
        XCTAssertNotNil(httpServer)
        
        // Clean up
        try FileManager.default.removeItem(at: tempDir)
    }
    
    func testWebSocketServer() throws {
        // Test that WebSocketServer can be instantiated
        let wsServer = WebSocketServer(
            port: 0, // Use port 0 for testing to avoid conflicts
            host: "localhost",
            logger: DevServerLogger()
        )
        
        XCTAssertNotNil(wsServer)
    }
    
    func testDevServerErrorTypes() throws {
        // Test all DevServerError cases
        let portError = DevServerError.portInUse(8080)
        let buildError = DevServerError.buildFailed("Test build failure")
        let fileError = DevServerError.fileSystemError("Test file error")
        let networkError = DevServerError.networkError("Test network error")
        
        XCTAssertEqual(portError.errorDescription, "Port 8080 is already in use")
        XCTAssertEqual(buildError.errorDescription, "Build failed: Test build failure")
        XCTAssertEqual(fileError.errorDescription, "File system error: Test file error")
        XCTAssertEqual(networkError.errorDescription, "Network error: Test network error")
    }
    
    func testDevServerLoggerLogLevels() throws {
        // Test different log levels
        let logger = DevServerLogger(minimumLogLevel: .debug)
        
        // Test all log levels without crashing
        logger.debug("Debug message")
        logger.info("Info message")
        logger.warning("Warning message")
        logger.error("Error message")
        logger.success("Success message")
        
        XCTAssertNotNil(logger)
    }
    
    func testBuildManagerConfiguration() throws {
        // Test BuildManager.Configuration
        let config = BuildManager.BuildConfiguration(
            buildCommand: "swift build",
            buildDirectory: "./build",
            workingDirectory: "./",
            environment: ["PATH": "/usr/bin"],
            buildTimeout: 60.0
        )
        
        XCTAssertEqual(config.buildCommand, "swift build")
        XCTAssertEqual(config.buildDirectory, "./build")
        XCTAssertEqual(config.workingDirectory, "./")
        XCTAssertEqual(config.environment["PATH"], "/usr/bin")
        XCTAssertEqual(config.buildTimeout, 60.0)
    }
    
    func testFileWatcherWithCallback() throws {
        // Test FileWatcher with callback
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("test-watch-callback")
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        
        let watcher = FileWatcher(
            directory: tempDir.path,
            extensions: [".swift"]
        )
        
        watcher.onFileChanged = { files in
            XCTAssertFalse(files.isEmpty)
        }
        
        XCTAssertNotNil(watcher)
        XCTAssertNotNil(watcher.onFileChanged)
        
        // Clean up
        try FileManager.default.removeItem(at: tempDir)
    }
}