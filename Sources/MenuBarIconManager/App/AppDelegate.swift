//
//  AppDelegate.swift
//  MenuBarIconManager
//
//  Created by Droid on 2025-09-29.
//  Copyright © 2025 Menu Bar Icon Manager. All rights reserved.
//

import Cocoa
import ServiceManagement
import OSLog

class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: - Properties
    
    /// App settings manager
    private var settings: AppSettings!
    
    /// Theme manager
    private var themeManager: ThemeManager!
    
    /// Status bar coordinator
    private var statusBarCoordinator: StatusBarCoordinator!
    
    /// Hotkey manager
    private var hotkeyManager: HotkeyManager!
    
    /// Logger
    private let logger = Logger(subsystem: "com.menubar.iconmanager", category: "AppDelegate")
    
    // MARK: - App Lifecycle
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        logger.info("Application did finish launching")
        
        // Initialize core components
        setupCoreComponents()
        
        // Setup login item if requested
        setupLoginItem()
        
        // Setup global hotkey if configured
        setupGlobalHotkey()
        
        // Show onboarding if first launch
        if settings.isFirstLaunch {
            showOnboarding()
            settings.isFirstLaunch = false
        }
        
        logger.info("Application initialization completed")
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        logger.info("Application will terminate")
        
        // Clean up resources
        statusBarCoordinator?.tearDown()
        hotkeyManager?.unregisterAllHotkeys()
        
        // Save final settings
        settings?.saveSettings()
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // Show preferences when app is reopened
        if !flag {
            showPreferences()
        }
        return true
    }
    
    // MARK: - Setup Methods
    
    private func setupCoreComponents() {
        // Initialize settings first
        settings = AppSettings()
        
        // Initialize theme manager
        themeManager = ThemeManager(settings: settings)
        
        // Initialize status bar coordinator
        statusBarCoordinator = StatusBarCoordinator(settings: settings, themeManager: themeManager)
        
        // Initialize hotkey manager
        hotkeyManager = HotkeyManager()
        
        logger.info("Core components initialized")
    }
    
    private func setupLoginItem() {
        guard settings.launchAtLogin else { return }
        
        do {
            if #available(macOS 13.0, *) {
                try SMAppService.mainApp.register()
                logger.info("Login item registered successfully")
            } else {
                logger.warning("Login item registration not supported on this macOS version")
            }
        } catch {
            logger.error("Failed to register login item: \(error.localizedDescription)")
        }
    }
    
    private func setupGlobalHotkey() {
        guard let hotkey = settings.globalHotkey,
              !hotkey.isEmpty else { return }
        
        let success = hotkeyManager.registerHotkey(hotkey) { [weak self] in
            self?.handleGlobalHotkeyPressed()
        }
        
        if success {
            logger.info("Global hotkey registered: \(hotkey)")
        } else {
            logger.error("Failed to register global hotkey: \(hotkey)")
        }
    }
    
    // MARK: - Action Handlers
    
    private func handleGlobalHotkeyPressed() {
        logger.debug("Global hotkey pressed")
        statusBarCoordinator?.spacerController.toggle()
    }
    
    private func showPreferences() {
        logger.debug("Showing preferences")
        print("Preferences window not yet implemented")
    }
    
    private func showOnboarding() {
        logger.debug("Showing onboarding")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let alert = NSAlert()
            alert.messageText = NSLocalizedString("Welcome to Menu Bar Icon Manager!", comment: "Onboarding title")
            alert.informativeText = NSLocalizedString("To organize your menu bar icons:\n\n1. Hold ⌘ (Command) and drag icons\n2. Position icons you want to hide to the RIGHT of our arrow\n3. Click our arrow to collapse/expand\n\nYou can configure settings by right-clicking our icon.", comment: "Onboarding message")
            alert.alertStyle = .informational
            alert.addButton(withTitle: NSLocalizedString("Got it!", comment: "Onboarding button"))
            alert.runModal()
        }
    }
    
    @objc func showAbout() {
        NSApp.orderFrontStandardAboutPanel(nil)
    }
    
    @objc func quitApplication() {
        NSApp.terminate(nil)
    }
}

// MARK: - Extensions

extension AppDelegate {
    
    /// Get the current app version
    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    }
    
    /// Get the current build number
    static var buildNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }
    
    /// Get the app name
    static var appName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "Menu Bar Icon Manager"
    }
}