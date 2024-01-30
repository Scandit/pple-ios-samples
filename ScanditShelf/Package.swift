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
			"ScanditLabelCapture",
			"ScanditPriceLabel"
        ])
    ],
    dependencies: [],
    targets: [
		.binaryTarget(
			name: "ScanditShelf",
			url: "https://shelf.scandit.com/packages/pple-sdk-ios-1.4.0.zip",
			checksum: "462d4049b11b4ad6b41ddf31062f2a7d0b00e2d0bfe3470d851bc6fc02271367"
		),
		.binaryTarget(
			name: "ScanditBarcodeCapture",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-barcode-6.20.0-xcframework.zip",
			checksum: "046659d32ee25ee07577a813b6bd2086b9d4c15c72fc6be350ca1776da7d252a"
		),
		.binaryTarget(
			name: "ScanditCaptureCore",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-core-6.20.0-xcframework.zip",
			checksum: "effb9bed521dcecfb65f2aaa7368f9bef7375f05e146e8c5e01c53f638ff199f"
		),
		.binaryTarget(
			name: "ScanditLabelCapture",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-label-6.20.0-xcframework.zip",
			checksum: "280592b3f7d43a2b324e003599faa3d0cab29213b761fd6ee1c0b0bc13dc263c"
		),
		.binaryTarget(
			name: "ScanditPriceLabel",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-label-plv-models-6.20.0-xcframework.zip",
			checksum: "767a39fbb4411ff899c0f3e0e0443860a210b4bc22e57b300152581e17cbe4cb"
		)
    ]
)
