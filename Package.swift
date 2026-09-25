// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "kantacky-kit",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .tvOS(.v26),
        .visionOS(.v26),
        .watchOS(.v26),
    ],
    products: [
        .library(
            name: "Camera",
            targets: ["Camera"]
        ),
        .library(
            name: "HeadphoneMotion",
            targets: ["HeadphoneMotion"]
        ),
        .library(
            name: "ImageClassification",
            targets: ["ImageClassification"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(name: "Camera"),
        .target(name: "HeadphoneMotion"),
        .target(name: "ImageClassification"),
    ]
)

for target in package.targets {
    target.swiftSettings =
        (target.swiftSettings ?? []) + [
            .enableUpcomingFeature("ApproachableConcurrency"),
            .enableUpcomingFeature("ExistentialAny"),
            .enableUpcomingFeature("ImmutableWeakCaptures"),
            .enableUpcomingFeature("InferIsolatedConformances"),
            .enableUpcomingFeature("InternalImportsByDefault"),
            .enableUpcomingFeature("MemberImportVisibility"),
            .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        ]
}
