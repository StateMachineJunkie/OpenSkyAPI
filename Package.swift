// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenSkyAPI",
    platforms: [
        .iOS(.v16), .macOS(.v13)
    ],
    products: [
        .library(name: "OpenSkyAPI", targets: ["OpenSkyAPI"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(name: "OpenSkyAPI", dependencies: []),
        .testTarget(name: "OpenSkyAPITests",
                    dependencies: ["OpenSkyAPI"],
                    resources: [
                        .process("opensky_api_flights_all_output.json"),
                        .process("opensky_api_states_all_output.json"),
                        .process("opensky_api_states_single_output.json"),
                        .process("opensky_api_tracks_all_output.json")
                    ])
    ]
)
