//
//  main.swift
//  MenuBarIconManager
//
//  Created by Droid on 2025-09-29.
//  Copyright © 2025 Menu Bar Icon Manager. All rights reserved.
//

import Cocoa

// Create and run the application
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

// Configure application
app.setActivationPolicy(.accessory) // Menu bar only app
app.run()