//
//  XCChatTextCell.swift
//
//
//  Created by FangLin on 2017/1/3.
//  Copyright © 2017年 FangLin. All rights reserved.
//

import UIKit

class XCChatTextCell: XCChatBaseCell {
    
    // MARK:- 模型
    override var model: XCChatMsgModel? { didSet { setModel() } }
    
    // MARK:- 懒加载
    lazy var contentLabel: UILabel = {
        let contentL = UILabel()
        contentL.numberOfLines = 0
        contentL.textAlignment = .left
        contentL.font = UIFont.systemFont(ofSize: 16.0)
        return contentL
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bubbleView.addSubview(self.contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 模型数据
extension XCChatTextCell {
    fileprivate func setModel() {
        contentLabel.attributedText = XCChatFindEmotion.shared.findAttrStr(text: model?.text, font: contentLabel.font)
        
        // 设置泡泡
        let img = self.model?.userType == .me ? #imageLiteral(resourceName: "message_sender_background_normal") : #imageLiteral(resourceName: "message_receiver_background_normal")
        let normalImg = img.resizableImage(withCapInsets: UIEdgeInsets(top: 30, left: 28, bottom: 85, right: 28), resizingMode: .stretch)
        bubbleView.image = normalImg
        
        let contentSize = contentLabel.sizeThatFits(CGSize(width: 220.0, height: CGFloat(FLT_MAX)))
        
        // 重新布局
        avatar.snp.remakeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(self.snp.top)
        }
        bubbleView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(-2)
            make.bottom.equalTo(contentLabel.snp.bottom).offset(16)
        }
        contentLabel.snp.remakeConstraints { (make) in
            make.height.equalTo(contentSize.height)
            make.width.equalTo(contentSize.width)
        }
        tipView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(avatar.snp.centerY)
            make.width.height.equalTo(30)
        }
        
        if model?.userType == .me {
            avatar.snp.makeConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(-10)
            }
            bubbleView.snp.makeConstraints { (make) in
                make.right.equalTo(avatar.snp.left).offset(-2)
                make.left.equalTo(contentLabel.snp.left).offset(-20)
            }
            contentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(bubbleView.snp.top).offset(12)
                make.right.equalTo(bubbleView.snp.right).offset(-17)
            }
            tipView.snp.makeConstraints { (make) in
                make.right.equalTo(bubbleView.snp.left)
            }
            
        } else {
            avatar.snp.makeConstraints { (make) in
                make.left.equalTo(self.snp.left).offset(10)
            }
            
            bubbleView.snp.makeConstraints { (make) in
                make.left.equalTo(avatar.snp.right).offset(2)
                make.right.equalTo(contentLabel.snp.right).offset(20)
            }
            contentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(bubbleView.snp.top).offset(12)
                make.left.equalTo(bubbleView.snp.left).offset(17)
            }
            tipView.snp.makeConstraints { (make) in
                make.left.equalTo(bubbleView.snp.right)
            }
        }
        
        model?.cellHeight = getCellHeight()
    }
}
