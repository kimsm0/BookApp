// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WebView",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "WebView",
            targets: ["WebView"]),
    ],
    dependencies: [
        .package(path: "../Platform"),        
    ],
    targets: [
        .target(
            name: "WebView",
            dependencies: [
                .product(name: "Extensions", package: "Platform"),
                .product(name: "Common", package: "Platform")                
            ]
        ),
    ]
)
