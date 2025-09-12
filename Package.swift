// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "CocoaEx",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17), .watchOS(.v7)],
    products: [
        .library(name: "CocoaEx", targets: ["CocoaEx"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CocoaEx",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "CocoaExTests",
            dependencies: ["CocoaEx"],
            path: "Tests"
        ),
    ]
)
