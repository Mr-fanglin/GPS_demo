//
//  UserInfoCell.swift
//  XinChat
//
//  Created by FangLin on 2019/10/17.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class UserInfoCell: UITableViewCell {
    
    var model:XCContactCellModel = XCContactCellModel() {
        didSet{
            iconImg.image = UIImage.init(named: model.image ?? "DefaultProfileHead_phone")
            nameLabel.text = model.title
            tipLabel.text = "ID：\(model.userId ?? "未设置")"
        }
    }
    
    lazy var iconImg:UIImageView = {
        let img = UIImageView.init()
        return img
    }()
    
    lazy var nameLabel:UILabel = {
        let nameL = UILabel.init()
        nameL.font = UIFont.boldSystemFont(ofSize: CGFloat(20*IPONE_SCALE))
        nameL.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        return nameL
    }()
    
    lazy var tipLabel:UILabel = {
        let tipL = UILabel.init()
        tipL.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        tipL.textColor = HEXCOLOR(h: 0x666666, alpha: 1)
        return tipL
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
        self.addSubview(iconImg)
        self.addSubview(nameLabel)
        self.addSubview(tipLabel)
        
        iconImg.layer.cornerRadius = 5
        iconImg.layer.masksToBounds = true
        iconImg.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.top.equalTo(8*IPONE_SCALE)
            make.width.height.equalTo(60*IPONE_SCALE)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImg.snp.right).offset(10)
            make.top.equalTo(5*IPONE_SCALE)
            make.height.equalTo(20*IPONE_SCALE)
        }
        
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(5*IPONE_SCALE)
            make.height.equalTo(15*IPONE_SCALE)
        }
        
        let lineV = UIView.init()
        lineV.backgroundColor = HEXCOLOR(h: 0xebebed, alpha: 1)
        self.addSubview(lineV)
        lineV.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalTo(iconImg)
        }
    }

}
