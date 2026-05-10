// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PomodoroTimer",
    defaultLocalization: "zh",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .executable(name: "PomodoroTimer", targets: ["PomodoroTimer"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "PomodoroTimer",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "PomodoroTimerTests",
            dependencies: ["PomodoroTimer"]
        )
    ]
)
