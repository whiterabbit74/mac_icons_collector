//
//  AppSettings.swift
//  MenuBarIconManager
//

import Foundation
import Combine

class AppSettings: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isFirstLaunch: Bool = true
    @Published var launchAtLogin: Bool = false
    @Published var globalHotkey: String? = nil
    @Published var theme: Theme = .auto
    @Published var selectedIcon: String = "default"
    @Published var isMonochrome: Bool = false
    @Published var defaultCollapseWidth: Double = 200.0
    @Published var animationsEnabled: Bool = true
    @Published var animationDuration: Double = 0.2
    @Published var autoCollapseTimeout: Double = 0.0
    @Published var clickBehavior: ClickBehavior = .toggle
    @Published var syncDisplayProfiles: Bool = true
    
    // MARK: - Private Properties
    
    private let userDefaults = UserDefaults.standard
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Keys
    
    private enum Keys {
        static let isFirstLaunch = "isFirstLaunch"
        static let launchAtLogin = "launchAtLogin"
        static let globalHotkey = "globalHotkey"
        static let theme = "theme"
        static let selectedIcon = "selectedIcon"
        static let isMonochrome = "isMonochrome"
        static let defaultCollapseWidth = "defaultCollapseWidth"
        static let animationsEnabled = "animationsEnabled"
        static let animationDuration = "animationDuration"
        static let autoCollapseTimeout = "autoCollapseTimeout"
        static let clickBehavior = "clickBehavior"
        static let syncDisplayProfiles = "syncDisplayProfiles"
    }
    
    // MARK: - Initialization
    
    init() {
        loadSettings()
        setupObservers()
    }
    
    // MARK: - Public Methods
    
    func saveSettings() {
        userDefaults.set(isFirstLaunch, forKey: Keys.isFirstLaunch)
        userDefaults.set(launchAtLogin, forKey: Keys.launchAtLogin)
        userDefaults.set(globalHotkey, forKey: Keys.globalHotkey)
        userDefaults.set(theme.rawValue, forKey: Keys.theme)
        userDefaults.set(selectedIcon, forKey: Keys.selectedIcon)
        userDefaults.set(isMonochrome, forKey: Keys.isMonochrome)
        userDefaults.set(defaultCollapseWidth, forKey: Keys.defaultCollapseWidth)
        userDefaults.set(animationsEnabled, forKey: Keys.animationsEnabled)
        userDefaults.set(animationDuration, forKey: Keys.animationDuration)
        userDefaults.set(autoCollapseTimeout, forKey: Keys.autoCollapseTimeout)
        userDefaults.set(clickBehavior.rawValue, forKey: Keys.clickBehavior)
        userDefaults.set(syncDisplayProfiles, forKey: Keys.syncDisplayProfiles)
    }
    
    // MARK: - Private Methods
    
    private func loadSettings() {
        isFirstLaunch = userDefaults.bool(forKey: Keys.isFirstLaunch)
        launchAtLogin = userDefaults.bool(forKey: Keys.launchAtLogin)
        globalHotkey = userDefaults.string(forKey: Keys.globalHotkey)
        
        if let themeRaw = userDefaults.string(forKey: Keys.theme),
           let loadedTheme = Theme(rawValue: themeRaw) {
            theme = loadedTheme
        }
        
        let iconName = userDefaults.string(forKey: Keys.selectedIcon)
        selectedIcon = iconName?.isEmpty == false ? iconName! : "default"
        
        isMonochrome = userDefaults.bool(forKey: Keys.isMonochrome)
        
        let width = userDefaults.double(forKey: Keys.defaultCollapseWidth)
        defaultCollapseWidth = width > 0 ? width : 200.0
        
        animationsEnabled = userDefaults.object(forKey: Keys.animationsEnabled) == nil ? true : userDefaults.bool(forKey: Keys.animationsEnabled)
        
        let duration = userDefaults.double(forKey: Keys.animationDuration)
        animationDuration = duration > 0 ? duration : 0.2
        
        autoCollapseTimeout = userDefaults.double(forKey: Keys.autoCollapseTimeout)
        
        if let behaviorRaw = userDefaults.string(forKey: Keys.clickBehavior),
           let loadedBehavior = ClickBehavior(rawValue: behaviorRaw) {
            clickBehavior = loadedBehavior
        }
        
        syncDisplayProfiles = userDefaults.object(forKey: Keys.syncDisplayProfiles) == nil ? true : userDefaults.bool(forKey: Keys.syncDisplayProfiles)
    }
    
    private func setupObservers() {
        // Auto-save when any published property changes
        Publishers.CombineLatest4($isFirstLaunch, $launchAtLogin, $globalHotkey, $theme)
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] _, _, _, _ in
                self?.saveSettings()
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest4($selectedIcon, $isMonochrome, $defaultCollapseWidth, $animationsEnabled)
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] _, _, _, _ in
                self?.saveSettings()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Supporting Types

enum ClickBehavior: String, CaseIterable {
    case toggle = "toggle"
    case popover = "popover"
    
    var displayName: String {
        switch self {
        case .toggle:
            return NSLocalizedString("Toggle", comment: "Toggle behavior")
        case .popover:
            return NSLocalizedString("Show Popover", comment: "Popover behavior")
        }
    }
}

enum CollapseState: String, CaseIterable {
    case collapsed = "collapsed"
    case expanded = "expanded"
    
    var displayName: String {
        switch self {
        case .collapsed:
            return NSLocalizedString("Collapsed", comment: "Collapsed state")
        case .expanded:
            return NSLocalizedString("Expanded", comment: "Expanded state")
        }
    }
}