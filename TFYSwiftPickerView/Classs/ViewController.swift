//
//  ViewController.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/16.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import UIKit

@available(iOS 15.0, *)
class ViewController: UIViewController {

    // MARK: - Properties
    private let dataArray: [DemoItem] = [
        // 字符串选择器演示
        DemoItem(title: "字符串选择器 - 单列", type: .stringSingle),
        DemoItem(title: "字符串选择器 - 多列", type: .stringMultiple),
        
        // 日期选择器演示 - 系统样式
        DemoItem(title: "日期选择器 - 时间 (系统)", type: .dateTime),
        DemoItem(title: "日期选择器 - 日期 (系统)", type: .dateDate),
        DemoItem(title: "日期选择器 - 日期时间 (系统)", type: .dateDateAndTime),
        DemoItem(title: "日期选择器 - 倒计时 (系统)", type: .dateCountDown),
        
        // 日期选择器演示 - 自定义样式
        DemoItem(title: "日期选择器 - 年月日时分秒", type: .dateYMDHMS),
        DemoItem(title: "日期选择器 - 年月日时分", type: .dateYMDHM),
        DemoItem(title: "日期选择器 - 月日时分", type: .dateMDHM),
        DemoItem(title: "日期选择器 - 年月日", type: .dateYMD),
        DemoItem(title: "日期选择器 - 年月", type: .dateYM),
        DemoItem(title: "日期选择器 - 年", type: .dateYear),
        DemoItem(title: "日期选择器 - 月日", type: .dateMD),
        DemoItem(title: "日期选择器 - 时分", type: .dateHM),
        DemoItem(title: "日期选择器 - 带范围限制", type: .dateWithRange),
        
        // 地址选择器演示
        DemoItem(title: "地址选择器 - 只显示省", type: .addressProvince),
        DemoItem(title: "地址选择器 - 显示省市", type: .addressCity),
        DemoItem(title: "地址选择器 - 显示省市区", type: .addressArea),
        DemoItem(title: "地址选择器 - 默认选中", type: .addressDefault),
        
        // 高级功能演示
        DemoItem(title: "自定义主题颜色", type: .customTheme),
        DemoItem(title: "自动选择模式", type: .autoSelect),
        DemoItem(title: "iPad适配演示", type: .iPadAdaptation)
    ]
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .insetGrouped)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 60
        return table
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120))
        view.backgroundColor = PickerColors.theme
        
        let titleLabel = UILabel()
        titleLabel.text = "TFYSwiftPickerView 优化版演示"
        titleLabel.font = UIFont.title(size: 20, weight: .bold)
        titleLabel.textColor = PickerColors.text
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "支持 iOS 15+ | 深色模式 | iPad适配"
        subtitleLabel.font = UIFont.caption(size: 14)
        subtitleLabel.textColor = PickerColors.text.withAlphaComponent(0.7)
        subtitleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = PickerColors.theme
        title = "选择器演示"
        
        view.addSubview(tableView)
        tableView.tableHeaderView = headerView
        
        // 添加导航栏按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "settings".localized,
            style: .plain,
            target: self,
            action: #selector(showSettings)
        )
        
        // 设置导航栏样式
        setupNavigationBarStyle()
    }
    
    private func setupNavigationBarStyle() {
        // 确保导航栏可见
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        // 设置导航栏标题样式
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: - Actions
    @objc private func showSettings() {
        let alert = UIAlertController(title: "settings".localized, message: "picker_config_options".localized, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "dark_mode".localized, style: .default) { _ in
            self.toggleDarkMode()
        })
        
        alert.addAction(UIAlertAction(title: "reset_theme".localized, style: .default) { _ in
            self.resetTheme()
        })
        
        // 添加语言切换选项
        alert.addAction(UIAlertAction(title: "切换语言", style: .default) { _ in
            self.showLanguageSelector()
        })
        
        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func toggleDarkMode() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.forEach { window in
            window.overrideUserInterfaceStyle = window.overrideUserInterfaceStyle == .dark ? .light : .dark
        }
    }
    
    private func resetTheme() {
        // 重置主题颜色
        tableView.reloadData()
    }
    
    private func showLanguageSelector() {
        let alert = UIAlertController(title: "选择语言", message: "Select Language", preferredStyle: .actionSheet)
        
        let languages = TFYSwiftLocalizationManager.shared.getSupportedLanguages()
        let currentLanguage = TFYSwiftLocalizationManager.shared.getCurrentLanguage()
        
        for language in languages {
            let displayName = TFYSwiftLocalizationManager.shared.getLanguageDisplayName(language)
            let isCurrent = language == currentLanguage
            let title = isCurrent ? "\(displayName) (当前)" : displayName
            
            alert.addAction(UIAlertAction(title: title, style: .default) { _ in
                TFYSwiftLocalizationManager.shared.setLanguage(language)
                self.refreshUI()
            })
        }
        
        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func refreshUI() {
        // 刷新UI以应用新语言
        title = "选择器演示"
        navigationItem.rightBarButtonItem?.title = "settings".localized
        tableView.reloadData()
    }
    
    // MARK: - Demo Methods
    private func showStringPickerDemo(_ type: DemoType) {
        switch type {
        case .stringSingle:
            let dataArray = ["男", "女", "宅男", "宅女", "其他", "程序员", "设计师", "产品经理"]
            TFYSwiftStringPickerView.show(
                title: "select_gender".localized,
                dataArray: dataArray,
                defaultSelectedValue: "宅男",
                isAutoSelect: false,
                mode: .single
            ) { selectedValue in
                self.showResult("string_picker_demo".localized, "selected".localized + ": \(selectedValue)")
            } cancel: {
                self.showResult("string_picker_demo".localized, "user_cancelled".localized)
            }
            
        case .stringMultiple:
            var dataArray: [[String]] = []
            var ages: [String] = []
            var weights: [String] = []
            
            for i in 18...80 {
                ages.append("\(i)岁")
            }
            for j in 30...150 {
                weights.append("\(j)kg")
            }
            dataArray = [ages, weights]
            
            TFYSwiftStringPickerView.show(
                title: "select_option".localized,
                dataArray: dataArray,
                defaultSelectedValue: ["25岁", "65kg"],
                isAutoSelect: false,
                mode: .multiple
            ) { selectedValue in
                if let array = selectedValue as? [String] {
                    self.showResult("multiple_picker_demo".localized, "selected".localized + ": \(array[0]), \(array[1])")
                }
            } cancel: {
                self.showResult("multiple_picker_demo".localized, "user_cancelled".localized)
            }
            
        default:
            break
        }
    }
    
    private func showDatePickerDemo(_ type: DemoType) {
        switch type {
        case .dateTime:
            TFYSwiftDatePickerView.show(
                title: "select_time".localized,
                mode: .time,
                defaultDate: "",
                isAutoSelect: false
            ) { selectedValue in
                self.showResult("time_picker_demo".localized, "selected".localized + ": \(selectedValue)")
            } cancel: {
                self.showResult("time_picker_demo".localized, "user_cancelled".localized)
            }
            
        case .dateDate:
            TFYSwiftDatePickerView.show(
                title: "select_date".localized,
                mode: .date,
                defaultDate: "",
                isAutoSelect: false
            ) { selectedValue in
                self.showResult("date_picker_demo".localized, "selected".localized + ": \(selectedValue)")
            } cancel: {
                self.showResult("date_picker_demo".localized, "user_cancelled".localized)
            }
            
        case .dateDateAndTime:
            TFYSwiftDatePickerView.show(
                title: "select_datetime".localized,
                mode: .dateAndTime,
                defaultDate: "",
                isAutoSelect: false
            ) { selectedValue in
                self.showResult("datetime_picker_demo".localized, "selected".localized + ": \(selectedValue)")
            } cancel: {
                self.showResult("datetime_picker_demo".localized, "user_cancelled".localized)
            }
            
        case .dateCountDown:
            TFYSwiftDatePickerView.show(
                title: "select_countdown".localized,
                mode: .countDownTimer,
                defaultDate: "",
                isAutoSelect: false
            ) { selectedValue in
                self.showResult("countdown_picker_demo".localized, "selected".localized + ": \(selectedValue)")
            } cancel: {
                self.showResult("countdown_picker_demo".localized, "user_cancelled".localized)
            }
            
        case .dateYMDHMS:
            TFYSwiftDatePickerView.show(
                title: "选择完整日期时间",
                mode: .ymdhms,
                defaultDate: "",
                isAutoSelect: false
            ) { selectedValue in
                self.showResult("完整日期时间选择器", "选中: \(selectedValue)")
            } cancel: {
                self.showResult("完整日期时间选择器", "用户取消")
            }
            
        case .dateYMDHM:
            TFYSwiftDatePickerView.show(
                title: "选择年月日时分",
                mode: .ymdhm,
                defaultDate: "",
                isAutoSelect: false
            ) { selectedValue in
                self.showResult("年月日时分选择器", "选中: \(selectedValue)")
            } cancel: {
                self.showResult("年月日时分选择器", "用户取消")
            }
            
        case .dateMDHM:
            TFYSwiftDatePickerView.show(
                title: "选择月日时分",
                mode: .mdhm,
                defaultDate: "",
                isAutoSelect: false
            ) { selectedValue in
                self.showResult("月日时分选择器", "选中: \(selectedValue)")
            } cancel: {
                self.showResult("月日时分选择器", "用户取消")
            }
            
        case .dateYMD:
            TFYSwiftDatePickerView.show(
                title: "选择年月日",
                mode: .ymd,
                defaultDate: "",
                isAutoSelect: false
            ) { selectedValue in
                self.showResult("年月日选择器", "选中: \(selectedValue)")
            } cancel: {
                self.showResult("年月日选择器", "用户取消")
            }
            
        case .dateYM:
            TFYSwiftDatePickerView.show(
                title: "选择年月",
                mode: .ym,
                defaultDate: "",
                isAutoSelect: false
            ) { selectedValue in
                self.showResult("年月选择器", "选中: \(selectedValue)")
            } cancel: {
                self.showResult("年月选择器", "用户取消")
            }
            
        case .dateYear:
            TFYSwiftDatePickerView.show(
                title: "选择年份",
                mode: .year,
                defaultDate: "",
                isAutoSelect: false
            ) { selectedValue in
                self.showResult("年份选择器", "选中: \(selectedValue)")
            } cancel: {
                self.showResult("年份选择器", "用户取消")
            }
            
        case .dateMD:
            TFYSwiftDatePickerView.show(
                title: "选择月日",
                mode: .md,
                defaultDate: "",
                isAutoSelect: false
            ) { selectedValue in
                self.showResult("月日选择器", "选中: \(selectedValue)")
            } cancel: {
                self.showResult("月日选择器", "用户取消")
            }
            
        case .dateHM:
            TFYSwiftDatePickerView.show(
                title: "选择时分",
                mode: .hm,
                defaultDate: "",
                isAutoSelect: false
            ) { selectedValue in
                self.showResult("时分选择器", "选中: \(selectedValue)")
            } cancel: {
                self.showResult("时分选择器", "用户取消")
            }
            
        case .dateWithRange:
            let minDate = Date.create(year: 2020, month: 1, day: 1)
            let maxDate = Date.create(year: 2030, month: 12, day: 31)
            
            TFYSwiftDatePickerView.show(
                title: "选择日期 (带范围限制)",
                mode: .ymd,
                defaultDate: "",
                minDate: minDate,
                maxDate: maxDate,
                isAutoSelect: false
            ) { selectedValue in
                self.showResult("带范围限制的日期选择器", "选中: \(selectedValue)")
            } cancel: {
                self.showResult("带范围限制的日期选择器", "用户取消")
            }
            
        default:
            break
        }
    }
    
    private func showAddressPickerDemo(_ type: DemoType) {
        switch type {
        case .addressProvince:
            TFYSwiftAddressPickerView.show(
                mode: .province,
                defaultSelected: [],
                isAutoSelect: false
            ) { province, city, area in
                self.showResult("省份选择器", "选中: \(province.name)")
            } cancel: {
                self.showResult("省份选择器", "用户取消")
            }
            
        case .addressCity:
            TFYSwiftAddressPickerView.show(
                mode: .city,
                defaultSelected: [],
                isAutoSelect: false
            ) { province, city, area in
                self.showResult("省市选择器", "选中: \(province.name) - \(city.name)")
            } cancel: {
                self.showResult("省市选择器", "用户取消")
            }
            
        case .addressArea:
            TFYSwiftAddressPickerView.show(
                mode: .area,
                defaultSelected: [],
                isAutoSelect: false
            ) { province, city, area in
                self.showResult("省市区选择器", "选中: \(province.name) - \(city.name) - \(area.name)")
            } cancel: {
                self.showResult("省市区选择器", "用户取消")
            }
            
        case .addressDefault:
            TFYSwiftAddressPickerView.show(
                mode: .area,
                defaultSelected: ["浙江省", "杭州市", "滨江区"],
                isAutoSelect: false
            ) { province, city, area in
                self.showResult("默认选中地址选择器", "选中: \(province.name) - \(city.name) - \(area.name)")
            } cancel: {
                self.showResult("默认选中地址选择器", "用户取消")
            }
            
        default:
            break
        }
    }
    
    private func showAdvancedDemo(_ type: DemoType) {
        switch type {
        case .customTheme:
            showCustomThemeDemo()
        case .autoSelect:
            showAutoSelectDemo()
        case .iPadAdaptation:
            showiPadAdaptationDemo()
        default:
            break
        }
    }
    
    private func showCustomThemeDemo() {
        // 这里可以展示自定义主题的功能
        let alert = UIAlertController(title: "自定义主题", message: "在代码中可以自定义选择器的颜色、字体等样式", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    private func showAutoSelectDemo() {
        TFYSwiftStringPickerView.show(
            title: "自动选择模式",
            dataArray: ["选项1", "选项2", "选项3", "选项4"],
            defaultSelectedValue: "选项1",
            isAutoSelect: true,
            mode: .single
        ) { selectedValue in
            self.showResult("自动选择模式", "选中: \(selectedValue)")
        } cancel: {
            self.showResult("自动选择模式", "用户取消")
        }
    }
    
    private func showiPadAdaptationDemo() {
        let alert = UIAlertController(title: "iPad适配", message: "在iPad上，选择器会自动调整大小和位置以适应大屏幕", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    private func showResult(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
@available(iOS 15.0, *)
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = dataArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.textLabel?.font = UIFont.body(size: 16)
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        
        // 根据类型设置不同的颜色
        switch item.type {
        case .stringSingle, .stringMultiple:
            cell.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        case .dateTime, .dateDate, .dateDateAndTime, .dateCountDown, .dateYMDHMS, .dateYMDHM, .dateMDHM, .dateYMD, .dateYM, .dateYear, .dateMD, .dateHM, .dateWithRange:
            cell.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        case .addressProvince, .addressCity, .addressArea, .addressDefault:
            cell.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.1)
        case .customTheme, .autoSelect, .iPadAdaptation:
            cell.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.1)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
@available(iOS 15.0, *)
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = dataArray[indexPath.row]
        
        switch item.type {
        case .stringSingle, .stringMultiple:
            showStringPickerDemo(item.type)
        case .dateTime, .dateDate, .dateDateAndTime, .dateCountDown, .dateYMDHMS, .dateYMDHM, .dateMDHM, .dateYMD, .dateYM, .dateYear, .dateMD, .dateHM, .dateWithRange:
            showDatePickerDemo(item.type)
        case .addressProvince, .addressCity, .addressArea, .addressDefault:
            showAddressPickerDemo(item.type)
        case .customTheme, .autoSelect, .iPadAdaptation:
            showAdvancedDemo(item.type)
        }
    }
}

// MARK: - Demo Models
@available(iOS 15.0, *)
struct DemoItem {
    let title: String
    let type: DemoType
}

@available(iOS 15.0, *)
enum DemoType {
    // 字符串选择器
    case stringSingle
    case stringMultiple
    
    // 日期选择器
    case dateTime
    case dateDate
    case dateDateAndTime
    case dateCountDown
    case dateYMDHMS
    case dateYMDHM
    case dateMDHM
    case dateYMD
    case dateYM
    case dateYear
    case dateMD
    case dateHM
    case dateWithRange
    
    // 地址选择器
    case addressProvince
    case addressCity
    case addressArea
    case addressDefault
    
    // 高级功能
    case customTheme
    case autoSelect
    case iPadAdaptation
}

// MARK: - Legacy Support
@available(iOS 15.0, *)
extension ViewController {
    // 保留旧版本的API调用方式，确保向后兼容
    private func showLegacyDemo() {
        // 这里可以展示旧版本的API调用方式
        let alert = UIAlertController(title: "向后兼容", message: "旧版本的API仍然可以正常使用", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}
