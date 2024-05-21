// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Book",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "BookSearch",
            targets: ["BookSearch"]),
    ],
    dependencies: [
        .package(path: "../Platform"),
    ],
    targets: [
        .target(
            name: "BookSearch",
            dependencies: [
                .product(name: "ArchitectureModule", package: "Platform"),
                .product(name: "Extensions", package: "Platform"),
                .product(name: "CustomUI", package: "Platform"),
            ]
        ),
    ]
)
