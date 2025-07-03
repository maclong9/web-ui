import Foundation

/// Manages build operations for the development server.
///
/// `BuildManager` handles the execution of build commands and manages
/// the build output directory:
/// - Executes Swift build commands
/// - Captures build output and errors
/// - Manages build artifacts and cleanup
/// - Provides build status reporting
/// - Optimizes build performance with incremental builds
///
/// ## Usage
///
/// ```swift
/// let buildManager = BuildManager(
///     buildCommand: "swift run MyApp",
///     buildDirectory: "./build"
/// )
/// 
/// try await buildManager.performBuild()
/// ```
public final class BuildManager: @unchecked Sendable {
    
    /// Configuration for build operations
    public struct BuildConfiguration: Sendable {
        /// Command to execute for building the project
        public let buildCommand: String
        /// Directory where build output will be placed
        public let buildDirectory: String
        /// Working directory for build execution
        public let workingDirectory: String
        /// Environment variables for build process
        public let environment: [String: String]
        /// Timeout for build operations (in seconds)
        public let buildTimeout: TimeInterval
        
        public init(
            buildCommand: String,
            buildDirectory: String,
            workingDirectory: String = FileManager.default.currentDirectoryPath,
            environment: [String: String] = ProcessInfo.processInfo.environment,
            buildTimeout: TimeInterval = 300
        ) {
            self.buildCommand = buildCommand
            self.buildDirectory = buildDirectory
            self.workingDirectory = workingDirectory
            self.environment = environment
            self.buildTimeout = buildTimeout
        }
    }
    
    private let configuration: BuildConfiguration
    private let logger: DevServerLogger
    private let lock = NSLock()
    private var isBuilding = false
    private var lastBuildTime: Date?
    
    /// Creates a new build manager with the specified configuration.
    ///
    /// - Parameters:
    ///   - buildCommand: Command to execute for building
    ///   - buildDirectory: Directory for build output
    ///   - logger: Logger instance for build output
    public convenience init(
        buildCommand: String,
        buildDirectory: String,
        logger: DevServerLogger
    ) {
        let config = BuildConfiguration(
            buildCommand: buildCommand,
            buildDirectory: buildDirectory
        )
        self.init(configuration: config, logger: logger)
    }
    
    /// Creates a new build manager with detailed configuration.
    ///
    /// - Parameters:
    ///   - configuration: Complete build configuration
    ///   - logger: Logger instance for build output
    public init(
        configuration: BuildConfiguration,
        logger: DevServerLogger
    ) {
        self.configuration = configuration
        self.logger = logger
    }
    
    /// Performs a complete build of the project.
    ///
    /// This method will:
    /// 1. Check if a build is already in progress
    /// 2. Execute the build command
    /// 3. Capture and log build output
    /// 4. Handle build success or failure
    /// 5. Update build status and timing
    ///
    /// - Throws: `DevServerError.buildFailed` if the build fails
    public func performBuild() async throws {
        // Prevent concurrent builds
        guard !lock.withLock({ isBuilding }) else {
            logger.warning("Build already in progress, skipping...")
            return
        }
        
        lock.withLock { isBuilding = true }
        defer { lock.withLock { isBuilding = false } }
        
        let startTime = Date()
        logger.info("Starting build...")
        
        do {
            // Ensure build directory exists
            try createBuildDirectoryIfNeeded()
            
            // Execute the build command
            let result = try await executeBuildCommand()
            
            // Handle build result
            if result.exitCode == 0 {
                let duration = Date().timeIntervalSince(startTime)
                logger.success("Build completed successfully in \(String(format: "%.2f", duration))s")
                lock.withLock { lastBuildTime = Date() }
            } else {
                let errorMessage = result.stderr.isEmpty ? result.stdout : result.stderr
                logger.error("Build failed with exit code \(result.exitCode)")
                if !errorMessage.isEmpty {
                    logger.error("Build output:\n\(errorMessage)")
                }
                throw DevServerError.buildFailed(errorMessage)
            }
            
        } catch let error as DevServerError {
            throw error
        } catch {
            logger.error("Build error: \(error.localizedDescription)")
            throw DevServerError.buildFailed(error.localizedDescription)
        }
    }
    
    /// Returns whether a build is currently in progress.
    public var isBuildInProgress: Bool {
        return lock.withLock { isBuilding }
    }
    
    /// Returns the timestamp of the last successful build.
    public var lastSuccessfulBuild: Date? {
        return lock.withLock { lastBuildTime }
    }
    
    // MARK: - Private Methods
    
    private func createBuildDirectoryIfNeeded() throws {
        let buildURL = URL(fileURLWithPath: configuration.buildDirectory)
        
        if !FileManager.default.fileExists(atPath: buildURL.path) {
            try FileManager.default.createDirectory(
                at: buildURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
            logger.info("Created build directory: \(configuration.buildDirectory)")
        }
    }
    
    private func executeBuildCommand() async throws -> ProcessResult {
        return try await withCheckedThrowingContinuation { continuation in
            let process = Process()
            let stdoutPipe = Pipe()
            let stderrPipe = Pipe()
            
            // Configure process
            process.currentDirectoryPath = configuration.workingDirectory
            process.environment = configuration.environment
            process.standardOutput = stdoutPipe
            process.standardError = stderrPipe
            
            // Parse command and arguments
            let components = parseCommand(configuration.buildCommand)
            guard !components.isEmpty else {
                continuation.resume(throwing: DevServerError.buildFailed("Invalid build command"))
                return
            }
            
            process.executableURL = URL(fileURLWithPath: components[0])
            if components.count > 1 {
                process.arguments = Array(components.dropFirst())
            }
            
            // Setup termination handler
            process.terminationHandler = { process in
                let stdout = String(data: stdoutPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
                let stderr = String(data: stderrPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
                
                let result = ProcessResult(
                    exitCode: Int(process.terminationStatus),
                    stdout: stdout,
                    stderr: stderr
                )
                
                continuation.resume(returning: result)
            }
            
            // Start the process
            do {
                try process.run()
                
                // Setup timeout
                DispatchQueue.global().asyncAfter(deadline: .now() + configuration.buildTimeout) {
                    if process.isRunning {
                        process.terminate()
                        continuation.resume(throwing: DevServerError.buildFailed("Build timed out after \(self.configuration.buildTimeout) seconds"))
                    }
                }
                
            } catch {
                continuation.resume(throwing: DevServerError.buildFailed("Failed to start build process: \(error.localizedDescription)"))
            }
        }
    }
    
    private func parseCommand(_ command: String) -> [String] {
        // Simple command parsing - handles quoted arguments
        var components: [String] = []
        var currentComponent = ""
        var inQuotes = false
        var escapeNext = false
        
        for char in command {
            if escapeNext {
                currentComponent.append(char)
                escapeNext = false
            } else if char == "\\" {
                escapeNext = true
            } else if char == "\"" {
                inQuotes.toggle()
            } else if char == " " && !inQuotes {
                if !currentComponent.isEmpty {
                    components.append(currentComponent)
                    currentComponent = ""
                }
            } else {
                currentComponent.append(char)
            }
        }
        
        if !currentComponent.isEmpty {
            components.append(currentComponent)
        }
        
        return components
    }
}

// MARK: - Process Result

private struct ProcessResult {
    let exitCode: Int
    let stdout: String
    let stderr: String
}

