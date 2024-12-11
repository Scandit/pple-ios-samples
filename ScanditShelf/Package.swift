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
			url: "https://shelf.scandit.com/packages/pple-sdk-ios-1.6.0-beta.1.zip",
			checksum: "c1d63b61383c51e392bbe723ebea084a6e8eab5ef526c635d878f95b6f88e546"
		),
		.binaryTarget(
			name: "ScanditBarcodeCapture",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-barcode-6.28.1-xcframework.zip",
			checksum: "979434fbb67b6f96fed6b116921bc97958dead7c1c63db554053eb4e2aaf5ad1"
		),
		.binaryTarget(
			name: "ScanditCaptureCore",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-core-6.28.1-xcframework.zip",
			checksum: "2d4ba0576d3c7a4e66d02aa9b8dfa956bbd99681a170b3adab76c150c29997bd"
		),
		.binaryTarget(
			name: "ScanditLabelCapture",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-label-6.28.1-xcframework.zip",
			checksum: "cf348c25ac58a2990877214ad02e8bdab9be1ef5e950cded1be670f76dac4816"
		),
		.binaryTarget(
			name: "ScanditPriceLabel",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-label-plv-models-6.28.1-xcframework.zip",
			checksum: "8031fcf5a99401145234363bbed89915b3f3e96d4e4ba990f37b86928e8722d7"
		)
    ]
)
