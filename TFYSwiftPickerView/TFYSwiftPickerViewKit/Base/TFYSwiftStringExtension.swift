//
//  TFYSwiftStringExtension.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/16.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import Foundation
import UIKit

// MARK: - String Extension for Localization
public extension String {
    /// 本地化字符串
    var localized: String {
        return TFYSwiftLocalizationManager.shared.localizedString(for: self)
    }
    
    /// 本地化字符串（带注释）
    func localized(comment: String) -> String {
        return TFYSwiftLocalizationManager.shared.localizedString(for: self, comment: comment)
    }
}

// MARK: - Notification Names
public extension Notification.Name {
    static let languageDidChange = Notification.Name("TFYSwiftLanguageDidChange")
}

// MARK: - Legacy Support
public func TFYSwiftLocalizedString(_ key: String, comment: String = "") -> String {
    return TFYSwiftLocalizationManager.shared.localizedString(for: key, comment: comment)
} 