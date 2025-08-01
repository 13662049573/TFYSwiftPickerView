//
//  TFYSwiftAddressModel.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/18.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import UIKit
import Foundation

@available(iOS 15.0, *)
public class TFYSwiftAddressModel: NSObject, Codable {
    public var code: String = ""
    public var name: String = ""
    public var index: Int = 0
    public var citylist: [TFYSwiftCitylistModel]?
    
    public override init() {
        super.init()
    }
    
    public init(code: String, name: String, index: Int = 0) {
        self.code = code
        self.name = name
        self.index = index
        super.init()
    }
}

@available(iOS 15.0, *)
public class TFYSwiftCitylistModel: NSObject, Codable {
    public var code: String = ""
    public var name: String = ""
    public var index: Int = 0
    public var arealist: [TFYSwiftArealistModel]?
    
    public override init() {
        super.init()
    }
    
    public init(code: String, name: String, index: Int = 0) {
        self.code = code
        self.name = name
        self.index = index
        super.init()
    }
}

@available(iOS 15.0, *)
public class TFYSwiftArealistModel: NSObject, Codable {
    public var code: String = ""
    public var name: String = ""
    public var index: Int = 0
    
    public override init() {
        super.init()
    }
    
    public init(code: String, name: String, index: Int = 0) {
        self.code = code
        self.name = name
        self.index = index
        super.init()
    }
}

// MARK: - Bundle Resource Helper
@available(iOS 15.0, *)
public func getBundleResource(bundleName: String, resourceName: String, ofType ext: String?) -> String? {
    let resourcePath = bundleName
    guard let bundlePath = Bundle.main.path(forResource: resourcePath, ofType: "bundle"),
          let bundle = Bundle(path: bundlePath) else {
        return nil
    }
    return bundle.path(forResource: resourceName, ofType: ext)
}

// MARK: - JSON Helper
@available(iOS 15.0, *)
public func loadJSONData(name: String) -> [[String: Any]] {
    guard let path = getBundleResource(bundleName: "TFYSwiftCityBundle", resourceName: name, ofType: "json"),
          let url = URL(string: "file://" + path) else {
        print("Failed to find JSON file: \(name)")
        return []
    }
    
    do {
        let data = try Data(contentsOf: url)
        let jsonString = String(data: data, encoding: .utf8)
        
        guard let jsonData = jsonString?.data(using: .utf8) else {
            print("Failed to convert JSON string to data")
            return []
        }
        
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [[String: Any]]
        return jsonObject ?? []
    } catch {
        print("Error reading JSON data: \(error.localizedDescription)")
        return []
    }
}

// MARK: - Legacy Support
@available(iOS 15.0, *)
public func kPickerGetJSON(name: String) -> [[String: Any]] {
    return loadJSONData(name: name)
}

