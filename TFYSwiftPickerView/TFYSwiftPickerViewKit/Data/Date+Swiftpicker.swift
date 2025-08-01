//
//  Date+Swiftpicker.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/17.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 15.0, *)
public extension Date {
    
    // MARK: - Calendar Constants
    private static let calendarUnitFlags: NSCalendar.Unit = [.year, .month, .day, .weekOfMonth, .hour, .minute, .second, .weekday, .weekdayOrdinal]
    
    // MARK: - Calendar Helper
    /// 获取日历单例对象
    static func calendar() -> Calendar {
        return Calendar.autoupdatingCurrent
    }
    
    // MARK: - Date Components
    /// 获取年份
    var year: Int {
        let components = Date.calendar().dateComponents([.year], from: self)
        return components.year ?? 0
    }
    
    /// 获取月份
    var month: Int {
        let components = Date.calendar().dateComponents([.month], from: self)
        return components.month ?? 0
    }
    
    /// 获取日期
    var day: Int {
        let components = Date.calendar().dateComponents([.day], from: self)
        return components.day ?? 0
    }
    
    /// 获取小时
    var hour: Int {
        let components = Date.calendar().dateComponents([.hour], from: self)
        return components.hour ?? 0
    }
    
    /// 获取分钟
    var minute: Int {
        let components = Date.calendar().dateComponents([.minute], from: self)
        return components.minute ?? 0
    }
    
    /// 获取秒
    var second: Int {
        let components = Date.calendar().dateComponents([.second], from: self)
        return components.second ?? 0
    }
    
    /// 获取星期
    var weekday: Int {
        let components = Date.calendar().dateComponents([.weekday], from: self)
        return components.weekday ?? 0
    }
    
    // MARK: - Date Creation
    /// 创建指定日期
    static func create(year: Int = -1, month: Int = -1, day: Int = -1, hour: Int = -1, minute: Int = -1, second: Int = -1) -> Date {
        var components = Date.calendar().dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        
        if year >= 0 { components.year = year }
        if month >= 0 { components.month = month }
        if day >= 0 { components.day = day }
        if hour >= 0 { components.hour = hour }
        if minute >= 0 { components.minute = minute }
        if second >= 0 { components.second = second }
        
        return Date.calendar().date(from: components) ?? Date()
    }
    
    /// 创建指定年月日的日期
    static func create(year: Int, month: Int, day: Int) -> Date {
        return create(year: year, month: month, day: day, hour: -1, minute: -1, second: -1)
    }
    
    /// 创建指定年月的日期
    static func create(year: Int, month: Int) -> Date {
        return create(year: year, month: month, day: -1, hour: -1, minute: -1, second: -1)
    }
    
    /// 创建指定年份的日期
    static func create(year: Int) -> Date {
        return create(year: year, month: -1, day: -1, hour: -1, minute: -1, second: -1)
    }
    
    /// 创建指定月日的日期
    static func create(month: Int, day: Int) -> Date {
        return create(year: -1, month: month, day: day, hour: -1, minute: -1, second: -1)
    }
    
    /// 创建指定时分秒的日期
    static func create(hour: Int, minute: Int, second: Int = -1) -> Date {
        return create(year: -1, month: -1, day: -1, hour: hour, minute: minute, second: second)
    }
    
    /// 创建指定时分的日期
    static func create(hour: Int, minute: Int) -> Date {
        return create(year: -1, month: -1, day: -1, hour: hour, minute: minute, second: -1)
    }
    
    // MARK: - Date Formatting
    /// 将日期转换为字符串
    static func format(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    /// 将字符串转换为日期
    static func parse(_ dateString: String, format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = format
        return formatter.date(from: dateString)
    }
    
    /// 格式化当前日期
    func format(_ format: String) -> String {
        return Date.format(self, format: format)
    }
    
    // MARK: - Date Calculations
    /// 获取指定年月的天数
    static func daysInMonth(year: Int, month: Int) -> Int {
        let calendar = Date.calendar()
        let date = create(year: year, month: month, day: 1)
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.count ?? 0
    }
    
    /// 判断是否为闰年
    static func isLeapYear(_ year: Int) -> Bool {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
    }
    
    /// 添加天数
    func addingDays(_ days: Int) -> Date {
        return addingTimeInterval(TimeInterval(days * 24 * 60 * 60))
    }
    
    /// 添加月数
    func addingMonths(_ months: Int) -> Date {
        let calendar = Date.calendar()
        var components = DateComponents()
        components.month = months
        return calendar.date(byAdding: components, to: self) ?? self
    }
    
    /// 添加年数
    func addingYears(_ years: Int) -> Date {
        let calendar = Date.calendar()
        var components = DateComponents()
        components.year = years
        return calendar.date(byAdding: components, to: self) ?? self
    }
    
    // MARK: - Date Comparison
    /// 比较两个日期
    func compare(to date: Date, format: String? = nil) -> ComparisonResult {
        if let format = format {
            let dateString1 = self.format(format)
            let dateString2 = date.format(format)
            let date1 = Date.parse(dateString1, format: format) ?? self
            let date2 = Date.parse(dateString2, format: format) ?? date
            return date1.compare(date2)
        } else {
            return self.compare(date)
        }
    }
    
    /// 检查是否早于指定日期
    func isBefore(_ date: Date, format: String? = nil) -> Bool {
        return compare(to: date, format: format) == .orderedAscending
    }
    
    /// 检查是否晚于指定日期
    func isAfter(_ date: Date, format: String? = nil) -> Bool {
        return compare(to: date, format: format) == .orderedDescending
    }
    
    /// 检查是否等于指定日期
    func isEqual(to date: Date, format: String? = nil) -> Bool {
        return compare(to: date, format: format) == .orderedSame
    }
    
    // MARK: - Date Range
    /// 获取日期范围
    static func dateRange(from startDate: Date, to endDate: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = currentDate.addingDays(1)
        }
        
        return dates
    }
    
    /// 获取月份的所有日期
    func daysInMonth() -> [Date] {
        let calendar = Date.calendar()
        let range = calendar.range(of: .day, in: .month, for: self)
        let days = range?.count ?? 0
        
        return (1...days).compactMap { day in
            calendar.date(bySetting: .day, value: day, of: self)
        }
    }
    
    // MARK: - Legacy Support
    static func pickercalendar() -> NSCalendar {
        return NSCalendar.autoupdatingCurrent as NSCalendar
    }
    
    func pickerYear() -> Int { return year }
    func pickerMonth() -> Int { return month }
    func pickerDay() -> Int { return day }
    func pickerHour() -> Int { return hour }
    func pickerMinute() -> Int { return minute }
    func pickerSecond() -> Int { return second }
    func pickerWeekday() -> Int { return weekday }
    
    static func pickerSetYear(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
        return create(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
    }
    
    static func pickerSetYear(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        return create(year: year, month: month, day: day, hour: hour, minute: minute)
    }
    
    static func pickerSetYear(year: Int, month: Int, day: Int) -> Date {
        return create(year: year, month: month, day: day)
    }
    
    static func pickerSetYear(year: Int, month: Int) -> Date {
        return create(year: year, month: month)
    }
    
    static func pickerSetYear(year: Int) -> Date {
        return create(year: year)
    }
    
    static func pickerSetYear(month: Int, day: Int, hour: Int, minute: Int) -> Date {
        return create(month: month, day: day, hour: hour, minute: minute)
    }
    
    static func pickerSetYear(month: Int, day: Int) -> Date {
        return create(month: month, day: day)
    }
    
    static func pickerSetYear(hour: Int, minute: Int) -> Date {
        return create(hour: hour, minute: minute)
    }
    
    static func pickerGetDateString(date: Date, format: String) -> String {
        return Date.format(date, format: format)
    }
    
    static func pickerGetDate(dateString: String, format: String) -> Date {
        return Date.parse(dateString, format: format) ?? Date()
    }
    
    static func pickerGetDaysInYear(year: Int, month: Int) -> Int {
        return Date.daysInMonth(year: year, month: month)
    }
    
    static func pickerGetDaysInYear2(year: Int, month: Int) -> Int {
        return Date.daysInMonth(year: year, month: month)
    }
    
    func pickerGetNewDate(date: Date, addDays: TimeInterval) -> Date {
        return addingTimeInterval(addDays * 24 * 60 * 60)
    }
    
    func pickerCompare(targetDate: Date, format: String) -> ComparisonResult {
        return compare(to: targetDate, format: format)
    }
}
