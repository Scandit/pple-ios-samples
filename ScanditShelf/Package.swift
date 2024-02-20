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
			url: "https://shelf.scandit.com/packages/pple-sdk-ios-1.4.1.zip",
			checksum: "58c5485a462bbc380b67011e3297f6f8e94f561ae1a275ea6b0d6103e3ae672b"
		),
		.binaryTarget(
			name: "ScanditBarcodeCapture",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-barcode-6.21.2-xcframework.zip",
			checksum: "43f22e24ffe64ea139107aab1c8fa5f9e82baaf506ccaca1742804e397c481b7"
		),
		.binaryTarget(
			name: "ScanditCaptureCore",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-core-6.21.2-xcframework.zip",
			checksum: "f410a86847d54e14381e679a2c765b231c0e30856b8eee008a74fedce63f4f7c"
		),
		.binaryTarget(
			name: "ScanditLabelCapture",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-label-6.21.2-xcframework.zip",
			checksum: "730f240b8c166eb6fa7c6e178b1a64c7070223667f1f529766ee36ed953dc2f0"
		),
		.binaryTarget(
			name: "ScanditPriceLabel",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-label-plv-models-6.21.2-xcframework.zip",
			checksum: "16384215298367158e51848228fdbb7373d88204b7fbc52b8cc19bdd9a9f3162"
		)
    ]
)
