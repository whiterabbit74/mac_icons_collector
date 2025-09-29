//
//  StatusBarCoordinator.swift  
//  MenuBarIconManager
//

import Foundation
import AppKit
import Combine

/// Central coordinator for managing menu bar status items
class StatusBarCoordinator: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    /// Toggle status item (the visible icon users interact with)
    private var toggleItem: NSStatusItem?
    
    /// Spacer status item (invisible, controls width)
    private var spacerItem: NSStatusItem?
    
    /// Spacer controller for managing animations and state
    private let spacerController: SpacerController
    
    /// Theme manager for handling appearance
    private let themeManager: ThemeManager
    
    /// App settings reference
    private let settings: AppSettings
    
    /// Combine cancellables
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(settings: AppSettings, themeManager: ThemeManager) {
        self.settings = settings
        self.themeManager = themeManager
        self.spacerController = SpacerController(settings: settings)
        
        super.init()
        
        setupStatusItems()
        setupObservers()
    }
    
    deinit {
        tearDown()
    }
    
    // MARK: - Public Methods
    
    /// Setup the status bar items
    func setupStatusItems() {
        createToggleItem()
        createSpacerItem()
        updateToggleIcon()
    }
    
    /// Clean up status bar items
    func tearDown() {
        if let toggle = toggleItem {
            NSStatusBar.system.removeStatusItem(toggle)
        }
        if let spacer = spacerItem {
            NSStatusBar.system.removeStatusItem(spacer)
        }
        toggleItem = nil
        spacerItem = nil
    }
    
    /// Update the toggle icon based on current state and theme
    func updateToggleIcon() {
        guard let button = toggleItem?.button else { return }
        
        // Create simple arrow icon
        let icon = createArrowIcon()
        button.image = icon
        button.imagePosition = .imageOnly
        
        // Update accessibility
        button.toolTip = getTooltipText()
    }
    
    /// Handle toggle button click
    @objc func handleToggleClick() {
        spacerController.toggle()
    }
    
    /// Handle right-click on toggle button
    @objc func handleRightClick() {
        showContextMenu()
    }
    
    // MARK: - Private Methods
    
    private func createToggleItem() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        guard let button = item.button else {
            fatalError("Failed to create status item button")
        }
        
        // Configure button
        button.target = self
        button.action = #selector(handleToggleClick)
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        
        // Accessibility
        button.accessibilityIdentifier = "MenuBarToggle"
        
        self.toggleItem = item
    }
    
    private func createSpacerItem() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        // Create a custom view for the spacer
        let spacerView = SpacerView()
        spacerView.frame = NSRect(x: 0, y: 0, width: 0, height: 24)
        item.view = spacerView
        
        self.spacerItem = item
    }
    
    private func setupObservers() {
        // Listen to spacer controller state changes
        spacerController.$currentState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateToggleIcon()
            }
            .store(in: &cancellables)
    }
    
    private func getTooltipText() -> String {
        let stateName = spacerController.currentState.displayName
        let actionName = spacerController.currentState == .collapsed ? 
                        NSLocalizedString("Expand", comment: "Expand action") :
                        NSLocalizedString("Collapse", comment: "Collapse action")
        
        return String(format: NSLocalizedString("Menu Bar Icon Manager - %@ (Click to %@)", 
                                              comment: "Tooltip format"), 
                     stateName, actionName)
    }
    
    private func createArrowIcon() -> NSImage {
        let size = NSSize(width: 16, height: 16)
        let image = NSImage(size: size)
        
        image.lockFocus()
        
        let color = NSColor.controlTextColor
        color.setFill()
        
        let path = NSBezierPath()
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        // Simple down arrow
        path.move(to: CGPoint(x: center.x - 4, y: center.y + 2))
        path.line(to: CGPoint(x: center.x, y: center.y - 2))
        path.line(to: CGPoint(x: center.x + 4, y: center.y + 2))
        
        path.lineWidth = 2.0
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.stroke()
        
        image.unlockFocus()
        image.isTemplate = true
        
        return image
    }
    
    private func showContextMenu() {
        let menu = NSMenu()
        
        // Toggle state item
        let stateText = spacerController.currentState == .collapsed ? 
                       NSLocalizedString("Expand", comment: "Expand menu item") :
                       NSLocalizedString("Collapse", comment: "Collapse menu item")
        
        let toggleMenuItem = NSMenuItem(title: stateText, action: #selector(menuToggleClicked), keyEquivalent: "")
        toggleMenuItem.target = self
        menu.addItem(toggleMenuItem)
        
        menu.addItem(.separator())
        
        // Quit
        let quitMenuItem = NSMenuItem(title: NSLocalizedString("Quit", comment: "Quit menu item"), 
                                    action: #selector(menuQuitClicked), 
                                    keyEquivalent: "q")
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)
        
        // Show menu
        if let button = toggleItem?.button {
            menu.popUp(positioning: nil, at: NSPoint(x: 0, y: button.bounds.height), in: button)
        }
    }
    
    // MARK: - Menu Actions
    
    @objc private func menuToggleClicked() {
        spacerController.toggle()
    }
    
    @objc private func menuQuitClicked() {
        NSApp.terminate(nil)
    }
}

// MARK: - Custom Spacer View

/// Custom view for the spacer status item
private class SpacerView: NSView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Make the view invisible but still occupy space
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
    }
    
    override func draw(_ dirtyRect: NSRect) {
        // Draw nothing - this is an invisible spacer
        NSColor.clear.setFill()
        dirtyRect.fill()
    }
}