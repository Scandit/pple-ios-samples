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
			url: "https://shelf.scandit.com/packages/pple-sdk-ios-1.7.0.zip",
			checksum: "d0a7333a1b348ec3b313bef060448377deef97a2977543377215336baa55585f"
		),
		.binaryTarget(
			name: "ScanditBarcodeCapture",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-barcode-7.0.2-xcframework.zip",
			checksum: "2b315cdb0912192707ca350f768cb344a91e47a8d4b56a3eaaacb4b4f852332a"
		),
		.binaryTarget(
			name: "ScanditCaptureCore",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-core-7.0.2-xcframework.zip",
			checksum: "ed3dc01d9676dc1a81616e9c08d557cfcafcf58184c4f877b480588d67f22251"
		),
		.binaryTarget(
			name: "ScanditLabelCapture",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-label-7.0.2-xcframework.zip",
			checksum: "0688c46ecfd01441b1b6329a849815a82b69e3f4fed120ca2f3f78cf7607cef9"
		),
		.binaryTarget(
			name: "ScanditPriceLabel",
			url: "https://ssl.scandit.com/sdk/download/scandit-datacapture-ios-label-plv-models-7.0.2-xcframework.zip",
			checksum: "058d8f15f1300849609f30b5c85e3f4c6571b87554f14f84c2559a6b1d59fa46"
		)
    ]
)
