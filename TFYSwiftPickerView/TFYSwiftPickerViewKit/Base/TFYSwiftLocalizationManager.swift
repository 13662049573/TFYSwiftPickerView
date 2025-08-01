//
//  TFYSwiftLocalizationManager.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/16.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 15.0, *)
public class TFYSwiftLocalizationManager {
    
    // MARK: - Singleton
    public static let shared = TFYSwiftLocalizationManager()
    
    // MARK: - Properties
    private var bundle: Bundle?
    private var currentLanguage: String = "zh-Hans"
    
    // MARK: - Initialization
    private init() {
        setupBundle()
        setupLanguage()
    }
    
    // MARK: - Setup Methods
    private func setupBundle() {
        // 获取TFYSwiftCityBundle.bundle的路径
        if let bundlePath = Bundle.main.path(forResource: "TFYSwiftCityBundle", ofType: "bundle"),
           let bundle = Bundle(path: bundlePath) {
            self.bundle = bundle
        } else {
            // 如果找不到bundle，使用主bundle
            self.bundle = Bundle.main
        }
    }
    
    private func setupLanguage() {
        // 获取系统语言
        let preferredLanguage = Locale.preferredLanguages.first ?? "zh-Hans"
        
        // 确定当前语言
        if preferredLanguage.hasPrefix("zh") {
            currentLanguage = "zh-Hans"
        } else if preferredLanguage.hasPrefix("en") {
            currentLanguage = "en"
        } else {
            // 默认使用中文
            currentLanguage = "zh-Hans"
        }
    }
    
    // MARK: - Public Methods
    /// 获取本地化字符串
    public func localizedString(for key: String, comment: String = "") -> String {
        guard let bundle = bundle else {
            return key
        }
        
        // 尝试从指定语言的lproj文件夹获取字符串
        let languagePath = "\(currentLanguage).lproj"
        if let languageBundlePath = bundle.path(forResource: languagePath, ofType: nil),
           let languageBundle = Bundle(path: languageBundlePath) {
            let localizedString = languageBundle.localizedString(forKey: key, value: key, table: "Localizable")
            if localizedString != key {
                return localizedString
            }
        }
        
        // 如果找不到，尝试从主bundle获取
        return bundle.localizedString(forKey: key, value: key, table: "Localizable")
    }
    
    /// 设置语言
    public func setLanguage(_ language: String) {
        guard isLanguageSupported(language) else {
            print("⚠️ 不支持的语言: \(language)")
            return
        }
        
        currentLanguage = language
        print("🌍 语言已切换为: \(getLanguageDisplayName(language))")
        
        // 发送语言切换通知
        NotificationCenter.default.post(name: .languageDidChange, object: language)
    }
    
    /// 获取当前语言
    public func getCurrentLanguage() -> String {
        return currentLanguage
    }
    
    /// 获取支持的语言列表
    public func getSupportedLanguages() -> [String] {
        return ["zh-Hans", "en"]
    }
    
    /// 检查是否支持指定语言
    public func isLanguageSupported(_ language: String) -> Bool {
        return getSupportedLanguages().contains(language)
    }
    
    /// 获取语言显示名称
    public func getLanguageDisplayName(_ language: String) -> String {
        switch language {
        case "zh-Hans":
            return "简体中文"
        case "en":
            return "English"
        default:
            return language
        }
    }
} 