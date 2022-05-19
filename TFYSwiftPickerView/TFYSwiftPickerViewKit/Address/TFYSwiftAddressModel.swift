//
//  TFYSwiftAddressModel.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/18.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import UIKit
import Foundation

public class TFYSwiftAddressModel: NSObject {
    var code:String = ""
    var name:String = ""
    var index:Int = 0
    var citylist:[TFYSwiftCitylistModel]?
}

public class TFYSwiftCitylistModel: NSObject {
    var code:String = ""
    var name:String = ""
    var index:Int = 0
    var arealist:[TFYSwiftArealistModel]?
}

public class TFYSwiftArealistModel: NSObject {
    var code:String = ""
    var name:String = ""
    var index:Int = 0
}

public func getBundleResource(bundName: String, resourceName: String, ofType ext: String?) -> String? {
    let resourcePath = "\(bundName)"
    guard let bundlePath = Bundle.main.path(forResource: resourcePath, ofType: "bundle"), let bundle = Bundle(path: bundlePath) else {
        return nil
    }
    let imageStr = bundle.path(forResource: resourceName, ofType: ext)
    return imageStr
}

// MARK: 读取本地json文件
public func kPickerGetJSON(name:String) -> [[String:Any]] {
    let path = getBundleResource(bundName: "TFYSwiftCityBundle", resourceName: name, ofType: "json")
    let url = URL(fileURLWithPath: path!)
    do {
        let data = try Data(contentsOf: url)
        let jsonString = String(data: data, encoding: .utf8)
        let jsonObject:[[String:Any]] = try JSONSerialization.jsonObject(with: jsonString!.data(using: String.Encoding.utf8)!, options: .allowFragments) as! [[String:Any]]
        return jsonObject
    } catch _ as Error? {
        print("读取本地数据出现错误!")
        return [[String:Any]]()
    }
}

