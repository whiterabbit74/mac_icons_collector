//
//  Theme.swift
//  MenuBarIconManager
//

import Foundation

/// App theme options
enum Theme: String, CaseIterable, Codable {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
    
    /// Localized display name
    var displayName: String {
        switch self {
        case .light:
            return NSLocalizedString("Light", comment: "Light theme")
        case .dark:
            return NSLocalizedString("Dark", comment: "Dark theme")
        case .auto:
            return NSLocalizedString("Auto", comment: "Auto theme")
        }
    }
    
    /// Whether this theme should follow system appearance
    var followsSystem: Bool {
        return self == .auto
    }
}