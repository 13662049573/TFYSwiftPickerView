//
//  TFYSwiftResourceBundle.swift
//  TFYSwiftPickerViewKit
//

import Foundation

@available(iOS 15.0, *)
public enum TFYSwiftResourceBundle {
    /// Resolves `TFYSwiftCityBundle.bundle` for CocoaPods (app main bundle) and Swift Package Manager (`Bundle.module`).
    public static var cityBundle: Bundle {
        #if SWIFT_PACKAGE
        if let url = Bundle.module.url(forResource: "TFYSwiftCityBundle", withExtension: "bundle"),
           let bundle = Bundle(url: url) {
            return bundle
        }
        return Bundle.module
        #else
        if let bundlePath = Bundle.main.path(forResource: "TFYSwiftCityBundle", ofType: "bundle"),
           let bundle = Bundle(path: bundlePath) {
            return bundle
        }
        return Bundle.main
        #endif
    }
}
