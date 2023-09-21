// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "Characters",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Characters",
            targets: ["Characters"]),
    ],
    dependencies: [
        .package(path: "../NetworkKit"),
        .package(path: "../DesignKit"),
        .package(path: "../LocalStorageKit"),
    ],
    targets: [
        .target(
            name: "Characters",
            dependencies: [
                "NetworkKit",
                "DesignKit",
                "LocalStorageKit"
            ]),
        .testTarget(
            name: "CharactersTests",
            dependencies: ["Characters"]),
    ]
)
