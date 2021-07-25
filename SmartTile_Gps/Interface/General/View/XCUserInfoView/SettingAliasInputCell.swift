//
//  SettingAliasInputCell.swift
//  XinChat
//
//  Created by FangLin on 2019/11/19.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class SettingAliasInputCell: UITableViewCell {

    lazy var inputTF:UITextField = {
        let input = UITextField.init()
        input.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        input.font = UIFont.systemFont(ofSize: CGFloat(17*IPONE_SCALE))
        input.delegate = UIViewController.getCurrentViewCtrl() as? UITextFieldDelegate
        return input
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.selectionStyle = .none
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUp() {
        self.addSubview(inputTF)
        inputTF.snp.makeConstraints { (make) in
            make.left.equalTo(15*IPONE_SCALE)
            make.right.equalTo(-15*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.height.equalTo(36*IPONE_SCALE)
        }
    }
}
