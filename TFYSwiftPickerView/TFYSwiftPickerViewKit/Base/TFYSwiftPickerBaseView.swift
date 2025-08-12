//
//  TFYSwiftPickerBaseView.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/16.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import UIKit
import Foundation

@available(iOS 15.0, *)
public class TFYSwiftPickerBaseView: UIView {
    
    // MARK: - Properties
    private var isAnimating = false
    private var tapGesture: UITapGestureRecognizer?
    
    // MARK: - UI Components
    /// 容器视图
    lazy var containerView: UIView = {
        let y = PickerScreenConstants.height - PickerLayout.containerHeight
        let view = UIView(frame: CGRectMake(0, y, PickerScreenConstants.width, PickerLayout.containerHeight))
        view.backgroundColor = PickerColors.popupBackground
        view.setCornerRadius(PickerLayout.cornerRadius, corners: [.topLeft, .topRight])
        view.addShadow(color: .black, opacity: 0.1, offset: CGSize(width: 0, height: -2), radius: 8)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    /// 头部视图
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: PickerScreenConstants.width, height: PickerLayout.headerHeight)))
        view.backgroundColor = PickerColors.theme
        view.layer.borderColor = PickerColors.border.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    /// 取消按钮
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(origin: CGPoint(x: 15, y: (PickerLayout.headerHeight - PickerLayout.buttonHeight) / 2), size: CGSize(width: PickerLayout.buttonWidth, height: PickerLayout.buttonHeight))
        button.backgroundColor = PickerColors.buttonBackground
        button.titleLabel?.font = UIFont.body(size: 15, weight: .semibold)
        button.setTitleColor(PickerColors.text, for: .normal)
        button.setTitle("cancel".localized, for: .normal)
        button.setCornerRadius(6)
        button.layer.borderColor = PickerColors.border.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        // 添加触觉反馈
        button.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        
        return button
    }()
    
    /// 确认按钮
    lazy var confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(origin: CGPoint(x: PickerScreenConstants.width - PickerLayout.buttonWidth - 15, y: (PickerLayout.headerHeight - PickerLayout.buttonHeight) / 2), size: CGSize(width: PickerLayout.buttonWidth, height: PickerLayout.buttonHeight))
        button.backgroundColor = PickerColors.buttonBackground
        button.titleLabel?.font = UIFont.body(size: 15, weight: .semibold)
        button.setTitleColor(PickerColors.text, for: .normal)
        button.setTitle("confirm".localized, for: .normal)
        button.setCornerRadius(6)
        button.layer.borderColor = PickerColors.border.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        // 添加触觉反馈
        button.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        
        return button
    }()
    
    /// 标题标签
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.body(size: 14, weight: .medium)
        label.textColor = PickerColors.text
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    /// 内容视图
    public var contentView: UIView {
        return containerView
    }
    
    // MARK: - Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupGestures()
        
        // 确保初始化完成后布局正确
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
        setupGestures()
        
        // 确保初始化完成后布局正确
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(headerView)
        headerView.addSubview(cancelButton)
        headerView.addSubview(confirmButton)
        headerView.addSubview(titleLabel)
        
        // 设置标题标签的frame
        let titleX = cancelButton.frame.maxX + 10
        let titleWidth = confirmButton.frame.minX - titleX - 10
        titleLabel.frame = CGRect(x: titleX, y: 0, width: titleWidth, height: PickerLayout.headerHeight)
        
        // 应用主题
        applyTheme()
    }
    
    private func setupConstraints() {
        // 使用frame布局，不需要Auto Layout约束
        // 所有视图的frame已经在初始化时设置好了
    }
    
    private func setupGestures() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        if let tapGesture = tapGesture {
            addGestureRecognizer(tapGesture)
        }
    }
    
    // MARK: - Public Methods
    /// 设置标题
    public func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    /// 设置按钮标题
    public func setButtonTitles(cancel: String = "cancel".localized, confirm: String = "confirm".localized) {
        cancelButton.setTitle(cancel, for: .normal)
        confirmButton.setTitle(confirm, for: .normal)
    }
    
    /// 显示选择器
    public func show(animated: Bool = true) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else {
            return 
        }
        
        // 1. 先移除旧视图
        self.removeFromSuperview()
        
        // 2. 添加到window
        window.addSubview(self)
        window.bringSubviewToFront(self)
        
        // 3. 设置frame为全屏
        self.frame = window.bounds
        
        // 4. 设置初始属性
        alpha = 0
        isUserInteractionEnabled = true
        
        // 5. 设备适配
        updateLayoutForDevice()
        
        // 6. 确保布局正确
        setNeedsLayout()
        layoutIfNeeded()
    
        if animated {
            showWithAnimation()
        } else {
            alpha = 1
            containerView.transform = .identity
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    /// 隐藏选择器
    public func dismiss(animated: Bool = true) {
        if animated {
            dismissWithAnimation()
        } else {
            removeFromSuperview()
        }
    }
    
    // MARK: - Private Methods
    @objc private func backgroundTapped() {
        handleCancel()
    }
    
    @objc private func cancelButtonTapped() {
        handleCancel()
    }
    
    @objc private func confirmButtonTapped() {
        handleConfirm()
    }
    
    @objc private func buttonTouchDown() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func showWithAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        
        print("🎬 开始显示动画")
        print("🎬 初始状态 - alpha: \(alpha), containerView.transform: \(containerView.transform)")
        print("🎬 containerView 初始frame: \(containerView.frame)")
        print("🎬 self.frame: \(frame)")
        
        // 设置初始状态
        alpha = 0
        // 从屏幕底部开始动画
        let translateY = PickerLayout.containerHeight
        containerView.transform = CGAffineTransform(translationX: 0, y: translateY)
        
        // 使用更简单的动画
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = 1
            self.containerView.transform = .identity
        }) { _ in
            self.isAnimating = false
        }
    }
    
    private func dismissWithAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        
        // 向屏幕底部消失
        let translateY = PickerLayout.containerHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseIn], animations: {
            self.alpha = 0
            self.containerView.transform = CGAffineTransform(translationX: 0, y: translateY)
        }) { _ in
            self.removeFromSuperview()
            self.isAnimating = false
        }
    }
    
    // MARK: - Theme Management
    private func applyTheme() {
        backgroundColor = PickerColors.maskBackground
        containerView.backgroundColor = PickerColors.popupBackground
        headerView.backgroundColor = PickerColors.theme
        cancelButton.backgroundColor = PickerColors.buttonBackground
        confirmButton.backgroundColor = PickerColors.buttonBackground
        titleLabel.textColor = PickerColors.text
        cancelButton.setTitleColor(PickerColors.text, for: .normal)
        confirmButton.setTitleColor(PickerColors.text, for: .normal)
    }
    
    // MARK: - Layout Management
    private func updateLayoutForDevice() {
        if PickerScreenConstants.isiPad {
            // 对于iPad，使用frame布局
            let maxWidth = PickerLayout.adjustedSize(for: 400)
            let centerX = (bounds.width - maxWidth) / 2
            let y = PickerScreenConstants.height - PickerLayout.containerHeight
            
            // 更新容器视图frame，确保在底部
            containerView.frame = CGRect(x: centerX, y: y, width: maxWidth, height: PickerLayout.containerHeight)
            
            // 更新头部视图frame
            headerView.frame = CGRect(x: 0, y: 0, width: maxWidth, height: PickerLayout.headerHeight)
            
            // 更新按钮frame
            cancelButton.frame = CGRect(x: 15, y: (PickerLayout.headerHeight - PickerLayout.buttonHeight) / 2, width: PickerLayout.buttonWidth, height: PickerLayout.buttonHeight)
            confirmButton.frame = CGRect(x: maxWidth - PickerLayout.buttonWidth - 15, y: (PickerLayout.headerHeight - PickerLayout.buttonHeight) / 2, width: PickerLayout.buttonWidth, height: PickerLayout.buttonHeight)
            
            // 更新标题标签frame
            let titleX = cancelButton.frame.maxX + 10
            let titleWidth = confirmButton.frame.minX - titleX - 10
            titleLabel.frame = CGRect(x: titleX, y: 0, width: titleWidth, height: PickerLayout.headerHeight)
        }
    }
    
    // MARK: - Override Methods
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // 更新容器视图位置以适应不同设备
        updateLayoutForDevice()
    }
    
    // MARK: - Subclass Override Methods
    /// 处理取消操作 - 子类可重写
    public func handleCancel() {
        dismissWithAnimation()
    }
    
    /// 处理确认操作 - 子类可重写
    public func handleConfirm() {
        dismissWithAnimation()
    }
    
    // MARK: - Memory Management
    deinit {
        if let tapGesture = tapGesture {
            removeGestureRecognizer(tapGesture)
        }
    }
}

// MARK: - Legacy Support
@available(iOS 15.0, *)
public extension TFYSwiftPickerBaseView {
    /// 兼容旧版本的属性
    var alertView: UIView { containerView }
    var topView: UIView { headerView }
    var leftBtn: UIButton { cancelButton }
    var rightBtn: UIButton { confirmButton }
    
    func layoutUI() {
        // 新版本使用Auto Layout，此方法保留用于兼容
    }
    
    func show() {
        show(animated: false)
    }
    
    func dismiss() {
        dismiss(animated: false)
    }
    
    @objc func didTapBackgroundView() {
        backgroundTapped()
    }
    
    @objc func clickLeftBtn() {
        cancelButtonTapped()
    }
    
    @objc func clickRightBtn() {
        confirmButtonTapped()
    }
}
