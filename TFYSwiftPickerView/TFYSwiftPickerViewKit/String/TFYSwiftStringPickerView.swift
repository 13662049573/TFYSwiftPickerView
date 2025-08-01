//
//  TFYSwiftStringPickerView.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/16.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import UIKit

@available(iOS 15.0, *)
public enum TFYSwiftStringPickerMode: Int, CaseIterable {
    case single = 0
    case multiple = 1
}

@available(iOS 15.0, *)
public typealias StringPickerResultBlock = (_ selectedValue: Any) -> Void
@available(iOS 15.0, *)
public typealias StringPickerCancelBlock = () -> Void

@available(iOS 15.0, *)
public class TFYSwiftStringPickerView: TFYSwiftPickerBaseView {
    
    // MARK: - Properties
    private var isDataSourceValid: Bool = false
    private var isAutoSelect: Bool = false
    private var mode: TFYSwiftStringPickerMode = .single
    private var resultBlock: StringPickerResultBlock?
    private var cancelBlock: StringPickerCancelBlock?
    
    // 单列数据
    private var singleDataArray: [String] = []
    private var defaultSingleValue: String = ""
    private var selectedSingleValue: String = ""
    
    // 多列数据
    private var multipleDataArray: [[String]] = [[]]
    private var defaultMultipleValue: [String] = []
    private var selectedMultipleValue: [String] = []
    
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
        title: String,
        dataArray: Any,
        defaultSelectedValue: Any,
        isAutoSelect: Bool = false,
        mode: TFYSwiftStringPickerMode = .single,
        result: @escaping StringPickerResultBlock,
        cancel: @escaping StringPickerCancelBlock
    ) {
        print("🔍 TFYSwiftStringPickerView.show() 被调用")
        print("📝 title: \(title)")
        print("📊 dataArray: \(dataArray)")
        
        let pickerView = TFYSwiftStringPickerView(
            title: title,
            dataArray: dataArray,
            defaultSelectedValue: defaultSelectedValue,
            isAutoSelect: isAutoSelect,
            mode: mode,
            result: result,
            cancel: cancel
        )
        
        print("✅ pickerView 创建成功，isDataSourceValid: \(pickerView.isDataSourceValid)")
        pickerView.show(animated: true)
    }
    
    // MARK: - Initialization
    private init(
        title: String,
        dataArray: Any,
        defaultSelectedValue: Any,
        isAutoSelect: Bool,
        mode: TFYSwiftStringPickerMode,
        result: @escaping StringPickerResultBlock,
        cancel: @escaping StringPickerCancelBlock
    ) {
        super.init(frame: .zero)
        
        self.setTitle(title)
        self.isAutoSelect = isAutoSelect
        self.resultBlock = result
        self.cancelBlock = cancel
        self.mode = mode
        
        configureDataSource(dataArray: dataArray, defaultSelectedValue: defaultSelectedValue)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup Methods
    private func configureDataSource(dataArray: Any, defaultSelectedValue: Any) {
        switch mode {
        case .single:
            if let stringArray = dataArray as? [String] {
                singleDataArray = stringArray
                defaultSingleValue = defaultSelectedValue as? String ?? ""
                isDataSourceValid = !stringArray.isEmpty
            } else {
                isDataSourceValid = false
            }
            
        case .multiple:
            if let nestedArray = dataArray as? [[String]] {
                multipleDataArray = nestedArray
                defaultMultipleValue = defaultSelectedValue as? [String] ?? []
                isDataSourceValid = !nestedArray.isEmpty && nestedArray.allSatisfy { !$0.isEmpty }
            } else {
                isDataSourceValid = false
            }
        }
        
        if isDataSourceValid {
            setupDefaultValues()
        }
    }
    
    private func setupDefaultValues() {
        switch mode {
        case .single:
            if !defaultSingleValue.isEmpty && singleDataArray.contains(defaultSingleValue) {
                selectedSingleValue = defaultSingleValue
            } else {
                selectedSingleValue = singleDataArray.first ?? ""
            }
            
            if let index = singleDataArray.firstIndex(of: selectedSingleValue) {
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            
        case .multiple:
            var tempArray: [String] = []
            
            for (i, componentArray) in multipleDataArray.enumerated() {
                var selectedValue = ""
                
                if i < defaultMultipleValue.count && componentArray.contains(defaultMultipleValue[i]) {
                    selectedValue = defaultMultipleValue[i]
                    tempArray.append(selectedValue)
                } else {
                    selectedValue = componentArray.first ?? ""
                    tempArray.append(selectedValue)
                }
                
                if let index = componentArray.firstIndex(of: selectedValue) {
                    pickerView.selectRow(index, inComponent: i, animated: false)
                }
            }
            
            selectedMultipleValue = tempArray
        }
    }
    
    private func setupUI() {
        contentView.addSubview(pickerView)
        
        // 使用frame布局
        let pickerY = headerView.frame.maxY + 0.5
        let pickerHeight = contentView.frame.height - pickerY
        pickerView.frame = CGRect(x: 0, y: pickerY, width: contentView.frame.width, height: pickerHeight)
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
        switch mode {
        case .single:
            if !selectedSingleValue.isEmpty {
                resultBlock?(selectedSingleValue)
            }
        case .multiple:
            if !selectedMultipleValue.isEmpty {
                resultBlock?(selectedMultipleValue)
            }
        }
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
extension TFYSwiftStringPickerView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch mode {
        case .single:
            return 1
        case .multiple:
            return multipleDataArray.count
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch mode {
        case .single:
            return singleDataArray.count
        case .multiple:
            return component < multipleDataArray.count ? multipleDataArray[component].count : 0
        }
    }
}

// MARK: - UIPickerViewDelegate
@available(iOS 15.0, *)
extension TFYSwiftStringPickerView: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch mode {
        case .single:
            return singleDataArray[row]
        case .multiple:
            guard component < multipleDataArray.count, row < multipleDataArray[component].count else {
                return ""
            }
            return multipleDataArray[component][row]
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
        case .single:
            label.text = singleDataArray[row]
        case .multiple:
            guard component < multipleDataArray.count, row < multipleDataArray[component].count else {
                label.text = ""
                return label
            }
            label.text = multipleDataArray[component][row]
        }
        
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch mode {
        case .single:
            selectedSingleValue = singleDataArray[row]
        case .multiple:
            if component < multipleDataArray.count && row < multipleDataArray[component].count {
                selectedMultipleValue[component] = multipleDataArray[component][row]
            }
        }
        
        if isAutoSelect {
            handleResult()
        }
    }
}

// MARK: - Legacy Support
@available(iOS 15.0, *)
public extension TFYSwiftStringPickerView {
    static func showStringPickerWithTitle(
        title: String,
        dataArr: Any,
        defaultSelValue: Any,
        isAutoSelect: Bool,
        type: TFYSwiftStringPickerMode,
        resultBlock: @escaping StringPickerResultBlock,
        cancelBlock: @escaping StringPickerCancelBlock
    ) {
        show(
            title: title,
            dataArray: dataArr,
            defaultSelectedValue: defaultSelValue,
            isAutoSelect: isAutoSelect,
            mode: type,
            result: resultBlock,
            cancel: cancelBlock
        )
    }
}
