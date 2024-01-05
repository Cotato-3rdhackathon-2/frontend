// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GlobalResources",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "GlobalResources",
            targets: ["GlobalResources"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kakao/kakao-ios-sdk", .upToNextMajor(from: "2.18.2")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: .init(5, 7, 1))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "GlobalResources",
            dependencies: [
                .product(name: "KakaoSDK", package: "kakao-ios-sdk"),
                .product(name: "Alamofire", package: "Alamofire")
            ]
        ),
        .testTarget(
            name: "GlobalResourcesTests",
            dependencies: ["GlobalResources"]),
    ]
)
