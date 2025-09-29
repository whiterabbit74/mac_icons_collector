# Menu Bar Icon Manager - Build Instructions

## Swift Package Manager Build

This project is structured as a Swift Package that can be built using the `swift build` command.

### Prerequisites

- macOS 13.0 (Ventura) or later
- Xcode 15.0 or later (or Xcode Command Line Tools)
- Swift 5.9 or later
- Apple Silicon (M-series) CPU (recommended, built for arm64)

### Building the Application

1. **Clone or download the repository:**
   ```bash
   git clone <repository-url>
   cd mac_icons_collector
   ```

2. **Build the application using Swift Package Manager:**
   ```bash
   swift build --configuration release
   ```

3. **The built executable will be located at:**
   ```
   .build/release/MenuBarIconManager
   ```

4. **Run the application:**
   ```bash
   .build/release/MenuBarIconManager
   ```

### Development Build

For development builds:
```bash
swift build
# Executable will be at: .build/debug/MenuBarIconManager
```

### Testing

Run the test suite:
```bash
swift test
```

### Creating an App Bundle (Optional)

While the executable can run directly, you may want to create a proper .app bundle for distribution:

```bash
# Create app bundle structure
mkdir -p MenuBarIconManager.app/Contents/MacOS
mkdir -p MenuBarIconManager.app/Contents/Resources

# Copy executable
cp .build/release/MenuBarIconManager MenuBarIconManager.app/Contents/MacOS/

# Copy Info.plist
cp Sources/MenuBarIconManager/Resources/Info.plist MenuBarIconManager.app/Contents/

# Copy resources
cp -r Sources/MenuBarIconManager/Resources/* MenuBarIconManager.app/Contents/Resources/
```

### Features Implemented

- ✅ Menu bar status item management
- ✅ Dynamic spacer for hiding/showing icons
- ✅ Theme support (light/dark/auto)
- ✅ Global hotkey support (basic implementation)
- ✅ Settings persistence with UserDefaults
- ✅ Login item support (SMAppService)
- ✅ Localization (English/Russian)
- ✅ Smooth animations
- ⏳ Preferences UI (planned)

### Architecture

- **AppDelegate**: Main application coordinator
- **StatusBarCoordinator**: Manages menu bar items
- **SpacerController**: Controls the invisible spacer width
- **ThemeManager**: Handles appearance themes
- **HotkeyManager**: Global keyboard shortcuts
- **AppSettings**: Persistent configuration

### Notes

- The app runs as a menu bar only application (LSUIElement = true)
- Requires macOS 13+ for SMAppService login item support
- Built for Apple Silicon but should work on Intel Macs
- Uses AppKit for UI and Combine for reactive programming