//
//  XCChatOrderCell.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/21.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class XCChatOrderCell: XCChatBaseCell {

    // MARK:- 模型
    override var model: XCChatMsgModel? { didSet { setModel() } }
    
    lazy var contentLabel:UILabel = {
        let contentL = UILabel.init()
        contentL.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        contentL.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        return contentL
    }()
    
    lazy var lineView:UIView = {
        let lineV = UIView.init()
        lineV.backgroundColor = HEXCOLOR(h: 0x999999, alpha: 1)
        return lineV
    }()
    
    lazy var lookDetailL:UILabel = {
        let lookDetail = UILabel.init()
        lookDetail.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        lookDetail.textColor = Main_Color
        lookDetail.text = "查看详情"
        return lookDetail
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bubbleView.addSubview(self.contentLabel)
        bubbleView.addSubview(lineView)
        bubbleView.addSubview(lookDetailL)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(bgTap))
        bubbleView.isUserInteractionEnabled = true
        bubbleView.addGestureRecognizer(tapGes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func bgTap() {
        if model?.modelType == .askingPick {
            if let model = model {
                let VC = SRequestHelpController()
//                let amapcoord = AMapCoordinateConvert(CLLocationCoordinate2D(latitude: model.latitude, longitude: model.longitude), AMapCoordinateType.GPS)
//                VC.childLocationCoordinate = amapcoord
                let childModel = ChildStatusModel()
                childModel.child.id = model.childId
                VC.childModel = childModel
                UIViewController.getCurrentViewCtrl().navigationController?.pushViewController(VC, animated: true)
            }
        }else if model?.modelType == .requestPick {
            if let model = model {
                let orderDetailVC = DriverOrderController()
                let orderModel = OrderModel()
                orderModel.id = model.orderId
                orderModel.fromLatitude = model.latitude
                orderModel.fromLongitude = model.longitude
                orderModel.toLatitude = model.toLatitude
                orderModel.toLongitude = model.toLongitude
                orderDetailVC.model = orderModel
                UIViewController.getCurrentViewCtrl().navigationController?.pushViewController(orderDetailVC, animated: true)
            }
        }else if model?.modelType == .agreePick {
            if let model = model {
                let orderDetailVC = DriverOrderController()
                let orderModel = OrderModel()
                orderModel.id = model.orderId
                orderDetailVC.model = orderModel
                UIViewController.getCurrentViewCtrl().navigationController?.pushViewController(orderDetailVC, animated: true)
            }
        }else if model?.modelType == .helpPick {
            if let model = model {
                let orderDetailVC = DriverOrderController()
                let orderModel = OrderModel()
                orderModel.id = model.orderId
                orderDetailVC.model = orderModel
                UIViewController.getCurrentViewCtrl().navigationController?.pushViewController(orderDetailVC, animated: true)
            }
        }
    }
}


// MARK:- 模型数据
extension XCChatOrderCell {
    fileprivate func setModel() {
        if model?.modelType == .helpPick {
            contentLabel.text = "我想帮忙接送小孩"
        }else if model?.modelType == .agreePick {
            contentLabel.text = "同意接送小孩"
        }else if model?.modelType == .requestPick {
            contentLabel.text = (model?.userName ?? "朋友") + "请求帮忙接送小孩"
        }else if model?.modelType == .askingPick {
            contentLabel.text = (model?.childName ?? "您的小孩") + " Asking pickup!"
        }
//        contentLabel.attributedText = XCChatFindEmotion.shared.findAttrStr(text: model?.text, font: contentLabel.font)
        
        // 设置泡泡
        let img = self.model?.userType == .me ? #imageLiteral(resourceName: "message_sender_background_normal") : #imageLiteral(resourceName: "message_receiver_background_normal")
        let normalImg = img.resizableImage(withCapInsets: UIEdgeInsets(top: 30, left: 28, bottom: 85, right: 28), resizingMode: .stretch)
        bubbleView.image = normalImg
        
//        let contentSize = contentLabel.sizeThatFits(CGSize(width: 220.0, height: CGFloat(FLT_MAX)))
        
        // 重新布局
        avatar.snp.remakeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(self.snp.top)
        }
        contentLabel.snp.remakeConstraints { (make) in
//            make.top.equalTo(avatar.snp.top)
            make.height.equalTo(15*IPONE_SCALE)
            make.width.equalTo(150*IPONE_SCALE)
        }
        
        lookDetailL.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(30*IPONE_SCALE)
        }
        
        bubbleView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(-2)
            make.height.equalTo(80*IPONE_SCALE)
            make.width.equalTo(200*IPONE_SCALE)
        }
        
        lineView.snp.remakeConstraints { (make) in
            make.left.equalTo(bubbleView).offset(10)
            make.right.equalTo(bubbleView).offset(-10)
            make.height.equalTo(1)
            make.bottom.equalTo(bubbleView.snp.bottom).offset(-30*IPONE_SCALE)
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
            }
            contentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(bubbleView.snp.top).offset(10)
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
            }
            contentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(bubbleView.snp.top).offset(10)
                make.left.equalTo(bubbleView.snp.left).offset(17)
            }
            tipView.snp.makeConstraints { (make) in
                make.left.equalTo(bubbleView.snp.right)
            }
        }
        
        model?.cellHeight = getCellHeight()
    }
}

