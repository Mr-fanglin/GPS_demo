//
//  XCSettingMiddleCell.swift
//  XinChat
//
//  Created by FangLin on 2019/10/16.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class XCSettingMiddleCell: XCSettingBaseCell {
    
    override var model: XCSettingCellModel? {
        didSet{
            titleLabel.text = model?.title
            tipImgView.image = UIImage.init(named: model?.tipImg ?? "")
        }
    }
    
    // MARK:- 懒加载
    lazy var titleLabel: UILabel = {
        let titleL = UILabel()
        titleL.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        titleL.font = UIFont.systemFont(ofSize: 14)
        titleL.textAlignment = .center
        return titleL
    }()
    
    lazy var tipImgView: UIImageView = {
        let tipImgV = UIImageView()
        tipImgV.contentMode = .center
        return tipImgV
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = kNavBarBgColor
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
    
    func setUp() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-10*IPONE_SCALE)
            make.top.equalTo(5*IPONE_SCALE)
            make.height.equalTo(15*IPONE_SCALE)
        }
        
        self.addSubview(tipImgView)
        tipImgView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(5*IPONE_SCALE)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(20*IPONE_SCALE)
        }
    }

}
