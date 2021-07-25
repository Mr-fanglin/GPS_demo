//
//  XCChatBaseCell.swift
//  
//
//  Created by FangLin on 2017/1/3.
//  Copyright © 2017年 FangLin. All rights reserved.
//

import UIKit

class XCChatBaseCell: UITableViewCell {
    
    // MARK:- 模型
    var model: XCChatMsgModel? {
        didSet {
            baseCellSetModel()
        }
    }
    
    lazy var avatar: UIButton = {
        let avaBtn = UIButton()
        avaBtn.layer.cornerRadius = 5
        avaBtn.layer.masksToBounds = true
        return avaBtn
    }()
    lazy var bubbleView: UIImageView = {
        return UIImageView()
    }()
    
    lazy var tipView: UIView = { [unowned self] in
        let tipV = UIView()
        tipV.addSubview(self.activityIndicator)
        tipV.addSubview(self.resendButton)
        return tipV
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let act = UIActivityIndicatorView()
        act.style = .gray
        act.hidesWhenStopped = false
        act.startAnimating()
        return act
    }()
    
    lazy var resendButton: UIButton = {
        let resendBtn = UIButton(type: .custom)
        resendBtn.setImage(#imageLiteral(resourceName: "resend"), for: .normal)
        resendBtn.contentMode = .scaleAspectFit
        resendBtn.addTarget(self, action: #selector(resend), for: .touchUpInside)
        return resendBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        selectionStyle = .none
        self.contentView.addSubview(avatar)
        self.contentView.addSubview(bubbleView)
        self.contentView.addSubview(tipView)
        
        activityIndicator.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(tipView)
        }
        resendButton.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(tipView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XCChatBaseCell {
    func baseCellSetModel() {
        tipView.isHidden = false
        activityIndicator.startAnimating()
        guard let deliveryState = model?.message?.deliveryState else {
            return
        }
        let userInfo = XCXinChatTools.shared.getFriendInfo(userId: model?.fromUserId ?? "")
        avatar.setImage(UIImage.init(named: userInfo?.userInfo?.avatarUrl ?? "DefaultProfileHead_phone"), for: .normal)
        if model?.userType == .me { // 自己
            switch deliveryState {
            case .delivering:
                resendButton.isHidden = true
                activityIndicator.isHidden = false
            case .failed:
                resendButton.isHidden = false
                activityIndicator.isHidden = true
            case .deliveried:
                tipView.isHidden = true
            }
        } else {    // 对方
            tipView.isHidden = true
        }
        
    }
}

extension XCChatBaseCell {
    // MARK:- 获取cell的高度
    func getCellHeight() -> CGFloat {
        self.layoutSubviews()
        
        if avatar.height > bubbleView.height {
            return avatar.height + 10.0
        } else {
            return bubbleView.height + 10.0
        }
    }
    
    @objc func resend() {
        Dprint("重新发送操作")
        guard let message = model?.message else {
            return
        }
        if XCXinChatTools.shared.resendMessage(message: message) {
            Dprint("重送发送成功")
        } else {
            Dprint("重送发送成失败")
        }
    }
}
