// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BreathNew",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "BreathNew",
            targets: ["BreathNew"]),
    ],
    targets: [
        .target(
            name: "BreathNew"),
        .testTarget(
            name: "BreathNewTests",
            dependencies: ["BreathNew"]),
    ]
)
