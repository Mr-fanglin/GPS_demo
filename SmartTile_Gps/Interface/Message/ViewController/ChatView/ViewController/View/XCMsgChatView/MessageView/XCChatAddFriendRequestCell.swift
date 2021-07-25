//
//  XCChatAddFriendRequestCell.swift
//  XinChat
//
//  Created by FangLin on 2019/11/21.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

/// 添加好友请求单元格
class XCChatAddFriendRequestCell: UITableViewCell {

    var model: XCChatMsgModel? {
        didSet {
            setModel()
        }
    }
    
    var bgView:UIView = {
        let bgV = UIView.init()
        bgV.backgroundColor = .white
        bgV.layer.cornerRadius = 10
        bgV.layer.masksToBounds = true
        //添加手势
        bgV.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(bgVTap))
        bgV.addGestureRecognizer(tapGes)
        return bgV
    }()
    
    var avatar: UIImageView = {
        let avaImg = UIImageView()
        avaImg.layer.cornerRadius = 5
        avaImg.layer.masksToBounds = true
        return avaImg
    }()
    
    var nameLabel: UILabel = {
        let nameL = UILabel.init()
        nameL.textColor = HEXCOLOR(h: 333333, alpha: 1)
        nameL.font = UIFont.systemFont(ofSize: CGFloat(18*IPONE_SCALE))
        return nameL
    }()
    
    var attachLabel: UILabel = {
        let attachL = UILabel.init()
        attachL.textColor = HEXCOLOR(h: 999999, alpha: 1)
        attachL.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        return attachL
    }()
    
    var lineView:UIView = {
        let lineV = UIView.init()
        lineV.backgroundColor = HEXCOLOR(h: 0xededed, alpha: 1)
        return lineV
    }()
    
    var lookDetailLabel: UILabel = {
        let lookDetailL = UILabel.init()
        lookDetailL.font = UIFont.systemFont(ofSize: CGFloat(19*IPONE_SCALE))
        lookDetailL.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        lookDetailL.text = "查看详情"
        return lookDetailL
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        selectionStyle = .none
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUp() {
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(5*IPONE_SCALE)
            make.left.equalTo(15*IPONE_SCALE)
            make.right.equalTo(-15*IPONE_SCALE)
            make.bottom.equalTo(-5*IPONE_SCALE)
        }
        
        bgView.addSubview(avatar)
        avatar.snp.makeConstraints { (make) in
            make.top.equalTo(20*IPONE_SCALE)
            make.left.equalTo(20*IPONE_SCALE)
            make.width.height.equalTo(40*IPONE_SCALE)
        }
        
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatar.snp.right).offset(10*IPONE_SCALE)
            make.centerY.equalTo(avatar)
            make.height.equalTo(18*IPONE_SCALE)
            make.right.equalTo(-15*IPONE_SCALE)
        }
        
        bgView.addSubview(attachLabel)
        attachLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatar.snp.bottom).offset(15*IPONE_SCALE)
            make.left.equalTo(avatar)
            make.height.equalTo(15*IPONE_SCALE)
            make.right.equalTo(-15*IPONE_SCALE)
        }
        
        bgView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(attachLabel.snp.bottom).offset(20*IPONE_SCALE)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        bgView.addSubview(lookDetailLabel)
        lookDetailLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-20*IPONE_SCALE)
            make.top.equalTo(lineView.snp.bottom).offset(10*IPONE_SCALE)
            make.height.equalTo(19*IPONE_SCALE)
        }
    }
}


// MARK:- 手势处理
extension XCChatAddFriendRequestCell {
    @objc fileprivate func bgVTap() {

    }
}

extension XCChatAddFriendRequestCell {
    fileprivate func setModel() {
        guard let model = model else {
            return
        }
        model.cellHeight = CGFloat(160*IPONE_SCALE)
        guard let attach = model.attach else {
            attachLabel.text = ""
            return
        }
        attachLabel.text = attach
    }
}

