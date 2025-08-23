import Foundation

// Helper function to run shell commands
func shell(_ command: String) -> (output: String, stderr: String, exitCode: Int32) {
    let process = Process()
    let outputPipe = Pipe()
    let errorPipe = Pipe()

    process.standardOutput = outputPipe
    process.standardError = errorPipe
    process.launchPath = "/bin/bash"
    process.arguments = ["-c", command]

    process.launch()
    process.waitUntilExit()

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

    let output = String(data: outputData, encoding: .utf8) ?? ""
    let stderr = String(data: errorData, encoding: .utf8) ?? ""

    return (output: output, stderr: stderr, exitCode: process.terminationStatus)
}
