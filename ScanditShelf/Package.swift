// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScanditShelf",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "ScanditShelf", targets: [
            "ScanditShelf",
            "ScanditBarcodeCapture",
            "ScanditCaptureCore",
            "ScanditLabelCapture"
        ])
    ],
    dependencies: [],
    targets: [
  		.binaryTarget(
  			name: "ScanditShelf",
  			path: "ScanditSDK/ScanditShelf.xcframework"
  		),
  		.binaryTarget(
  			name: "ScanditBarcodeCapture",
  			path: "ScanditSDK/ScanditBarcodeCapture.xcframework"
  		),
  		.binaryTarget(
  			name: "ScanditCaptureCore",
  			path: "ScanditSDK/ScanditCaptureCore.xcframework"
  		),
  		.binaryTarget(
  			name: "ScanditLabelCapture",
  			path: "ScanditSDK/ScanditLabelCapture.xcframework"
  		)
    ]
)