//
//  XCChatImageCell.swift
//  
//
//  Created by FangLin on 2017/1/3.
//  Copyright © 2017年 FangLin. All rights reserved.
//

import UIKit
import SDWebImage

class XCChatImageCell: XCChatBaseCell {
    
    // MARK:- 模型
    override var model: XCChatMsgModel? { didSet { setModel() } }
    
    // MARK:- 定义属性
    lazy var chatImgView: UIImageView = { [unowned self] in
        let chatImgV = UIImageView()
        // 添加手势
        chatImgV.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(imgTap))
        chatImgV.addGestureRecognizer(tapGes)
        return chatImgV
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- 手势处理
extension XCChatImageCell {
    @objc fileprivate func imgTap() {
        let objDic = ["model": model!, "view": chatImgView] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNoteChatMsgTapImg), object: objDic)
    }
}


// MARK:- 设置数据
extension XCChatImageCell {
    fileprivate func setModel() {
        if subviews.contains(chatImgView) {
            chatImgView.removeFromSuperview()
        }
        addSubview(chatImgView)
        
        chatImgView.sd_setImage(with: URL.init(string: model?.imgUrl ?? ""), completed: nil)
        
        // 获取缩略图size
        let thumbSize = XCChatMsgDataHelper.shared.getThumbImageSize(model?.imgSize ?? CGSize.zero)
        
        // 重新布局
        avatar.snp.remakeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(self.snp.top)
        }
        chatImgView.snp.remakeConstraints { (make) in
            make.top.equalTo(avatar.snp.top)
            make.width.equalTo(thumbSize.width)
            make.height.equalTo(thumbSize.height)
        }
        bubbleView.snp.remakeConstraints { (make) in
            make.left.top.right.bottom.equalTo(chatImgView)
        }
        tipView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(avatar.snp.centerY)
            make.width.height.equalTo(30)
        }
        
        if model?.userType == .me {
            avatar.snp.makeConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(-10)
            }
            chatImgView.snp.makeConstraints { (make) in
                make.right.equalTo(avatar.snp.left).offset(-2)
            }
            tipView.snp.makeConstraints { (make) in
                make.right.equalTo(bubbleView.snp.left)
            }
            
        } else {
            avatar.snp.makeConstraints { (make) in
                make.left.equalTo(self.snp.left).offset(10)
            }
            chatImgView.snp.makeConstraints { (make) in
                make.left.equalTo(avatar.snp.right).offset(2)
            }
            tipView.snp.makeConstraints { (make) in
                make.left.equalTo(bubbleView.snp.right)
            }
        }
        
        model?.cellHeight = getCellHeight()
        
        // 绘制 imageView 的 bubble layer
        let stretchInsets = UIEdgeInsets(top: 30, left: 28, bottom: 23, right: 28)
        let stretchImage = model?.userType == .me ? #imageLiteral(resourceName: "SenderImageNodeMask") : #imageLiteral(resourceName: "ReceiverImageNodeMask")
        self.chatImgView.clipShape(stretchImage: stretchImage, stretchInsets: stretchInsets)

        // 绘制coerImage 盖住图片
        let stretchCoverImage = model?.userType == .me ? #imageLiteral(resourceName: "SenderImageNodeBorder") : #imageLiteral(resourceName: "ReceiverImageNodeBorder")
        let bubbleCoverImage = stretchCoverImage.resizableImage(withCapInsets: stretchInsets, resizingMode: .stretch)
        bubbleView.image = bubbleCoverImage
        
    }
}

