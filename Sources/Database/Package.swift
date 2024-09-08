// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Database",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Database",
            targets: ["Database"]),
    ],
    dependencies: [
        .package(path: "./Models"),
        .package(path: "../../../SwiftPackages/Domain"),
        .package(path: "../../../SwiftPackages/Storage"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Database",
            dependencies: [
                "Domain",
                "Storage",
                "Models",
            ]),
        .testTarget(
            name: "DatabaseTests",
            dependencies: ["Database"]),
    ]
)
