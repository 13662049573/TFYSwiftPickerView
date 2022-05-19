

Pod::Spec.new do |spec|

  spec.name         = "TFYSwiftPickerViewKit"

  spec.version      = "1.0.0"

  spec.summary      = "swift版选择器，最低支持ios 12 ,swift5"

  spec.description  = <<-DESC
  swift版选择器，最低支持ios 12 ,swift5
                   DESC

  spec.homepage     = "https://github.com/13662049573/TFYSwiftPickerView"
 
  spec.license      = "MIT"
  
  spec.author       = { "田风有" => "420144542@qq.com" }
  
  spec.platform     = :ios, "12.0"

  spec.swift_version = '5.0'

  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }

  spec.source       = { :git => "https://github.com/13662049573/TFYSwiftPickerView.git", :tag => spec.version }

  spec.subspec 'Base' do |ss|
    ss.source_files  = "TFYSwiftPickerView/TFYSwiftPickerViewKit/Base/*.{swift}"
  end

  spec.subspec 'Address' do |ss|
    ss.source_files  = "TFYSwiftPickerView/TFYSwiftPickerViewKit/Address/*.{swift}"
    ss.dependency "TFYSwiftPickerViewKit/Base"
  end

  spec.subspec 'Data' do |ss|
    ss.source_files  = "TFYSwiftPickerView/TFYSwiftPickerViewKit/Data/*.{swift}"
    ss.dependency "TFYSwiftPickerViewKit/Base"
  end

  spec.subspec 'String' do |ss|
    ss.source_files  = "TFYSwiftPickerView/TFYSwiftPickerViewKit/String/*.{swift}"
    ss.dependency "TFYSwiftPickerViewKit/Base"
  end

  spec.resources = "TFYSwiftPickerView/TFYSwiftPickerViewKit/TFYSwiftCityBundle.bundle"

  spec.requires_arc = true

end
