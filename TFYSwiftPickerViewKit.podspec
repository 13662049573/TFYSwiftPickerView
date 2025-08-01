Pod::Spec.new do |spec|

  spec.name         = "TFYSwiftPickerViewKit"

  spec.version      = "1.0.8"

  spec.summary      = "Swift版选择器，支持iOS 15+，Swift 5，包含字符串选择器、日期选择器、地址选择器，支持多语言"

  spec.description  = <<-DESC
  Swift版选择器，最低支持iOS 15，Swift 5
  
  功能特性：
  - 字符串选择器（单选/多选）
  - 日期选择器（系统样式/自定义样式）
  - 地址选择器（省市区三级联动）
  - 支持中英文双语
  - 支持深色模式
  - 支持自定义主题
  - 支持运行时语言切换
  - 使用Frame布局，避免Auto Layout冲突
  - 完整的导航栏支持
  
  支持iOS 15.0+，Swift 5.0+
                   DESC

  spec.homepage     = "https://github.com/13662049573/TFYSwiftPickerView"
 
  spec.license      = "MIT"
  
  spec.author       = { "田风有" => "420144542@qq.com" }
  
  spec.platform     = :ios, "15.0"

  spec.swift_version = '5.0'

  spec.source       = { :git => "https://github.com/13662049573/TFYSwiftPickerView.git", :tag => spec.version }

  # 默认包含所有子模块
  spec.default_subspecs = 'Core'

  # 基础模块
  spec.subspec 'Base' do |ss|
    ss.source_files  = "TFYSwiftPickerView/TFYSwiftPickerViewKit/Base/*.{swift}"
    ss.resources = "TFYSwiftPickerView/TFYSwiftPickerViewKit/TFYSwiftCityBundle.bundle"
  end

  # 地址选择器模块
  spec.subspec 'Address' do |ss|
    ss.source_files  = "TFYSwiftPickerView/TFYSwiftPickerViewKit/Address/*.{swift}"
    ss.dependency "TFYSwiftPickerViewKit/Base"
    ss.resources = "TFYSwiftPickerView/TFYSwiftPickerViewKit/TFYSwiftCityBundle.bundle"
  end

  # 日期选择器模块
  spec.subspec 'Data' do |ss|
    ss.source_files  = "TFYSwiftPickerView/TFYSwiftPickerViewKit/Data/*.{swift}"
    ss.dependency "TFYSwiftPickerViewKit/Base"
    ss.resources = "TFYSwiftPickerView/TFYSwiftPickerViewKit/TFYSwiftCityBundle.bundle"
  end

  # 字符串选择器模块
  spec.subspec 'String' do |ss|
    ss.source_files  = "TFYSwiftPickerView/TFYSwiftPickerViewKit/String/*.{swift}"
    ss.dependency "TFYSwiftPickerViewKit/Base"
    ss.resources = "TFYSwiftPickerView/TFYSwiftPickerViewKit/TFYSwiftCityBundle.bundle"
  end

  # 资源文件
  spec.resources = "TFYSwiftPickerView/TFYSwiftPickerViewKit/TFYSwiftCityBundle.bundle"

  # 框架依赖
  spec.frameworks = "UIKit", "Foundation"

  # 需要ARC
  spec.requires_arc = true

  # 支持的架构
  spec.pod_target_xcconfig = { 
    'SWIFT_VERSION' => '5.0',
    'IPHONEOS_DEPLOYMENT_TARGET' => '15.0'
  }

end
