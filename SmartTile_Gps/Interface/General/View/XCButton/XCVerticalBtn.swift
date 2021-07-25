//
//  XCVerticalBtn.swift
// 
//
//  Created by FangLin on 2019/7/23.
//  Copyright © 2019年 FangLin. All rights reserved.
//

import UIKit

class XCVerticalBtn: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let radio: CGFloat = 0.7
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: contentRect.size.width, height: contentRect.size.height * 0.7)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: contentRect.size.height * radio, width: contentRect.size.width, height: contentRect.size.height * (1 - radio))
    }

}
