// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyGFX",
    products: [
        .library(
            name: "SwiftyGFX",
            targets: ["SwiftyGFX"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftyGFX",
            dependencies: ["CFreeType"]),
        .testTarget(
            name: "SwiftyGFXTests",
            dependencies: ["SwiftyGFX"]),
        .systemLibrary(
            name: "CFreeType",
            path: "Sources/CFreeType",
            pkgConfig: "freetype2",
            providers: [.brew(["freetype"]), .apt(["libfreetype2-dev"])]),
    ]
)
