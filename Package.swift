// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "ToDo-Titan",
    dependencies: [
        .Package(url: "https://github.com/bermudadigitalstudio/Titan.git", majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/bermudadigitalstudio/TitanKituraAdapter.git", majorVersion: 0, minor: 4)
    ]
)
