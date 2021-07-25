//
//  UserInfoSetAliasCell.swift
//  XinChat
//
//  Created by FangLin on 2019/11/19.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class UserInfoSetAliasCell: UITableViewCell {

    lazy var titleLabel:UILabel = {
        let titleL = UILabel.init()
        titleL.font = UIFont.systemFont(ofSize: CGFloat(17*IPONE_SCALE))
        titleL.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        titleL.text = "设置备注"
        return titleL
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUp() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.height.equalTo(17*IPONE_SCALE)
        }
    }
    
}
