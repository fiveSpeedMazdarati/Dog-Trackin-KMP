// swift-tools-version: 6.0
import PackageDescription

/// Pure-Swift domain + feature-model layer. Must never import Firebase or UIKit,
/// so its rules are fast to test and independent of the backend.
let package = Package(
    name: "DogTrackinCore",
    platforms: [.iOS(.v18), .tvOS(.v18)],
    products: [
        .library(name: "DogTrackinCore", targets: ["DogTrackinCore"]),
    ],
    targets: [
        .target(name: "DogTrackinCore"),
        .testTarget(name: "DogTrackinCoreTests", dependencies: ["DogTrackinCore"]),
    ]
)
