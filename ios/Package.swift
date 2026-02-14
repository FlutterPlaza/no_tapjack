// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "no_tapjack",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "no-tapjack", targets: ["no_tapjack"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "no_tapjack",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
