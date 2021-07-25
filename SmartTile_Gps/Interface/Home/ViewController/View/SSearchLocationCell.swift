//
//  SSearchLocationCell.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/2.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class SSearchLocationCell: UITableViewCell {

    var model:AMapPOI = AMapPOI() {
        didSet{
            nameLabel.text = model.name
            addressLabel.text = "\(model.distance)m内 | " + model.address
        }
    }

    var nameLabel:UILabel = {
        let nameL = UILabel.init()
        nameL.font = UIFont.systemFont(ofSize: CGFloat(16*IPONE_SCALE))
        nameL.textColor = HEXCOLOR(h: 0x666666, alpha: 1)
        return nameL
    }()

    var addressLabel:UILabel = {
        let addressL = UILabel.init()
        addressL.font = UIFont.systemFont(ofSize: CGFloat(14*IPONE_SCALE))
        addressL.textColor = HEXCOLOR(h: 0x999999, alpha: 1)
        return addressL
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUp() {
        self.addSubview(nameLabel)
        self.addSubview(addressLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.bottom.equalTo(self.snp.centerY).offset(-5*IPONE_SCALE)
            make.height.equalTo(16*IPONE_SCALE)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(self.snp.centerY).offset(5*IPONE_SCALE)
            make.height.equalTo(14*IPONE_SCALE)
        }
        
        let lineV = UIView.init()
        lineV.backgroundColor = HEXCOLOR(h: 0xededed, alpha: 1)
        self.addSubview(lineV)
        lineV.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
    }

}
