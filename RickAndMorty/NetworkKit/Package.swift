// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "NetworkKit",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "NetworkKit",
            targets: ["NetworkKit"]
        ),
    ],
    dependencies: [
        .package(path: "../SerializationKit")
    ],
    targets: [
        .target(
            name: "NetworkKit",
            dependencies: [ "SerializationKit" ]
        ),
        .testTarget(
            name: "NetworkKitTests",
            dependencies: ["NetworkKit"]),
    ]
)
