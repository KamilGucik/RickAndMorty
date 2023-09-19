// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "Episodes",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Episodes",
            targets: ["Episodes"]),
    ],
    dependencies: [
        .package(path: "../NetworkKit"),
    ],
    targets: [
        .target(
            name: "Episodes",
            dependencies: [
                "NetworkKit"
            ]),
        .testTarget(
            name: "EpisodesTests",
            dependencies: ["Episodes"]),
    ]
)
