// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let package = Package(
    name: "Huffer",
    products: [
        .executable(
            name: "huffer",
            targets: ["Huffer"]
        ),
        .library(
            name: "HufferLib",
            targets: ["HufferLib"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.1.4"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "Huffer",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "HufferLib",
            ]
        ),
        .target(
            name: "HufferLib",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
            ]
        ),
        .testTarget(
            name: "HufferTests",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                "HufferLib"
            ]
        ),
    ]
)
