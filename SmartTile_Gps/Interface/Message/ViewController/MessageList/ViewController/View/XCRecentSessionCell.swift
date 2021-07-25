//
//  XCRecentSessionCell.swift
//  
//
//  Created by FangLin on 2019/1/17.
//  Copyright © 2019年 FangLin. All rights reserved.
//

import UIKit
import BadgeSwift

///最近会话单元格
class XCRecentSessionCell: UITableViewCell {
    
    var model:XCRecentSessionModel! {
        didSet {
            setModel()
        }
    }
    
    // MARK:- 懒加载
    lazy var avatarView: UIImageView = {
        let avatarView = UIImageView()
        avatarView.image = #imageLiteral(resourceName: "Icon")
        avatarView.layer.cornerRadius = 5
        avatarView.layer.masksToBounds = true
        return avatarView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameL = UILabel()
        nameL.font = UIFont.systemFont(ofSize: CGFloat(17*IPONE_SCALE))
        return nameL
    }()
    
    lazy var detailLabel: UILabel = {
        let detailL = UILabel()
        detailL.font = UIFont.systemFont(ofSize: CGFloat(14*IPONE_SCALE))
        detailL.textColor = UIColor.gray
        return detailL
    }()
    
    lazy var timeLabel: UILabel = {
        let timeL = UILabel()
        timeL.font = UIFont.systemFont(ofSize: CGFloat(13*IPONE_SCALE))
        timeL.textColor = UIColor.gray
        timeL.textAlignment = .right
        return timeL
    }()
    
    lazy var tipBadge: BadgeSwift = {
        let badge = BadgeSwift()
        badge.font = UIFont.systemFont(ofSize: 12.0)
        badge.textColor = UIColor.white
        badge.cornerRadius = 9
        badge.badgeColor = UIColor.red
        return badge
    }()
    
    // MARK:- init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 初始化
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 初始化
extension XCRecentSessionCell {
    fileprivate func setup() {
        self.addSubview(avatarView)
        self.addSubview(nameLabel)
        self.addSubview(detailLabel)
        self.addSubview(timeLabel)
        self.addSubview(tipBadge)
        
        // 布局
        avatarView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(18*IPONE_SCALE)
            make.width.height.equalTo(50*IPONE_SCALE)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(12*IPONE_SCALE)
            make.top.equalTo(avatarView.snp.top).offset(3*IPONE_SCALE)
            make.right.equalTo(-80*IPONE_SCALE)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left)
            make.bottom.equalTo(avatarView.snp.bottom).offset(-3*IPONE_SCALE)
            make.right.equalTo(self.snp.right).offset(-15*IPONE_SCALE)
            
        }
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-10*IPONE_SCALE)
            make.top.equalTo(nameLabel.snp.top)
        }
        tipBadge.snp.makeConstraints { (make) in
            make.centerX.equalTo(avatarView.snp.right)
            make.centerY.equalTo(avatarView.snp.top)
        }
    }
}

// MARK:- 设置数据
extension XCRecentSessionCell {
    fileprivate func setModel() {
        avatarView.image = UIImage.init(named: model.avatarPath ?? "DefaultProfileHead_phone")
        nameLabel.text = model.title
        detailLabel.text = model.subTitle
        timeLabel.text = model.time
        timeLabel.sizeToFit()
        if model.unreadCount == 0 {
            tipBadge.isHidden = true
        } else {
            tipBadge.isHidden = false
            tipBadge.text = "\(model.unreadCount)"
        }
    }
}
