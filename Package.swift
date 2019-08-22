// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "PaletteKit",
	products: [
		.library(
			name: "PaletteKit",
			targets: ["PaletteKit"]
		),
	],
	targets: [
		.target(
			name: "PaletteKit",
			dependencies: []
		),
		.testTarget(
			name: "PaletteKitTests",
			dependencies: ["PaletteKit"]
		),
	]
)
