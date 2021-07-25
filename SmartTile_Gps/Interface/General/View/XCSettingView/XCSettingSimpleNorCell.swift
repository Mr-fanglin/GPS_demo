//
//  XCSettingSimpleNorCell.swift
//  XinChat
//
//  Created by FangLin on 2019/10/30.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class XCSettingSimpleNorCell: XCSettingBaseCell {

    override var model: XCSettingCellModel? {
        didSet{
            iconView.image = UIImage.init(named: model?.icon ?? "")
            titleLabel.text = model?.title
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
        titleL.font = UIFont.systemFont(ofSize: CGFloat(17*IPONE_SCALE))
        return titleL
    }()
    
    lazy var arrowImageView:UIImageView = {
        let arrowImg = UIImageView.init()
        arrowImg.contentMode = .scaleAspectFit
        return arrowImg
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
        self.contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(25*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25*IPONE_SCALE)
        }
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(20*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.height.equalTo(17*IPONE_SCALE)
        }
        
        self.contentView.addSubview(arrowImageView)
        arrowImageView.image = UIImage.init(named: "user_arrow")
        arrowImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-20*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.width.equalTo(7*IPONE_SCALE)
            make.height.equalTo(12*IPONE_SCALE)
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
