//
//  XCBarButton.swift
//  
//
//  Created by FangLin on 2019/12/24.
//  Copyright © 2019年 FangLin. All rights reserved.
//


import UIKit

class XCBarButton: UIButton {

    init(bgColor: UIColor?, disabledColor: UIColor?, title: String, titleColor: UIColor?, titleHighlightedColor: UIColor?) {
        super.init(frame: CGRect.zero)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.setTitleColor(titleHighlightedColor, for: .highlighted)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        self.setBackgroundImage((bgColor ?? kBtnWhite).trans2Image(), for: .normal)
        self.setBackgroundImage((disabledColor ?? kBtnWhite).trans2Image(), for: .disabled)
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
