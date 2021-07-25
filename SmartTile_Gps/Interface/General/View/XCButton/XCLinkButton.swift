//
//  XCLinkButton.swift
//  
//
//  Created by FangLin on 2019/12/24.
//  Copyright © 2019年 FangLin. All rights reserved.
//

import UIKit

class XCLinkButton: UIButton {

    init(title: String, fontSize: CGFloat) {
        super.init(frame: CGRect.zero)
        
        let linkColor = RGBA(r: 0.42, g: 0.49, b: 0.62, a: 1.00)
        self.setTitle(title, for: .normal)
        self.setTitleColor(linkColor, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        self.titleLabel?.sizeToFit()
        self.bounds = (self.titleLabel?.bounds)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
