//
//  TFYSwiftPickerShowBaseView.swift
//  TFYSwiftPickerView
//
//  Created by 田风有 on 2022/5/17.
//  Copyright © 2022 TFYSwift. All rights reserved.
//

import UIKit

public class TFYSwiftPickerShowBaseView: UIView {

    var title:String = "" {
        didSet {
            let name = title
            self.titleLabel.text = name
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.kPickerWidth, height: self.kPickerHeight))
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = kPickerTextColor
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
