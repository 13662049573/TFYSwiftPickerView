// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "TFYSwiftPickerViewKit",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(name: "TFYSwiftPickerViewKitBase", targets: ["TFYSwiftPickerViewKitBase"]),
        .library(name: "TFYSwiftPickerViewKitAddress", targets: ["TFYSwiftPickerViewKitAddress"]),
        .library(name: "TFYSwiftPickerViewKitData", targets: ["TFYSwiftPickerViewKitData"]),
        .library(name: "TFYSwiftPickerViewKitString", targets: ["TFYSwiftPickerViewKitString"]),
    ],
    targets: [
        .target(
            name: "TFYSwiftPickerViewKitBase",
            path: "TFYSwiftPickerView/TFYSwiftPickerViewKit",
            sources: ["Base"],
            resources: [
                .copy("TFYSwiftCityBundle.bundle"),
            ]
        ),
        .target(
            name: "TFYSwiftPickerViewKitAddress",
            dependencies: ["TFYSwiftPickerViewKitBase"],
            path: "TFYSwiftPickerView/TFYSwiftPickerViewKit",
            sources: ["Address"]
        ),
        .target(
            name: "TFYSwiftPickerViewKitData",
            dependencies: ["TFYSwiftPickerViewKitBase"],
            path: "TFYSwiftPickerView/TFYSwiftPickerViewKit",
            sources: ["Data"]
        ),
        .target(
            name: "TFYSwiftPickerViewKitString",
            dependencies: ["TFYSwiftPickerViewKitBase"],
            path: "TFYSwiftPickerView/TFYSwiftPickerViewKit",
            sources: ["String"]
        ),
    ]
)
