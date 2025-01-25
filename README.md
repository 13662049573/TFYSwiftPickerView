# TFYSwiftPickerView

🎯 一个功能强大、使用简单的 Swift 选择器库，支持日期、地址、自定义字符串等多种选择模式。

[![Version](https://img.shields.io/cocoapods/v/TFYSwiftPickerViewKit.svg?style=flat)](https://cocoapods.org/pods/TFYSwiftPickerViewKit)
[![Platform](https://img.shields.io/cocoapods/p/TFYSwiftPickerViewKit.svg?style=flat)](https://cocoapods.org/pods/TFYSwiftPickerViewKit)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![License](https://img.shields.io/cocoapods/l/TFYSwiftPickerViewKit.svg?style=flat)](LICENSE)

## ✨ 特性

- 📅 丰富的日期选择模式
  - 年月日时分秒完整模式
  - 年月日模式
  - 时分模式
  - 自定义日期格式
  
- 📍 完整的地址选择功能
  - 省市区三级联动
  - 支持自定义地址数据
  - 灵活的显示模式

- 🎨 自定义字符串选择器
  - 单列/多列选择
  - 自定义数据源
  - 灵活的回调方式

- 🌈 其他特性
  - iOS 12+ 适配
  - Swift 5.0+ 支持
  - 深色模式支持
  - 链式调用
  - 自定义主题

## 🚀 安装

### CocoaPods

```ruby
pod 'TFYSwiftPickerViewKit'
```

## 📖 使用示例

### 日期选择器

```swift
TFYSwiftDatePickerView.showDatePickerWithTitle(
    title: "选择日期",
    dateType: .TFYSwiftDatePickerModeYMD,
    defaultSelValue: "2023-01-01",
    minDate: Date.distantPast,
    maxDate: Date.distantFuture,
    isAutoSelect: true) { dateStr in
        print("选择的日期: \(dateStr)")
    } cancelBlock: {
        print("取消选择")
}
```

### 地址选择器

```swift
TFYSwiftAddressPickerView.showAddressPickerWithTitle(
    showType: .TFYSwiftAddressPickerModeArea,
    defaultSelected: ["广东省", "深圳市", "南山区"],
    isAutoSelect: true) { province, city, area in
        print("选择的地址: \(province.name)\(city.name)\(area.name)")
    } cancelBlock: {
        print("取消选择")
}
```

### 自定义字符串选择器

```swift
let dataSource = ["选项1", "选项2", "选项3"]
TFYSwiftStringPickerView.showStringPickerWithTitle(
    title: "请选择",
    dataArr: dataSource,
    defaultSelValue: "选项1",
    isAutoSelect: true,
    type: .TFYSwiftStringPickerComponentSingle) { result in
        print("选择的结果: \(result)")
    } cancelBlock: {
        print("取消选择")
}
```

## 🛠 自定义配置

### 主题定制

```swift
// 修改主题颜色
kPickerTheneColor = UIColor.white
kPickerTextColor = UIColor.black
kPickerBorderColor = UIColor.gray
```

### 样式调整

```swift
// 修改选择器高度
kPickerContentViewHeight = 280.0
// 修改圆角大小
kPickerContentViewCorners = 16.0
```

## 📱 要求

- iOS 12.0+
- Swift 5.0+
- Xcode 12.0+

## 🤝 贡献

欢迎提交 Issue 和 Pull Request

## 📄 许可证

TFYSwiftPickerView 基于 MIT 许可证开源。详细内容请查看 [LICENSE](LICENSE) 文件。

## 👨‍💻 作者

田风有

## 📮 联系方式

- Email: 420144542@qq.com
- GitHub: [@田风有](https://github.com/13662049573)

---

如果这个项目对你有帮助，欢迎 star ⭐️
