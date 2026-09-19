// swift-tools-version: 5.10
import PackageDescription

/// Version-specific manifest used by Swift 5.10 toolchains.
///
/// SwiftPM selects this file for any 5.x toolchain (the `Package@swift-5` key),
/// while Swift 6.x and later use `Package.swift`. Keep both manifests in sync.
let package = Package(
    name: "Presentor",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "Presentor", targets: ["Presentor"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.17.0"),
    ],
    targets: [
        .target(
            name: "Presentor",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "PresentorTests",
            dependencies: [
                "Presentor",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
    ]
)
