//
//  Date+Swiftpicker.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/17.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import Foundation
import UIKit

let unitFlags:NSCalendar.Unit = [.year,.month,.day,.weekOfMonth,.hour,.minute,.second,.weekday,.weekdayOrdinal]

extension Date {
    /// 获取日历单例对象
    static func pickercalendar() -> NSCalendar {
        let sharedCalendar:NSCalendar = NSCalendar.autoupdatingCurrent as NSCalendar
        return sharedCalendar
    }
    
    /// 获取指定日期的年份
    func pickerYear() -> Int {
        let components:DateComponents = Date.pickercalendar().components(unitFlags, from: self)
        return components.year ?? 0
    }
    
    /// 获取指定日期的月份
    func pickerMonth() -> Int {
        let components:DateComponents = Date.pickercalendar().components(unitFlags, from: self)
        return components.month ?? 0
    }
    
    /// 获取指定日期的天
    func pickerDay() -> Int {
        let components:DateComponents = Date.pickercalendar().components(unitFlags, from: self)
        return components.day ?? 0
    }
    
    /// 获取指定日期的小时
    func pickerHour() -> Int {
        let components:DateComponents = Date.pickercalendar().components(unitFlags, from: self)
        return components.hour ?? 0
    }
    
    /// 获取指定日期的分钟
    func pickerMinute() -> Int {
        let components:DateComponents = Date.pickercalendar().components(unitFlags, from: self)
        return components.minute ?? 0
    }
    
    /// 获取指定日期的秒
    func pickerSecond() -> Int {
        let components:DateComponents = Date.pickercalendar().components(unitFlags, from: self)
        return components.second ?? 0
    }
    
    /// 获取指定日期的星期
    func pickerWeekday() -> Int {
        let components:DateComponents = Date.pickercalendar().components(unitFlags, from: self)
        return components.weekday ?? 0
    }
    
    /// 除了使用 NSDateComponents 获取年月日等信息，还可以通过格式化日期获取日期的详细的信息 //////
    static func pickerSetYear(year:Int,month:Int,day:Int,hour:Int,minute:Int,second:Int) -> Self {
        let calendar:NSCalendar = Date.pickercalendar()
        var components:DateComponents = calendar.components(unitFlags, from: Date())
        if year >= 0 {
            components.year = year
        }
        if month >= 0 {
            components.month = month
        }
        if day >= 0 {
            components.day = day
        }
        if hour >= 0 {
            components.hour = hour
        }
        if minute >= 0 {
            components.minute = minute
        }
        if second >= 0 {
            components.second = second
        }
        let date:Date = calendar.date(from: components as DateComponents) ?? Date()
        return date
    }
    
    static func pickerSetYear(year:Int,month:Int,day:Int,hour:Int,minute:Int) -> Self {
        return pickerSetYear(year: year, month: month, day: day, hour: hour, minute: minute, second: -1)
    }
    
    static func pickerSetYear(year:Int,month:Int,day:Int) -> Self {
        return pickerSetYear(year: year, month: month, day: day, hour: -1, minute: -1, second: -1)
    }
    
    static func pickerSetYear(year:Int,month:Int) -> Self {
        return pickerSetYear(year: year, month: month, day: -1, hour: -1, minute: -1, second: -1)
    }
    
    static func pickerSetYear(year:Int) -> Self {
        return pickerSetYear(year: year, month: -1, day: -1, hour: -1, minute: -1, second: -1)
    }
    
    static func pickerSetYear(month:Int,day:Int,hour:Int,minute:Int) -> Self {
        return pickerSetYear(year: -1, month: month, day: day, hour: hour, minute: minute, second: -1)
    }
    
    static func pickerSetYear(month:Int,day:Int) -> Self {
        return pickerSetYear(year: -1, month: month, day: day, hour: -1, minute: -1, second: -1)
    }
    
    static func pickerSetYear(hour:Int,minute:Int) -> Self {
        return pickerSetYear(year: -1, month: -1, day: -1, hour: hour, minute: minute, second: -1)
    }
    
    /// 日期和字符串之间的转换：
    static func pickerGetDateString(date:Date,format:String) -> String {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    ///日期和字符串之间的转换：NSString --> NSDate
    static func pickerGetDate(dateString:String,format:String) -> Self {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
    /// 获取某个月的天数（通过年月求每月天数）
    static func pickerGetDaysInYear(year:Int,month:Int) -> Int {
        let isLeapYear:Bool = year % 4 == 0 ? (year % 100 == 0 ? (year % 400 == 0 ? true : false) : true) : false
        switch month {
            case 1,3,5,7,8,10,12:
                return 31
            case 4,6,9,11:
                return 30
            case 2:
                if isLeapYear {
                    return 29
                } else {
                    return 28
                }
            default:
                break;
        }
        return 0
    }
    
    /// 获取某个月的天数（通过年月求每月天数）
    static func pickerGetDaysInYear2(year:Int,month:Int) -> Int {
        let date:Date = Date.pickerGetDate(dateString: "\(year)-\(month)", format: "yyyy-MM")
        let calendar:NSCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        let range:NSRange = calendar.range(of: .day, in: .month, for: date)
        return range.length
    }
    
    /// 获取 日期加上/减去某天数后的新日期
    func pickerGetNewDate(date:Date,addDays:TimeInterval) -> Self {
        return self.addingTimeInterval(60 * 60 * 24 * addDays)
    }
    
    /// 比较两个时间大小（可以指定比较级数，即按指定格式进行比较）
    func pickerCompare(targetDate:Date,format:String) -> ComparisonResult {
        let dateString1:String = Date.pickerGetDateString(date: self, format: format)
        let dateString2:String = Date.pickerGetDateString(date: targetDate, format: format)
        let date1:Date = Date.pickerGetDate(dateString: dateString1, format: format)
        let date2:Date = Date.pickerGetDate(dateString: dateString2, format: format)
        if date1.compare(date2) == .orderedDescending {
            return .orderedDescending
        } else if date1.compare(date2) == .orderedAscending {
            return .orderedAscending
        } else {
            return .orderedSame
        }
    }
    
}
