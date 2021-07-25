//
//  XCChatLocationCell.swift
//  XinChat
//
//  Created by FangLin on 2019/11/18.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class XCChatLocationCell: XCChatBaseCell {
    
    override var model: XCChatMsgModel? { didSet { setModel() } }
    
    //MARK: 定义属性
    var chatBgView:UIView = {
        let bgV = UIView.init()
        bgV.backgroundColor = .white
        return bgV
    }()
    var titleLabel:UILabel = {
        let titleL = UILabel.init()
        titleL.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        titleL.font = UIFont.systemFont(ofSize: CGFloat(17*IPONE_SCALE))
        return titleL
    }()
    var subTitleLabel:UILabel = {
        let subTitleL = UILabel.init()
        subTitleL.textColor = HEXCOLOR(h: 0x999999, alpha: 1)
        subTitleL.font = UIFont.systemFont(ofSize: CGFloat(14*IPONE_SCALE))
        return subTitleL
    }()
    var mapView:MAMapView = {
        let mapV = MAMapView.init(frame: CGRect.init(x: 0, y: 0, width: CGFloat(235*IPONE_SCALE), height: CGFloat(97*IPONE_SCALE)))
        mapV.showsUserLocation = false
        mapV.showsScale = false
        mapV.showsCompass = false
        mapV.setZoomLevel(15.7, animated: true)
        mapV.isScrollEnabled = false
        mapV.isZoomEnabled = false
        mapV.showsWorldMap = 1
        return mapV
    }()
    
    var centerAnnotation = MAPointAnnotation()
    var currentLocationCoordinate = CLLocationCoordinate2D()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bubbleView.addSubview(chatBgView)
        chatBgView.addSubview(titleLabel)
        chatBgView.addSubview(subTitleLabel)
        chatBgView.addSubview(mapView)
        mapView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XCChatLocationCell {
    fileprivate func setModel() {
        guard let model = model else {
            return
        }
       
        let contentArr = model.title?.components(separatedBy: ",") ?? []
        if contentArr.count >= 2 {
            titleLabel.text = contentArr[1]
            subTitleLabel.text = contentArr[0]
        }else {
            titleLabel.text = "[位置]"
        }
        
        ///设置地图
        currentLocationCoordinate = CLLocationCoordinate2DMake(model.latitude, model.longitude)
        mapView.setCenter(currentLocationCoordinate, animated: true)
        centerAnnotation.coordinate = currentLocationCoordinate
        centerAnnotation.isLockedToScreen = true
        centerAnnotation.lockedScreenPoint = mapView.center
        mapView.addAnnotation(centerAnnotation)
        
        // 重新布局
        avatar.snp.remakeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(self.snp.top)
        }
        chatBgView.snp.remakeConstraints { (make) in
            make.top.equalTo(avatar.snp.top)
            make.width.equalTo(235*IPONE_SCALE)
            make.height.equalTo(148*IPONE_SCALE)
        }
        bubbleView.snp.remakeConstraints { (make) in
            make.left.top.right.bottom.equalTo(chatBgView)
        }
        tipView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(avatar.snp.centerY)
            make.width.height.equalTo(30)
        }
        titleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(15*IPONE_SCALE)
            make.top.equalTo(10*IPONE_SCALE)
            make.height.equalTo(17*IPONE_SCALE)
            make.right.equalTo(-15*IPONE_SCALE)
        }
        subTitleLabel.snp.remakeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5*IPONE_SCALE)
            make.height.equalTo(14*IPONE_SCALE)
        }
        mapView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(subTitleLabel.snp.bottom).offset(5*IPONE_SCALE)
        }
        
        if model.userType == .me {
            avatar.snp.makeConstraints { (make) in
                make.right.equalTo(self.snp.right).offset(-10)
            }
            chatBgView.snp.makeConstraints { (make) in
                make.right.equalTo(avatar.snp.left).offset(-2)
            }
            tipView.snp.makeConstraints { (make) in
                make.right.equalTo(bubbleView.snp.left)
            }
        } else {
            avatar.snp.makeConstraints { (make) in
                make.left.equalTo(self.snp.left).offset(10)
            }
            chatBgView.snp.makeConstraints { (make) in
                make.left.equalTo(avatar.snp.right).offset(2)
            }
            tipView.snp.makeConstraints { (make) in
                make.left.equalTo(bubbleView.snp.right)
            }
        }
        
        model.cellHeight = getCellHeight()
        
        // 绘制 imageView 的 bubble layer
        let stretchInsets = UIEdgeInsets(top: 30, left: 28, bottom: 23, right: 28)
        let stretchImage = model.userType == .me ? #imageLiteral(resourceName: "SenderImageNodeMask") : #imageLiteral(resourceName: "ReceiverImageNodeMask")
        self.chatBgView.clipShape(stretchImage: stretchImage, stretchInsets: stretchInsets)
        
        // 绘制coerImage 盖住图片
        let stretchCoverImage = model.userType == .me ? #imageLiteral(resourceName: "SenderImageNodeBorder") : #imageLiteral(resourceName: "ReceiverImageNodeBorder")
        let bubbleCoverImage = stretchCoverImage.resizableImage(withCapInsets: stretchInsets, resizingMode: .stretch)
        bubbleView.image = bubbleCoverImage
    }
}

extension XCChatLocationCell: MAMapViewDelegate {
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            annotationView!.image = UIImage(named: "poi_checkbox_on")
            annotationView!.centerOffset = CGPoint.init(x: 0, y: -70)
            return annotationView!
        }
        return nil
    }
}
