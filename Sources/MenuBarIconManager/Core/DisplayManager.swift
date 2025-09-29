//
//  DisplayManager.swift
//  MenuBarIconManager
//
//  Created by Droid on 2025-09-29.
//

import AppKit
import Combine

/// Manages multi-display configuration and settings
class DisplayManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var currentDisplays: [DisplayInfo] = []
    @Published var activeDisplay: DisplayInfo?
    
    // MARK: - Private Properties
    
    private let settings: AppSettings
    private var displayObserver: Any?
    
    // MARK: - Initialization
    
    init(settings: AppSettings) {
        self.settings = settings
        updateDisplays()
        setupDisplayObserver()
    }
    
    deinit {
        if let observer = displayObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // MARK: - Public Methods
    
    /// Get collapse width for a specific display
    func getCollapseWidth(for display: DisplayInfo) -> Double {
        let key = "collapseWidth_\(display.id)"
        let width = UserDefaults.standard.double(forKey: key)
        return width > 0 ? width : settings.defaultCollapseWidth
    }
    
    /// Set collapse width for a specific display
    func setCollapseWidth(_ width: Double, for display: DisplayInfo) {
        let key = "collapseWidth_\(display.id)"
        UserDefaults.standard.set(width, forKey: key)
        
        // If syncing is enabled, update all displays
        if settings.syncDisplayProfiles {
            syncCollapseWidthToAllDisplays(width)
        }
    }
    
    /// Get the current display info
    func getCurrentDisplay() -> DisplayInfo? {
        guard let mainScreen = NSScreen.main else { return nil }
        return currentDisplays.first { $0.screen === mainScreen }
    }
    
    // MARK: - Private Methods
    
    private func updateDisplays() {
        currentDisplays = NSScreen.screens.map { screen in
            DisplayInfo(
                id: screen.displayID,
                name: screen.localizedName,
                frame: screen.frame,
                screen: screen
            )
        }
        
        activeDisplay = getCurrentDisplay()
    }
    
    private func setupDisplayObserver() {
        displayObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateDisplays()
        }
    }
    
    private func syncCollapseWidthToAllDisplays(_ width: Double) {
        for display in currentDisplays {
            let key = "collapseWidth_\(display.id)"
            UserDefaults.standard.set(width, forKey: key)
        }
    }
}

// MARK: - Display Info

struct DisplayInfo: Identifiable, Equatable {
    let id: CGDirectDisplayID
    let name: String
    let frame: CGRect
    weak var screen: NSScreen?
    
    static func == (lhs: DisplayInfo, rhs: DisplayInfo) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - NSScreen Extensions

extension NSScreen {
    
    /// Get display ID for the screen
    var displayID: CGDirectDisplayID {
        return deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID ?? 0
    }
}