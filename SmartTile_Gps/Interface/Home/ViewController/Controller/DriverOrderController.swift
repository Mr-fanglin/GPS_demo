//
//  DriverOrderController.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/22.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class DriverOrderController: SBaseController, AMapNaviDriveManagerDelegate {
    
    var model:OrderModel = OrderModel() 
    
    var startAnnotation = MAPointAnnotation() //小孩送达位置
    var startLocationCoordinate = CLLocationCoordinate2D()  //开始经纬度
    var endAnnotation = MAPointAnnotation() //小孩送达位置
    var endLocationCoordinate = CLLocationCoordinate2D()  //结束经纬度

    var mapView:MAMapView = MAMapView.init(frame: CGRect.init(x: 0, y: NEWNAVHEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-NEWNAVHEIGHT))
    
    var driveStatusView = DriveStatusView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH-CGFloat(30*IPONE_SCALE), height: CGFloat(225*IPONE_SCALE)))
    
     var orderStatusView = OrderStatusView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH-CGFloat(30*IPONE_SCALE), height: CGFloat(225*IPONE_SCALE)))
    
    var driveCurrentLocation = CLLocationCoordinate2D() //司机当前位置
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.createNavbar(navTitle: NSLocalizedString("Order_Detail", comment: ""), leftImage: nil, rightImage: nil, ringhtAction: nil)
        
        self.setInterface()
        self.setBlock()
        AMapNaviDriveManager.sharedInstance().delegate = AMapNaviDriveObject.shared()
        AMapNaviDriveObject.shared().mapDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshData()
        AMapLocationHelper.shared().delegate = self
        AMapLocationHelper.shared().initAMapLocation()
        AMapLocationHelper.shared().startUpdatingLocation()
        MQTTHelper.shared().delegate = self
    }
    
    func refreshData() {
        //加载动画
        self.view.makeToastActivity(.center)
        HomeRequestObject.shared.requestOrderStatus(orderId: model.id) { [weak self](statusModel) in
            if let weakself = self {
                weakself.view.hideToastActivity()
                if statusModel.order.orderStatus != 1 {
                    let orderModel = OrderModel()
                    orderModel.id = statusModel.order.id
                    orderModel.fromLatitude = statusModel.order.fromLatitude
                    orderModel.fromLongitude = statusModel.order.fromLongitude
                    orderModel.toLatitude = statusModel.order.toLatitude
                    orderModel.toLongitude = statusModel.order.toLongitude
                    weakself.model = orderModel
                }
                
                statusModel.order.guardianName = weakself.model.guardianName
                weakself.startLocationCoordinate = CLLocationCoordinate2D(latitude: statusModel.order.fromLatitude, longitude: statusModel.order.fromLongitude)
                weakself.endLocationCoordinate = CLLocationCoordinate2D(latitude: statusModel.order.toLatitude, longitude: statusModel.order.toLongitude)
                weakself.setStartPoint()
                weakself.setEndPoint()
                weakself.mapView.showAnnotations([weakself.startAnnotation,weakself.endAnnotation], edgePadding: UIEdgeInsets.init(top: NEWNAVHEIGHT, left: 0, bottom: CGFloat(300*IPONE_SCALE), right: 0), animated: true)
                guard let startPoint = AMapNaviPoint.location(withLatitude: CGFloat(statusModel.order.fromLatitude), longitude: CGFloat(statusModel.order.fromLongitude)) else {
                    return
                }
                guard let endPoint = AMapNaviPoint.location(withLatitude: CGFloat(statusModel.order.toLatitude), longitude: CGFloat(statusModel.order.toLongitude)) else {
                    return
                }
                AMapNaviDriveObject.shared().calculateDriveRouteId(withStart: [startPoint], end: [endPoint], wayPoints: nil, drivingStrategy: .singleDefault, routeId: statusModel.order.childId)
                if statusModel.order.orderStatus == 0 || statusModel.order.orderStatus == 1 || statusModel.order.orderStatus == 2 {
                    weakself.driveStatusView.isHidden = false
                    weakself.orderStatusView.isHidden = true
                    weakself.driveStatusView.statusModel = statusModel
                }else {
                    weakself.driveStatusView.isHidden = true
                    weakself.orderStatusView.isHidden = false
                    weakself.orderStatusView.statusModel = statusModel
                    HomeRequestObject.shared.requestOrderProgress(orderId: weakself.model.id) { [weak self](dataList) in
                        if let weakself = self {
                            weakself.orderStatusView.progressList = dataList
                        }
                    }
                }
            }
        }
    }
    
    private func setInterface() {
        mapView.showsUserLocation = false
        mapView.userTrackingMode = .none
        mapView.mapType = MAMapType.standard
        mapView.setZoomLevel(16, animated: false)
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsCompass = false
        mapView.showsWorldMap = 1
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(NEWNAVHEIGHT)
            make.bottom.equalToSuperview()
        })
//        AMapLocationHelper.shared().loadLocationMapData(mapView: mapView)
        mapView.performSelector(inBackground: NSSelectorFromString("setMapLanguage:"), with: currentLocale == "zh_CN" ? 0:1)
        
        driveStatusView.isHidden = true
        self.view.addSubview(driveStatusView)
        driveStatusView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-20*IPONE_SCALE)
            make.height.equalTo(CGFloat(225*IPONE_SCALE))
        }
        
        orderStatusView.isHidden = true
        self.view.addSubview(orderStatusView)
        orderStatusView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-20*IPONE_SCALE)
            make.height.equalTo(CGFloat(225*IPONE_SCALE))
        }
    }
    
    func setBlock() {
        driveStatusView.helpBtnActionBlock = {[weak self](statusModel) in
            if let weakself = self {
                guard let acceptId = UserInfo.mr_findFirst()?.idaccount else {
                    return
                }
                guard let acceptName = UserInfo.mr_findFirst()?.name else {
                    return
                }
                //加载动画
                weakself.view.makeToastActivity(.center)
                HomeRequestObject.shared.requestAcceptOrder(acceptId: acceptId, acceptName: acceptName, childId: statusModel.order.childId, orderId: statusModel.order.id, fromLatitude: weakself.driveCurrentLocation.latitude, fromLongitude: weakself.driveCurrentLocation.longitude) { () in
                    self?.view.hideToastActivity()
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        orderStatusView.driverOperatBlock = {[weak self](tag) in
            if let weakself = self {
                var status = 0
                if tag == 200 {
                    status = 4
                }else if tag == 201 {
                    status = 5
                }else if tag == 202 {
                    status = 6
                }
                //加载动画
                weakself.view.makeToastActivity(.center)
                HomeRequestObject.shared.requestOrderUpdate(orderId: weakself.model.id, status: Int8(status)) { (dataList) in
                    self?.view.hideToastActivity()
                    HomeRequestObject.shared.requestOrderProgress(orderId: weakself.model.id) { [weak self](dataList) in
                        if let weakself = self {
                            weakself.orderStatusView.progressList = dataList
                        }
                    }
                }
            }
        }
    }
}
//设置地图位置点
extension DriverOrderController {
    func showMapStartPoint() {
        mapView.setCenter(self.startLocationCoordinate, animated: true)
    }
    func setStartPoint() {
        startAnnotation.coordinate = self.startLocationCoordinate
        startAnnotation.title = NSLocalizedString("Boarding_position", comment: "")
        startAnnotation.subtitle = ""
        self.mapView.addAnnotation(startAnnotation)
    }
    
    func setEndPoint() {
        endAnnotation.coordinate = self.endLocationCoordinate
        endAnnotation.title = NSLocalizedString("Delivery_location", comment: "")
        endAnnotation.subtitle = ""
        self.mapView.addAnnotation(endAnnotation)
    }
}

