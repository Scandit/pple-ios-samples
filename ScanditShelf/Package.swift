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
			url: "https://shelf.scandit.com/packages/pple-sdk-ios-1.5.0.zip",
			checksum: "8f5dbab79757d95b75e8300163aca30486c9c4548ffbae796665206cfdc4a7f0"
		),
		.binaryTarget(
			name: "ScanditBarcodeCapture",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-barcode-6.26.0-xcframework.zip",
			checksum: "732ffd2c723e0cbf839e567bfea1c3ac58dcb59d1775999558dd25ccc8e6d070"
		),
		.binaryTarget(
			name: "ScanditCaptureCore",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-core-6.26.0-xcframework.zip",
			checksum: "714c4a3bcfcb2a432fa171fb4bcc342a18abf68fae8ac67bb16c84aa776bf6cd"
		),
		.binaryTarget(
			name: "ScanditLabelCapture",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-label-6.26.0-xcframework.zip",
			checksum: "86aeb719b7211407e714c397d82afeb3a4a7a063840b6029dd668806eb5097b0"
		),
		.binaryTarget(
			name: "ScanditPriceLabel",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-label-plv-models-6.26.0-xcframework.zip",
			checksum: "c9cc86a7a10b9b0f46e5a6ab45dbf5eb68138bc5243fd3fcf30ec7846c5f0993"
		)
    ]
)
