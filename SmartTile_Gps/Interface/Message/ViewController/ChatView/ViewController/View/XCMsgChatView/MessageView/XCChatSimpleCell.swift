//
//  XCChatSimpleCell.swift
//  XinChat
//
//  Created by FangLin on 2019/12/5.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class XCChatSimpleCell: UITableViewCell {

    // MARK:- 模型
    var model: XCChatMsgModel? {
        didSet {
            setModel()
        }
    }
    // MARK:- 懒加载
    lazy var contentLabel: UILabel = {
        let contentL = UILabel()
        contentL.textColor = HEXCOLOR(h: 0xA0A0A0, alpha: 1)
        contentL.font = UIFont.systemFont(ofSize: 15)
        return contentL
    }()
    
    // MARK:- init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.addSubview(contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XCChatSimpleCell {
    fileprivate func setModel() {
        guard let model = model else {
            return
        }
        model.cellHeight = getCellHeight()
        if (model.sessionId?.contains("system_01"))! {
            contentLabel.text = model.text
        }else if model.modelType == .orderTip {
            if model.status == OrderStatus.START.rawValue {
                contentLabel.text = "司机正在路上"
            }else if model.status == OrderStatus.Picked.rawValue {
                contentLabel.text = "司机已接到小孩"
            }else if model.status == OrderStatus.ARRIVE.rawValue {
                contentLabel.text = "已送达目的地"
            }else if model.status == OrderStatus.SUCCESS.rawValue {
                contentLabel.text = "订单完成"
            }
        }else {
            contentLabel.text = model.addSucTip
        }
        contentLabel.sizeToFit()
        contentLabel.snp.remakeConstraints { (make) in
            make.width.equalTo(contentLabel.width)
            make.height.equalTo(contentLabel.height)
            make.center.equalTo(self.snp.center)
        }
    }
}

extension XCChatSimpleCell {
    // MARK:- 获取cell的高度
    func getCellHeight() -> CGFloat {
        return CGFloat(20*IPONE_SCALE)
    }
}
