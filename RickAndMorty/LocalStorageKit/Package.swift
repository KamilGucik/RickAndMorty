// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "LocalStorageKit",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "LocalStorageKit",
            targets: ["LocalStorageKit"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LocalStorageKit",
            dependencies: []
        )
    ]
)
