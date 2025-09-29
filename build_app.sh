#!/bin/bash

# Menu Bar Icon Manager Build Script
# This script builds the Swift package and creates a proper macOS app bundle

set -e

echo "🚀 Building Menu Bar Icon Manager..."

# Check if Swift is available
if ! command -v swift &> /dev/null; then
    echo "❌ Swift not found. Please install Xcode Command Line Tools:"
    echo "   xcode-select --install"
    exit 1
fi

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script must be run on macOS"
    exit 1
fi

# Build configuration (default: release)
BUILD_CONFIG=${1:-release}
APP_NAME="MenuBarIconManager"
BUILD_DIR=".build"
EXECUTABLE_PATH="$BUILD_DIR/$BUILD_CONFIG/$APP_NAME"
BUNDLE_DIR="$APP_NAME.app"

echo "📦 Building Swift package (configuration: $BUILD_CONFIG)..."

# Clean previous builds
rm -rf "$BUILD_DIR"
rm -rf "$BUNDLE_DIR"

# Build the Swift package
swift build --configuration $BUILD_CONFIG

# Check if build was successful
if [ ! -f "$EXECUTABLE_PATH" ]; then
    echo "❌ Build failed: executable not found at $EXECUTABLE_PATH"
    exit 1
fi

echo "✅ Swift package built successfully"

echo "🏗️  Creating app bundle..."

# Create app bundle structure
mkdir -p "$BUNDLE_DIR/Contents/MacOS"
mkdir -p "$BUNDLE_DIR/Contents/Resources"

# Copy executable
cp "$EXECUTABLE_PATH" "$BUNDLE_DIR/Contents/MacOS/$APP_NAME"

# Copy Info.plist
cp "Sources/$APP_NAME/Resources/Info.plist" "$BUNDLE_DIR/Contents/"

# Copy localization resources
cp -r "Sources/$APP_NAME/Resources/"* "$BUNDLE_DIR/Contents/Resources/"

# Remove the Info.plist from Resources (it's now in Contents/)
rm -f "$BUNDLE_DIR/Contents/Resources/Info.plist"

# Make executable
chmod +x "$BUNDLE_DIR/Contents/MacOS/$APP_NAME"

echo "✅ App bundle created: $BUNDLE_DIR"

# Optional: Code signing (if developer certificate is available)
if command -v codesign &> /dev/null; then
    echo "🔐 Attempting to code sign..."
    if codesign --sign - "$BUNDLE_DIR" 2>/dev/null; then
        echo "✅ Code signed successfully"
    else
        echo "⚠️  Code signing failed (no developer certificate found)"
    fi
fi

# Display bundle information
echo "📋 Bundle information:"
echo "   Location: $(pwd)/$BUNDLE_DIR"
echo "   Size: $(du -sh "$BUNDLE_DIR" | cut -f1)"
echo "   Architecture: $(file "$BUNDLE_DIR/Contents/MacOS/$APP_NAME" | cut -d: -f2-)"

# Verify bundle structure
echo "📁 Bundle structure:"
find "$BUNDLE_DIR" -type f | head -20

echo ""
echo "🎉 Build completed successfully!"
echo ""
echo "To run the app:"
echo "   open $BUNDLE_DIR"
echo ""
echo "To run from command line:"
echo "   ./$BUNDLE_DIR/Contents/MacOS/$APP_NAME"
echo ""
echo "To build only the Swift package:"
echo "   swift build --configuration $BUILD_CONFIG"
echo "   ./.build/$BUILD_CONFIG/$APP_NAME"