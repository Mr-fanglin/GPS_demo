//
//  XCSettingAvatarCell.swift
//  XinChat
//
//  Created by FangLin on 2019/10/30.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class XCSettingAvatarCell: XCSettingBaseCell {
    
    override var model: XCSettingCellModel?{
        didSet{
            iconView.image = UIImage.init(named: model?.icon ?? "DefaultProfileHead_phone")
            titleLabel.text = model?.title
            subTitleLabel.text = model?.subTitle
        }
    }
    
    
    lazy var iconView:UIImageView = {
        let iconV = UIImageView.init()
        return iconV
    }()
    
    lazy var titleLabel:UILabel = {
        let titleL = UILabel.init()
        titleL.font = UIFont.boldSystemFont(ofSize: CGFloat(22*IPONE_SCALE))
        titleL.textColor = .black
        return titleL
    }()
    
    lazy var subTitleLabel:UILabel = {
        let subTitleL = UILabel.init()
        subTitleL.font = UIFont.systemFont(ofSize: CGFloat(17*IPONE_SCALE))
        subTitleL.textColor = HEXCOLOR(h: 0x666666, alpha: 1)
        return subTitleL
    }()

    lazy var arrowImageView:UIImageView = {
        let arrowImg = UIImageView.init()
        arrowImg.contentMode = .scaleAspectFit
        return arrowImg
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUp() {
        iconView.layer.cornerRadius = 5
        iconView.layer.masksToBounds = true
        self.contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(30*IPONE_SCALE)
            make.top.equalTo(35*IPONE_SCALE)
            make.width.height.equalTo(60*IPONE_SCALE)
        }
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(20*IPONE_SCALE)
            make.top.equalTo(iconView.snp.top).offset(5*IPONE_SCALE)
            make.height.equalTo(22*IPONE_SCALE)
            make.right.equalTo(-20*IPONE_SCALE)
        }
        
        self.contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.bottom.equalTo(iconView.snp.bottom).offset(-5*IPONE_SCALE)
            make.height.equalTo(18*IPONE_SCALE)
            make.right.equalTo(-40*IPONE_SCALE)
        }
        
        self.contentView.addSubview(arrowImageView)
        arrowImageView.image = UIImage.init(named: "user_arrow")
        arrowImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-20*IPONE_SCALE)
            make.centerY.equalTo(subTitleLabel)
            make.width.equalTo(7*IPONE_SCALE)
            make.height.equalTo(12*IPONE_SCALE)
        }
    }
}
