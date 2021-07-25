//
//  XCSettingNormalCell.swift
//  XinChat
//
//  Created by FangLin on 2019/10/16.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class XCSettingNormalCell: XCSettingBaseCell {
    
    override var model: XCSettingCellModel? {
        didSet{
            iconView.image = UIImage.init(named: model?.icon ?? "")
            titleLabel.text = model?.title
            subTitleLabel.text = model?.subTitle
        }
    }
    
    // MARK:- 懒加载
    lazy var iconView: UIImageView = {
        let iconV = UIImageView()
        return iconV
    }()
    
    lazy var titleLabel: UILabel = {
        let titleL = UILabel()
        titleL.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        titleL.font = UIFont.systemFont(ofSize: 17.0)
        return titleL
    }()
    
    lazy var subTitleLabel: UILabel = {
        let subTitleL = UILabel()
        subTitleL.textColor = HEXCOLOR(h: 0x666666, alpha: 1)
        subTitleL.font = UIFont.systemFont(ofSize: 15.0)
        return subTitleL
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func setUp() {
        self.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(15*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(36*IPONE_SCALE)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(15*IPONE_SCALE)
            make.top.equalTo(15*IPONE_SCALE)
            make.height.equalTo(17*IPONE_SCALE)
        }
        
        self.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.bottom.equalTo(-15*IPONE_SCALE)
            make.height.equalTo(15*IPONE_SCALE)
        }
        
        let lineV = UIView.init()
        lineV.backgroundColor = HEXCOLOR(h: 0xebebed, alpha: 1)
        self.addSubview(lineV)
        lineV.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalTo(titleLabel)
        }
    }

}
