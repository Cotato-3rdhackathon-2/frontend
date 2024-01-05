// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CalendarUI",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CalendarUI",
            targets: ["CalendarUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/WenchaoD/FSCalendar.git", from: "2.8.4")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CalendarUI",
            dependencies: [
                .product(name: "FSCalendar", package: "fscalendar"),
            ]
        ),
        .testTarget(
            name: "CalendarUITests",
            dependencies: ["CalendarUI"]
        ),
    ]
)
