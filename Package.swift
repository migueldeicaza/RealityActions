// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RealityActions",
    platforms: [.iOS(.v15), .macOS(.v12), .visionOS(.v1)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RealityActions",
            targets: ["RealityActions"]),
    ],
    dependencies: [
            .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "RealityActions"),
        .testTarget(
            name: "RealityActionsTests",
            dependencies: ["RealityActions"]),
    ]
)
