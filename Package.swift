// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [.macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .executable(name: "Generator", targets: ["Generator"]),
        .library(
            name: "AdventOfCode-2021",
            targets: ["AdventOfCode-2021"]),
        .library(name: "AdventOfCodeCommon",
                 targets: ["AdventOfCodeCommon"]),
        .library(name: "AdventOfCode-2022",
                 targets: ["AdventOfCode-2022"]),
        .library(name: "AdventOfCode-2023",
                 targets: ["AdventOfCode-2023"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/objecthub/swift-commandlinekit.git", from: "0.3.4"),
    ],
    targets: [
        .target(name: "AdventOfCodeCommon",
                path: "Common/Sources"),
        .testTarget(
            name: "AdventOfCodeCommonTests",
            dependencies: ["AdventOfCodeCommon"],
            path: "Common/Tests"),
        .executableTarget(name: "Generator",
                dependencies: [
                    .product(name: "CommandLineKit", package: "swift-commandlinekit")
                ],
                path: "Generator/Sources"),
        .executableTarget(name: "Runner",
                dependencies: ["AdventOfCode-2022"],
                path: "Runner/Sources"),
        .target(
            name: "AdventOfCode-2021",
            dependencies: ["AdventOfCodeCommon"],
            path: "2021/Sources"),
        .testTarget(
            name: "AdventOfCode-2021Tests",
            dependencies: ["AdventOfCode-2021"],
            path: "2021/Tests",
            resources: [
                .process("Data")
            ]
        ),
        .target(
            name: "AdventOfCode-2022",
            dependencies: ["AdventOfCodeCommon"],
            path: "2022/Sources"),
        .testTarget(
            name: "AdventOfCode-2022Tests",
            dependencies: ["AdventOfCode-2022"],
            path: "2022/Tests",
            resources: [
                .process("Data")
            ]
        ),
        .target(
            name: "AdventOfCode-2023",
            dependencies: ["AdventOfCodeCommon"],
            path: "2023/Sources"),
        .testTarget(
            name: "AdventOfCode-2023Tests",
            dependencies: ["AdventOfCode-2023"],
            path: "2023/Tests",
            resources: [
                .process("Data")
            ]
        ),
    ]
)
