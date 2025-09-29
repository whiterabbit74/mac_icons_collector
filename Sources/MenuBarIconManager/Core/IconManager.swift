//
//  IconManager.swift
//  MenuBarIconManager
//
//  Created by Droid on 2025-09-29.
//

import AppKit

/// Manages creation and styling of menu bar icons
class IconManager {
    
    /// Create an icon based on the icon type and current state
    static func createIcon(type: String, state: CollapseState, isMonochrome: Bool) -> NSImage {
        let size = NSSize(width: 16, height: 16)
        let image = NSImage(size: size)
        
        image.lockFocus()
        
        let color = NSColor.controlTextColor
        color.setFill()
        color.setStroke()
        
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        switch type {
        case "chevron":
            drawChevron(center: center, state: state)
        case "triangle":
            drawTriangle(center: center, state: state)
        case "dots":
            drawDots(center: center, state: state)
        default: // "default"
            drawArrow(center: center, state: state)
        }
        
        image.unlockFocus()
        image.isTemplate = isMonochrome
        
        return image
    }
    
    private static func drawArrow(center: CGPoint, state: CollapseState) {
        let path = NSBezierPath()
        
        if state == .collapsed {
            // Up arrow when collapsed (to indicate it will expand)
            path.move(to: CGPoint(x: center.x - 4, y: center.y - 2))
            path.line(to: CGPoint(x: center.x, y: center.y + 2))
            path.line(to: CGPoint(x: center.x + 4, y: center.y - 2))
        } else {
            // Down arrow when expanded (to indicate it will collapse)
            path.move(to: CGPoint(x: center.x - 4, y: center.y + 2))
            path.line(to: CGPoint(x: center.x, y: center.y - 2))
            path.line(to: CGPoint(x: center.x + 4, y: center.y + 2))
        }
        
        path.lineWidth = 2.0
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.stroke()
    }
    
    private static func drawChevron(center: CGPoint, state: CollapseState) {
        let path = NSBezierPath()
        
        if state == .collapsed {
            // Up chevron
            path.move(to: CGPoint(x: center.x - 3, y: center.y - 1))
            path.line(to: CGPoint(x: center.x, y: center.y + 2))
            path.line(to: CGPoint(x: center.x + 3, y: center.y - 1))
        } else {
            // Down chevron
            path.move(to: CGPoint(x: center.x - 3, y: center.y + 1))
            path.line(to: CGPoint(x: center.x, y: center.y - 2))
            path.line(to: CGPoint(x: center.x + 3, y: center.y + 1))
        }
        
        path.lineWidth = 1.5
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.stroke()
    }
    
    private static func drawTriangle(center: CGPoint, state: CollapseState) {
        let path = NSBezierPath()
        
        if state == .collapsed {
            // Up triangle
            path.move(to: CGPoint(x: center.x, y: center.y + 3))
            path.line(to: CGPoint(x: center.x - 4, y: center.y - 3))
            path.line(to: CGPoint(x: center.x + 4, y: center.y - 3))
            path.close()
        } else {
            // Down triangle
            path.move(to: CGPoint(x: center.x, y: center.y - 3))
            path.line(to: CGPoint(x: center.x - 4, y: center.y + 3))
            path.line(to: CGPoint(x: center.x + 4, y: center.y + 3))
            path.close()
        }
        
        path.fill()
    }
    
    private static func drawDots(center: CGPoint, state: CollapseState) {
        let dotSize: CGFloat = 2.0
        let spacing: CGFloat = 4.0
        
        if state == .collapsed {
            // Vertical dots
            for i in -1...1 {
                let dotRect = NSRect(
                    x: center.x - dotSize/2,
                    y: center.y - dotSize/2 + CGFloat(i) * spacing,
                    width: dotSize,
                    height: dotSize
                )
                let dotPath = NSBezierPath(ovalIn: dotRect)
                dotPath.fill()
            }
        } else {
            // Horizontal dots
            for i in -1...1 {
                let dotRect = NSRect(
                    x: center.x - dotSize/2 + CGFloat(i) * spacing,
                    y: center.y - dotSize/2,
                    width: dotSize,
                    height: dotSize
                )
                let dotPath = NSBezierPath(ovalIn: dotRect)
                dotPath.fill()
            }
        }
    }
}