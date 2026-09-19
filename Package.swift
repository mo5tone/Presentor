// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Presentor",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Presentor", targets: ["Presentor"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.17.0")
    ],
    targets: [
        .target(name: "Presentor"),
        .testTarget(
            name: "PresentorTests",
            dependencies: [
                "Presentor",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        )
    ]
)
