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
        .library(
            name: "BookDataModel",
            targets: ["BookDataModel"]),
        .library(
            name: "BookRepository",
            targets: ["BookRepository"]),
        .library(
            name: "BookDetail",
            targets: ["BookDetail"]),
        .library(
            name: "BookTestSupport",
            targets: ["BookTestSupport"]),
    ],
    dependencies: [
        .package(path: "../Platform"),
        .package(path: "../WebView"),
    ],
    targets: [
        .target(
            name: "BookSearch",
            dependencies: [
                .product(name: "ArchitectureModule", package: "Platform"),
                .product(name: "Extensions", package: "Platform"),
                .product(name: "CustomUI", package: "Platform"),
                .product(name: "Storage", package: "Platform"),
                "BookRepository",
                "BookDataModel",
                "BookDetail"            
            ]
        ),
        .target(
            name: "BookDetail",
            dependencies: [
                .product(name: "ArchitectureModule", package: "Platform"),
                .product(name: "Extensions", package: "Platform"),
                .product(name: "CustomUI", package: "Platform"),
                .product(name: "Storage", package: "Platform"),
                .product(name: "WebView", package: "WebView"),
                .product(name: "WebViewCommon", package: "WebView"),
                "BookRepository",
                "BookDataModel", 
                
            ]
        ),
        .target(
            name: "BookDataModel",
            dependencies: [
            ]
        ),
        .target(
            name: "BookRepository",
            dependencies: [
                .product(name: "Extensions", package: "Platform"),
                .product(name: "Network", package: "Platform"),
                .product(name: "Utils", package: "Platform"),
                .product(name: "Common", package: "Platform"),
                .product(name: "CustomUI", package: "Platform"),
                "BookDataModel"
            ]
        ),
        .target(
            name: "BookTestSupport",
            dependencies: [
                "BookRepository",
                .product(name: "Extensions", package: "Platform"),
                .product(name: "Common", package: "Platform"),
            ]
        ),
        .testTarget(name: "BookSearchTest",
                   dependencies: [
                    .product(name: "Extensions", package: "Platform"),
                    .product(name: "Common", package: "Platform"),
                    .product(name: "Network", package: "Platform"),
                    .product(name: "Utils", package: "Platform"),
                    "BookDataModel",
                    "BookRepository",
                    "BookTestSupport",
                    "BookSearch"
                   ]),
        .testTarget(name: "BookDetailTest",
                   dependencies: [
                    .product(name: "Extensions", package: "Platform"),
                    .product(name: "Common", package: "Platform"),
                    .product(name: "Network", package: "Platform"),
                    .product(name: "Utils", package: "Platform"),
                    .product(name: "WebView", package: "WebView"),
                    "BookDataModel",
                    "BookRepository",
                    "BookTestSupport",
                    "BookDetail"
                   ]),
    ]
)
