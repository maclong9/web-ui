#!/bin/bash
set -euo pipefail

# WebUI CLI Installation Script
# Usage: curl -sSL https://raw.githubusercontent.com/maclong9/web-ui/main/install-cli.sh | bash

REPO="maclong9/web-ui"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="webui-cli"
VERSION="${1:-latest}"

echo "🚀 Installing WebUI CLI..."

# Detect OS and architecture
if [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
else
    echo "❌ Unsupported platform: $OSTYPE"
    echo "   WebUI CLI currently supports macOS only"
    exit 1
fi

# Get the latest release if version is 'latest'
if [ "$VERSION" = "latest" ]; then
    echo "🔍 Finding latest release..."
    VERSION=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    echo "   Latest version: $VERSION"
else
    echo "📌 Using specified version: $VERSION"
fi

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download the binary
DOWNLOAD_URL="https://github.com/$REPO/releases/download/$VERSION/webui-cli-$PLATFORM.tar.gz"
echo "📥 Downloading from: $DOWNLOAD_URL"

if curl -L -f -o "webui-cli-$PLATFORM.tar.gz" "$DOWNLOAD_URL"; then
    echo "✅ Download completed"
else
    echo "❌ Failed to download WebUI CLI"
    echo "   Check that version $VERSION exists: https://github.com/$REPO/releases"
    exit 1
fi

# Extract the binary
echo "📦 Extracting binary..."
tar -xzf "webui-cli-$PLATFORM.tar.gz"

# Make sure we have the binary
if [ ! -f "$BINARY_NAME" ]; then
    echo "❌ Binary not found in archive"
    exit 1
fi

# Make it executable
chmod +x "$BINARY_NAME"

# Test the binary
echo "🧪 Testing binary..."
if "./$BINARY_NAME" --version; then
    echo "✅ Binary test passed"
else
    echo "❌ Binary test failed"
    exit 1
fi

# Install to system PATH
echo "📍 Installing to $INSTALL_DIR..."
if [ -w "$INSTALL_DIR" ]; then
    cp "$BINARY_NAME" "$INSTALL_DIR/"
else
    echo "   Need sudo permissions for $INSTALL_DIR"
    sudo cp "$BINARY_NAME" "$INSTALL_DIR/"
fi

# Verify installation
echo "✅ Verifying installation..."
if command -v "$BINARY_NAME" >/dev/null 2>&1; then
    echo "🎉 WebUI CLI installed successfully!"
    echo ""
    echo "Version: $($BINARY_NAME --version)"
    echo "Location: $(which $BINARY_NAME)"
    echo ""
    echo "Get started:"
    echo "  $BINARY_NAME init MyProject"
    echo "  cd MyProject"  
    echo "  $BINARY_NAME build"
    echo "  $BINARY_NAME serve"
    echo ""
    echo "Documentation: https://github.com/$REPO/blob/main/CLI.md"
else
    echo "⚠️  Installation completed but $BINARY_NAME not found in PATH"
    echo "   You may need to restart your shell or check your PATH"
fi

# Cleanup
cd - >/dev/null
rm -rf "$TEMP_DIR"