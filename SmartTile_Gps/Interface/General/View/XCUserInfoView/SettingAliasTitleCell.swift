//
//  SettingAliasTitleCell.swift
//  XinChat
//
//  Created by FangLin on 2019/11/19.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class SettingAliasTitleCell: UITableViewCell {
    
    lazy var titleLabel:UILabel = {
        let titleL = UILabel.init()
        titleL.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        titleL.textColor = HEXCOLOR(h: 0x999999, alpha: 1)
        return titleL
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUp() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15*IPONE_SCALE)
            make.bottom.equalTo(-5*IPONE_SCALE)
            make.height.equalTo(15*IPONE_SCALE)
        }
    }
    
}
