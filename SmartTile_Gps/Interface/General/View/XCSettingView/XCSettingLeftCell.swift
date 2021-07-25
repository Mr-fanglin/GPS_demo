//
//  XCSettingLeftCell.swift
//  XinChat
//
//  Created by FangLin on 2019/12/5.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class XCSettingLeftCell: XCSettingBaseCell {
    
    override var model: XCSettingCellModel? {
        didSet{
            titleLabel.text = model?.title
        }
    }

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
        self.backgroundColor = .white
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(25*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.height.equalTo(17*IPONE_SCALE)
        }
        
        self.addSubview(arrowImageView)
        arrowImageView.image = UIImage.init(named: "user_arrow")
        arrowImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-20*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.width.equalTo(7*IPONE_SCALE)
            make.height.equalTo(12*IPONE_SCALE)
        }
    }
}
