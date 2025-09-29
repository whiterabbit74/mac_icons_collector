# macOS Menu Bar Icon Manager

A powerful macOS utility for managing and organizing menu bar icons, built with Swift and AppKit.

## Features

- **Menu Bar Integration**: Lives entirely in the menu bar as a status item
- **Dynamic Icon Management**: Hide/show menu bar icons by controlling spacer width
- **Smooth Animations**: Configurable animation duration and timing
- **Simple Interface**: Click to toggle, right-click for menu
- **Apple Silicon Optimized**: Native arm64 performance

## System Requirements

- **macOS**: 13 Ventura and higher
- **CPU**: Apple Silicon (arm64, M-series)
- **Language**: Swift 5.9+

## Installation

### From Source

1. Clone this repository:
   ```bash
   git clone https://github.com/whiterabbit74/mac_icons_collector.git
   cd mac_icons_collector
   ```

2. Open the project in Xcode:
   ```bash
   open MenuBarIconManager/MenuBarIconManager.xcodeproj
   ```

3. Build and run (⌘R)

## How It Works

The app creates two status items in your menu bar:

1. **Toggle Button**: The visible icon you interact with
2. **Spacer**: An invisible element that controls width

When collapsed, the spacer expands to push icons to the right off-screen. When expanded, the spacer shrinks to 0 width, showing all icons.

## Usage

### Basic Operation

1. **Launch the app** - A new arrow icon appears in your menu bar
2. **Organize icons**: Hold `⌘ (Command)` and drag icons
   - Place icons you want to hide to the **RIGHT** of our toggle button
   - Place icons you want to keep visible to the **LEFT** of our toggle button
3. **Toggle**: Click our arrow icon to collapse/expand hidden icons

### Configuration

- **Right-click** the toggle button for context menu
- **Quit** the application from the context menu

## Development

### Project Structure

```
MenuBarIconManager/
├── MenuBarIconManager.xcodeproj
├── MenuBarIconManager/
│   ├── App/
│   │   └── AppDelegate.swift
│   ├── Core/
│   │   ├── StatusBarCoordinator.swift
│   │   ├── SpacerController.swift
│   │   ├── ThemeManager.swift
│   │   └── HotkeyManager.swift
│   ├── Models/
│   │   ├── AppSettings.swift
│   │   └── Theme.swift
│   └── Resources/
│       └── Assets.xcassets
```

### Key Components

- **AppDelegate**: Application lifecycle and coordination
- **StatusBarCoordinator**: Manages NSStatusItems and user interactions
- **SpacerController**: Handles width animations and state management
- **ThemeManager**: Manages appearance and icon rendering
- **HotkeyManager**: Global keyboard shortcut handling
- **AppSettings**: Centralized configuration with automatic persistence

### Building

```bash
# Development build
xcodebuild -project MenuBarIconManager.xcodeproj \
           -scheme MenuBarIconManager \
           -configuration Debug \
           build

# Release build
xcodebuild -project MenuBarIconManager.xcodeproj \
           -scheme MenuBarIconManager \
           -configuration Release \
           build
```

## License

Copyright © 2025 Menu Bar Icon Manager. All rights reserved.

## Technical Specification

This implementation is based on the detailed technical specification found in [`tz.txt`](./tz.txt) (in Russian), which outlines the complete feature set, architecture, and requirements for the Menu Bar Icon Manager utility.

## Credits

- Built with ❤️ using Swift and AppKit
- AI-assisted development by Droid
- Icons created programmatically with Core Graphics