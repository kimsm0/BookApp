// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Platform",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ArchitectureModule",
            targets: ["ArchitectureModule"]),
        .library(
            name: "Storage",
            targets: ["Storage"]),
        .library(
            name: "Common",
            targets: ["Common"]),
        .library(
            name: "CustomUI",
            targets: ["CustomUI"]),
        .library(
            name: "Extensions",
            targets: ["Extensions"]),
        
        .library(
            name: "Utils",
            targets: ["Utils"]),
        .library(
            name: "Network",
            targets: ["Network"]),
    ],
    targets: [
        .target(
            name: "ArchitectureModule",
        dependencies: [
            "Extensions",
        ]),
        .target(
            name: "Storage"),
        .target(
            name: "Common",
            dependencies: [
                "Storage",
                "Extensions"
            ]
        ),
        .target(
            name: "CustomUI",
            dependencies: [
                "Extensions",                
            ]
        ),
        .target(
            name: "Extensions",
            dependencies: [
            ]
        ),
        .target(
            name: "Utils",
            dependencies: [
            ]
        ),
        .target(
            name: "Network",
            dependencies: [
                "Common"
            ]
        ),
    ]
)
