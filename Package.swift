// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MenuBarIconManager",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "MenuBarIconManager",
            targets: ["MenuBarIconManager"]
        ),
    ],
    dependencies: [
        // Add any external dependencies here if needed
    ],
    targets: [
        .executableTarget(
            name: "MenuBarIconManager",
            dependencies: [],
            path: "Sources/MenuBarIconManager",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "MenuBarIconManagerTests",
            dependencies: ["MenuBarIconManager"],
            path: "Tests/MenuBarIconManagerTests"
        ),
    ]
)