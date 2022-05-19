//
//  TFYSwiftAddressPickerView.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/18.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import UIKit

enum TFYSwiftAddressPickerMode:Int {
    /// 只显示省
    case  TFYSwiftAddressPickerModeProvince = 0
    /// 显示省市
    case TFYSwiftAddressPickerModeCity = 1
    /// 显示省市区（默认）
    case TFYSwiftAddressPickerModeArea = 2
}

typealias addressResultBlock = (_ provinceModel: TFYSwiftAddressModel,_ cityModel:TFYSwiftCitylistModel,_ areaModel:TFYSwiftArealistModel) -> Void
typealias addressCancelBlock = () -> Void

class TFYSwiftAddressPickerView: TFYSwiftPickerBaseView {

    var addressResultBlock:addressResultBlock?
    var addressCancelBlock:addressCancelBlock?
    var isDataSourceValid:Bool = false
    var isAutoSelect:Bool = false
    var provinceIndex:Int = 0
    var cityIndex:Int = 0
    var areaIndex:Int = 0
    var selectProvinceModel:TFYSwiftAddressModel = TFYSwiftAddressModel()
    var selectCityModel:TFYSwiftCitylistModel = TFYSwiftCitylistModel()
    var selectAreaModel:TFYSwiftArealistModel = TFYSwiftArealistModel()
    
    var provinceModelArr:[TFYSwiftAddressModel] = []
    var cityModelArr:[TFYSwiftCitylistModel] = []
    var areaModelArr:[TFYSwiftArealistModel] = []
    
    var showType:TFYSwiftAddressPickerMode = .TFYSwiftAddressPickerModeArea
    
    
    var defaultSelectedArr:[String]? = []
    
    lazy var pickerView: UIPickerView = {
        let pickView = UIPickerView(frame: CGRect(x: 0, y: kPickerTopViewHeight+0.5, width: self.alertView.kPickerWidth, height: self.alertView.kPickerHeight-kPickerTopViewHeight))
        pickView.backgroundColor = kPickerTheneColor
        pickView.delegate = self
        pickView.dataSource = self
        pickView.showsSelectionIndicator = true
        return pickView
    }()
    
    static func showAddressPickerWithTitle(showType:TFYSwiftAddressPickerMode = .TFYSwiftAddressPickerModeArea,
                                           defaultSelected:[String],
                                           isAutoSelect:Bool,
                                           resultBlock:@escaping (_ provinceModel: TFYSwiftAddressModel,_ cityModel:TFYSwiftCitylistModel,_ areaModel:TFYSwiftArealistModel) -> Void,
                                           cancelBlock:@escaping () ->Void) {
        let addressView:TFYSwiftAddressPickerView = TFYSwiftAddressPickerView(showType: showType, defaultSelected: defaultSelected, isAutoSelect: isAutoSelect, resultBlock: resultBlock, cancelBlock: cancelBlock)
        if addressView.isDataSourceValid {
            addressView.showWithAnimation()
        }
    }
    
    init(
        showType:TFYSwiftAddressPickerMode = .TFYSwiftAddressPickerModeArea,
        defaultSelected:[String],
        isAutoSelect:Bool,
        resultBlock:@escaping (_ provinceModel: TFYSwiftAddressModel,_ cityModel:TFYSwiftCitylistModel,_ areaModel:TFYSwiftArealistModel) -> Void,
        cancelBlock:@escaping () ->Void) {
            super.init(frame: CGRect.zero)
            
        self.isAutoSelect = isAutoSelect
        self.addressResultBlock = resultBlock
        self.addressCancelBlock = cancelBlock
        self.isDataSourceValid = true
        self.defaultSelectedArr = defaultSelected
        self.showType = showType
        self.loadData()
            
        if isDataSourceValid {
            self.layoutUI()
            if showType == .TFYSwiftAddressPickerModeProvince {
                self.titleLabel.text = "请选择省份"
            } else if showType == .TFYSwiftAddressPickerModeCity {
                self.titleLabel.text = "请选择城市"
            } else {
                self.titleLabel.text = "请选择地区"
            }
            self.alertView.addSubview(self.pickerView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didTapBackgroundView() {
        super.didTapBackgroundView()
        if (addressCancelBlock != nil) {
            addressCancelBlock!()
        }
    }
    
    override func clickLeftBtn() {
        super.clickLeftBtn()
        if (addressCancelBlock != nil) {
            addressCancelBlock!()
        }
    }
    
    override func clickRightBtn() {
        super.clickRightBtn()
        if (addressResultBlock != nil) {
            addressResultBlock!(selectProvinceModel,selectCityModel,selectAreaModel)
        }
    }
    
    private func loadData() {
        let dataArr:[[String:Any]] = kPickerGetJSON(name: "TFYSwiftCityData")
        isDataSourceValid = (dataArr.count == 0) ? false : true
        var provinceModelArr:[TFYSwiftAddressModel] = []
        for (index , itemDict) in dataArr.enumerated() {
            let proviveModel:TFYSwiftAddressModel = TFYSwiftAddressModel()
            proviveModel.code = itemDict["code"] as! String
            proviveModel.name = itemDict["name"] as! String
            proviveModel.index = index
            var cityModelArr:[TFYSwiftCitylistModel] = []
            let citylist:[[String:Any]] = itemDict["citylist"] as! [[String:Any]]
            for (index2 , itemDict2) in citylist.enumerated() {
                let cityModel:TFYSwiftCitylistModel = TFYSwiftCitylistModel()
                cityModel.code = itemDict2["code"] as! String
                cityModel.name = itemDict2["name"] as! String
                cityModel.index = index2
                var areaModelArr:[TFYSwiftArealistModel] = []
                let arealist:[[String:Any]] = itemDict2["arealist"] as! [[String:Any]]
                for (index3 , itemDict3) in arealist.enumerated() {
                    let areaModel:TFYSwiftArealistModel = TFYSwiftArealistModel()
                    areaModel.code = itemDict3["code"] as! String
                    areaModel.name = itemDict3["name"] as! String
                    areaModel.index = index3
                    areaModelArr.append(areaModel)
                }
                cityModel.arealist = areaModelArr
                cityModelArr.append(cityModel)
            }
            proviveModel.citylist = cityModelArr
            provinceModelArr.append(proviveModel)
        }
        self.provinceModelArr = provinceModelArr
        
        self.setupDefaultValue(dataArr: provinceModelArr)
        
        self.scrollToRow(provinceIndex: provinceIndex, cityIndex: cityIndex, areaIndex: areaIndex)
    }
    
    /// 设置默认值
    private func setupDefaultValue(dataArr:[TFYSwiftAddressModel]) {
        var selectProvinceName:String = ""
        var selectCityName:String = ""
        var selectAreaName:String = ""
        if defaultSelectedArr != nil {
            if defaultSelectedArr!.count > 0 {
                selectProvinceName = defaultSelectedArr!.first!
            }
            if defaultSelectedArr!.count > 1 {
                selectCityName = defaultSelectedArr![1]
            }
            if defaultSelectedArr!.count > 2 {
                selectAreaName = defaultSelectedArr!.last!
            }
        }
        
        for (idx , obj) in dataArr.enumerated() {
            let model:TFYSwiftAddressModel = obj
            if model.name.contains(selectProvinceName) {
                provinceIndex = idx
                selectProvinceModel = model
                break
            } else {
                if idx == provinceModelArr.count - 1 {
                    provinceIndex = 0
                    selectProvinceModel = dataArr.first!
                }
            }
        }
        
        if showType == .TFYSwiftAddressPickerModeCity || showType == .TFYSwiftAddressPickerModeArea {
            cityModelArr = self.getCityModelArray(provinceIndex: provinceIndex)
            for (idx,obj) in cityModelArr.enumerated() {
                let cityModel:TFYSwiftCitylistModel = obj
                if cityModel.name.contains(selectCityName) {
                    cityIndex = idx
                    selectCityModel = cityModel
                    break
                } else {
                    if idx == cityModelArr.count - 1 {
                        cityIndex = 0
                        selectCityModel = cityModelArr.first!
                    }
                }
            }
        }
        
        if showType == .TFYSwiftAddressPickerModeArea {
            areaModelArr = self.getAreaModelArray(provinceIndex: provinceIndex, cityIndex: cityIndex)
            for (idx,obj) in areaModelArr.enumerated() {
                let areaModel:TFYSwiftArealistModel = obj
                if areaModel.name.contains(selectAreaName) {
                    areaIndex = idx
                    selectAreaModel = areaModel
                    break
                } else {
                    if idx == cityModelArr.count - 1 {
                        areaIndex = 0
                        selectAreaModel = areaModelArr.first!
                    }
                }
            }
        }
    }
    
    /// 根据 省索引 获取 城市模型数组
    private func getCityModelArray(provinceIndex:Int) -> [TFYSwiftCitylistModel] {
        let provinceModel:TFYSwiftAddressModel = provinceModelArr[provinceIndex]
        return provinceModel.citylist!
    }
    
    /// 根据 省索引和城市索引 获取 区域模型数组
    private func getAreaModelArray(provinceIndex:Int,cityIndex:Int) -> [TFYSwiftArealistModel] {
        let provinceModel:TFYSwiftAddressModel = provinceModelArr[provinceIndex]
        let cityModel:TFYSwiftCitylistModel = provinceModel.citylist![cityIndex]
        return cityModel.arealist!
    }
    
    /// 滚动到指定行
    private func scrollToRow(provinceIndex:Int,cityIndex:Int,areaIndex:Int) {
        if showType == .TFYSwiftAddressPickerModeProvince {
            self.pickerView.selectRow(provinceIndex, inComponent: 0, animated: true)
        } else if showType == .TFYSwiftAddressPickerModeCity {
            self.pickerView.selectRow(provinceIndex, inComponent: 0, animated: true)
            self.pickerView.selectRow(cityIndex, inComponent: 1, animated: true)
        } else if showType == .TFYSwiftAddressPickerModeArea {
            self.pickerView.selectRow(provinceIndex, inComponent: 0, animated: true)
            self.pickerView.selectRow(cityIndex, inComponent: 1, animated: true)
            self.pickerView.selectRow(areaIndex, inComponent: 2, animated: true)
        }
    }
    
   private func changeSpearatorLineColor(lineColor:UIColor) {
        self.pickerView.subviews.forEach { speartorView in
            if speartorView.kPickerHeight < kPickerTopViewHeight {
                speartorView.backgroundColor = .clear
                speartorView.layer.borderWidth = 0.5
                speartorView.layer.borderColor = lineColor.cgColor
                speartorView.layer.masksToBounds = true
                speartorView.layer.cornerRadius = 0
            } else {
                speartorView.backgroundColor = .clear
            }
        }
    }
    
}

extension TFYSwiftAddressPickerView: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch showType {
        case .TFYSwiftAddressPickerModeProvince:
            return 1
        case .TFYSwiftAddressPickerModeCity:
            return 2
        case .TFYSwiftAddressPickerModeArea:
            return 3
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return provinceModelArr.count
        }
        if component == 1 {
            return cityModelArr.count
        }
        if component == 2 {
            return areaModelArr.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return kPickerSliderHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        self.changeSpearatorLineColor(lineColor: kPickerBorderColor)
        let width:CGFloat = self.alertView.kPickerWidth/CGFloat(3)
        let pickView:TFYSwiftPickerShowBaseView = TFYSwiftPickerShowBaseView(frame: CGRect(x: 0, y: 0, width: width, height: 35))
        if component == 0 {
            pickView.title = provinceModelArr[row].name
        } else if component == 1 {
            pickView.title = cityModelArr[row].name
        } else if component == 2 {
            pickView.title = areaModelArr[row].name
        }
        return pickView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            provinceIndex = row
            switch showType {
            case .TFYSwiftAddressPickerModeProvince:
                selectProvinceModel = provinceModelArr[provinceIndex]
            case .TFYSwiftAddressPickerModeCity:
                cityModelArr = provinceModelArr[provinceIndex].citylist!
                self.pickerView.reloadComponent(1)
                self.pickerView.selectRow(0, inComponent: 1, animated: true)
                selectProvinceModel = provinceModelArr[provinceIndex]
                selectCityModel = cityModelArr.first!
            case .TFYSwiftAddressPickerModeArea:
                cityModelArr = provinceModelArr[provinceIndex].citylist!
                areaModelArr = provinceModelArr[provinceIndex].citylist![0].arealist!
                self.pickerView.reloadComponent(1)
                self.pickerView.selectRow(0, inComponent: 1, animated: true)
                self.pickerView.reloadComponent(2)
                self.pickerView.selectRow(0, inComponent: 2, animated: true)
                selectProvinceModel = provinceModelArr[provinceIndex]
                selectCityModel = cityModelArr.first!
                selectAreaModel = areaModelArr.first!
            }
        } else if component == 1 {
            cityIndex = row
            switch showType {
            case .TFYSwiftAddressPickerModeCity:
                  selectCityModel = cityModelArr[cityIndex]
            case .TFYSwiftAddressPickerModeArea:
                areaModelArr = provinceModelArr[provinceIndex].citylist![cityIndex].arealist!
                self.pickerView.reloadComponent(2)
                self.pickerView.selectRow(0, inComponent: 2, animated: true)
                selectCityModel = cityModelArr[cityIndex]
                selectAreaModel = areaModelArr.first!
            default:break
            }
            
        } else if component == 2 {
            areaIndex = row
            if showType == .TFYSwiftAddressPickerModeArea {
                selectAreaModel = areaModelArr[areaIndex]
            }
        }
        
        if isAutoSelect {
            if (addressResultBlock != nil) {
                addressResultBlock!(selectProvinceModel,selectCityModel,selectAreaModel)
            }
        }
    }
}
