//
//  TFYSwiftDatePickerView.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/17.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import UIKit

public enum TFYSwiftDatePickerMode:Int {
    /// 系统模式 HH:mm
    case TFYSwiftDatePickerModeTime = 0
    /// 系统模式 yyy-MM-dd
    case TFYSwiftDatePickerModeDate = 1
    /// 系统模式 yyyy-MM-dd HH:mm
    case TFYSwiftDatePickerModeDateAndTime = 2
    /// 系统模式 HH:mm
    case TFYSwiftDatePickerModeCountDownTimer = 3
    /// 自定义模式 yyyy-MM-dd HH:mm:ss
    case TFYSwiftDatePickerModeYMDHMS = 4
    /// 自定义模式 yyyy-MM-dd HH:mm
    case TFYSwiftDatePickerModeYMDHM = 5
    /// 自定义模式 MM-dd HH:mm
    case TFYSwiftDatePickerModeMDHM = 6
    /// 自定义模式 yyyy-MM-dd
    case TFYSwiftDatePickerModeYMD = 7
    /// 自定义模式yyyy-MM
    case TFYSwiftDatePickerModeYM = 8
    /// 自定义模式 yyyy
    case TFYSwiftDatePickerModeY = 9
    /// 自定义模式 MM-dd
    case TFYSwiftDatePickerModeMD = 10
    /// 自定义模式 HH:mm
    case TFYSwiftDatePickerModeHM = 11
}

enum TFYSwiftDatePickerStyle:Int {
    case TFYSwiftDatePickerStyleSystem = 1
    case TFYSwiftDatePickerStyleCustom = 2
}

typealias dateresultBlock = (_ textselectValue: String) -> Void
typealias datecancelBlock = () -> Void

class TFYSwiftDatePickerView: TFYSwiftPickerBaseView {
    var dateresultBlock:dateresultBlock?
    var datecancelBlock:datecancelBlock?
    
    var yearIndex:Int = 0
    var monthIndex:Int = 0
    var dayIndex:Int = 0
    var hourIndex:Int = 0
    var minuteIndex:Int = 0
    var secondIndex:Int = 0
    
    var isAutoSelect:Bool = false
    
    var yearArr:[Int] = []
    var monthArr:[Int] = []
    var dayArr:[Int] = []
    var hourArr:[Int] = []
    var minuteArr:[Int] = []
    var secondArr:[Int] = []
    
    var showType:TFYSwiftDatePickerMode?
    var style:TFYSwiftDatePickerStyle = .TFYSwiftDatePickerStyleCustom
    var datePickerMode:UIDatePicker.Mode = .time
    
    
    var minLimitDate:Date? = Date.distantPast
    var maxLimitDate:Date? = Date.distantFuture
    var selectDate:Date?
    
    var selectDateFormatter:String = ""
    
    lazy var pickerView: UIPickerView = {
        let pickView = UIPickerView(frame: CGRect(x: 0, y: kPickerTopViewHeight+0.5, width: self.alertView.kPickerWidth, height: self.alertView.kPickerHeight-kPickerTopViewHeight))
        pickView.backgroundColor = kPickerTheneColor
        pickView.delegate = self
        pickView.dataSource = self
        pickView.showsSelectionIndicator = true
        return pickView
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePick = UIDatePicker(frame: CGRect(x: 0, y: kPickerTopViewHeight+0.5, width: self.alertView.kPickerWidth, height: self.alertView.kPickerHeight-kPickerTopViewHeight))
        datePick.backgroundColor = .white
        datePick.locale = Locale(identifier: "zh")
        if #available(iOS 13.4, *) {
            datePick.preferredDatePickerStyle = .wheels
        }
        datePick.datePickerMode = self.datePickerMode
        if (self.minLimitDate != nil) {
            datePick.minimumDate = self.minLimitDate
        }
        if (self.maxLimitDate != nil) {
            datePick.maximumDate = self.maxLimitDate
        }
        datePick.addTarget(self, action: #selector(didSelectValueChanged), for: .valueChanged)
        return datePick
    }()

    static func showDatePickerWithTitle(
        title:String,
        dateType:TFYSwiftDatePickerMode,
        defaultSelValue:String,
        minDate:Date = Date.distantPast,
        maxDate:Date = Date.distantFuture,
        isAutoSelect:Bool,
        resultBlock:@escaping (_ textselectValue: String) -> Void,
        cancelBlock:@escaping () ->Void) {
            
            let datePickerView:TFYSwiftDatePickerView = TFYSwiftDatePickerView(title: title, dateType: dateType, defaultSelValue: defaultSelValue, minDate: minDate, maxDate: maxDate, isAutoSelect: isAutoSelect, resultBlock: resultBlock, cancelBlock: cancelBlock)
            datePickerView.showWithAnimation()
        }
    
    init(
        title:String,
        dateType:TFYSwiftDatePickerMode,
        defaultSelValue:String,
        minDate:Date = Date.distantPast,
        maxDate:Date = Date.distantFuture,
        isAutoSelect:Bool,
        resultBlock:@escaping (_ textselectValue: String) -> Void,
        cancelBlock:@escaping () ->Void) {
        super.init(frame: CGRect.zero)
        
            self.titleLabel.text = title
            self.isAutoSelect = isAutoSelect
            self.dateresultBlock = resultBlock
            self.datecancelBlock = cancelBlock
            self.showType = dateType
            self.dataType(type: dateType)
            
            /// 最小日期限制 最大日期限制
            if minDate != Date.distantPast {
                self.minLimitDate = minDate
            } else {
                switch dateType {
                case .TFYSwiftDatePickerModeTime,.TFYSwiftDatePickerModeCountDownTimer,.TFYSwiftDatePickerModeHM:
                    self.minLimitDate = Date.pickerSetYear(hour: 0, minute: 0)
                case .TFYSwiftDatePickerModeMD:
                    self.minLimitDate = Date.pickerSetYear(month: 1, day: 1)
                case .TFYSwiftDatePickerModeMDHM:
                    self.minLimitDate = Date.pickerSetYear(month: 1, day: 1, hour: 0, minute: 0)
                default:
                    self.minLimitDate = Date.distantPast
                }
            }
            
            /// 最大日期限制
            if maxDate != Date.distantFuture {
                self.maxLimitDate = maxDate
            } else {
                switch dateType {
                case .TFYSwiftDatePickerModeTime,.TFYSwiftDatePickerModeCountDownTimer,.TFYSwiftDatePickerModeHM:
                    self.maxLimitDate = Date.pickerSetYear(hour: 23, minute: 59)
                case .TFYSwiftDatePickerModeMD:
                    self.maxLimitDate = Date.pickerSetYear(month: 12, day:31)
                case .TFYSwiftDatePickerModeMDHM:
                    self.maxLimitDate = Date.pickerSetYear(month: 12, day: 31, hour: 23, minute: 59)
                default:
                    self.maxLimitDate = Date.distantFuture
                }
            }
            
            /// 最小日期不能大于最大日期！
            let minMoreThanMax:Bool = self.minLimitDate!.pickerCompare(targetDate: self.maxLimitDate!, format: self.selectDateFormatter) == .orderedDescending
            if minMoreThanMax {
                self.minLimitDate = Date.distantPast
                self.maxLimitDate = Date.distantFuture
            }

            /// 默认选中的日期
            if !defaultSelValue.isEmpty {
                var defaultSelDate:Date? = Date.pickerGetDate(dateString: defaultSelValue, format: self.selectDateFormatter)
                if defaultSelDate == nil {
                    defaultSelDate = Date()
                }
                switch dateType {
                case .TFYSwiftDatePickerModeTime,.TFYSwiftDatePickerModeCountDownTimer,.TFYSwiftDatePickerModeHM:
                    self.selectDate = Date.pickerSetYear(hour: (defaultSelDate?.pickerHour())!, minute: (defaultSelDate?.pickerMinute())!)
                case .TFYSwiftDatePickerModeMD:
                    self.selectDate = Date.pickerSetYear(month: (defaultSelDate?.pickerMonth())!, day:(defaultSelDate?.pickerDay())!)
                case .TFYSwiftDatePickerModeMDHM:
                    self.selectDate = Date.pickerSetYear(month: (defaultSelDate?.pickerMonth())!, day: (defaultSelDate?.pickerDay())!, hour: (defaultSelDate?.pickerHour())!, minute: (defaultSelDate?.pickerMinute())!)
                default:
                    self.selectDate = defaultSelDate
                }
            } else {
                self.selectDate = Date()
            }
            
            /// 默认选择的日期不能小于最小日期！
            let selectLessThanMin:Bool = self.selectDate?.pickerCompare(targetDate: self.minLimitDate!, format: self.selectDateFormatter) == .orderedAscending
            if selectLessThanMin {
                self.selectDate = self.minLimitDate
            }
            
            /// 默认选择的日期不能大于最大日期！
            let selectMoreThanMax:Bool = self.selectDate?.pickerCompare(targetDate: self.maxLimitDate!, format: self.selectDateFormatter) == .orderedDescending
            if selectMoreThanMax {
                self.selectDate = self.maxLimitDate
            }
            
            if self.style == .TFYSwiftDatePickerStyleCustom {
                self.initDefaultDateArray(selectDate: self.selectDate!)
            }
            self.layoutUI()
            
            switch self.style {
            case .TFYSwiftDatePickerStyleSystem:
                self.alertView.addSubview(self.datePicker)
                self.datePicker.setDate(self.selectDate!, animated: false)
            case .TFYSwiftDatePickerStyleCustom:
                self.alertView.addSubview(self.pickerView)
                self.scrollToSelectDate(selectDate: self.selectDate!,dateType: dateType)
            }
            
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didTapBackgroundView() {
        super.didTapBackgroundView()
        if (datecancelBlock != nil) {
            datecancelBlock!()
        }
    }
    
    override func clickLeftBtn() {
        super.clickLeftBtn()
        if (datecancelBlock != nil) {
            datecancelBlock!()
        }
    }
    
    override func clickRightBtn() {
        super.clickRightBtn()
        let selectDateValue:String = Date.pickerGetDateString(date: selectDate!, format: selectDateFormatter)
        if (dateresultBlock != nil && !selectDateValue.isEmpty) {
            dateresultBlock!(selectDateValue)
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
    
    
    @objc func didSelectValueChanged(sender:UIDatePicker) {
        selectDate = sender.date
        
        let selectLessThanMin:Bool = selectDate?.pickerCompare(targetDate: minLimitDate!, format: selectDateFormatter) == .orderedAscending
        let selectMoreThanMax:Bool = selectDate?.pickerCompare(targetDate: maxLimitDate!, format: selectDateFormatter) == .orderedDescending
        if selectLessThanMin {
            selectDate = minLimitDate
        }
        if selectMoreThanMax {
            selectDate = maxLimitDate
        }
        datePicker.setDate(selectDate!, animated: true)
        if isAutoSelect {
            let selectDateValue:String = Date.pickerGetDateString(date: selectDate!, format: selectDateFormatter)
            if (dateresultBlock != nil && !selectDateValue.isEmpty) {
                dateresultBlock!(selectDateValue)
            }
        }
    }
    
    private func dataType(type:TFYSwiftDatePickerMode) {
        switch type {
        case .TFYSwiftDatePickerModeTime:
            self.selectDateFormatter = "HH:mm"
            self.style = .TFYSwiftDatePickerStyleSystem
            self.datePickerMode = .time
        case .TFYSwiftDatePickerModeDate:
            self.selectDateFormatter = "yyyy-MM-dd"
            self.style = .TFYSwiftDatePickerStyleSystem
            self.datePickerMode = .date
        case .TFYSwiftDatePickerModeDateAndTime:
            self.selectDateFormatter = "yyyy-MM-dd HH:mm"
            self.style = .TFYSwiftDatePickerStyleSystem
            self.datePickerMode = .dateAndTime
        case .TFYSwiftDatePickerModeCountDownTimer:
            self.selectDateFormatter = "HH:mm"
            self.style = .TFYSwiftDatePickerStyleSystem
            self.datePickerMode = .countDownTimer
        case .TFYSwiftDatePickerModeYMDHMS:
            self.selectDateFormatter = "yyyy-MM-dd HH:mm:ss"
            self.style = .TFYSwiftDatePickerStyleCustom
        case .TFYSwiftDatePickerModeYMDHM:
            self.selectDateFormatter = "yyyy-MM-dd HH:mm"
            self.style = .TFYSwiftDatePickerStyleCustom
        case .TFYSwiftDatePickerModeMDHM:
            self.selectDateFormatter = "MM-dd HH:mm"
            self.style = .TFYSwiftDatePickerStyleCustom
        case .TFYSwiftDatePickerModeYMD:
            self.selectDateFormatter = "yyyy-MM-dd"
            self.style = .TFYSwiftDatePickerStyleCustom
        case .TFYSwiftDatePickerModeYM:
            self.selectDateFormatter = "yyyy-MM"
            self.style = .TFYSwiftDatePickerStyleCustom
        case .TFYSwiftDatePickerModeY:
            self.selectDateFormatter = "yyyy"
            self.style = .TFYSwiftDatePickerStyleCustom
        case .TFYSwiftDatePickerModeMD:
            self.selectDateFormatter = "MM-dd"
            self.style = .TFYSwiftDatePickerStyleCustom
        case .TFYSwiftDatePickerModeHM:
            self.selectDateFormatter = "HH:mm"
            self.style = .TFYSwiftDatePickerStyleCustom
        }
    }
    
    private func scrollToSelectDate(selectDate:Date,dateType:TFYSwiftDatePickerMode) {
        let yearIndex:Int = selectDate.pickerYear() - self.minLimitDate!.pickerYear()
        let monthIndex:Int = selectDate.pickerMonth() - (yearIndex == 0 ? self.minLimitDate!.pickerMonth() : 1)
        let dayIndex:Int = selectDate.pickerDay() - ((yearIndex == 0 && monthIndex == 0) ? self.minLimitDate!.pickerDay() : 1)
        let hourIndex:Int = selectDate.pickerHour() - ((yearIndex == 0 && monthIndex == 0 && dayIndex == 0) ? self.minLimitDate!.pickerHour() : 0)
        let minuteIndex:Int = selectDate.pickerMinute() - ((yearIndex == 0 && monthIndex == 0 && dayIndex == 0 && hourIndex == 0) ? self.minLimitDate!.pickerMinute() : 0)
        let secondIndex:Int = selectDate.pickerSecond() - ((yearIndex == 0 && monthIndex == 0 && dayIndex == 0 && hourIndex == 0 && minuteIndex == 0) ? self.minLimitDate!.pickerSecond() : 0)
        self.yearIndex = yearIndex
        self.monthIndex = monthIndex
        self.dayIndex = dayIndex
        self.hourIndex = hourIndex
        self.minuteIndex = minuteIndex
        self.secondIndex = secondIndex
        
        var indexArr:[Int] = []
        if dateType == .TFYSwiftDatePickerModeYMDHMS {
            indexArr = [yearIndex,monthIndex,dayIndex,hourIndex,minuteIndex,secondIndex]
        } else if dateType == .TFYSwiftDatePickerModeYMDHM {
            indexArr = [yearIndex,monthIndex,dayIndex,hourIndex,minuteIndex]
        } else if dateType == .TFYSwiftDatePickerModeMDHM {
            indexArr = [monthIndex,dayIndex,hourIndex,minuteIndex]
        } else if dateType == .TFYSwiftDatePickerModeYMD {
            indexArr = [yearIndex,monthIndex,dayIndex]
        } else if dateType == .TFYSwiftDatePickerModeYM {
            indexArr = [yearIndex,monthIndex]
        } else if dateType == .TFYSwiftDatePickerModeY {
            indexArr = [yearIndex]
        } else if dateType == .TFYSwiftDatePickerModeMD {
            indexArr = [monthIndex,dayIndex]
        } else if dateType == .TFYSwiftDatePickerModeHM {
            indexArr = [hourIndex,minuteIndex]
        }
        for (i,value) in indexArr.enumerated() {
            self.pickerView.selectRow(value, inComponent: i, animated: false)
        }
    }
    
    private func initDefaultDateArray(selectDate:Date) {
        /// 获取年数据
        self.yearArr = self.setupYearArr()
        /// 获取月数据
        self.monthArr = self.setupMonthArr(year: selectDate.pickerYear())
        /// 获取天数
        self.dayArr = self.setupDayArr(year: selectDate.pickerYear(), month: selectDate.pickerMonth())
        /// 获取小时数据
        self.hourArr = self.setupHourArr(year: selectDate.pickerYear(), month: selectDate.pickerMonth(), day: selectDate.pickerDay())
        // 获取分钟数据
        self.minuteArr = self.setupMinuteArr(year: selectDate.pickerYear(), month: selectDate.pickerMonth(), day: selectDate.pickerDay(), hour: selectDate.pickerHour())
        // 获取妙
        self.secondArr = self.setupSecondArr(year: selectDate.pickerYear(), month: selectDate.pickerMonth(), day: selectDate.pickerDay(), hour: selectDate.pickerHour(), second: selectDate.pickerSecond())
        
    }
    
    // 获取年数据
    private func setupYearArr() -> [Int] {
        var tempArr:[Int] = []
        for i in self.minLimitDate!.pickerYear()...self.maxLimitDate!.pickerYear() {
            tempArr.append(i)
        }
        return tempArr
    }
    
    // 获取月数据
    private func setupMonthArr(year:Int) -> [Int] {
        var startMonth:Int = 1
        var endMonth:Int = 12
        if year == self.minLimitDate!.pickerYear() {
            startMonth = self.minLimitDate!.pickerMonth()
        }
        if year == self.maxLimitDate!.pickerYear() {
            endMonth = self.maxLimitDate!.pickerMonth()
        }
        var tempArr:[Int] = []
        for i in startMonth...endMonth {
            tempArr.append(i)
        }
        return tempArr
    }
    
    // 获取天数数据
    private func setupDayArr(year:Int,month:Int) -> [Int] {
        var startDay:Int = 1
        var endDay:Int = Date.pickerGetDaysInYear(year: year, month: month)
        if year == self.minLimitDate!.pickerYear() && month == self.minLimitDate!.pickerMonth() {
            startDay = self.minLimitDate!.pickerDay()
        }
        if year == self.maxLimitDate!.pickerYear() && month == self.maxLimitDate!.pickerMonth() {
            endDay = self.maxLimitDate!.pickerDay()
        }
        var tempArr:[Int] = []
        for i in startDay...endDay {
            tempArr.append(i)
        }
        return tempArr
    }
    
    // 获取小时数据
    private func setupHourArr(year:Int,month:Int,day:Int) -> [Int] {
        var startHour:Int = 0
        var endHour:Int = 23
        if year == self.minLimitDate!.pickerYear() && month == self.minLimitDate!.pickerMonth() && day == self.minLimitDate!.pickerDay() {
            startHour = self.minLimitDate!.pickerHour()
        }
        if year == self.maxLimitDate!.pickerYear() && month == self.maxLimitDate!.pickerMonth() && day == self.maxLimitDate!.pickerDay() {
            endHour = self.maxLimitDate!.pickerHour()
        }
        var tempArr:[Int] = []
        for i in startHour...endHour {
            tempArr.append(i)
        }
        return tempArr
    }
    
    // 获取分钟数据
    private func setupMinuteArr(year:Int,month:Int,day:Int,hour:Int) -> [Int] {
        var startMinute:Int = 0
        var endMinute:Int = 59
        if year == self.minLimitDate!.pickerYear() && month == self.minLimitDate!.pickerMonth() && day == self.minLimitDate!.pickerDay() && hour == self.minLimitDate!.pickerHour(){
            startMinute = self.minLimitDate!.pickerMinute()
        }
        if year == self.maxLimitDate!.pickerYear() && month == self.maxLimitDate!.pickerMonth() && day == self.maxLimitDate!.pickerDay() && hour == self.maxLimitDate!.pickerHour() {
            endMinute = self.maxLimitDate!.pickerMinute()
        }
        var tempArr:[Int] = []
        for i in startMinute...endMinute {
            tempArr.append(i)
        }
        return tempArr
    }
    
    // 获取妙数据
    private func setupSecondArr(year:Int,month:Int,day:Int,hour:Int,second:Int) -> [Int] {
        var startMinute:Int = 0
        var endMinute:Int = 59
        if year == self.minLimitDate!.pickerYear() && month == self.minLimitDate!.pickerMonth() && day == self.minLimitDate!.pickerDay() && hour == self.minLimitDate!.pickerHour() && second == self.minLimitDate!.pickerSecond() {
            startMinute = self.minLimitDate!.pickerSecond()
        }
        if year == self.maxLimitDate!.pickerYear() && month == self.maxLimitDate!.pickerMonth() && day == self.maxLimitDate!.pickerDay() && hour == self.maxLimitDate!.pickerHour() && second == self.maxLimitDate!.pickerSecond() {
            endMinute = self.maxLimitDate!.pickerSecond()
        }
        var tempArr:[Int] = []
        for i in startMinute...endMinute {
            tempArr.append(i)
        }
        return tempArr
    }
}


extension TFYSwiftDatePickerView:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if self.showType == .TFYSwiftDatePickerModeYMDHMS {
            return 6
        } else if self.showType == .TFYSwiftDatePickerModeYMDHM {
            return 5
        } else if self.showType == .TFYSwiftDatePickerModeMDHM {
            return 4
        } else if self.showType == .TFYSwiftDatePickerModeYMD {
            return 3
        } else if self.showType == .TFYSwiftDatePickerModeYM {
            return 2
        } else if self.showType == .TFYSwiftDatePickerModeY {
            return 1
        } else if self.showType == .TFYSwiftDatePickerModeMD {
            return 2
        } else if self.showType == .TFYSwiftDatePickerModeHM {
            return 2
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rowsArr:[Int] = []
        if self.showType == .TFYSwiftDatePickerModeYMDHMS {
            rowsArr = [yearArr.count,monthArr.count,dayArr.count,hourArr.count,minuteArr.count,secondArr.count]
        } else if self.showType == .TFYSwiftDatePickerModeYMDHM {
            rowsArr = [yearArr.count,monthArr.count,dayArr.count,hourArr.count,minuteArr.count]
        } else if self.showType == .TFYSwiftDatePickerModeMDHM {
            rowsArr = [monthArr.count,dayArr.count,hourArr.count,minuteArr.count]
        } else if self.showType == .TFYSwiftDatePickerModeYMD {
            rowsArr = [yearArr.count,monthArr.count,dayArr.count]
        } else if self.showType == .TFYSwiftDatePickerModeYM {
            rowsArr = [yearArr.count,monthArr.count]
        } else if self.showType == .TFYSwiftDatePickerModeY {
            rowsArr = [yearArr.count]
        } else if self.showType == .TFYSwiftDatePickerModeMD {
            rowsArr = [monthArr.count,dayArr.count]
        } else if self.showType == .TFYSwiftDatePickerModeHM {
            rowsArr = [hourArr.count,minuteArr.count]
        }
        return rowsArr[component]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        self.changeSpearatorLineColor(lineColor: kPickerBorderColor)
        let pickView:TFYSwiftPickerShowBaseView = TFYSwiftPickerShowBaseView(frame: CGRect(x: 0, y: 0, width: self.pickerWidth(), height: 35))
        pickView.title = self.setDateLabelText(component: component, row: row)
        return pickView
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return kPickerSliderHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 获取滚动后选择的日期
        selectDate = self.getDidSelectedDate(component: component, row: row)
        if isAutoSelect {
            let selectDateValue:String = Date.pickerGetDateString(date: selectDate!, format: selectDateFormatter)
            if (dateresultBlock != nil && !selectDateValue.isEmpty) {
                dateresultBlock!(selectDateValue)
            }
        }
    }
    
    
    private func pickerWidth() -> CGFloat {
        var width:CGFloat = self.alertView.kPickerWidth
        if self.showType == .TFYSwiftDatePickerModeYMDHMS {
            width = self.alertView.kPickerWidth/CGFloat(6)
        } else if self.showType == .TFYSwiftDatePickerModeYMDHM {
            width = self.alertView.kPickerWidth/CGFloat(5)
        } else if self.showType == .TFYSwiftDatePickerModeMDHM {
            width = self.alertView.kPickerWidth/CGFloat(4)
        } else if self.showType == .TFYSwiftDatePickerModeYMD {
            width = self.alertView.kPickerWidth/CGFloat(3)
        } else if self.showType == .TFYSwiftDatePickerModeYM {
            width = self.alertView.kPickerWidth/CGFloat(2)
        } else if self.showType == .TFYSwiftDatePickerModeY {
            width = self.alertView.kPickerWidth/CGFloat(1)
        } else if self.showType == .TFYSwiftDatePickerModeMD {
            width = self.alertView.kPickerWidth/CGFloat(2)
        } else if self.showType == .TFYSwiftDatePickerModeHM {
            width = self.alertView.kPickerWidth/CGFloat(2)
        }
        return width
    }
    
    private func setDateLabelText(component:Int,row:Int) -> String {
        var title:String = ""
        if self.showType == .TFYSwiftDatePickerModeYMDHMS {
            if component == 0 {
                title = "\(yearArr[row])年"
            } else if component == 1 {
                title = "\(monthArr[row])月"
            } else if component == 2 {
                title = "\(dayArr[row])日"
            } else if component == 3 {
                title = "\(hourArr[row])时"
            } else if component == 4 {
                title = "\(minuteArr[row])分"
            } else if component == 5 {
                title = "\(secondArr[row])秒"
            }
        } else if self.showType == .TFYSwiftDatePickerModeYMDHM {
            if component == 0 {
                title = "\(yearArr[row])年"
            } else if component == 1 {
                title = "\(monthArr[row])月"
            } else if component == 2 {
                title = "\(dayArr[row])日"
            } else if component == 3 {
                title = "\(hourArr[row])时"
            } else if component == 4 {
                title = "\(minuteArr[row])分"
            }
        } else if self.showType == .TFYSwiftDatePickerModeMDHM {
            if component == 0 {
                title = "\(monthArr[row])月"
            } else if component == 1 {
                title = "\(dayArr[row])日"
            } else if component == 2 {
                title = "\(hourArr[row])时"
            } else if component == 3 {
                title = "\(secondArr[row])秒"
            }
        } else if self.showType == .TFYSwiftDatePickerModeYMD {
            if component == 0 {
                title = "\(yearArr[row])年"
            } else if component == 1 {
                title = "\(monthArr[row])月"
            } else if component == 2 {
                title = "\(dayArr[row])日"
            }
        } else if self.showType == .TFYSwiftDatePickerModeYM {
            if component == 0 {
                title = "\(yearArr[row])年"
            } else if component == 1 {
                title = "\(monthArr[row])月"
            }
        } else if self.showType == .TFYSwiftDatePickerModeY {
            if component == 0 {
                title = "\(yearArr[row])年"
            }
        } else if self.showType == .TFYSwiftDatePickerModeMD {
            if component == 0 {
                title = "\(monthArr[row])月"
            } else if component == 1 {
                title = "\(dayArr[row])日"
            }
        } else if self.showType == .TFYSwiftDatePickerModeHM {
            if component == 0 {
                title = "\(hourArr[row])时"
            } else if component == 1 {
                title = "\(minuteArr[row])分"
            }
        }
        return title
    }
    
    private func getDidSelectedDate(component:Int,row:Int) -> Date {
        var selectDateValue:String = ""
        if self.showType == .TFYSwiftDatePickerModeYMDHMS {
            if component == 0 {
                yearIndex = row
                self.updateDateArray()
                self.pickerView.reloadComponent(1)
                self.pickerView.reloadComponent(2)
                self.pickerView.reloadComponent(3)
                self.pickerView.reloadComponent(4)
                self.pickerView.reloadComponent(5)
            } else if component == 1 {
                monthIndex = row
                self.updateDateArray()
                self.pickerView.reloadComponent(2)
                self.pickerView.reloadComponent(3)
                self.pickerView.reloadComponent(4)
                self.pickerView.reloadComponent(5)
            } else if component == 2 {
                dayIndex = row
                self.updateDateArray()
                self.pickerView.reloadComponent(3)
                self.pickerView.reloadComponent(4)
                self.pickerView.reloadComponent(5)
            } else if component == 3 {
                hourIndex = row
                self.updateDateArray()
                self.pickerView.reloadComponent(4)
                self.pickerView.reloadComponent(5)
            } else if component == 4 {
                minuteIndex = row
                self.updateDateArray()
                self.pickerView.reloadComponent(5)
            } else if component == 5 {
                secondIndex = row
            }
            selectDateValue = "\(String(format: "%02ld", yearArr[yearIndex]))-\(String(format: "%02ld", monthArr[monthIndex]))-\(String(format: "%02ld", dayArr[dayIndex])) \(String(format: "%02ld", hourArr[hourIndex])):\(String(format: "%02ld", minuteArr[minuteIndex])):\(String(format: "%02ld", secondArr[secondIndex]))"
        } else if self.showType == .TFYSwiftDatePickerModeYMDHM {
            if component == 0 {
                yearIndex = row
                self.updateDateArray()
                self.pickerView.reloadComponent(1)
                self.pickerView.reloadComponent(2)
                self.pickerView.reloadComponent(3)
                self.pickerView.reloadComponent(4)
            } else if component == 1 {
                monthIndex = row
                self.updateDateArray()
                self.pickerView.reloadComponent(2)
                self.pickerView.reloadComponent(3)
                self.pickerView.reloadComponent(4)
            } else if component == 2 {
                dayIndex = row
                self.updateDateArray()
                self.pickerView.reloadComponent(3)
                self.pickerView.reloadComponent(4)
            } else if component == 3 {
                hourIndex = row
                self.updateDateArray()
                self.pickerView.reloadComponent(4)
            } else if component == 4 {
                minuteIndex = row
            }
            selectDateValue = "\(String(format: "%02ld", yearArr[yearIndex]))-\(String(format: "%02ld", monthArr[monthIndex]))-\(String(format: "%02ld", dayArr[dayIndex])) \(String(format: "%02ld", hourArr[hourIndex])):\(String(format: "%02ld", minuteArr[minuteIndex]))"
        } else if self.showType == .TFYSwiftDatePickerModeMDHM {
            if component == 0 {
                monthIndex = row
                self.updateDateArray()
                self.pickerView.reloadComponent(1)
                self.pickerView.reloadComponent(2)
                self.pickerView.reloadComponent(3)
            } else if component == 1 {
                dayIndex = row
                self.updateDateArray()
                self.pickerView.reloadComponent(2)
                self.pickerView.reloadComponent(3)
            } else if component == 2 {
                hourIndex = row
                self.updateDateArray()
                self.pickerView.reloadComponent(3)
            } else if component == 3 {
                minuteIndex = row
            }
            selectDateValue = "\(String(format: "%02ld", monthArr[monthIndex]))-\(String(format: "%02ld", dayArr[dayIndex])) \(String(format: "%02ld", hourArr[hourIndex])):\(String(format: "%02ld", minuteArr[minuteIndex]))"
        } else if self.showType == .TFYSwiftDatePickerModeYMD {
            if component == 0 {
                yearIndex = row
                self.updateDateArray()
                self.pickerView.reloadComponent(1)
                self.pickerView.reloadComponent(2)
            } else if component == 1 {
                monthIndex = row
                self.updateDateArray()
                self.pickerView.reloadComponent(2)
            } else if component == 2 {
                dayIndex = row
            }
            selectDateValue = "\(String(format: "%02ld", yearArr[yearIndex]))-\(String(format: "%02ld", monthArr[monthIndex]))-\(String(format: "%02ld", dayArr[dayIndex]))"
        } else if self.showType == .TFYSwiftDatePickerModeYM {
            if component == 0 {
                yearIndex = row
                self.updateDateArray()
                self.pickerView.reloadComponent(1)
            } else if component == 1 {
                monthIndex = row
            }
            selectDateValue = "\(String(format: "%02ld", yearArr[yearIndex]))-\(String(format: "%02ld", monthArr[monthIndex]))"
        } else if self.showType == .TFYSwiftDatePickerModeY {
            if component == 0 {
                yearIndex = row
            }
            selectDateValue = "\(String(format: "%02ld", yearArr[yearIndex]))"
        } else if self.showType == .TFYSwiftDatePickerModeMD {
            if component == 0 {
                monthIndex = row
                self.updateDateArray()
                self.pickerView.reloadComponent(1)
            } else if component == 1 {
                dayIndex = row
            }
            selectDateValue = "\(String(format: "%02ld", monthArr[monthIndex]))-\(String(format: "%02ld", dayArr[dayIndex]))"
        } else if self.showType == .TFYSwiftDatePickerModeHM {
            if component == 0 {
                hourIndex = row
                self.updateDateArray()
                self.pickerView.reloadComponent(1)
            } else if component == 1 {
                minuteIndex = row
            }
            selectDateValue = "\(String(format: "%02ld", hourArr[hourIndex])):\(String(format: "%02ld", minuteArr[minuteIndex]))"
        }
        return Date.pickerGetDate(dateString: selectDateValue, format: selectDateFormatter)
    }
     
    // 更新日期数据源数组
   private func updateDateArray() {
       let year:Int = yearArr[yearIndex]
       monthArr = self.setupMonthArr(year: year)
       monthIndex = (monthIndex > monthArr.count - 1) ? (monthArr.count - 1) : monthIndex
       
       let month:Int = monthArr[monthIndex]
       dayArr = self.setupDayArr(year: year, month: month)
       dayIndex = (dayIndex > dayArr.count - 1) ? (dayArr.count - 1) : dayIndex
       
       let day:Int = dayArr[dayIndex]
       hourArr = self.setupHourArr(year: year, month: month, day: day)
       hourIndex = (hourIndex > hourArr.count - 1) ? (hourArr.count - 1) : hourIndex
       
       let hour:Int = hourArr[hourIndex]
       minuteArr = self.setupMinuteArr(year: year, month: month, day: day, hour: hour)
       minuteIndex = (minuteIndex > minuteArr.count - 1) ? (minuteArr.count - 1) : minuteIndex
       
       let minute:Int = minuteArr[minuteIndex]
       secondArr = self.setupSecondArr(year: year, month: month, day: day, hour: hour, second: minute)
       secondIndex = (secondIndex > secondArr.count - 1) ? (secondArr.count - 1) : secondIndex
       
    }
}
