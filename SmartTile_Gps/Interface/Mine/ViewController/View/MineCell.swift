//
//  MineCell.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/15.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class MineCell: UITableViewCell {
    
    var deviceModel:ChildModel = ChildModel() {
        didSet{
            nameLabel.text = deviceModel.name
            avatarView.image = UIImage.init(named: "DefaultProfileHead_phone")
        }
    }
    
    var model:XCContactCellModel = XCContactCellModel() {
        didSet{
            avatarView.image = UIImage.init(named: model.image!)
            nameLabel.text = model.title
        }
    }
    
    // MARK:- 懒加载
    lazy var avatarView: UIImageView = {
        let avatarView = UIImageView()
        return avatarView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameL = UILabel()
        nameL.font = UIFont.systemFont(ofSize: CGFloat(13*IPONE_SCALE))
        nameL.textColor = HEXCOLOR(h: 0x3a3a3a, alpha: 1)
        return nameL
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
        self.accessoryType = .disclosureIndicator
        // 初始化
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- 初始化
extension MineCell {
    fileprivate func setup() {
        self.addSubview(avatarView)
        self.addSubview(nameLabel)
        
        // 布局
        avatarView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(25*IPONE_SCALE)
            make.width.height.equalTo(21*IPONE_SCALE)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(12*IPONE_SCALE)
            make.top.equalTo(avatarView.snp.top).offset(3*IPONE_SCALE)
            make.right.equalTo(-80*IPONE_SCALE)
        }
    }
}

