//
//  GroupCell.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/15.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    
    var model:GroupListModel! {
        didSet {
            nameLabel.text = model.name
            detailLabel.text = "\(model.count)"
        }
    }
    
    // MARK:- 懒加载
    lazy var avatarView: UIImageView = {
        let avatarView = UIImageView()
        avatarView.image = UIImage.init(named: "add_friend_icon_addgroup")
        avatarView.layer.cornerRadius = 5
        avatarView.layer.masksToBounds = true
        return avatarView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameL = UILabel()
        nameL.font = UIFont.systemFont(ofSize: CGFloat(18*IPONE_SCALE))
        return nameL
    }()
    
    lazy var detailLabel: UILabel = {
        let detailL = UILabel()
        detailL.font = UIFont.systemFont(ofSize: CGFloat(16*IPONE_SCALE))
        detailL.textColor = UIColor.gray
        return detailL
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
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
extension GroupCell {
    fileprivate func setup() {
        self.addSubview(avatarView)
        self.addSubview(nameLabel)
        self.addSubview(detailLabel)
        
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
        
    }
}
