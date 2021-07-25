//
//  XCSettingSimpleMidCell.swift
//  XinChat
//
//  Created by FangLin on 2019/10/30.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class XCSettingSimpleMidCell: XCSettingBaseCell {

    override var model: XCSettingCellModel? {
        didSet {
            self.setModel()
        }
    }
    
    // MARK:- 懒加载
    lazy var titleLabel: UILabel = {
        let titleL = UILabel()
        titleL.textAlignment = .center
        return titleL
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(titleLabel)
        // 布局
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XCSettingSimpleMidCell {
    fileprivate func setModel() {
        titleLabel.text = model?.title
    }
}

