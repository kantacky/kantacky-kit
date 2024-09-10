// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "KantackyKit",
    platforms: [
        .iOS(.v17),
        .macCatalyst(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .visionOS(.v1),
        .watchOS(.v10),
    ],
    products: [
        .library(name: "FoundationExtension", targets: ["FoundationExtension"]),
        .library(name: "LocalSearchClient", targets: ["LocalSearchClient"]),
        .library(name: "LocationClient", targets: ["LocationClient"]),
        .library(name: "Logger", targets: ["Logger"]),
        .library(name: "RemoteConfigClient", targets: ["RemoteConfigClient"]),
        .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "11.0.0")),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(name: "FoundationExtension"),
        .testTarget(
            name: "FoundationExtensionTests",
            dependencies: ["FoundationExtension"]
        ),
        .target(
            name: "LocalSearchClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "LocationClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ]
        ),
        .target(name: "Logger"),
        .testTarget(
            name: "LoggerTests",
            dependencies: ["Logger"]
        ),
        .target(
            name: "RemoteConfigClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
            ]
        ),
        .target(
            name: "UserDefaultsClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        ),
    ]
)
