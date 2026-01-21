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
			url: "https://shelf.scandit.com/packages/pple-sdk-ios-1.8.0-beta.1.zip",
			checksum: "93a9e379a3bad739a78f032a65b329a485a15ea71ff50e6ad2f90387c9447d76"
		),
		.binaryTarget(
			name: "ScanditBarcodeCapture",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-barcode-8.1.0-xcframework.zip",
			checksum: "b4c4907e5c82d3c97c38922ffe8ab61939d20862c40a9a2fc9916e89562b05f7"
		),
		.binaryTarget(
			name: "ScanditCaptureCore",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-core-8.1.0-xcframework.zip",
			checksum: "2ae0fdf26fecaa855b98e87996032faf37ac349a9d78f060976e18abbc6c190a"
		),
		.binaryTarget(
			name: "ScanditLabelCapture",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-label-8.1.0-xcframework.zip",
			checksum: "9292725c5cb9a86654a17ee3e1de0ea5cae44505a6530548d6c1e1b462869b82"
		),
		.binaryTarget(
			name: "ScanditPriceLabel",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-label-plv-models-8.1.0-xcframework.zip",
			checksum: "46af4b22d82f32c6771415f604665a0e2cd9b67b840772fcef10f1ab83646d6b"
		)
    ]
)
