//
//  TFYSwiftStringPickerView.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/16.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import UIKit

enum TFYSwiftStringPickerMode:Int {
    case TFYSwiftStringPickerComponentSingle = 0
    case TFYSwiftStringPickerComponentMore = 1
}

typealias resultBlock = (_ textselectValue: Any) -> Void
typealias cancelBlock = () -> Void

class TFYSwiftStringPickerView: TFYSwiftPickerBaseView {
    
    var isDataSourceValid:Bool = false
    var isAutoSelect:Bool = false
    var type:TFYSwiftStringPickerMode = .TFYSwiftStringPickerComponentSingle
    var resultBlock:resultBlock?
    var cancelBlock:cancelBlock?
    var dataSourceSingleArr:[String] = []
    var dataSourceMoreArr:[[String]] = [[]]
    var defaultSelSingleValue:String = ""
    var selectValue:String = ""
    var defaultSelMoreValue:[String] = []
    var selectValueArr:[String] = []
    
    lazy var pickerView: UIPickerView = {
        let pickView = UIPickerView(frame: CGRect(x: 0, y: kPickerTopViewHeight+0.5, width: self.alertView.kPickerWidth, height: self.alertView.kPickerHeight-kPickerTopViewHeight))
        pickView.backgroundColor = kPickerTheneColor
        pickView.delegate = self
        pickView.dataSource = self
        pickView.showsSelectionIndicator = true
        return pickView
    }()
    
    static func showStringPickerWithTitle(
        title:String,
        dataArr:Any,
        defaultSelValue:Any,
        isAutoSelect:Bool,
        type:TFYSwiftStringPickerMode,
        resultBlock:@escaping (_ textselectValue: Any) -> Void,
        cancelBlock:@escaping () ->Void) {
        let strPickerView:TFYSwiftStringPickerView = TFYSwiftStringPickerView(title: title, dataArr: dataArr, defaultSelValue: defaultSelValue, isAutoSelect: isAutoSelect,type: type, resultBlock: resultBlock, cancelBlock: cancelBlock)
        if strPickerView.isDataSourceValid {
            strPickerView.showWithAnimation()
        }
    }

    init(
        title:String,
        dataArr:Any,
        defaultSelValue:Any,
        isAutoSelect:Bool,
        type:TFYSwiftStringPickerMode,
        resultBlock:@escaping (_ textselectValue: Any) -> Void,
        cancelBlock:@escaping () ->Void) {
            super.init(frame: CGRect.zero)
            
        self.titleLabel.text = title
        self.isAutoSelect = isAutoSelect
        self.resultBlock = resultBlock
        self.cancelBlock = cancelBlock
        self.isDataSourceValid = true
        self.type = type
        self.configDataSource(dataArr: dataArr, defaultSelValue: defaultSelValue)
        if isDataSourceValid {
            self.layoutUI()
            self.alertView.addSubview(self.pickerView)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didTapBackgroundView() {
        super.didTapBackgroundView()
        if (cancelBlock != nil) {
            cancelBlock!()
        }
    }
    
    override func clickLeftBtn() {
        super.clickLeftBtn()
        if (cancelBlock != nil) {
            cancelBlock!()
        }
    }
    
    override func clickRightBtn() {
        super.clickRightBtn()
        switch type {
        case .TFYSwiftStringPickerComponentSingle:
            if (resultBlock != nil && !selectValue.isEmpty) {
                resultBlock!(selectValue)
            }
        case .TFYSwiftStringPickerComponentMore:
            if (resultBlock != nil && selectValueArr.count > 0) {
                resultBlock!(selectValueArr)
            }
        }
    }
    
    func configDataSource(dataArr:Any,defaultSelValue:Any) {
        if dataArr is [Any] {
            if type == .TFYSwiftStringPickerComponentSingle {
                dataSourceSingleArr = dataArr as! [String]
                defaultSelSingleValue = defaultSelValue as! String
            } else if type == .TFYSwiftStringPickerComponentMore {
                dataSourceMoreArr = dataArr as! [[String]]
                defaultSelMoreValue = defaultSelValue as! [String]
            }
        }  else {
            isDataSourceValid = false
        }
    
        if type == .TFYSwiftStringPickerComponentSingle {
            if defaultSelValue is String && dataSourceSingleArr.contains(defaultSelSingleValue) {
                selectValue = defaultSelSingleValue
            } else {
                selectValue = dataSourceSingleArr.first!
            }
            let row = dataSourceSingleArr.firstIndex(of: selectValue)
            self.pickerView.selectRow(row!, inComponent: 0, animated: false)
        } else if type == .TFYSwiftStringPickerComponentMore {
            var tempArr:[String] = []
            for (i,_) in dataSourceMoreArr.enumerated() {
                var selValue:String = ""
                if defaultSelMoreValue.count > 0 && dataSourceMoreArr[i].contains(defaultSelMoreValue[i]) {
                    selValue = defaultSelMoreValue[i]
                    tempArr.append(selValue)
                } else {
                    tempArr.append(dataSourceMoreArr[i].first!)
                    selValue = dataSourceMoreArr[i].first!
                }
                let row = dataSourceMoreArr[i].firstIndex(of: selValue)!
                self.pickerView.selectRow(row, inComponent: i, animated: false)
            }
            selectValueArr = tempArr
        }
    }
    
    func changeSpearatorLineColor(lineColor:UIColor) {
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

extension TFYSwiftStringPickerView:UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch type {
        case .TFYSwiftStringPickerComponentSingle:
            return 1
        case .TFYSwiftStringPickerComponentMore:
            return dataSourceMoreArr.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch type {
        case .TFYSwiftStringPickerComponentSingle:
            return dataSourceSingleArr.count
        case .TFYSwiftStringPickerComponentMore:
            return dataSourceMoreArr[component].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return kPickerSliderHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        self.changeSpearatorLineColor(lineColor: kPickerBorderColor)
        var width:CGFloat = self.alertView.kPickerWidth
        if type == .TFYSwiftStringPickerComponentMore {
            width = self.alertView.kPickerWidth/CGFloat(dataSourceMoreArr.count)
        }
        let pickView:TFYSwiftPickerShowBaseView = TFYSwiftPickerShowBaseView(frame: CGRect(x: 0, y: 0, width: width, height: 35))
        if type == .TFYSwiftStringPickerComponentSingle {
            pickView.title = dataSourceSingleArr[row]
        } else if type == .TFYSwiftStringPickerComponentMore {
            pickView.title = dataSourceMoreArr[component][row]
        }
        return pickView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch type {
        case .TFYSwiftStringPickerComponentSingle:
            selectValue = dataSourceSingleArr[row]
            if isAutoSelect {
                if (resultBlock != nil) {
                    resultBlock!(selectValue)
                }
            }
        case .TFYSwiftStringPickerComponentMore:
            var tempArr:[String] = []
            for (i,_) in dataSourceMoreArr.enumerated() {
                if i == component {
                    tempArr.append(dataSourceMoreArr[component][row])
                } else {
                    tempArr.append(selectValueArr[i])
                }
            }
            selectValueArr = tempArr
            if isAutoSelect {
                if (resultBlock != nil) {
                    resultBlock!(selectValueArr)
                }
            }
        }
    }
}
