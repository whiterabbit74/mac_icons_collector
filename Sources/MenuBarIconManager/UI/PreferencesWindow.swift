//
//  PreferencesWindow.swift
//  MenuBarIconManager
//
//  Created by Droid on 2025-09-29.
//

import SwiftUI
import AppKit
import ServiceManagement

/// SwiftUI-based preferences window
struct PreferencesWindow: View {
    @ObservedObject var settings: AppSettings
    @ObservedObject var themeManager: ThemeManager
    @State private var selectedTab: PreferencesTab = .general
    
    var body: some View {
        TabView(selection: $selectedTab) {
            GeneralTab(settings: settings)
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(PreferencesTab.general)
            
            AppearanceTab(settings: settings, themeManager: themeManager)
                .tabItem {
                    Label("Appearance", systemImage: "paintbrush")
                }
                .tag(PreferencesTab.appearance)
            
            BehaviorTab(settings: settings)
                .tabItem {
                    Label("Behavior", systemImage: "slider.horizontal.3")
                }
                .tag(PreferencesTab.behavior)
            
            ShortcutsTab(settings: settings)
                .tabItem {
                    Label("Shortcuts", systemImage: "keyboard")
                }
                .tag(PreferencesTab.shortcuts)
        }
        .frame(width: 500, height: 400)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

enum PreferencesTab: String, CaseIterable {
    case general = "general"
    case appearance = "appearance"
    case behavior = "behavior"
    case shortcuts = "shortcuts"
}

// MARK: - General Tab
struct GeneralTab: View {
    @ObservedObject var settings: AppSettings
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Startup")
                    .font(.headline)
                
                Toggle("Launch at login", isOn: $settings.launchAtLogin)
                    .onChange(of: settings.launchAtLogin) { newValue in
                        updateLoginItem(enabled: newValue)
                    }
                
                Text("Automatically start Menu Bar Icon Manager when you log in.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Click Behavior")
                    .font(.headline)
                
                Picker("Click behavior", selection: $settings.clickBehavior) {
                    ForEach(ClickBehavior.allCases, id: \.self) { behavior in
                        Text(behavior.displayName).tag(behavior)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Text("Choose what happens when you click the menu bar icon.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func updateLoginItem(enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to update login item: \(error)")
            }
        }
    }
}

// MARK: - Appearance Tab
struct AppearanceTab: View {
    @ObservedObject var settings: AppSettings
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Theme")
                    .font(.headline)
                
                Picker("Theme", selection: $settings.theme) {
                    ForEach(Theme.allCases, id: \.self) { theme in
                        Text(theme.displayName).tag(theme)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Toggle("Use monochrome icon", isOn: $settings.isMonochrome)
                
                Text("Choose the appearance theme for the menu bar icon.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Icon Style")
                    .font(.headline)
                
                Picker("Selected icon", selection: $settings.selectedIcon) {
                    Text("Default Arrow").tag("default")
                    Text("Chevron Down").tag("chevron")
                    Text("Triangle").tag("triangle")
                    Text("Dots").tag("dots")
                }
                .pickerStyle(MenuPickerStyle())
                
                Text("Choose the icon style for the menu bar.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Behavior Tab
struct BehaviorTab: View {
    @ObservedObject var settings: AppSettings
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Collapse Width")
                    .font(.headline)
                
                HStack {
                    Text("Width:")
                    Slider(value: $settings.defaultCollapseWidth, in: 50...500, step: 10)
                    Text("\(Int(settings.defaultCollapseWidth))px")
                        .frame(width: 50, alignment: .trailing)
                }
                
                Button("Calibrate") {
                    // Trigger calibration mode
                }
                .buttonStyle(.borderedProminent)
                
                Text("Adjust how much space the collapsed state takes up.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Animation")
                    .font(.headline)
                
                Toggle("Enable animations", isOn: $settings.animationsEnabled)
                
                HStack {
                    Text("Duration:")
                    Slider(value: $settings.animationDuration, in: 0.1...1.0, step: 0.1)
                    Text("\(settings.animationDuration, specifier: "%.1f")s")
                        .frame(width: 50, alignment: .trailing)
                }
                .disabled(!settings.animationsEnabled)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Auto-Collapse")
                    .font(.headline)
                
                HStack {
                    Text("Timeout:")
                    Slider(value: $settings.autoCollapseTimeout, in: 0...30, step: 1)
                    Text(settings.autoCollapseTimeout == 0 ? "Off" : "\(Int(settings.autoCollapseTimeout))s")
                        .frame(width: 50, alignment: .trailing)
                }
                
                Text("Automatically collapse after expanding (0 = disabled).")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Shortcuts Tab
struct ShortcutsTab: View {
    @ObservedObject var settings: AppSettings
    @State private var isRecordingHotkey = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Global Hotkey")
                    .font(.headline)
                
                HStack {
                    Text("Toggle shortcut:")
                    
                    Button(settings.globalHotkey ?? "None") {
                        isRecordingHotkey.toggle()
                    }
                    .buttonStyle(.bordered)
                    .frame(minWidth: 120)
                    
                    if settings.globalHotkey != nil {
                        Button("Clear") {
                            settings.globalHotkey = nil
                        }
                        .buttonStyle(.borderless)
                    }
                }
                
                Text("Press the button above and then press the key combination you want to use.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Instructions")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("1.")
                        Text("Hold ⌘ (Command) and drag menu bar icons")
                    }
                    
                    HStack {
                        Text("2.")
                        Text("Position icons you want to hide to the RIGHT of our arrow")
                    }
                    
                    HStack {
                        Text("3.")
                        Text("Click our arrow to collapse/expand the hidden area")
                    }
                }
                .font(.system(.body, design: .rounded))
            }
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Preferences Window Controller
class PreferencesWindowController: NSWindowController {
    convenience init(settings: AppSettings, themeManager: ThemeManager) {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        window.title = "Menu Bar Icon Manager Preferences"
        window.center()
        window.setFrameAutosaveName("PreferencesWindow")
        
        let contentView = PreferencesWindow(settings: settings, themeManager: themeManager)
        window.contentView = NSHostingView(rootView: contentView)
        
        self.init(window: window)
    }
}