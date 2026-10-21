# TFYSwiftPickerView 🎯

<div align="center">

![Version](https://img.shields.io/cocoapods/v/TFYSwiftPickerViewKit.svg?style=flat)
![Platform](https://img.shields.io/cocoapods/p/TFYSwiftPickerViewKit.svg?style=flat)
![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg)
![License](https://img.shields.io/cocoapods/l/TFYSwiftPickerViewKit.svg?style=flat)
![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)
![iPad](https://img.shields.io/badge/iPad-Supported-green.svg)
![Languages](https://img.shields.io/badge/Languages-中文%20%7C%20English-blue.svg)

**🚀 全新优化版本 - 专为 iOS 16+ 打造的高性能选择器库，支持中英文双语**

</div>

---

## ✨ 全新特性

### 🎨 现代化设计
- **iOS 16+ 原生支持** - 充分利用最新系统特性
- **深色模式完美适配** - 自动跟随系统主题切换
- **iPad 完美适配** - 大屏幕设备优化体验
- **触觉反馈** - 增强用户交互体验
- **流畅动画** - 使用 Spring 动画提升视觉效果
- **多语言支持** - 完整的中英文双语支持
- **运行时语言切换** - 支持应用内语言切换
- **系统语言跟随** - 自动检测系统语言设置

### 📱 设备适配
- **iPhone 全系列** - 刘海屏、安全区域完美适配
- **iPad 大屏优化** - 自适应布局，居中显示
- **多窗口支持** - 支持 iPad 多任务模式
- **动态字体** - 支持系统字体大小调整

### 🛠 架构优化
- **现代化 Swift 语法** - 使用最新的 Swift 特性
- **内存管理优化** - 避免循环引用，提升性能
- **错误处理完善** - 健壮的错误处理机制
- **代码结构清晰** - 模块化设计，易于维护
- **Frame 布局** - 避免 Auto Layout 冲突
- **导航栏支持** - 完整的导航栏集成
- **模块化设计** - 支持按需引入功能模块

---

## 🎯 功能展示

### 📅 日期选择器

| 功能 | 描述 | 示例 |
|------|------|------|
| **系统时间选择** | 原生 UIDatePicker 体验 | `HH:mm` |
| **系统日期选择** | 标准日期选择器 | `yyyy-MM-dd` |
| **系统日期时间** | 日期+时间组合 | `yyyy-MM-dd HH:mm` |
| **自定义年月日** | 完整日期选择 | `yyyy-MM-dd` |
| **自定义年月** | 年月选择 | `yyyy-MM` |
| **自定义时分** | 时间选择 | `HH:mm` |
| **范围限制** | 支持最小/最大日期 | 自定义范围 |

### 📍 地址选择器

| 功能 | 描述 | 数据源 |
|------|------|--------|
| **省份选择** | 只显示省份列表 | 内置中国省份数据 |
| **省市选择** | 省份+城市二级联动 | 实时更新城市数据 |
| **省市区选择** | 完整三级联动 | 包含所有区县数据 |
| **默认选中** | 支持预设默认值 | 灵活配置 |

### 🎨 字符串选择器

| 功能 | 描述 | 应用场景 |
|------|------|----------|
| **单列选择** | 简单列表选择 | 性别、类型等 |
| **多列选择** | 复杂组合选择 | 年龄+体重、身高+体重等 |
| **自定义数据** | 支持任意字符串数组 | 灵活配置 |
| **默认值** | 支持预设选中项 | 用户体验优化 |

---

## 🚀 快速开始

### 📦 安装

#### CocoaPods
```ruby
# 完整版本（包含所有功能）
pod 'TFYSwiftPickerViewKit'

# 按需引入特定模块
pod 'TFYSwiftPickerViewKit/Base'      # 基础功能
pod 'TFYSwiftPickerViewKit/String'    # 字符串选择器
pod 'TFYSwiftPickerViewKit/Data'      # 日期选择器
pod 'TFYSwiftPickerViewKit/Address'   # 地址选择器
```

#### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/13662049573/TFYSwiftPickerView.git", from: "1.0.8")
]
```

### 💻 基础使用

#### 🌍 多语言示例
```swift
import TFYSwiftPickerView

// 自动跟随系统语言
let title = "select_date".localized
let cancelText = "cancel".localized
let confirmText = "confirm".localized

// 手动切换语言
TFYSwiftLocalizationManager.shared.setLanguage("en") // 英文
TFYSwiftLocalizationManager.shared.setLanguage("zh-Hans") // 中文

// 监听语言变化
NotificationCenter.default.addObserver(
    forName: .languageDidChange,
    object: nil,
    queue: .main
) { _ in
    // 刷新UI
    self.refreshUI()
}
```

#### 1. 日期选择器
```swift
import TFYSwiftPickerView

// 简单日期选择
TFYSwiftDatePickerView.show(
    title: "select_date".localized,
    mode: .date,
    defaultDate: "2024-01-01",
    isAutoSelect: false
) { selectedDate in
    print("选择的日期: \(selectedDate)")
} cancel: {
    print("用户取消")
}

// 带范围限制的日期选择
let minDate = Date.create(year: 2020, month: 1, day: 1)
let maxDate = Date.create(year: 2030, month: 12, day: 31)

TFYSwiftDatePickerView.show(
    title: "select_date".localized,
    mode: .ymd,
    defaultDate: "",
    minDate: minDate,
    maxDate: maxDate,
    isAutoSelect: false
) { selectedDate in
    print("选择的日期: \(selectedDate)")
} cancel: {
    print("用户取消")
}
```

#### 2. 地址选择器
```swift
// 省市区三级联动
TFYSwiftAddressPickerView.show(
    mode: .area,
    defaultSelected: ["浙江省", "杭州市", "滨江区"],
    isAutoSelect: false
) { province, city, area in
    print("选择的地址: \(province.name) - \(city.name) - \(area.name)")
} cancel: {
    print("用户取消")
}

// 只显示省份
TFYSwiftAddressPickerView.show(
    mode: .province,
    defaultSelected: [],
    isAutoSelect: false
) { province, city, area in
    print("选择的省份: \(province.name)")
} cancel: {
    print("用户取消")
}
```

#### 3. 字符串选择器
```swift
// 单列选择
let options = ["男", "女", "其他"]
TFYSwiftStringPickerView.show(
    title: "select_gender".localized,
    dataArray: options,
    defaultSelectedValue: "男",
    isAutoSelect: false,
    mode: .single
) { selectedValue in
    print("选择的性别: \(selectedValue)")
} cancel: {
    print("用户取消")
}

// 多列选择
let ageOptions = Array(18...80).map { "\($0)岁" }
let weightOptions = Array(30...150).map { "\($0)kg" }
let multiData = [ageOptions, weightOptions]

TFYSwiftStringPickerView.show(
    title: "select_age_weight".localized,
    dataArray: multiData,
    defaultSelectedValue: ["25岁", "65kg"],
    isAutoSelect: false,
    mode: .multiple
) { selectedValue in
    if let array = selectedValue as? [String] {
        print("年龄: \(array[0]), 体重: \(array[1])")
    }
} cancel: {
    print("用户取消")
}
```

---

## 🌍 多语言支持

### 📱 语言配置
```swift
import TFYSwiftPickerView

// 获取当前语言
let currentLanguage = TFYSwiftLocalizationManager.shared.getCurrentLanguage()
print("当前语言: \(currentLanguage)")

// 获取支持的语言列表
let supportedLanguages = TFYSwiftLocalizationManager.shared.getSupportedLanguages()
print("支持的语言: \(supportedLanguages)")

// 切换语言
TFYSwiftLocalizationManager.shared.setLanguage("en") // 切换到英文
TFYSwiftLocalizationManager.shared.setLanguage("zh-Hans") // 切换到中文
```

### 🔄 运行时语言切换
```swift
// 监听语言变化通知
NotificationCenter.default.addObserver(
    forName: .languageDidChange,
    object: nil,
    queue: .main
) { notification in
    if let newLanguage = notification.object as? String {
        print("语言已切换为: \(newLanguage)")
        // 刷新UI
        self.refreshUI()
    }
}

// 刷新UI方法
private func refreshUI() {
    // 更新所有使用本地化的UI元素
    title = "picker_demo".localized
    navigationItem.rightBarButtonItem?.title = "settings".localized
    // 刷新表格视图等
    tableView.reloadData()
}
```

### 📝 本地化字符串使用
```swift
// 基础本地化
let title = "select_date".localized

// 带注释的本地化
let description = "picker_description".localized(comment: "选择器描述")

// 动态语言切换
func updateLanguage(_ language: String) {
    TFYSwiftLocalizationManager.shared.setLanguage(language)
    // UI会自动更新
}
```

---

## 🎨 高级功能
```swift
// 自定义颜色主题
PickerColors.theme = UIColor.systemBlue
PickerColors.text = UIColor.label
PickerColors.border = UIColor.separator
PickerColors.popupBackground = UIColor.systemBackground
PickerColors.buttonBackground = UIColor.secondarySystemBackground
```

### 📱 设备适配
```swift
// iPad 适配
if PickerScreenConstants.isiPad {
    // iPad 特定配置
    let maxWidth: CGFloat = 400
    // 居中显示逻辑
}

// 深色模式适配
if traitCollection.userInterfaceStyle == .dark {
    // 深色模式特定配置
}
```

### ⚡ 性能优化
```swift
// 内存管理
weak var pickerView: TFYSwiftPickerView?

// 动画优化
UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseOut]) {
    // 流畅的动画效果
}
```

---

## 📋 完整 API 文档

### 🌍 本地化字符串列表
```swift
// 通用按钮
"cancel" = "取消" / "Cancel"
"confirm" = "完成" / "Confirm"
"done" = "完成" / "Done"

// 选择器标题
"select_gender" = "选择性别" / "Select Gender"
"select_date" = "选择日期" / "Select Date"
"select_time" = "选择时间" / "Select Time"
"select_province" = "选择省份" / "Select Province"
"select_city" = "选择城市" / "Select City"
"select_area" = "选择地区" / "Select Area"

// 设置相关
"settings" = "设置" / "Settings"
"dark_mode" = "深色模式" / "Dark Mode"
"reset_theme" = "重置主题" / "Reset Theme"
"switch_language" = "切换语言" / "Switch Language"

// 结果提示
"user_cancelled" = "用户取消" / "User Cancelled"
"selected" = "选中" / "Selected"
"picker_demo" = "选择器演示" / "Picker Demo"
```

### 日期选择器模式
```swift
public enum TFYSwiftDatePickerMode: Int, CaseIterable {
    case time = 0           // HH:mm
    case date = 1           // yyyy-MM-dd
    case dateAndTime = 2    // yyyy-MM-dd HH:mm
    case countDownTimer = 3 // HH:mm
    case ymdhms = 4         // yyyy-MM-dd HH:mm:ss
    case ymdhm = 5          // yyyy-MM-dd HH:mm
    case mdhm = 6           // MM-dd HH:mm
    case ymd = 7            // yyyy-MM-dd
    case ym = 8             // yyyy-MM
    case year = 9           // yyyy
    case md = 10            // MM-dd
    case hm = 11            // HH:mm
}
```

### 地址选择器模式
```swift
public enum TFYSwiftAddressPickerMode: Int, CaseIterable {
    case province = 0  // 只显示省
    case city = 1      // 显示省市
    case area = 2      // 显示省市区（默认）
}
```

### 字符串选择器模式
```swift
public enum TFYSwiftStringPickerMode: Int, CaseIterable {
    case single = 0    // 单列选择
    case multiple = 1  // 多列选择
}
```

---

## 🔧 配置选项

### 布局配置
```swift
// 选择器高度
PickerLayout.contentHeight = 265.0
// 头部高度
PickerLayout.headerHeight = 55.0
// 圆角大小
PickerLayout.cornerRadius = 12.0
// 按钮尺寸
PickerLayout.buttonWidth = 60.0
PickerLayout.buttonHeight = 30.0
```

### 颜色配置
```swift
// 主题颜色
PickerColors.theme
// 文本颜色
PickerColors.text
// 边框颜色
PickerColors.border
// 弹出框背景
PickerColors.popupBackground
// 按钮背景
PickerColors.buttonBackground
// 遮罩背景
PickerColors.maskBackground
```

---

## 📱 系统要求

- **iOS 16.0+** - 充分利用最新系统特性
- **Swift 5.5+** - 现代化 Swift 语法
- **Xcode 14.0+** - 完整开发支持
- **iPad 支持** - 完美适配大屏设备

---

## 🎯 更新日志

### v1.1.0 (2026-10-21) 🚀
- 📱 **最低系统版本** - 提升至 iOS 16.0
- 🧹 **API 现代化** - 移除旧版导航栏与圆角遮罩兼容代码
- 📦 **CocoaPods** - 版本号 1.1.0

### v1.0.8 (2024-01-XX) 🚀
- ✨ **多语言支持** - 完整的中英文双语支持
- 🔄 **运行时语言切换** - 支持应用内语言切换
- 🌍 **系统语言跟随** - 自动检测系统语言设置
- 🧭 **导航栏支持** - 完整的导航栏集成
- 🏗 **Frame 布局** - 避免 Auto Layout 冲突
- 📦 **模块化设计** - 支持按需引入功能模块
- 🛠 **API 优化** - 更简洁的调用方式
- 📚 **完整文档** - 详细的 API 文档

### v1.0.7 (历史版本)
- 基础功能实现
- iOS 16+ 支持
- 基本选择器功能



---

## 🤝 贡献指南

我们欢迎所有形式的贡献！

### 🐛 报告问题
如果你发现了 bug，请创建一个 [Issue](https://github.com/13662049573/TFYSwiftPickerView/issues)。

### 💡 功能建议
如果你有新的功能建议，请创建一个 [Issue](https://github.com/13662049573/TFYSwiftPickerView/issues) 并标记为 `enhancement`。

### 🔧 代码贡献
1. Fork 这个仓库
2. 创建你的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开一个 Pull Request

---

## 📄 许可证

本项目基于 **MIT 许可证** 开源。详细内容请查看 [LICENSE](LICENSE) 文件。

---

## 👨‍💻 作者

**田风有** - iOS 开发者

- 📧 Email: 420144542@qq.com
- 🐙 GitHub: [@田风有](https://github.com/13662049573)
- 💼 技术栈: Swift, iOS, UIKit, SwiftUI

---

## 🙏 致谢

感谢所有为这个项目做出贡献的开发者！

- 感谢 [CocoaPods](https://cocoapods.org/) 提供的包管理服务
- 感谢 [GitHub](https://github.com/) 提供的代码托管服务
- 感谢所有使用和反馈的用户

---

<div align="center">

**如果这个项目对你有帮助，请给个 ⭐️ Star 支持一下！**

[![GitHub stars](https://img.shields.io/github/stars/13662049573/TFYSwiftPickerView.svg?style=social&label=Star)](https://github.com/13662049573/TFYSwiftPickerView)
[![GitHub forks](https://img.shields.io/github/forks/13662049573/TFYSwiftPickerView.svg?style=social&label=Fork)](https://github.com/13662049573/TFYSwiftPickerView)

**Made with ❤️ by 田风有**

</div>
