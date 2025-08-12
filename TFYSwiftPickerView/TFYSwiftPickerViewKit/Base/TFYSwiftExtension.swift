//
//  TFYSwiftExtension.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/19.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Data Extensions
@available(iOS 15.0, *)
public extension Data {
    /// 转换为字符串
    func toString(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }
    
    /// 转换为字节数组
    func toBytes() -> [UInt8] {
        return [UInt8](self)
    }
    
    /// 转换为字典
    func toDictionary() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any]
        } catch {
            print("Data to dictionary error: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// 转换为任意对象
    func toObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: options)
    }
    
    /// 转换为指定Model类型
    func toModel<T: Decodable>(_ type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(type, from: self)
        } catch {
            print("Data to model error: \(error.localizedDescription)")
            return nil
        }
    }
}

// MARK: - String Extensions
@available(iOS 15.0, *)
public extension String {
    /// 从base64初始化
    init?(base64: String) {
        guard let decodedData = Data(base64Encoded: base64),
              let str = String(data: decodedData, encoding: .utf8) else { 
            return nil 
        }
        self.init(str)
    }
    
    /// 转换为指定Model类型
    func toModel<T: Decodable>(_ type: T.Type) -> T? {
        return self.data(using: .utf8)?.toModel(type)
    }
    
    /// 复制到剪贴板
    func copyToClipboard() {
        UIPasteboard.general.string = self
    }
    
    /// 转换为日期
    func toDate(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    /// 转换为UTF8编码的Data
    func toUTF8Data() -> Data? {
        return self.data(using: .utf8)
    }
    
    /// 安全的字符串截取
    func safeSubstring(from startIndex: Int, to endIndex: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: max(0, startIndex))
        let end = self.index(self.startIndex, offsetBy: min(endIndex, self.count))
        return String(self[start..<end])
    }
}

// MARK: - UIWindow Extensions
@available(iOS 15.0, *)
public extension UIWindow {
    /// 获取当前key window
    static var keyWindow: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        return window
    }
    
    /// 获取所有窗口
    static var allWindows: [UIWindow] {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return []
        }
        return windowScene.windows
    }
}

// MARK: - UIDevice Extensions
@available(iOS 15.0, *)
public extension UIDevice {
    /// 是否为iPhone X系列设备
    var hasNotch: Bool {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return false
        }
        return window.safeAreaInsets.bottom > 0
    }
    
    /// 设备类型
    var deviceType: DeviceType {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return .iPhone
        case .pad:
            return .iPad
        case .tv:
            return .tv
        case .carPlay:
            return .carPlay
        case .mac:
            return .mac
        #if swift(>=5.9)
        case .vision:
            return .vision
        #endif
        case .unspecified:
            return .unknown
        @unknown default:
            return .unknown
        }
    }
    
    enum DeviceType {
        case iPhone
        case iPad
        case tv
        case carPlay
        case mac
        case vision
        case unknown
    }
}

// MARK: - UIView Extensions
@available(iOS 15.0, *)
public extension UIView {
    /// 设置圆角
    func setCornerRadius(_ radius: CGFloat, corners: UIRectCorner = .allCorners) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    /// 添加阴影
    func addShadow(color: UIColor = .black, opacity: Float = 0.1, offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 4) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
    
    /// 添加渐变背景
    func addGradientBackground(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Frame Properties
    /// X坐标
    var x: CGFloat {
        get { frame.origin.x }
        set { frame.origin.x = newValue }
    }
    
    /// Y坐标
    var y: CGFloat {
        get { frame.origin.y }
        set { frame.origin.y = newValue }
    }
    
    /// 宽度
    var width: CGFloat {
        get { frame.size.width }
        set { frame.size.width = newValue }
    }
    
    /// 高度
    var height: CGFloat {
        get { frame.size.height }
        set { frame.size.height = newValue }
    }
    
    /// 最大X坐标
    var maxX: CGFloat {
        get { frame.origin.x + frame.size.width }
        set { frame.origin.x = newValue - frame.size.width }
    }
    
    /// 最大Y坐标
    var maxY: CGFloat {
        get { frame.origin.y + frame.size.height }
        set { frame.origin.y = newValue - frame.size.height }
    }
    
    /// 中心X坐标
    var centerX: CGFloat {
        get { center.x }
        set { center.x = newValue }
    }
    
    /// 中心Y坐标
    var centerY: CGFloat {
        get { center.y }
        set { center.y = newValue }
    }
    
    /// 尺寸
    var size: CGSize {
        get { frame.size }
        set { frame.size = newValue }
    }
    
    /// 原点
    var origin: CGPoint {
        get { frame.origin }
        set { frame.origin = newValue }
    }
    
    // MARK: - Legacy Support
    var kPickerX: CGFloat { x }
    var kPickerY: CGFloat { y }
    var kPickerWidth: CGFloat { width }
    var kPickerHeight: CGFloat { height }
    var kPickerMaxX: CGFloat { maxX }
    var kPickerMaxY: CGFloat { maxY }
    var kPickerCenterX: CGFloat { centerX }
    var kPickerCenterY: CGFloat { centerY }
    var kPickerSize: CGSize { size }
    var kPickerOrigin: CGPoint { origin }
    
    func kPickerCornerCut(radius: CGFloat, corner: UIRectCorner) {
        setCornerRadius(radius, corners: corner)
    }
}

// MARK: - UIColor Extensions
@available(iOS 15.0, *)
public extension UIColor {
    /// 从十六进制字符串创建颜色
    static func hex(_ hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        var str = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if str.hasPrefix("0X") {
            str = String(str.dropFirst(2))
        } else if str.hasPrefix("#") {
            str = String(str.dropFirst(1))
        }
        
        let length = str.count
        guard length == 3 || length == 4 || length == 6 || length == 8 else {
            return .clear
        }
        
        // 将RGB/RGBA转换为RRGGBB/RRGGBBAA
        if length < 5 {
            var tStr = ""
            str.forEach { tStr.append(String(repeating: $0, count: 2)) }
            str = tStr
        }
        
        guard let hexValue = Int(str, radix: 16) else {
            return .clear
        }
        
        var red: Int, green: Int, blue: Int
        
        if length == 3 || length == 6 {
            red = (hexValue >> 16) & 0xFF
            green = (hexValue >> 8) & 0xFF
            blue = hexValue & 0xFF
        } else {
            red = (hexValue >> 20) & 0xFF
            green = (hexValue >> 16) & 0xFF
            blue = (hexValue >> 8) & 0xFF
        }
        
        return UIColor(red: CGFloat(red) / 255.0,
                      green: CGFloat(green) / 255.0,
                      blue: CGFloat(blue) / 255.0,
                      alpha: alpha)
    }
    
    /// 创建支持深色模式的颜色
    static func adaptive(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return light
            case .dark:
                return dark
            case .unspecified:
                return light
            @unknown default:
                return light
            }
        }
    }
    
    // MARK: - Legacy Support
    static func kPickerhexString(_ hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        return hex(hexString, alpha: alpha)
    }
    
    static func kPickerdiabloDarkColor(light: UIColor, dark: UIColor) -> UIColor {
        return adaptive(light: light, dark: dark)
    }
}

// MARK: - UIFont Extensions
@available(iOS 15.0, *)
public extension UIFont {
    /// 创建自适应字体
    static func adaptive(size: CGFloat, weight: Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    /// 创建标题字体
    static func title(size: CGFloat = 17, weight: Weight = .semibold) -> UIFont {
        return adaptive(size: size, weight: weight)
    }
    
    /// 创建正文字体
    static func body(size: CGFloat = 15, weight: Weight = .regular) -> UIFont {
        return adaptive(size: size, weight: weight)
    }
    
    /// 创建小字体
    static func caption(size: CGFloat = 12, weight: Weight = .regular) -> UIFont {
        return adaptive(size: size, weight: weight)
    }
}

// MARK: - Animation Extensions
@available(iOS 15.0, *)
public extension UIView {
    /// 淡入动画
    func fadeIn(duration: TimeInterval = 0.25, completion: (() -> Void)? = nil) {
        alpha = 0
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: { _ in
            completion?()
        })
    }
    
    /// 淡出动画
    func fadeOut(duration: TimeInterval = 0.25, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: { _ in
            completion?()
        })
    }
    
    /// 缩放动画
    func scale(scale: CGFloat, duration: TimeInterval = 0.25, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: { _ in
            completion?()
        })
    }
    
    /// 移动动画
    func move(to point: CGPoint, duration: TimeInterval = 0.25, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.center = point
        }, completion: { _ in
            completion?()
        })
    }
}
