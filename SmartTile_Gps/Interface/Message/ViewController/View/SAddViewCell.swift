//
//  SAddViewCell.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/8/28.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class SAddViewCell: UITableViewCell {
    
    var titleL:UILabel = UILabel.init()

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
        
        self.contentView.backgroundColor = HEXCOLOR(h: 0x666666, alpha: 1)
        
        titleL.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        titleL.textColor = HEXCOLOR(h: 0xffffff, alpha: 1)
        self.contentView.addSubview(titleL)
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(15*IPONE_SCALE)
            make.right.equalTo(-5*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.height.equalTo(15*IPONE_SCALE)
        }
        
        let lineV = UIView.init()
        lineV.backgroundColor = HEXCOLOR(h: 0x999999, alpha: 1)
        self.contentView.addSubview(lineV)
        lineV.snp.makeConstraints { (make) in
            make.left.equalTo(15*IPONE_SCALE)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
