# WebUI CLI Tool

The WebUI CLI provides a fast, optimized way to build WebUI projects without needing to install Swift or build the entire WebUI library from source.

## Features

- **Fast builds**: Skip Swift toolchain installation and library compilation
- **Cross-project compatibility**: Works with any WebUI project
- **Development server**: Built-in local server with optional file watching
- **Project scaffolding**: Quickly initialize new WebUI projects

## Installation

### From GitHub Releases (Recommended)

Download the latest prebuilt binary:

```bash
# Download and extract
curl -L -o webui-cli-macos.tar.gz \
  "https://github.com/maclong9/web-ui/releases/latest/download/webui-cli-macos.tar.gz"
tar -xzf webui-cli-macos.tar.gz

# Make executable and move to PATH
chmod +x webui-cli
sudo mv webui-cli /usr/local/bin/

# Verify installation
webui-cli --version
```

### From Source

```bash
cd ~/Developer/personal/tooling/web-ui
swift build -c release --product webui-cli
cp .build/release/webui-cli /usr/local/bin/webui-cli
```

## Usage

### Build a Static Site

```bash
# Build in current directory
webui-cli build

# Build with custom paths
webui-cli build --project-path ./my-project --output-directory ./dist

# Verbose output
webui-cli build --verbose
```

### Serve Locally

```bash
# Serve the generated site
webui-cli serve

# Custom port and path
webui-cli serve --path ./dist --port 3000
```

### Initialize New Project

```bash
# Create a new project
webui-cli init MyWebsite

# Navigate and build
cd MyWebsite
webui-cli build
webui-cli serve
```

## CI/CD Integration

### Optimized GitHub Workflow

Use the optimized WebUI workflow in your project:

```yaml
# .github/workflows/build.yml
name: Build Static Site

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    uses: maclong9/web-ui/.github/workflows/build-optimized.yml@main
    with:
      webui-cli-version: 'latest'
      output-directory: '.output'
      static-branch: 'static'
```

### Performance Comparison

| Method | Time | Cache Benefits |
|--------|------|---------------|
| **Traditional Swift Build** | ~8-10 minutes | Limited caching |
| **WebUI CLI (Optimized)** | ~2-3 minutes | Full CLI binary caching |

**Time savings: ~70-80% reduction**

### Custom Build Commands

```yaml
jobs:
  build:
    uses: maclong9/web-ui/.github/workflows/build-optimized.yml@main
    with:
      webui-cli-version: 'v1.2.0'  # Pin to specific version
      build-command: 'webui-cli build --executable MyApp --verbose'
      output-directory: './public'
```

## CLI Commands Reference

### `webui-cli build`

Build a static site from a WebUI Swift project.

**Options:**
- `--project-path <path>` - Swift project directory (default: `.`)
- `--output-directory <dir>` - Output directory (default: `.output`)
- `--executable <name>` - Swift executable name (default: `Application`)
- `--verbose` - Enable verbose logging

**Examples:**
```bash
webui-cli build
webui-cli build --project-path ../my-site --output-directory ./public
webui-cli build --executable PortfolioApp --verbose
```

### `webui-cli serve`

Serve the generated site locally for development.

**Options:**
- `--path <path>` - Directory to serve (default: `.output`)
- `--port <number>` - Port to serve on (default: `8080`)
- `--watch` - Enable auto-rebuild on file changes (coming soon)

**Examples:**
```bash
webui-cli serve
webui-cli serve --path ./public --port 3000
```

### `webui-cli init`

Initialize a new WebUI project.

**Arguments:**
- `<name>` - Project name (required)

**Options:**
- `--verbose` - Enable verbose logging

**Examples:**
```bash
webui-cli init MyBlog
webui-cli init "My Portfolio Site" --verbose
```

## Development

### Building from Source

```bash
# Clone the repository
git clone https://github.com/maclong9/web-ui.git
cd web-ui

# Build the CLI
swift build --product webui-cli

# Run locally
./.build/debug/webui-cli --help
```

### Testing

```bash
# Run CLI tests
swift test --filter WebUICLITests

# Manual testing
./.build/debug/webui-cli init TestProject
cd TestProject
../.build/debug/webui-cli build --verbose
```

## Troubleshooting

### CLI Not Found

If you get "command not found", ensure the binary is in your PATH:

```bash
which webui-cli
echo $PATH
```

### Build Failures

Check that your project has a valid `Package.swift` and the executable target exists:

```bash
swift package describe
swift build --show-dependencies
```

### Permission Denied

Make sure the CLI binary is executable:

```bash
chmod +x /usr/local/bin/webui-cli
```

### Python Server Issues

The `serve` command requires Python. Install it if missing:

```bash
# macOS
brew install python3

# Check installation
python3 --version
```

## Releases

New CLI versions are automatically built and released when WebUI is tagged:

- **Latest stable**: Always use `latest` in CI/CD
- **Specific versions**: Pin to exact versions for reproducible builds
- **Pre-releases**: Beta, alpha, and RC versions available

View all releases: https://github.com/maclong9/web-ui/releases