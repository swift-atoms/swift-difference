// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-difference",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Difference", targets: ["Difference"]),

        .library(name: "Difference Foundation Integration", targets: ["Difference Foundation Integration"]),
        .library(name: "Difference Test Support", targets: ["Difference Test Support"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-addition.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-subtraction.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-magnitude.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-cardinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-polarity.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-carrier.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-property.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Difference",
            dependencies: [
                .product(name: "Addition", package: "swift-addition"),
                .product(name: "Subtraction", package: "swift-subtraction"),
                .product(name: "Magnitude", package: "swift-magnitude"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Polarity", package: "swift-polarity"),
                .product(name: "Carrier", package: "swift-carrier"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Property", package: "swift-property"),
            ],
            path: "Sources/Difference"
        ),
        
        .target(
            name: "Difference Foundation Integration",
            dependencies: [
                .target(name: "Difference"),
            ],
            path: "Sources/Difference Foundation Integration"
        ),
        .target(
            name: "Difference Test Support",
            dependencies: [
                .target(name: "Difference"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Difference Tests",
            dependencies: [
                .target(name: "Difference"),
                .product(name: "Addition", package: "swift-addition"),
                .product(name: "Subtraction", package: "swift-subtraction"),
                .product(name: "Magnitude", package: "swift-magnitude"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Carrier", package: "swift-carrier"),
                .product(name: "Polarity", package: "swift-polarity"),
                .product(name: "Tagged", package: "swift-tagged"),
                .target(name: "Difference Test Support"),
                .target(name: "Difference Foundation Integration"),
            ],
            path: "Tests/Difference Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .define("SYNCHRONIZATION_AVAILABLE", .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS, .linux, .windows])),
    ]
}
