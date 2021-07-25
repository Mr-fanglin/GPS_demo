//
//  DriveStatusView.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/22.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class DriveStatusView: UIView,AMapReGeocodeSearchDelegate {
    
    var statusModel:ChildStatusModel = ChildStatusModel() {
        didSet{
            callBtn.isHidden = true
            if !statusModel.myChild {
                if statusModel.hasAccept {
                    operatBtn.tag = 100
                    operatBtn.setTitle(NSLocalizedString("Request Sent", comment: ""), for: .normal)
                }else {
                    if statusModel.order.receiverId == 0 {
                        operatBtn.setTitle(NSLocalizedString("Help pick up", comment: ""), for: .normal)
                        operatBtn.tag = 101
                    }else if statusModel.order.receiverId == UserInfo.mr_findFirst()?.idaccount {
                        operatBtn.tag = 100
                        operatBtn.setTitle(NSLocalizedString("Request Sent", comment: ""), for: .normal)
                    }else if statusModel.order.receiverId != 0 && statusModel.order.receiverId != UserInfo.mr_findFirst()?.idaccount {
                        operatBtn.tag = 100
                        operatBtn.setTitle(NSLocalizedString("The order accepted", comment: ""), for: .normal)
                    }
                }
            }
            if statusModel.myChild {
                nameLabel.text = statusModel.child.name
            }else {
                nameLabel.text = statusModel.order.guardianName + "'s child"
            }
            AMapLocationHelper.shared().setMapReGeocodeSearchRequest(latitude: statusModel.order.fromLatitude, longitude: statusModel.order.fromLongitude)
            AMapLocationHelper.shared().setMapReGeocodeSearchRequest(latitude: statusModel.order.toLatitude, longitude: statusModel.order.toLongitude)
        }
    }
    
    var topView:UIView = UIView.init()
    var headImg:UIImageView = UIImageView.init()
    var nameLabel:UILabel = UILabel.init()
    var callBtn:UIButton = UIButton.init()
    var mapViewBtn:UIButton = UIButton.init()
    
    var bottomView:UIView = UIView.init()
    var locationBgV:UIView = UIView.init()
    var startLocationImg:UIImageView = UIImageView.init()
    var startLocation:UILabel = UILabel.init()
    var endLocationImg:UIImageView = UIImageView.init()
    var endLocation:UILabel = UILabel.init()
    var lineV:UIView = UIView.init()
    var operatBtn:UIButton = UIButton.init(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = HEXCOLOR(h: 0xffffff, alpha: 0.1)
        self.setInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Action
    @objc func callBtnAction() {
//        let phone = "telprompt://" + orderModel.
//        guard let url = URL.init(string: phone) else {
//            return
//        }
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(url, options: [:]) { (success) in
//                Dprint("success")
//            }
//        }else {
//            UIApplication.shared.openURL(url)
//        }
    }
    
    @objc func mapViewBtnAction() {
//        let appName = "高德地图"
//        let urlString = "iosamap://path?sourceApplication=\(appName)&dname=&dlat=\(statusModel.order.fromLatitude)&dlon=\(statusModel.order.fromLongitude)&t=\(0)"
//        if self.openMap(urlString) == false {
//            print("您还没有安装高德地图")
//
//        }
        let gpsLocation = AMapCoordinateConvert(CLLocationCoordinate2D(latitude: statusModel.order.fromLatitude, longitude: statusModel.order.fromLongitude), AMapCoordinateType.GPS)
        let currentLocation = MKMapItem.forCurrentLocation()
        let toLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: gpsLocation, addressDictionary: nil))
        MKMapItem.openMaps(with: [currentLocation,toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:NSNumber.init(value: true)])
    }
    private func openMap(_ urlString: String) -> Bool {
        guard let url = URL.init(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            return false
        }
        if UIApplication.shared.canOpenURL(url) == true {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:]) { (success) in
                    Dprint("success")
                }
            }else {
                UIApplication.shared.openURL(url)
            }
            return true
        } else {
            return false
        }
    }
    
    //MARK: - UI
    func setInterface() {
        topView.backgroundColor = .white
        topView.layer.cornerRadius = CGFloat(55*IPONE_SCALE)/2
        topView.layer.masksToBounds = true
        self.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.equalTo(11*IPONE_SCALE)
            make.right.equalTo(-11*IPONE_SCALE)
            make.top.equalToSuperview()
            make.height.equalTo(55*IPONE_SCALE)
        }
        
        headImg.image = UIImage.init(named: "home_journey_trust_normal_50%")
        headImg.layer.cornerRadius = CGFloat(40*IPONE_SCALE)/2
        headImg.layer.masksToBounds = true
        topView.addSubview(headImg)
        headImg.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15*IPONE_SCALE)
            make.width.height.equalTo(40*IPONE_SCALE)
        }
        
        nameLabel.font = UIFont.systemFont(ofSize: CGFloat(16*IPONE_SCALE))
        nameLabel.textColor = HEXCOLOR(h: 0x3A3A3A, alpha: 1)
        topView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImg.snp.right).offset(19*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.height.equalTo(20*IPONE_SCALE)
        }
        
        callBtn.setImage(UIImage.init(named: "home_journey_phone"), for: .normal)
        callBtn.addTarget(self, action: #selector(callBtnAction), for: .touchUpInside)
        topView.addSubview(callBtn)
        callBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40*IPONE_SCALE)
            make.right.equalTo(-80*IPONE_SCALE)
        }
        
        mapViewBtn.setImage(UIImage.init(named: "home_journey_location"), for: .normal)
        mapViewBtn.addTarget(self, action: #selector(mapViewBtnAction), for: .touchUpInside)
        topView.addSubview(mapViewBtn)
        mapViewBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40*IPONE_SCALE)
            make.right.equalTo(-20*IPONE_SCALE)
        }
        
        bottomView.backgroundColor = .white
        bottomView.corner(byRoundingCorners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radii: CGFloat(15*IPONE_SCALE), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH-CGFloat(20*IPONE_SCALE), height: CGFloat(160*IPONE_SCALE)))
        self.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(10*IPONE_SCALE)
            make.right.equalTo(-10*IPONE_SCALE)
            make.top.equalTo(topView.snp.bottom).offset(10*IPONE_SCALE)
            make.height.equalTo(160*IPONE_SCALE)
        }
        
        locationBgV.backgroundColor = .white
        locationBgV.isHidden = false
        bottomView.addSubview(locationBgV)
        locationBgV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(90*IPONE_SCALE)
            make.top.equalTo(10*IPONE_SCALE)
        }
        startLocationImg.image = UIImage.init(named: "home_journey_ic_start")
        locationBgV.addSubview(startLocationImg)
        startLocationImg.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.top.equalTo(10*IPONE_SCALE)
            make.width.height.equalTo(30*IPONE_SCALE)
        }
        startLocation.text = "开始位置"
        startLocation.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        startLocation.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        locationBgV.addSubview(startLocation)
        startLocation.snp.makeConstraints { (make) in
            make.left.equalTo(startLocationImg.snp.right).offset(10*IPONE_SCALE)
            make.right.equalTo(-20*IPONE_SCALE)
            make.height.equalTo(17*IPONE_SCALE)
            make.centerY.equalTo(startLocationImg)
        }
        
        endLocationImg.image = UIImage.init(named: "home_journey_ic_end")
        locationBgV.addSubview(endLocationImg)
        endLocationImg.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.top.equalTo(startLocationImg.snp.bottom).offset(10*IPONE_SCALE)
            make.width.height.equalTo(30*IPONE_SCALE)
        }
        endLocation.text = "终点位置"
        endLocation.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        endLocation.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        locationBgV.addSubview(endLocation)
        endLocation.snp.makeConstraints { (make) in
            make.left.equalTo(endLocationImg.snp.right).offset(10*IPONE_SCALE)
            make.right.equalTo(-20*IPONE_SCALE)
            make.height.equalTo(17*IPONE_SCALE)
            make.centerY.equalTo(endLocationImg)
        }
        
        lineV.backgroundColor = HEXCOLOR(h: 0xededed, alpha: 1)
        bottomView.addSubview(lineV)
        lineV.snp.makeConstraints { (make) in
            make.left.equalTo(24*IPONE_SCALE)
            make.right.equalTo(-24*IPONE_SCALE)
            make.height.equalTo(1)
            make.top.equalTo(locationBgV.snp.bottom)
        }
        
        operatBtn.setTitle("帮忙接送", for: .normal)
        operatBtn.tag = 101
        operatBtn.setTitleColor(Main_Color, for: .normal)
        operatBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(18*IPONE_SCALE))
        operatBtn.addTarget(self, action: #selector(operatBtn(sender:)), for: .touchUpInside)
        bottomView.addSubview(operatBtn)
        operatBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lineV.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalTo(20*IPONE_SCALE)
            make.right.equalTo(-20*IPONE_SCALE)
        }
    }
    
    var helpBtnActionBlock:((_ model:ChildStatusModel)->())?
    var cancelBtnActionBlock:((_ model:OrderModel)->())?
    var finishBtnActionBlock:((_ model:OrderModel)->())?
    @objc func operatBtn(sender:UIButton){
        if sender.tag == 101 {
            if let block = helpBtnActionBlock {
                block(statusModel)
            }
        }else if sender.tag == 102 {
            
        }
        
    }

}
