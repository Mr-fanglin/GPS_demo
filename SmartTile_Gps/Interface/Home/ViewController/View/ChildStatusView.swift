//
//  ChildStatusView.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/8/25.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

enum OrderStatus:Int8 {
    case ASkING = 0   //小孩叫车
    case CREATE
    case ACCEPT
    case AGREE
    case START
    case Picked
    case ARRIVE
    case SUCCESS
    case DEFEAT
}

class ChildStatusView: AniShowCloseView {
    
    var model:ChildStatusModel = ChildStatusModel() {
        didSet{
            
            if !model.myChild {
                nameLabel.text = model.accountInfo.name + "'s child"
                driverStatusL.isHidden = true
                driverStatusL.snp.remakeConstraints { (make) in
                    make.left.equalTo(15*IPONE_SCALE)
                    make.top.equalTo(20*IPONE_SCALE)
                    make.height.equalTo(0)
                    make.width.lessThanOrEqualTo(SCREEN_WIDTH/2)
                }
                bottomView.snp.remakeConstraints { (make) in
                    make.left.equalTo(10*IPONE_SCALE)
                    make.right.equalTo(-10*IPONE_SCALE)
                    make.top.equalTo(topView.snp.bottom).offset(10*IPONE_SCALE)
                    make.height.equalTo(173*IPONE_SCALE)
                }
            }else {
                nameLabel.text = model.child.name
                driverStatusL.isHidden = false
                driverStatusL.snp.remakeConstraints { (make) in
                    make.left.equalTo(15*IPONE_SCALE)
                    make.top.equalTo(20*IPONE_SCALE)
                    make.height.equalTo(17*IPONE_SCALE)
                    make.width.lessThanOrEqualTo(SCREEN_WIDTH/2)
                }
                bottomView.snp.remakeConstraints { (make) in
                    make.left.equalTo(10*IPONE_SCALE)
                    make.right.equalTo(-10*IPONE_SCALE)
                    make.top.equalTo(topView.snp.bottom).offset(10*IPONE_SCALE)
                    make.height.equalTo(190*IPONE_SCALE)
                }
            }
            if model.order.id != 0 && model.order.orderStatus != 0 {
                locationBgV.isHidden = false
                locationBgV.snp.remakeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(90*IPONE_SCALE)
                    make.top.equalTo(driverStatusL.snp.bottom).offset(10*IPONE_SCALE)
                }
                bottomView.corner(byRoundingCorners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radii: CGFloat(15*IPONE_SCALE), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH-CGFloat(20*IPONE_SCALE), height: CGFloat(188*IPONE_SCALE)))
                bottomView.snp.remakeConstraints { (make) in
                    make.left.equalTo(10*IPONE_SCALE)
                    make.right.equalTo(-10*IPONE_SCALE)
                    make.top.equalTo(topView.snp.bottom).offset(10*IPONE_SCALE)
                    make.height.equalTo(190*IPONE_SCALE)
                }
                self.frame.origin.y = SCREEN_HEIGHT-CGFloat(263*IPONE_SCALE)-TabbarHeight
                self.frame.size.height = CGFloat(263*IPONE_SCALE)
                if model.order.orderStatus == OrderStatus.CREATE.rawValue {
                    driverStatusL.text = NSLocalizedString("Wait_Drive_takeOrder", comment: "")
                    operatBtn.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
                    operatBtn.tag = 102
                    cancelBtn.isHidden = true
                    cancelBtn.snp.remakeConstraints { (make) in
                        make.top.equalTo(lineV.snp.bottom)
                        make.bottom.equalToSuperview()
                        make.left.equalToSuperview()
                        make.width.equalTo(0)
                    }
                    operatBtn.snp.remakeConstraints { (make) in
                        make.top.equalTo(lineV.snp.bottom)
                        make.bottom.equalToSuperview()
                        make.left.equalToSuperview()
                        make.right.equalToSuperview()
                    }
                    if !model.myChild {
                        driveCallBtn.isHidden = true
                    }else {
                        driveCallBtn.isHidden = true
                    }
                }else if model.order.orderStatus == OrderStatus.ACCEPT.rawValue {
                    driverStatusL.text = String.init(format: NSLocalizedString("Drive_Want_Pickup_child", comment: ""), model.order.name)
                    operatBtn.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
                    operatBtn.tag = 102
                    cancelBtn.isHidden = true
                    cancelBtn.snp.remakeConstraints { (make) in
                        make.top.equalTo(lineV.snp.bottom)
                        make.bottom.equalToSuperview()
                        make.left.equalToSuperview()
                        make.width.equalTo(0)
                    }
                    operatBtn.snp.remakeConstraints { (make) in
                        make.top.equalTo(lineV.snp.bottom)
                        make.bottom.equalToSuperview()
                        make.left.equalToSuperview()
                        make.right.equalToSuperview()
                    }
                    if !model.myChild {
                        driveCallBtn.isHidden = true
                    }else {
                        driveCallBtn.isHidden = true
                    }
                }else if model.order.orderStatus == OrderStatus.AGREE.rawValue {
                    cancelBtn.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
                    cancelBtn.tag = 202
                    driverStatusL.text = NSLocalizedString("Wait_Drive_Pickup_child", comment: "")
                    operatBtn.setTitle(NSLocalizedString("Order_Detail", comment: ""), for: .normal)
                    operatBtn.tag = 104
                    cancelBtn.isHidden = false
                    cancelBtn.snp.remakeConstraints { (make) in
                        make.top.equalTo(lineV.snp.bottom)
                        make.bottom.equalToSuperview()
                        make.left.equalToSuperview()
                        make.right.equalTo(bottomView.snp.centerX)
                    }
                    operatBtn.snp.remakeConstraints { (make) in
                        make.top.equalTo(lineV.snp.bottom)
                        make.bottom.equalToSuperview()
                        make.left.equalTo(bottomView.snp.centerX)
                        make.right.equalToSuperview()
                    }
                    if !model.myChild {
                        driveCallBtn.isHidden = true
                    }else {
                        driveCallBtn.isHidden = false
                    }
                }else if model.order.orderStatus == OrderStatus.START.rawValue {
                    cancelBtn.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
                    cancelBtn.tag = 202
                    driverStatusL.text = NSLocalizedString("Drive_Goto_child", comment: "")
                    operatBtn.setTitle(NSLocalizedString("Order_Detail", comment: ""), for: .normal)
                    operatBtn.tag = 104
                    cancelBtn.isHidden = false
                    cancelBtn.snp.remakeConstraints { (make) in
                        make.top.equalTo(lineV.snp.bottom)
                        make.bottom.equalToSuperview()
                        make.left.equalToSuperview()
                        make.right.equalTo(bottomView.snp.centerX)
                    }
                    operatBtn.snp.remakeConstraints { (make) in
                        make.top.equalTo(lineV.snp.bottom)
                        make.bottom.equalToSuperview()
                        make.left.equalTo(bottomView.snp.centerX)
                        make.right.equalToSuperview()
                    }
                    if !model.myChild {
                        driveCallBtn.isHidden = true
                    }else {
                        driveCallBtn.isHidden = false
                    }
                }else if model.order.orderStatus == OrderStatus.Picked.rawValue {
                    driverStatusL.text = NSLocalizedString("Drive_has_pickup_child", comment: "")
                    operatBtn.setTitle(NSLocalizedString("Order_Detail", comment: ""), for: .normal)
                    operatBtn.tag = 104
                    cancelBtn.isHidden = true
                    cancelBtn.snp.remakeConstraints { (make) in
                        make.top.equalTo(lineV.snp.bottom)
                        make.bottom.equalToSuperview()
                        make.left.equalToSuperview()
                        make.width.equalTo(0)
                    }
                    operatBtn.snp.remakeConstraints { (make) in
                        make.top.equalTo(lineV.snp.bottom)
                        make.bottom.equalToSuperview()
                        make.left.equalToSuperview()
                        make.right.equalToSuperview()
                    }
                    if !model.myChild {
                        driveCallBtn.isHidden = true
                    }else {
                        driveCallBtn.isHidden = false
                    }
                }else if model.order.orderStatus == OrderStatus.ARRIVE.rawValue {
                    cancelBtn.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
                    cancelBtn.tag = 202
                    driverStatusL.text = NSLocalizedString("Arrived_destination", comment: "")
                    operatBtn.setTitle(NSLocalizedString("Finish", comment: ""), for: .normal)
                    operatBtn.tag = 103
                    cancelBtn.isHidden = true
                    cancelBtn.snp.remakeConstraints { (make) in
                        make.top.equalTo(lineV.snp.bottom)
                        make.bottom.equalToSuperview()
                        make.left.equalToSuperview()
                        make.width.equalTo(0)
                    }
                    operatBtn.snp.remakeConstraints { (make) in
                        make.top.equalTo(lineV.snp.bottom)
                        make.bottom.equalToSuperview()
                        make.left.equalToSuperview()
                        make.right.equalToSuperview()
                    }
                    if !model.myChild {
                        driveCallBtn.isHidden = true
                    }else {
                        driveCallBtn.isHidden = true
                    }
                }
                agreeAcceptBtn.isHidden = true
                AMapLocationHelper.shared().setMapReGeocodeSearchRequest(latitude: model.order.fromLatitude, longitude: model.order.fromLongitude)
                AMapLocationHelper.shared().setMapReGeocodeSearchRequest(latitude: model.order.toLatitude, longitude: model.order.toLongitude)
            }else {
                cancelBtn.setTitle(NSLocalizedString("My_pickup", comment: ""), for: .normal)
                cancelBtn.tag = 201
                driverStatusL.text = NSLocalizedString("No_travel_status", comment: "")
                operatBtn.setTitle(NSLocalizedString("Please_pickup", comment: ""), for: .normal)
                operatBtn.tag = 101
                agreeAcceptBtn.isHidden = true
                locationBgV.isHidden = true
                driveCallBtn.isHidden = true
                locationBgV.snp.remakeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(0)
                    make.top.equalTo(driverStatusL.snp.bottom).offset(10*IPONE_SCALE)
                }
                cancelBtn.isHidden = true
                cancelBtn.snp.remakeConstraints { (make) in
                    make.top.equalTo(lineV.snp.bottom)
                    make.bottom.equalToSuperview()
                    make.left.equalToSuperview()
                    make.width.equalTo(0)
                }
                operatBtn.snp.remakeConstraints { (make) in
                    make.top.equalTo(lineV.snp.bottom)
                    make.bottom.equalToSuperview()
                    make.left.equalToSuperview()
                    make.right.equalToSuperview()
                }
                bottomView.corner(byRoundingCorners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radii: CGFloat(15*IPONE_SCALE), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH-CGFloat(20*IPONE_SCALE), height: CGFloat(98*IPONE_SCALE)))
                bottomView.snp.remakeConstraints { (make) in
                    make.left.equalTo(10*IPONE_SCALE)
                    make.right.equalTo(-10*IPONE_SCALE)
                    make.top.equalTo(topView.snp.bottom).offset(10*IPONE_SCALE)
                    make.height.equalTo(100*IPONE_SCALE)
                }
                self.frame.origin.y = SCREEN_HEIGHT-CGFloat(173*IPONE_SCALE)-TabbarHeight
                self.frame.size.height = CGFloat(173*IPONE_SCALE)
            }
            
        }
    }
    
    var homeStatusModel:HomeStatusModel = HomeStatusModel() {
        didSet{
            if homeStatusModel.driveId != 0 {
//                if homeStatusModel.orderStatus == OrderStatus.ASkING.rawValue {
                driverStatusL.text = String.init(format: NSLocalizedString("Drive_Want_Pickup_child", comment: ""), homeStatusModel.driveName)
                agreeAcceptBtn.isHidden = false
//                }else {
//
//                }
            }
        }
    }
    
    var topView:UIView = UIView.init()
    var headImg:UIImageView = UIImageView.init()
    var nameLabel:UILabel = UILabel.init()
    var callBtn:UIButton = UIButton.init()
    var mapViewBtn:UIButton = UIButton.init()
    
    var bottomView:UIView = UIView.init()
    var driverStatusL:UILabel = UILabel.init()   //司机状态
    var driveCallBtn:UIButton = UIButton.init(type: .custom)   //司机电话
    var agreeAcceptBtn:UIButton = UIButton.init(type: .custom)  //同意接送按钮
    var locationBgV:UIView = UIView.init()
    var startLocationImg:UIImageView = UIImageView.init()
    var startLocation:UILabel = UILabel.init()
    var startNaviBtn:UIButton = UIButton.init(type: .custom)
    
    var endLocationImg:UIImageView = UIImageView.init()
    var endLocation:UILabel = UILabel.init()
    var endNaviBtn:UIButton = UIButton.init(type: .custom)
    
    var lineV:UIView = UIView.init()
    var operatBtn:UIButton = UIButton.init(type: .custom)
    var cancelBtn:UIButton = UIButton.init(type: .custom)

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
        let phone = "telprompt://" + model.child.phone
        guard let url = URL.init(string: phone) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                Dprint("success")
            }
        }else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func mapViewBtnAction() {
        let gpsLocation = AMapCoordinateConvert(CLLocationCoordinate2D(latitude: model.device.latitude, longitude: model.device.longitude), AMapCoordinateType.GPS)
//        let appName = "高德地图"
//        let urlString = "iosamap://path?sourceApplication=\(appName)&dname=&dlat=\(gpsLocation.latitude)&dlon=\(gpsLocation.longitude)&t=\(0)"
//        if self.openMap(urlString) == false {
//            print("您还没有安装高德地图")
//
//        }
        let currentLocation = MKMapItem.forCurrentLocation()
        let toLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: gpsLocation, addressDictionary: nil))
        MKMapItem.openMaps(with: [currentLocation,toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:NSNumber.init(value: true)])
        
    }
    @objc func startNaviBtnAction() {
//        let appName = "高德地图"
//        let urlString = "iosamap://path?sourceApplication=\(appName)&dname=&dlat=\(model.order.fromLatitude)&dlon=\(model.order.fromLongitude)&t=\(0)"
//        if self.openMap(urlString) == false {
//            print("您还没有安装高德地图")
//
//        }
        
        let gpsLocation = AMapCoordinateConvert(CLLocationCoordinate2D(latitude: model.order.fromLatitude, longitude: model.order.fromLongitude), AMapCoordinateType.GPS)
        let currentLocation = MKMapItem.forCurrentLocation()
        let toLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: gpsLocation, addressDictionary: nil))
        MKMapItem.openMaps(with: [currentLocation,toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:NSNumber.init(value: true)])
    }
    @objc func endNaviBtnAction() {
//        let appName = "高德地图"
//        let urlString = "iosamap://path?sourceApplication=\(appName)&dname=&dlat=\(model.order.toLatitude)&dlon=\(model.order.toLongitude)&t=\(0)"
//        if self.openMap(urlString) == false {
//            print("您还没有安装高德地图")
//
//        }
        let gpsLocation = AMapCoordinateConvert(CLLocationCoordinate2D(latitude: model.order.toLatitude, longitude: model.order.toLongitude), AMapCoordinateType.GPS)
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
    
    @objc func driveCallBtnAction() {
        let phone = "telprompt://" + model.accountInfo.phone
        guard let url = URL.init(string: phone) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                Dprint("success")
            }
        }else {
            UIApplication.shared.openURL(url)
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
        bottomView.corner(byRoundingCorners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radii: CGFloat(15*IPONE_SCALE), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH-CGFloat(20*IPONE_SCALE), height: CGFloat(188*IPONE_SCALE)))
        self.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(10*IPONE_SCALE)
            make.right.equalTo(-10*IPONE_SCALE)
            make.top.equalTo(topView.snp.bottom).offset(10*IPONE_SCALE)
            make.height.equalTo(188*IPONE_SCALE)
        }
        
        driverStatusL.text = NSLocalizedString("No_travel_status", comment: "")
        driverStatusL.textColor = Main_Color
        driverStatusL.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        bottomView.addSubview(driverStatusL)
        driverStatusL.snp.makeConstraints { (make) in
            make.left.equalTo(15*IPONE_SCALE)
            make.top.equalTo(20*IPONE_SCALE)
            make.height.equalTo(17*IPONE_SCALE)
            make.width.lessThanOrEqualTo((SCREEN_WIDTH/2)+30)
        }
        
        driveCallBtn.setImage(UIImage.init(named: "home_journey_phone"), for: .normal)
        driveCallBtn.addTarget(self, action: #selector(driveCallBtnAction), for: .touchUpInside)
        bottomView.addSubview(driveCallBtn)
        driveCallBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(driverStatusL)
            make.width.height.equalTo(40*IPONE_SCALE)
            make.right.equalTo(-20*IPONE_SCALE)
        }
        
        agreeAcceptBtn.setTitle(NSLocalizedString("Agree", comment: ""), for: .normal)
        agreeAcceptBtn.setTitleColor(Main_Color, for: .normal)
        agreeAcceptBtn.layer.borderWidth = 1
        agreeAcceptBtn.layer.borderColor = Main_Color.cgColor
        agreeAcceptBtn.layer.cornerRadius = 4
        agreeAcceptBtn.layer.masksToBounds = true
        agreeAcceptBtn.isHidden = true
        agreeAcceptBtn.addTarget(self, action: #selector(agreeAcceptBtnAction), for: .touchUpInside)
        bottomView.addSubview(agreeAcceptBtn)
        agreeAcceptBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-10*IPONE_SCALE)
            make.centerY.equalTo(driverStatusL)
            make.width.equalTo(50*IPONE_SCALE)
            make.height.equalTo(30*IPONE_SCALE)
        }
        
        locationBgV.backgroundColor = .white
        locationBgV.isHidden = true
        bottomView.addSubview(locationBgV)
        locationBgV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(90*IPONE_SCALE)
            make.top.equalTo(driverStatusL.snp.bottom).offset(10*IPONE_SCALE)
        }
        startLocationImg.image = UIImage.init(named: "home_journey_ic_start")
        locationBgV.addSubview(startLocationImg)
        startLocationImg.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.top.equalTo(10*IPONE_SCALE)
            make.width.height.equalTo(30*IPONE_SCALE)
        }
        startLocation.text = NSLocalizedString("Start_Location", comment: "")
        startLocation.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        startLocation.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        locationBgV.addSubview(startLocation)
        startLocation.snp.makeConstraints { (make) in
            make.left.equalTo(startLocationImg.snp.right).offset(10*IPONE_SCALE)
            make.right.equalTo(-60*IPONE_SCALE)
            make.height.equalTo(17*IPONE_SCALE)
            make.centerY.equalTo(startLocationImg)
        }
        startNaviBtn.setImage(UIImage.init(named: "home_nav_location_normal"), for: .normal)
        startNaviBtn.addTarget(self, action: #selector(startNaviBtnAction), for: .touchUpInside)
        locationBgV.addSubview(startNaviBtn)
        startNaviBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-10*IPONE_SCALE)
            make.centerY.equalTo(startLocation)
            make.width.height.equalTo(40*IPONE_SCALE)
        }
        
        endLocationImg.image = UIImage.init(named: "home_journey_ic_end")
        locationBgV.addSubview(endLocationImg)
        endLocationImg.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.top.equalTo(startLocationImg.snp.bottom).offset(10*IPONE_SCALE)
            make.width.height.equalTo(30*IPONE_SCALE)
        }
        endLocation.text = NSLocalizedString("End_Location", comment: "")
        endLocation.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        endLocation.font = UIFont.systemFont(ofSize: CGFloat(15*IPONE_SCALE))
        locationBgV.addSubview(endLocation)
        endLocation.snp.makeConstraints { (make) in
            make.left.equalTo(endLocationImg.snp.right).offset(10*IPONE_SCALE)
            make.right.equalTo(-60*IPONE_SCALE)
            make.height.equalTo(17*IPONE_SCALE)
            make.centerY.equalTo(endLocationImg)
        }
        endNaviBtn.setImage(UIImage.init(named: "home_nav_location_normal"), for: .normal)
        endNaviBtn.addTarget(self, action: #selector(endNaviBtnAction), for: .touchUpInside)
        locationBgV.addSubview(endNaviBtn)
        endNaviBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-10*IPONE_SCALE)
            make.centerY.equalTo(endLocation)
            make.width.height.equalTo(40*IPONE_SCALE)
        }
        
        lineV.backgroundColor = HEXCOLOR(h: 0xededed, alpha: 1)
        bottomView.addSubview(lineV)
        lineV.snp.makeConstraints { (make) in
            make.left.equalTo(24*IPONE_SCALE)
            make.right.equalTo(-24*IPONE_SCALE)
            make.height.equalTo(1)
            make.top.equalTo(locationBgV.snp.bottom)
        }
        
        cancelBtn.isHidden = true
        cancelBtn.setTitle(NSLocalizedString("My_pickup", comment: ""), for: .normal)
        cancelBtn.tag = 201
        cancelBtn.setTitleColor(HEXCOLOR(h: 0x666666, alpha: 1), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(18*IPONE_SCALE))
        cancelBtn.addTarget(self, action: #selector(cancelBtn(sender:)), for: .touchUpInside)
        bottomView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lineV.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(0)
        }
        
        operatBtn.setTitle(NSLocalizedString("Please_pickup", comment: ""), for: .normal)
        operatBtn.tag = 101
        operatBtn.setTitleColor(Main_Color, for: .normal)
        operatBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(18*IPONE_SCALE))
        operatBtn.addTarget(self, action: #selector(operatBtn(sender:)), for: .touchUpInside)
        bottomView.addSubview(operatBtn)
        operatBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lineV.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalTo(bottomView.snp.centerX)
            make.right.equalToSuperview()
        }
    }
    
    var operatBtnActionBlock:((_ model:ChildStatusModel)->())?
    var cancelBtnActionBlock:((_ model:ChildStatusModel)->())?
    var finishBtnActionBlock:((_ model:ChildStatusModel)->())?
    var orderDetailActionBlock:((_ model:ChildStatusModel)->())?
    @objc func operatBtn(sender:UIButton){
        if sender.tag == 101 {
            if let block = operatBtnActionBlock {
                block(model)
            }
        }else if sender.tag == 102 {
            if let block = cancelBtnActionBlock {
                block(model)
            }
        }else if sender.tag == 103 {
            if let block = finishBtnActionBlock {
                block(model)
            }
        }else if sender.tag == 104 {
            if let block = orderDetailActionBlock {
                block(model)
            }
        }
        
    }
    
    @objc func cancelBtn(sender:UIButton) {
        if let block = cancelBtnActionBlock {
            block(model)
        }
    }
    
    var agreeAcceptBtnActionBlock:((_ model:HomeStatusModel)->())?
    @objc func agreeAcceptBtnAction() {
        if let block = agreeAcceptBtnActionBlock {
            block(homeStatusModel)
        }
    }
}
