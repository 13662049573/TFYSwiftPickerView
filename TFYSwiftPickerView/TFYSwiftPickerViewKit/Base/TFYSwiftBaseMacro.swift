//
//  TFYSwiftBaseMacro.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/16.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Screen Constants
@available(iOS 15.0, *)
public struct PickerScreenConstants {
    /// 屏幕宽度
    static let width: CGFloat = UIScreen.main.bounds.width
    /// 屏幕高度
    static let height: CGFloat = UIScreen.main.bounds.height
    /// 屏幕边界
    static let bounds: CGRect = UIScreen.main.bounds
    
    /// 安全区域
    static var safeAreaInsets: UIEdgeInsets {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return .zero
        }
        return window.safeAreaInsets
    }
    
    /// 是否为iPhone
    static var isiPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    /// 是否为iPad
    static var isiPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// 是否为刘海屏设备
    static var hasNotch: Bool {
        return safeAreaInsets.bottom > 0
    }
}

// MARK: - Color Constants
@available(iOS 15.0, *)
public struct PickerColors {
    /// 主题颜色 - 支持深色模式
    static let theme: UIColor = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .light:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        case .dark:
            return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        case .unspecified:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        @unknown default:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    /// 文本颜色 - 支持深色模式
    static let text: UIColor = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .light:
            return UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 1)
        case .dark:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        case .unspecified:
            return UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 1)
        @unknown default:
            return UIColor(red: 0.145, green: 0.145, blue: 0.145, alpha: 1)
        }
    }
    
    /// 边框颜色 - 支持深色模式
    static let border: UIColor = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .light:
            return UIColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1)
        case .dark:
            return UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        case .unspecified:
            return UIColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1)
        @unknown default:
            return UIColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1)
        }
    }
    
    /// 弹出框背景色 - 支持深色模式
    static let popupBackground: UIColor = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .light:
            return UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        case .dark:
            return UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        case .unspecified:
            return UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        @unknown default:
            return UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        }
    }
    
    /// 按钮背景色 - 支持深色模式
    static let buttonBackground: UIColor = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .light:
            return UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        case .dark:
            return UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        case .unspecified:
            return UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        @unknown default:
            return UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        }
    }
    
    /// 遮罩背景色
    static let maskBackground: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
}

// MARK: - Layout Constants
@available(iOS 15.0, *)
public struct PickerLayout {
    /// 弹出框内容高度
    static let contentHeight: CGFloat = 265.0
    /// 容器圆角
    static let cornerRadius: CGFloat = 12.0
    /// 头部高度
    static let headerHeight: CGFloat = 55.0
    /// 选择器高度
    static let pickerHeight: CGFloat = 45.0
    /// 按钮宽度
    static let buttonWidth: CGFloat = 60.0
    /// 按钮高度
    static let buttonHeight: CGFloat = 30.0
    /// 底部安全区域高度
    static var bottomSafeHeight: CGFloat {
        return PickerScreenConstants.hasNotch ? 43.0 : 0.0
    }
    /// 容器总高度
    static var containerHeight: CGFloat {
        // 确保内容有足够的空间，考虑安全区域
        return contentHeight + headerHeight + max(bottomSafeHeight, PickerScreenConstants.safeAreaInsets.bottom)
    }
    /// 显示位置Y坐标
    static var showPositionY: CGFloat {
        // 修正：确保考虑到底部安全区域，使弹窗整体上移
        return PickerScreenConstants.height - containerHeight - PickerScreenConstants.safeAreaInsets.bottom
    }
    
    /// 根据设备类型调整尺寸
    static func adjustedSize(for baseSize: CGFloat) -> CGFloat {
        if PickerScreenConstants.isiPad {
            return baseSize * 1.2
        }
        return baseSize
    }
}

// MARK: - Legacy Support (保持向后兼容)
@available(iOS 15.0, *)
public struct PickerLegacyConstants {
    static let kPickerScrenWidth: CGFloat = PickerScreenConstants.width
    static let kPickerScrenHeight: CGFloat = PickerScreenConstants.height
    static let kPickerScrenBounds: CGRect = PickerScreenConstants.bounds
    static let kPickerTheneColor: UIColor = PickerColors.theme
    static let kPickerTextColor: UIColor = PickerColors.text
    static let kPickerBorderColor: UIColor = PickerColors.border
    static let kPickerShowColor: UIColor = PickerColors.popupBackground
    static let kPickerBackColor: UIColor = PickerColors.buttonBackground
    static let kPickerContentViewHeight: CGFloat = PickerLayout.contentHeight
    static let kPickerContentViewCorners: CGFloat = PickerLayout.cornerRadius
    static let kPickerTopViewHeight: CGFloat = PickerLayout.headerHeight
    static let kPickerSliderHeight: CGFloat = PickerLayout.pickerHeight
    static let kPickerbtnWidth: CGFloat = PickerLayout.buttonWidth
    static let kPickerbtnHeight: CGFloat = PickerLayout.buttonHeight
    static let kPickerBottomHeight: CGFloat = PickerLayout.bottomSafeHeight
    static let kPickerContainerHeight: CGFloat = PickerLayout.containerHeight
    static let kPickerShowHeight: CGFloat = PickerLayout.showPositionY
}
