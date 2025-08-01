//
//  TFYSwiftPickerShowBaseView.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/17.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import UIKit

@available(iOS 15.0, *)
public class TFYSwiftPickerShowBaseView: UIView {
    
    // MARK: - Properties
    private var title: String = ""
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.body(size: PickerLayout.adjustedSize(for: 15), weight: .semibold)
        label.textColor = PickerColors.text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        addSubview(titleLabel)
        
        // 使用frame布局
        titleLabel.frame = bounds
    }
    
    private func setupConstraints() {
        // 使用frame布局，不需要Auto Layout约束
    }
    
    // MARK: - Public Methods
    /// 设置标题
    public func setTitle(_ title: String) {
        self.title = title
        titleLabel.text = title
    }
    
    /// 获取当前标题
    public func getTitle() -> String {
        return title
    }
    
    /// 设置标题字体
    public func setTitleFont(_ font: UIFont) {
        titleLabel.font = font
    }
    
    /// 设置标题颜色
    public func setTitleColor(_ color: UIColor) {
        titleLabel.textColor = color
    }
    
    /// 设置文本对齐方式
    public func setTextAlignment(_ alignment: NSTextAlignment) {
        titleLabel.textAlignment = alignment
    }
    
    // MARK: - Legacy Support
    public var legacyTitleLabel: UILabel {
        return self.titleLabel
    }
}
