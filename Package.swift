// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "ToDo-Titan",
    dependencies: [
        .Package(url: "https://github.com/bermudadigitalstudio/Titan.git", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/bermudadigitalstudio/TitanKituraAdapter.git", majorVersion: 0, minor: 4),
        .Package(url: "https://github.com/bermudadigitalstudio/Rope.git", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/bermudadigitalstudio/TitanCORS.git", majorVersion: 0),
    ]
)
