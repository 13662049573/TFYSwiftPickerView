//
//  TFYSwiftAddressPickerView.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/18.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import UIKit

@available(iOS 15.0, *)
public enum TFYSwiftAddressPickerMode: Int, CaseIterable {
    /// 只显示省
    case province = 0
    /// 显示省市
    case city = 1
    /// 显示省市区（默认）
    case area = 2
    
    var title: String {
        switch self {
        case .province:
            return "select_province".localized
        case .city:
            return "select_city".localized
        case .area:
            return "select_area".localized
        }
    }
}

@available(iOS 15.0, *)
public typealias AddressPickerResultBlock = (_ province: TFYSwiftAddressModel, _ city: TFYSwiftCitylistModel, _ area: TFYSwiftArealistModel) -> Void
@available(iOS 15.0, *)
public typealias AddressPickerCancelBlock = () -> Void

@available(iOS 15.0, *)
public class TFYSwiftAddressPickerView: TFYSwiftPickerBaseView {
    
    // MARK: - Properties
    private var resultBlock: AddressPickerResultBlock?
    private var cancelBlock: AddressPickerCancelBlock?
    private var isDataSourceValid: Bool = false
    private var isAutoSelect: Bool = false
    private var mode: TFYSwiftAddressPickerMode = .area
    
    // 索引
    private var provinceIndex: Int = 0
    private var cityIndex: Int = 0
    private var areaIndex: Int = 0
    
    // 选中的模型
    private var selectedProvince: TFYSwiftAddressModel = TFYSwiftAddressModel()
    private var selectedCity: TFYSwiftCitylistModel = TFYSwiftCitylistModel()
    private var selectedArea: TFYSwiftArealistModel = TFYSwiftArealistModel()
    
    // 数据数组
    private var provinceArray: [TFYSwiftAddressModel] = []
    private var cityArray: [TFYSwiftCitylistModel] = []
    private var areaArray: [TFYSwiftArealistModel] = []
    
    // 默认选中值
    private var defaultSelectedArray: [String] = []
    
    // MARK: - UI Components
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = PickerColors.theme
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    // MARK: - Public Methods
    public static func show(
        mode: TFYSwiftAddressPickerMode = .area,
        defaultSelected: [String] = [],
        isAutoSelect: Bool = false,
        result: @escaping AddressPickerResultBlock,
        cancel: @escaping AddressPickerCancelBlock
    ) {
        let pickerView = TFYSwiftAddressPickerView(
            mode: mode,
            defaultSelected: defaultSelected,
            isAutoSelect: isAutoSelect,
            result: result,
            cancel: cancel
        )
        
        if pickerView.isDataSourceValid {
            pickerView.show(animated: true)
        }
    }
    
    // MARK: - Initialization
    private init(
        mode: TFYSwiftAddressPickerMode,
        defaultSelected: [String],
        isAutoSelect: Bool,
        result: @escaping AddressPickerResultBlock,
        cancel: @escaping AddressPickerCancelBlock
    ) {
        super.init(frame: .zero)
        
        self.mode = mode
        self.isAutoSelect = isAutoSelect
        self.resultBlock = result
        self.cancelBlock = cancel
        self.defaultSelectedArray = defaultSelected
        self.isDataSourceValid = true
        
        loadData()
        
        if isDataSourceValid {
            setupUI()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func loadData() {
        let dataArray = loadJSONData(name: "TFYSwiftCityData")
        isDataSourceValid = !dataArray.isEmpty
        
        guard isDataSourceValid else { return }
        
        provinceArray = parseProvinceData(dataArray)
        setupDefaultValues()
        scrollToSelectedRow()
    }
    
    private func parseProvinceData(_ dataArray: [[String: Any]]) -> [TFYSwiftAddressModel] {
        var provinces: [TFYSwiftAddressModel] = []
        
        for (index, provinceDict) in dataArray.enumerated() {
            let province = TFYSwiftAddressModel(
                code: provinceDict["code"] as? String ?? "",
                name: provinceDict["name"] as? String ?? "",
                index: index
            )
            
            // 解析城市数据
            if let cityList = provinceDict["citylist"] as? [[String: Any]] {
                var cities: [TFYSwiftCitylistModel] = []
                
                for (cityIndex, cityDict) in cityList.enumerated() {
                    let city = TFYSwiftCitylistModel(
                        code: cityDict["code"] as? String ?? "",
                        name: cityDict["name"] as? String ?? "",
                        index: cityIndex
                    )
                    
                    // 解析区域数据
                    if let areaList = cityDict["arealist"] as? [[String: Any]] {
                        var areas: [TFYSwiftArealistModel] = []
                        
                        for (areaIndex, areaDict) in areaList.enumerated() {
                            let area = TFYSwiftArealistModel(
                                code: areaDict["code"] as? String ?? "",
                                name: areaDict["name"] as? String ?? "",
                                index: areaIndex
                            )
                            areas.append(area)
                        }
                        
                        city.arealist = areas
                    }
                    
                    cities.append(city)
                }
                
                province.citylist = cities
            }
            
            provinces.append(province)
        }
        
        return provinces
    }
    
    private func setupDefaultValues() {
        var selectedProvinceName = ""
        var selectedCityName = ""
        var selectedAreaName = ""
        
        if !defaultSelectedArray.isEmpty {
            if defaultSelectedArray.count > 0 {
                selectedProvinceName = defaultSelectedArray[0]
            }
            if defaultSelectedArray.count > 1 {
                selectedCityName = defaultSelectedArray[1]
            }
            if defaultSelectedArray.count > 2 {
                selectedAreaName = defaultSelectedArray[2]
            }
        }
        
        // 设置默认省份
        if let provinceIndex = provinceArray.firstIndex(where: { $0.name.contains(selectedProvinceName) }) {
            self.provinceIndex = provinceIndex
            selectedProvince = provinceArray[provinceIndex]
        } else {
            selectedProvince = provinceArray.first ?? TFYSwiftAddressModel()
        }
        
        // 设置默认城市
        if mode == .city || mode == .area {
            cityArray = getCityArray(for: provinceIndex)
            
            if let cityIndex = cityArray.firstIndex(where: { $0.name.contains(selectedCityName) }) {
                self.cityIndex = cityIndex
                selectedCity = cityArray[cityIndex]
            } else {
                selectedCity = cityArray.first ?? TFYSwiftCitylistModel()
            }
        }
        
        // 设置默认区域
        if mode == .area {
            areaArray = getAreaArray(for: provinceIndex, cityIndex: cityIndex)
            
            if let areaIndex = areaArray.firstIndex(where: { $0.name.contains(selectedAreaName) }) {
                self.areaIndex = areaIndex
                selectedArea = areaArray[areaIndex]
            } else {
                selectedArea = areaArray.first ?? TFYSwiftArealistModel()
            }
        }
    }
    
    private func scrollToSelectedRow() {
        var indexArray: [Int] = []
        
        switch mode {
        case .province:
            indexArray = [provinceIndex]
        case .city:
            indexArray = [provinceIndex, cityIndex]
        case .area:
            indexArray = [provinceIndex, cityIndex, areaIndex]
        }
        
        for (component, index) in indexArray.enumerated() {
            pickerView.selectRow(index, inComponent: component, animated: false)
        }
    }
    
    private func setupUI() {
        setTitle(mode.title)
        contentView.addSubview(pickerView)
        
        // 使用frame布局
        let pickerY = headerView.frame.maxY + 0.5
        let pickerHeight = contentView.frame.height - pickerY
        pickerView.frame = CGRect(x: 0, y: pickerY, width: contentView.frame.width, height: pickerHeight)
    }
    
    // MARK: - Helper Methods
    private func getCityArray(for provinceIndex: Int) -> [TFYSwiftCitylistModel] {
        guard provinceIndex < provinceArray.count else { return [] }
        return provinceArray[provinceIndex].citylist ?? []
    }
    
    private func getAreaArray(for provinceIndex: Int, cityIndex: Int) -> [TFYSwiftArealistModel] {
        guard provinceIndex < provinceArray.count,
              cityIndex < getCityArray(for: provinceIndex).count else { return [] }
        return getCityArray(for: provinceIndex)[cityIndex].arealist ?? []
    }
    
    // MARK: - Override Methods
    public override func handleCancel() {
        super.handleCancel()
        cancelBlock?()
    }
    
    public override func handleConfirm() {
        super.handleConfirm()
        handleResult()
    }
    
    private func handleResult() {
        resultBlock?(selectedProvince, selectedCity, selectedArea)
    }
    
    // MARK: - Public Configuration
    public func changeSeparatorLineColor(_ color: UIColor) {
        pickerView.subviews.forEach { view in
            if view.height < PickerLayout.headerHeight {
                view.backgroundColor = .clear
                view.layer.borderWidth = 0.5
                view.layer.borderColor = color.cgColor
                view.layer.masksToBounds = true
                view.layer.cornerRadius = 0
            } else {
                view.backgroundColor = .clear
            }
        }
    }
}

// MARK: - UIPickerViewDataSource
@available(iOS 15.0, *)
extension TFYSwiftAddressPickerView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch mode {
        case .province:
            return 1
        case .city:
            return 2
        case .area:
            return 3
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch mode {
        case .province:
            return provinceArray.count
        case .city:
            switch component {
            case 0:
                return provinceArray.count
            case 1:
                return cityArray.count
            default:
                return 0
            }
        case .area:
            switch component {
            case 0:
                return provinceArray.count
            case 1:
                return cityArray.count
            case 2:
                return areaArray.count
            default:
                return 0
            }
        }
    }
}

// MARK: - UIPickerViewDelegate
@available(iOS 15.0, *)
extension TFYSwiftAddressPickerView: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch mode {
        case .province:
            return provinceArray[row].name
        case .city:
            switch component {
            case 0:
                return provinceArray[row].name
            case 1:
                return cityArray[row].name
            default:
                return ""
            }
        case .area:
            switch component {
            case 0:
                return provinceArray[row].name
            case 1:
                return cityArray[row].name
            case 2:
                return areaArray[row].name
            default:
                return ""
            }
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = PickerColors.text
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        
        // 设置合适的高度和边距
        label.frame = CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 44)
        label.text = ""
        
        switch mode {
        case .province:
            label.text = provinceArray[row].name
        case .city:
            switch component {
            case 0:
                label.text = provinceArray[row].name
            case 1:
                label.text = cityArray[row].name
            default:
                label.text = ""
            }
        case .area:
            switch component {
            case 0:
                label.text = provinceArray[row].name
            case 1:
                label.text = cityArray[row].name
            case 2:
                label.text = areaArray[row].name
            default:
                label.text = ""
            }
        }
        
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch mode {
        case .province:
            provinceIndex = row
            selectedProvince = provinceArray[row]
            
        case .city:
            switch component {
            case 0:
                provinceIndex = row
                selectedProvince = provinceArray[row]
                cityArray = getCityArray(for: provinceIndex)
                cityIndex = 0
                selectedCity = cityArray.first ?? TFYSwiftCitylistModel()
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: false)
                
            case 1:
                cityIndex = row
                selectedCity = cityArray[row]
            default:
                break
            }
            
        case .area:
            switch component {
            case 0:
                provinceIndex = row
                selectedProvince = provinceArray[row]
                cityArray = getCityArray(for: provinceIndex)
                cityIndex = 0
                selectedCity = cityArray.first ?? TFYSwiftCitylistModel()
                areaArray = getAreaArray(for: provinceIndex, cityIndex: cityIndex)
                areaIndex = 0
                selectedArea = areaArray.first ?? TFYSwiftArealistModel()
                pickerView.reloadComponent(1)
                pickerView.reloadComponent(2)
                pickerView.selectRow(0, inComponent: 1, animated: false)
                pickerView.selectRow(0, inComponent: 2, animated: false)
                
            case 1:
                cityIndex = row
                selectedCity = cityArray[row]
                areaArray = getAreaArray(for: provinceIndex, cityIndex: cityIndex)
                areaIndex = 0
                selectedArea = areaArray.first ?? TFYSwiftArealistModel()
                pickerView.reloadComponent(2)
                pickerView.selectRow(0, inComponent: 2, animated: false)
                
            case 2:
                areaIndex = row
                selectedArea = areaArray[row]
            default:
                break
            }
        }
        
        if isAutoSelect {
            handleResult()
        }
    }
}

// MARK: - Legacy Support
@available(iOS 15.0, *)
public extension TFYSwiftAddressPickerView {
    static func showAddressPickerWithTitle(
        showType: TFYSwiftAddressPickerMode = .area,
        defaultSelected: [String],
        isAutoSelect: Bool,
        resultBlock: @escaping AddressPickerResultBlock,
        cancelBlock: @escaping AddressPickerCancelBlock
    ) {
        show(
            mode: showType,
            defaultSelected: defaultSelected,
            isAutoSelect: isAutoSelect,
            result: resultBlock,
            cancel: cancelBlock
        )
    }
}
