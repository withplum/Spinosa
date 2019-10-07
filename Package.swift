// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Spinosa",
    platforms: [
        .iOS(.v12)
    ],
    path: "Spinosa/Sources",
    products: [
        .library(
            name: "Spinosa",
            targets: ["Spinosa"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.1")
    ],
    targets: [
        .target(
            name: "Spinosa",
            dependencies: ["SnapKit"]),
        .testTarget(
            name: "SpinosaTests",
            dependencies: ["Spinosa"]),
    ]
)
