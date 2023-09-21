// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "DesignKit",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "DesignKit",
            targets: ["DesignKit"]
        )
    ],
    targets: [
        .target(
            name: "DesignKit"
        )
    ]
)
