//
//  TFYSwiftPickerBaseView.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/16.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import UIKit

public class TFYSwiftPickerBaseView: UIView {
    /// 容器View
    lazy var alertView: UIView = {
        let alViewFrame:CGRect = CGRect(x: 0, y: kPickerScrenHeight, width: kPickerScrenWidth, height: kPickerContainerHeight)
        let alView = UIView(frame: alViewFrame)
        alView.backgroundColor = kPickerShowColor
        alView.kPickerCornerCut(radius: kPickerContentViewCorners, corner: [.topLeft,.topRight])
        return alView
    }()
    
    /// 顶部标题栏视图
    lazy var topView: UIView = {
        let tView = UIView(frame: CGRect(x: 0, y: 0, width: kPickerScrenWidth, height: kPickerTopViewHeight))
        tView.backgroundColor = kPickerTheneColor
        tView.layer.borderColor = UIColor.kPickerhexString("e6e6e6").cgColor
        tView.layer.borderWidth = 0.5
        return tView
    }()
    
    /// 左边取消按钮
    lazy var leftBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 15, y: 0, width: kPickerbtnWidth, height: kPickerbtnHeight)
        btn.kPickerCenterY = topView.kPickerCenterY
        btn.backgroundColor = kPickerBackColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        btn.setTitleColor(kPickerTextColor, for: .normal)
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = kPickerBorderColor.cgColor
        btn.layer.borderWidth = 1
        btn.setTitle("取消", for: .normal)
        btn.addTarget(self, action: #selector(clickLeftBtn), for: .touchUpInside)
        return btn
    }()
    
    /// 右边确定按钮
    lazy var rightBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: kPickerScrenWidth - kPickerbtnWidth - 15, y: 0, width: kPickerbtnWidth, height: kPickerbtnHeight)
        btn.kPickerCenterY = topView.kPickerCenterY
        btn.backgroundColor = kPickerBackColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        btn.setTitleColor(kPickerTextColor, for: .normal)
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = kPickerBorderColor.cgColor
        btn.layer.borderWidth = 1
        btn.setTitle("完成", for: .normal)
        btn.addTarget(self, action: #selector(clickRightBtn), for: .touchUpInside)
        return btn
    }()
    
    /// 中间标题
    lazy var titleLabel: UILabel = {
        let lab = UILabel(frame: CGRect(x: self.leftBtn.kPickerMaxX, y: 0, width: kPickerScrenWidth - 2*kPickerbtnWidth - 30, height: kPickerTopViewHeight))
        lab.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lab.textColor = kPickerTextColor
        lab.textAlignment = .center
        return lab
    }()
    
    func layoutUI() {
        self.frame = kPickerScrenBounds
        self.backgroundColor = UIColor.kPickerhexString("000000", alpha: 0.2)
        self.isUserInteractionEnabled = true
        self.autoresizingMask = [.flexibleTopMargin,.flexibleLeftMargin,.flexibleRightMargin,.flexibleBottomMargin,.flexibleWidth,.flexibleHeight]
        let mytap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
        self.addGestureRecognizer(mytap)
        
        self.addSubview(self.alertView)
        self.alertView.addSubview(self.topView)
        self.alertView.addSubview(self.leftBtn)
        self.alertView.addSubview(self.rightBtn)
        self.alertView.addSubview(self.titleLabel)
    }
    
    /// 点击屏幕消失
    @objc func didTapBackgroundView() {
        self.dismissWithAnimation()
    }
    
    /// 点击取消按钮
    @objc func clickLeftBtn() {
        self.dismissWithAnimation()
    }
    
    /// 点击完成按钮
    @objc func clickRightBtn() {
        self.dismissWithAnimation()
    }
    
    func showWithAnimation() {
        self.show()
        UIView.animate(withDuration: 0.25, animations: {
            self.alertView.frame = CGRect(x: 0, y: kPickerShowHeight, width: kPickerScrenWidth, height: kPickerContainerHeight)
        })
    }
    
    func dismissWithAnimation() {
        UIView.animate(withDuration: 0.25) {
            self.alertView.frame = CGRect(x: 0, y: kPickerScrenHeight, width: kPickerScrenWidth, height: kPickerContainerHeight)
        } completion: { isArr in
            self.dismiss()
        }
    }
    
    func show() {
        UIWindow.kPickerkeyWindow?.addSubview(self)
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
}
