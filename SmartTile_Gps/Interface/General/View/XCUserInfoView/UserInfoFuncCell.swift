//
//  UserInfoFuncCell.swift
//  XinChat
//
//  Created by FangLin on 2019/10/17.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class UserInfoFuncCell: UITableViewCell {
    
    var model:XCSettingCellModel = XCSettingCellModel() {
        didSet{
            tipButton.setTitle(model.title, for: .normal)
            tipButton.setImage(UIImage.init(named: model.icon ?? ""), for: .normal)
        }
    }
    
    lazy var tipButton:UIButton = {
        let tipBtn = UIButton.init(type: .custom)
        tipBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(17*IPONE_SCALE))
        tipBtn.setTitleColor(RGBCOLOR(r: 83, g: 91, b: 136, alpha: 1), for: .normal)
        return tipBtn
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUp() {
        tipButton.isEnabled = false
        self.addSubview(tipButton)
        tipButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(20*IPONE_SCALE)
        }
        
        let lineV = UIView.init()
        lineV.backgroundColor = HEXCOLOR(h: 0xebebed, alpha: 1)
        self.addSubview(lineV)
        lineV.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }

}
