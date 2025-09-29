//
//  MenuBarIconManagerTests.swift
//  MenuBarIconManagerTests
//
//  Created by Droid on 2025-09-29.
//  Copyright © 2025 Menu Bar Icon Manager. All rights reserved.
//

import XCTest
@testable import MenuBarIconManager

final class MenuBarIconManagerTests: XCTestCase {
    
    func testAppSettingsInitialization() {
        let settings = AppSettings()
        XCTAssertNotNil(settings)
        XCTAssertEqual(settings.defaultCollapseWidth, 200.0)
        XCTAssertTrue(settings.animationsEnabled)
        XCTAssertEqual(settings.animationDuration, 0.2)
    }
    
    func testThemeEnumValues() {
        XCTAssertEqual(Theme.light.rawValue, "light")
        XCTAssertEqual(Theme.dark.rawValue, "dark")
        XCTAssertEqual(Theme.auto.rawValue, "auto")
        XCTAssertTrue(Theme.auto.followsSystem)
        XCTAssertFalse(Theme.light.followsSystem)
    }
    
    func testCollapseStateEnum() {
        XCTAssertEqual(CollapseState.collapsed.rawValue, "collapsed")
        XCTAssertEqual(CollapseState.expanded.rawValue, "expanded")
    }
    
    func testSpacerControllerInitialization() {
        let settings = AppSettings()
        let controller = SpacerController(settings: settings)
        XCTAssertNotNil(controller)
        XCTAssertEqual(controller.currentState, .expanded)
        XCTAssertEqual(controller.currentWidth, 0)
    }
    
    func testHotkeyManagerInitialization() {
        let manager = HotkeyManager()
        XCTAssertNotNil(manager)
        XCTAssertTrue(manager.registeredCombinations.isEmpty)
    }
}