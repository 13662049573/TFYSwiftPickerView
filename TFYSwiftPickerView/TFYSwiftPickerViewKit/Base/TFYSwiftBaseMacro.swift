//
//  TFYSwiftBaseMacro.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/16.
//

import Foundation
import UIKit

let kPickerScrenWidth:CGFloat = UIScreen.main.bounds.width
let kPickerScrenHeight:CGFloat = UIScreen.main.bounds.height
let kPickerScrenBounds:CGRect = UIScreen.main.bounds
/// 默认主题颜色
let kPickerTheneColor:UIColor = UIColor.kPickerhexString("ffffff")
/// 默认背景颜色
let kPickerTextColor:UIColor = UIColor.kPickerhexString("252525")
/// 按钮边框颜色
let kPickerBorderColor:UIColor = UIColor.kPickerhexString("e6e6e6")
/// 按钮弹出框颜色
let kPickerShowColor:UIColor = UIColor.kPickerhexString("f7f7f7")
/// 按钮背景框颜色
let kPickerBackColor:UIColor = UIColor.kPickerhexString("f7f7f7")
/// 默认弹出框高度
let kPickerContentViewHeight:CGFloat = 265.0
/// 容器圆角
let kPickerContentViewCorners:CGFloat = 10
/// 头部点击高度 和
let kPickerTopViewHeight:CGFloat = 55.0
/// 滑块宽度
let kPickerSliderHeight:CGFloat = 45.0
/// 按钮宽度
let kPickerbtnWidth:CGFloat = 60
/// 按钮高度
let kPickerbtnHeight:CGFloat = 30
/// 底部高度
let kPickerBottomHeight:CGFloat = UIDevice().iskPickerIphoneX() ? 43.0 : 0.0
/// 容器高度
let kPickerContainerHeight:CGFloat = kPickerContentViewHeight + kPickerTopViewHeight + kPickerBottomHeight
/// 容器显示高度
let kPickerShowHeight:CGFloat = kPickerScrenHeight - kPickerContainerHeight
