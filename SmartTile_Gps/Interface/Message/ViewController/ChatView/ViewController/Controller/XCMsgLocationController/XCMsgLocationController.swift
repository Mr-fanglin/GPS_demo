//
//  XCMsgLocationController.swift
//  XinChat
//
//  Created by FangLin on 2019/11/13.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

//地图定位控制器
class  XCMsgLocationController: UIViewController {
    
    var user: XCRecentSessionModel?
    
    var mapView:MAMapView?
    var sendBtn = UIButton.init(type: .custom)
    
    var centerAnnotation = MAPointAnnotation()  //中心的
    var currentLocationCoordinate = CLLocationCoordinate2D()  //经纬度
    var titleStr = ""   //位置名称
    
    lazy var searchListView:XCLocationSearchListView = {
        let searchView = XCLocationSearchListView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(260*IPONE_SCALE)))
        searchView.delegate = self as XCLocationSearchListViewDelegate
        return searchView
    }()

    // MARK:- init
    init(user: XCRecentSessionModel?) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setInterface()
    }
    
    deinit {
        Dprint("deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.locationAction()
    }
    
    
    func setInterface() {
        mapView = MAMapView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-CGFloat(250*IPONE_SCALE)))
        mapView?.showsUserLocation = true
        mapView?.userTrackingMode = .follow
        mapView?.mapType = MAMapType.standard
        mapView?.showsScale = false
        mapView?.showsCompass = false
        mapView?.setZoomLevel(15.8, animated: true)
        mapView?.showsWorldMap = 1
        if IOS_VERSION >= 9 {
            mapView?.allowsBackgroundLocationUpdates = true
        }
        self.view.addSubview(mapView!)
        
        let navbarBgV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(125*IPONE_SCALE)))
        self.view.addSubview(navbarBgV)
        navbarBgV.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(125*IPONE_SCALE)
        }
        navbarBgV.addGradientLayer(colors: [HEXCOLOR(h: 0x333333, alpha: 0.7).cgColor, HEXCOLOR(h: 0x666666, alpha: 0.3).cgColor, HEXCOLOR(h: 0xdcdcdc, alpha: 0).cgColor], locations: [0.0, 0.8, 1.0], isHor: false)
        
        
        let backBtn = UIButton.init(type: .custom)
        backBtn.setTitle("取消", for: .normal)
        backBtn.setTitleColor(HEXCOLOR(h: 0xffffff, alpha: 1), for: .normal)
        backBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(18*IPONE_SCALE))
        backBtn.addTarget(self, action: #selector(cancelBtnClick(sender:)), for: .touchUpInside)
        navbarBgV.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(STATUSBAR_HEIGHT)
            make.left.equalTo(15*IPONE_SCALE)
            make.width.equalTo(50*IPONE_SCALE)
            make.height.equalTo(NavbarHeight)
        }
        
        sendBtn.setTitle("发送", for: .normal)
        sendBtn.setTitleColor(.white, for: .normal)
        sendBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(18*IPONE_SCALE))
        sendBtn.backgroundColor = HEXCOLOR(h: 0x07C160, alpha: 1)
        sendBtn.layer.cornerRadius = 5
        sendBtn.layer.masksToBounds = true
        sendBtn.addTarget(self, action: #selector(sendBtnClick(sender:)), for: .touchUpInside)
        sendBtn.isEnabled = false
        navbarBgV.addSubview(sendBtn)
        sendBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15*IPONE_SCALE)
            make.centerY.equalTo(backBtn)
            make.width.equalTo(60*IPONE_SCALE)
            make.height.equalTo(35*IPONE_SCALE)
        }
        
        self.view.addSubview(searchListView)
        searchListView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(260*IPONE_SCALE)
        }
    }
}

//设置地图位置点
extension XCMsgLocationController {
    func showMapPoint() {
        mapView?.setCenter(self.currentLocationCoordinate, animated: true)
    }
    
    func setCenterPoint() {
        centerAnnotation.coordinate = self.currentLocationCoordinate
        centerAnnotation.isLockedToScreen = true
        centerAnnotation.lockedScreenPoint = mapView?.center ?? CGPoint.init()
        centerAnnotation.title = ""
        centerAnnotation.subtitle = ""
        self.mapView?.addAnnotation(centerAnnotation)
    }
}

extension XCMsgLocationController {
    @objc func sendBtnClick(sender:UIButton) {
        XCXinChatTools.shared.sendLocation(userId: user?.userId, latitude: self.currentLocationCoordinate.latitude, longitude: self.currentLocationCoordinate.longitude, title: self.titleStr)
        self.dismiss(animated: true, completion: nil)
    }
    @objc func cancelBtnClick(sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func locationAction() {
        AMapLocationHelper.shared().getOneAMapLocation { (location, regeocode) in
            self.sendBtn.isEnabled = true
            self.mapView?.delegate = self
            AMapLocationHelper.shared().delegate = self
            self.currentLocationCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let subAddressStr:String = regeocode.poiName ?? regeocode.street
            let addressStr = regeocode.province + regeocode.city + regeocode.district + regeocode.street
            self.titleStr = addressStr + "," + subAddressStr
            self.showMapPoint()
            self.setCenterPoint()
            AMapLocationHelper.shared().setMapPOIAroundSearchRequest(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
}

