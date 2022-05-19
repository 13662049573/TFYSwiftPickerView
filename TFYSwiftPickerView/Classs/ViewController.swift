//
//  ViewController.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/16.
//

import UIKit

class ViewController: UIViewController {

    let dataArr:[String] = ["普通选择器单个数组","普通选择器多个数组","系统时间选择器time","系统时间选择器Date","系统时间选择器AndTime","系统时间选择器DownTimer","自定义时间选择器YMDHMS","自定义时间选择器YMDHM","自定义时间选择器MDHM","自定义时间选择器YMD","自定义时间选择器YM","自定义时间选择器Y","自定义时间选择器MD","自定义时间选择器HM","自定义时间选择器最小值和最大值设置","城市选择只显示省","城市选择显示省市","城市选择显示省市区（默认）","自定义选择城市"]
    
    lazy var tableView: UITableView = {
        let tab = UITableView(frame: view.bounds, style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.rowHeight = 50
        tab.estimatedRowHeight = 100
        tab.estimatedSectionFooterHeight = 0.01
        tab.estimatedSectionHeaderHeight = 0.01
        return tab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        tableView.reloadData()
    }

}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier:String = "identifier\(indexPath.row)"
        
        let cell:TFYSwiftTableViewCell = TFYSwiftTableViewCell().cellFromCodeWithTableView(tableView: tableView,identifier: identifier)
        
        cell.textLabel?.text = dataArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let dataSingleArr:[String] = ["男","女","宅男","宅女","其他"]
            TFYSwiftStringPickerView.showStringPickerWithTitle(title: "选择", dataArr: dataSingleArr, defaultSelValue: "宅男", isAutoSelect: false,type: .TFYSwiftStringPickerComponentSingle, resultBlock: { textselectValue in
                print("========\(textselectValue)")
            }, cancelBlock: {
                print("取消")
            })
        } else if indexPath.row == 1 {
            var dataMoreArr:[[String]] = [[]]
            var dataMoreArrOne:[String] = []
            var dataMoreArrTwo:[String] = []
            for i in 30...150 {
                let name:String = "\(i)"
                dataMoreArrOne.append(name)
            }
            for j in 0...200 {
                let name:String = ".\(j)kg"
                dataMoreArrTwo.append(name)
            }
            dataMoreArr = [dataMoreArrOne,dataMoreArrTwo]
            
            TFYSwiftStringPickerView.showStringPickerWithTitle(title: "选择", dataArr: dataMoreArr, defaultSelValue: ["50",".50kg"], isAutoSelect: false,type: .TFYSwiftStringPickerComponentMore, resultBlock: { textselectValue in
                let dataArr:[String] = textselectValue as! [String]
                print("========\(String(describing: dataArr.first))======\(String(describing: dataArr.last))")
            }, cancelBlock: {
                print("取消")
            })
        } else if indexPath.row == 2 {
            TFYSwiftDatePickerView.showDatePickerWithTitle(title: "系统时间选择器", dateType: .TFYSwiftDatePickerModeTime, defaultSelValue: "", isAutoSelect: false) { textselectValue in
                print("========\(textselectValue)")
            } cancelBlock: {
                print("取消")
            }
        } else if indexPath.row == 3 {
            TFYSwiftDatePickerView.showDatePickerWithTitle(title: "系统时间选择器", dateType: .TFYSwiftDatePickerModeDate, defaultSelValue: "", isAutoSelect: false) { textselectValue in
                print("========\(textselectValue)")
            } cancelBlock: {
                print("取消")
            }
        } else if indexPath.row == 4 {
            TFYSwiftDatePickerView.showDatePickerWithTitle(title: "系统时间选择器", dateType: .TFYSwiftDatePickerModeDateAndTime, defaultSelValue: "", isAutoSelect: false) { textselectValue in
                print("========\(textselectValue)")
            } cancelBlock: {
                print("取消")
            }
        } else if indexPath.row == 5 {
            TFYSwiftDatePickerView.showDatePickerWithTitle(title: "系统时间选择器", dateType: .TFYSwiftDatePickerModeCountDownTimer, defaultSelValue: "", isAutoSelect: false) { textselectValue in
                print("========\(textselectValue)")
            } cancelBlock: {
                print("取消")
            }
        } else if indexPath.row == 6 {
            TFYSwiftDatePickerView.showDatePickerWithTitle(title: "自定义时间选择器", dateType: .TFYSwiftDatePickerModeYMDHMS, defaultSelValue: "", isAutoSelect: false) { textselectValue in
                print("========\(textselectValue)")
            } cancelBlock: {
                print("取消")
            }
        } else if indexPath.row == 7 {
            TFYSwiftDatePickerView.showDatePickerWithTitle(title: "自定义时间选择器", dateType: .TFYSwiftDatePickerModeYMDHM, defaultSelValue: "", isAutoSelect: false) { textselectValue in
                print("========\(textselectValue)")
            } cancelBlock: {
                print("取消")
            }
        } else if indexPath.row == 8 {
            TFYSwiftDatePickerView.showDatePickerWithTitle(title: "自定义时间选择器", dateType: .TFYSwiftDatePickerModeMDHM, defaultSelValue: "", isAutoSelect: false) { textselectValue in
                print("========\(textselectValue)")
            } cancelBlock: {
                print("取消")
            }
        } else if indexPath.row == 9 {
            TFYSwiftDatePickerView.showDatePickerWithTitle(title: "自定义时间选择器", dateType: .TFYSwiftDatePickerModeYMD, defaultSelValue: "", isAutoSelect: false) { textselectValue in
                print("========\(textselectValue)")
            } cancelBlock: {
                print("取消")
            }
        } else if indexPath.row == 10 {
            TFYSwiftDatePickerView.showDatePickerWithTitle(title: "自定义时间选择器", dateType: .TFYSwiftDatePickerModeYM, defaultSelValue: "", isAutoSelect: false) { textselectValue in
                print("========\(textselectValue)")
            } cancelBlock: {
                print("取消")
            }
        } else if indexPath.row == 11 {
            TFYSwiftDatePickerView.showDatePickerWithTitle(title: "自定义时间选择器", dateType: .TFYSwiftDatePickerModeY, defaultSelValue: "", isAutoSelect: false) { textselectValue in
                print("========\(textselectValue)")
            } cancelBlock: {
                print("取消")
            }
        } else if indexPath.row == 12 {
            TFYSwiftDatePickerView.showDatePickerWithTitle(title: "自定义时间选择器", dateType: .TFYSwiftDatePickerModeMD, defaultSelValue: "", isAutoSelect: false) { textselectValue in
                print("========\(textselectValue)")
            } cancelBlock: {
                print("取消")
            }
        } else if indexPath.row == 13 {
            TFYSwiftDatePickerView.showDatePickerWithTitle(title: "自定义时间选择器", dateType: .TFYSwiftDatePickerModeHM, defaultSelValue: "", isAutoSelect: false) { textselectValue in
                print("========\(textselectValue)")
            } cancelBlock: {
                print("取消")
            }
        } else if indexPath.row == 14 {
            let minDate:Date = Date.pickerSetYear(year: 2019, month: 1, day: 1, hour: 16, minute: 24)
            let maxDate:Date = Date.pickerSetYear(year: 2029, month: 1, day: 1, hour: 16, minute: 24)
            TFYSwiftDatePickerView.showDatePickerWithTitle(title: "自定义时间选择器", dateType: .TFYSwiftDatePickerModeYMDHM, defaultSelValue: "", minDate: minDate, maxDate: maxDate, isAutoSelect: false) { textselectValue in
                print("========\(textselectValue)")
            } cancelBlock: {
                print("取消")
            }
        } else if indexPath.row == 15 {
            TFYSwiftAddressPickerView.showAddressPickerWithTitle(showType: .TFYSwiftAddressPickerModeProvince, defaultSelected: [], isAutoSelect: false) { provinceModel, cityModel, areaModel in
                print("========\(provinceModel.name)=====\(cityModel.name)=======\(areaModel.name)")
            } cancelBlock: {
                print("取消")
            }
        } else if indexPath.row == 16 {
            TFYSwiftAddressPickerView.showAddressPickerWithTitle(showType: .TFYSwiftAddressPickerModeCity, defaultSelected: [], isAutoSelect: false) { provinceModel, cityModel, areaModel in
                print("========\(provinceModel.name)=====\(cityModel.name)=======\(areaModel.name)")
            } cancelBlock: {
                print("取消")
            }
        } else if indexPath.row == 17 {
            TFYSwiftAddressPickerView.showAddressPickerWithTitle(showType: .TFYSwiftAddressPickerModeArea, defaultSelected: [], isAutoSelect: false) { provinceModel, cityModel, areaModel in
                print("========\(provinceModel.name)=====\(cityModel.name)=======\(areaModel.name)")
            } cancelBlock: {
                print("取消")
            }
        } else if indexPath.row == 18 {
            TFYSwiftAddressPickerView.showAddressPickerWithTitle(defaultSelected: ["浙江省","杭州市","滨江区"], isAutoSelect: false) { provinceModel, cityModel, areaModel in
                print("========\(provinceModel.name)=====\(cityModel.name)=======\(areaModel.name)")
            } cancelBlock: {
                print("取消")
            }
        }
        
    }

}

extension UITableViewCell {
    
    func cellFromXibWithTableView(tableView:UITableView) -> Self {
        let className:String = NSStringFromClass(self.classForCoder)
        return self.cellFromXibTableView(tableView: tableView, xibName: className, identifer: className)
    }

    func cellFromXibWithTableView(tableView:UITableView,identifer:String) -> Self {
        let className:String = NSStringFromClass(self.classForCoder)
        return self.cellFromXibTableView(tableView: tableView, xibName: className, identifer: identifer)
    }

    func cellFromCodeWithTableView(tableView:UITableView) -> Self {
        let className:String = NSStringFromClass(self.classForCoder)
        return self.cellFromCodeWithTableView(tableView: tableView, identifier: className)
    }

    func cellFromXibTableView(tableView:UITableView,xibName:String,identifer:String) -> Self {

        var cell = tableView.dequeueReusableCell(withIdentifier: identifer)
        if cell == nil {
            let xibPath:String = Bundle.main.path(forResource: xibName, ofType: "nib") ?? ""
            if xibPath.isEmpty {
               cell = self.cellFromCodeWithTableView(tableView: tableView, identifier: identifer)
            }
            cell = Bundle.main.loadNibNamed(xibName, owner: nil, options: nil)?.last as? UITableViewCell
        }
        return self
    }

   func cellFromCodeWithTableView(tableView:UITableView,identifier:String) -> Self {
        let className:String = NSStringFromClass(self.classForCoder)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            let anyClass = NSClassFromString(className) as! UITableViewCell.Type
            cell = anyClass.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
        }
       return self
    }
}
