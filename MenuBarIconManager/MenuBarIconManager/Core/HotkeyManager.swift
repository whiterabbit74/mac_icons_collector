//
//  HotkeyManager.swift
//  MenuBarIconManager
//

import Foundation
import AppKit

/// Manager for global keyboard shortcuts
class HotkeyManager: ObservableObject {
    
    // MARK: - Properties
    
    /// Registered hotkeys with their actions
    private var registeredHotkeys: [String: () -> Void] = [:]
    
    // MARK: - Initialization
    
    init() {
        // Basic initialization
    }
    
    deinit {
        unregisterAllHotkeys()
    }
    
    // MARK: - Public Methods
    
    /// Register a global hotkey
    /// - Parameters:
    ///   - keyCombo: Key combination string (e.g., "⌃⌘Space", "⌥⌘H")
    ///   - action: Action to perform when hotkey is pressed
    /// - Returns: Success status
    func registerHotkey(_ keyCombo: String, action: @escaping () -> Void) -> Bool {
        // Store the action for now (simplified implementation)
        registeredHotkeys[keyCombo] = action
        print("Registered hotkey: \(keyCombo)")
        return true
    }
    
    /// Unregister a specific hotkey
    /// - Parameter keyCombo: Key combination to unregister
    func unregisterHotkey(_ keyCombo: String) {
        registeredHotkeys.removeValue(forKey: keyCombo)
        print("Unregistered hotkey: \(keyCombo)")
    }
    
    /// Unregister all hotkeys
    func unregisterAllHotkeys() {
        registeredHotkeys.removeAll()
        print("Unregistered all hotkeys")
    }
    
    /// Get list of currently registered hotkey combinations
    var registeredCombinations: [String] {
        return Array(registeredHotkeys.keys)
    }
    
    /// Check if a hotkey combination is available
    /// - Parameter keyCombo: Key combination to check
    /// - Returns: Whether the combination is available
    func isHotkeyAvailable(_ keyCombo: String) -> Bool {
        return !registeredHotkeys.keys.contains(keyCombo)
    }
}