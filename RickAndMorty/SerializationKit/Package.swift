// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "SerializationKit",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "SerializationKit",
            targets: ["SerializationKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SerializationKit",
            dependencies: []),
        .testTarget(
            name: "SerializationKitTests",
            dependencies: ["SerializationKit"]),
    ]
)
