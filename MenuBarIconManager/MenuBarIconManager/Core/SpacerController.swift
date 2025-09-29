//
//  SpacerController.swift
//  MenuBarIconManager
//

import Foundation
import AppKit
import Combine

/// Controls the spacer item width and animations
class SpacerController: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var currentState: CollapseState = .expanded
    @Published var currentWidth: CGFloat = 0
    
    // MARK: - Private Properties
    
    private let settings: AppSettings
    private var spacerItem: NSStatusItem?
    
    // MARK: - Initialization
    
    init(settings: AppSettings) {
        self.settings = settings
    }
    
    // MARK: - Public Methods
    
    /// Toggle between collapsed and expanded states
    func toggle() {
        switch currentState {
        case .collapsed:
            expand()
        case .expanded:
            collapse()
        }
    }
    
    /// Collapse the spacer (hide icons to the right)
    func collapse() {
        currentState = .collapsed
        animateWidth(to: settings.defaultCollapseWidth)
    }
    
    /// Expand the spacer (show all icons)  
    func expand() {
        currentState = .expanded
        animateWidth(to: 0)
    }
    
    // MARK: - Private Methods
    
    private func animateWidth(to targetWidth: CGFloat) {
        guard settings.animationsEnabled else {
            setWidth(targetWidth)
            return
        }
        
        let startWidth = currentWidth
        let duration = settings.animationDuration
        let startTime = CACurrentMediaTime()
        
        // Simple animation using a timer
        let timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { timer in
            let elapsed = CACurrentMediaTime() - startTime
            let progress = min(elapsed / duration, 1.0)
            
            // Ease out animation
            let easedProgress = 1 - pow(1 - progress, 2)
            let currentWidth = startWidth + (targetWidth - startWidth) * easedProgress
            
            self.setWidth(currentWidth)
            
            if progress >= 1.0 {
                timer.invalidate()
            }
        }
        
        timer.fire()
    }
    
    private func setWidth(_ width: CGFloat) {
        currentWidth = width
        spacerItem?.length = width
    }
}

/// Simplified theme manager placeholder
class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme = .auto
    
    let settings: AppSettings
    
    init(settings: AppSettings) {
        self.settings = settings
    }
}