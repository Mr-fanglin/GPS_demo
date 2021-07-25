//
//  HomeController.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/8/17.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

class HomeController: SBaseController {
    
    var mapView:MAMapView?
    
    var navLeftLabel:UILabel = UILabel.init()
    var navLeftImageView:UIImageView = UIImageView.init()

    var orderView:HomeOrderView = HomeOrderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(70*IPONE_SCALE)))
    var statusView = HomeBoardObject.shared().childStatusView
    
    var gsensorValueView:GsensorValueView = GsensorValueView.init(frame: CGRect.init(x: 0, y: 0, width: CGFloat(70*IPONE_SCALE), height: CGFloat(50*IPONE_SCALE)))
    
    //小孩列表
    var childArr:[ChildModel] = []
    //小孩的当前的地图状态
    var statusArr:[HomeStatusModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.createNavbar(navTitle: "", leftImage: "home_nav_location_normal", rightImage: "home_nav_scan_normal", ringhtAction: #selector(rightBtnAction))
        self.setInterface()
        self.setBlock()
        
//        self.requestUnfinishOrder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AMapNaviDriveManager.sharedInstance().delegate = AMapNaviDriveObject.shared()
        AMapNaviDriveObject.shared().mapDelegate = self
        MQTTHelper.shared().delegate = self
        AMapLocationHelper.shared().delegate = self
        self.registerNote()
        self.requestChildList()
    }
    
    private func setInterface() {
        navLeftLabel.font = UIFont.systemFont(ofSize: CGFloat(17*IPONE_SCALE))
        navLeftLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        self.navBarV.addSubview(navLeftLabel)
        navLeftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.baseBackBtn.snp.right)
            make.centerY.equalTo(self.baseBackBtn)
            make.height.equalTo(17*IPONE_SCALE)
        }
        
        navLeftImageView.image = UIImage.init(named: "home_nav_combo")
        self.navBarV.addSubview(navLeftImageView)
        navLeftImageView.snp.makeConstraints { (make) in
            make.left.equalTo(navLeftLabel.snp.right).offset(1*IPONE_SCALE)
            make.centerY.equalTo(navLeftLabel)
            make.width.height.equalTo(20*IPONE_SCALE)
        }
        
        mapView = MAMapView.init(frame: CGRect.init(x: 0, y: NEWNAVHEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-NEWNAVHEIGHT))
        mapView?.showsUserLocation = false
        mapView?.userTrackingMode = .none
        mapView?.mapType = MAMapType.standard
        mapView?.showsScale = true
        mapView?.showsCompass = false
        mapView?.setZoomLevel(16, animated: false)
        mapView?.showsWorldMap = 1
        mapView?.delegate = self
        self.view.addSubview(mapView!)
        mapView?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(NEWNAVHEIGHT)
            make.bottom.equalTo(-TabbarHeight)
        })
    
        mapView?.performSelector(inBackground: NSSelectorFromString("setMapLanguage:"), with: currentLocale == "zh_CN" ? 0:1)
//        AMapLocationHelper.shared().loadLocationMapData(mapView: mapView)
        
        let mapTap = UITapGestureRecognizer.init(target: self, action: #selector(mapTapClick))
        mapView?.isUserInteractionEnabled = true
        mapTap.delegate = self
        mapView?.addGestureRecognizer(mapTap)
        
        
        self.view.addSubview(orderView)
        orderView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(NEWNAVHEIGHT)
            make.height.equalTo(70*IPONE_SCALE)
        }
        
        self.view.addSubview(gsensorValueView)
        gsensorValueView.snp.makeConstraints { (make) in
            make.right.equalTo(-5*IPONE_SCALE)
            make.top.equalTo(orderView.snp.bottom).offset(10*IPONE_SCALE)
            make.width.equalTo(70*IPONE_SCALE)
            make.height.equalTo(50*IPONE_SCALE)
        }
    }
    
    //MARK: - request
    func requestChildList() {
        let queue = DispatchQueue.init(label: "com.custom.thread")
        let group = DispatchGroup()
        var statusArr1:[ChildStatusModel] = []
        var statusArr2:[ChildStatusModel] = []
//        var ordersArr:[OrderModel] = []
        self.view.makeToastActivity(.center)
        group.enter()
        queue.async(group: group, execute: DispatchWorkItem.init(block: {
            HomeRequestObject.shared.requestChildList { [weak self](dataList) in
                if let weakself = self {
                    weakself.childArr = dataList
                    for index in 0..<weakself.childArr.count {
                        group.enter()
                        let childModel = weakself.childArr[index]
                        HomeRequestObject.shared.requestChildStatus(childId: childModel.id) { (model) in
                            statusArr1.append(model)
                            group.leave()
                            Dprint("任务一 \(index)")
                        }
                    }
                    group.leave()
                }
            }
            Dprint("任务一")
        }))
        
        group.enter()
        queue.async(group: group, execute: DispatchWorkItem.init(block: {
            HomeRequestObject.shared.requestOrderAcceptUnfinish { (orderList) in
                for index in 0..<orderList.count {
                    let orderModel = orderList[index]
                    HomeRequestObject.shared.requestChildStatus(childId: orderModel.childId) { (model) in
                        statusArr2.append(model)
                        group.leave()
                        Dprint("任务二 \(index)")
                    }
                }
                if orderList.count == 0 {
                    group.leave()
                }
            }
            Dprint("任务二")
        }))
        
        group.notify(queue: DispatchQueue.main) { [weak self]() in
            Dprint("所有任务完成")
            if let weakself = self {
                weakself.statusArr.removeAll()
                weakself.mapView?.removeAnnotations(weakself.mapView?.annotations)
                for statusM2 in statusArr2 {
                    var isHave = false
                    for statusM1 in statusArr1 {
                        if statusM2.child.id == statusM1.child.id {
                            isHave = true
                        }
                    }
                    if !isHave {
                        statusArr1.append(statusM2)
                    }
                }
                if statusArr1.count > 0 {
                    weakself.navLeftLabel.text = statusArr1[0].child.name
                    weakself.showStatusView(duration: 0)
                }else {
                    weakself.navLeftLabel.text = "no child"
                    weakself.statusView.animationClose()
                    return
                }
                for (index,statusM) in statusArr1.enumerated() {
                    let statusModel = HomeStatusModel.getFormModel(childStatusModel: statusM)
                    weakself.statusArr.append(statusModel)
                    weakself.addPointAnnotation(model: statusModel)
                    if index == 0 {
                        weakself.showMapCeneterPoint(lat: statusM.device.latitude, lng: statusM.device.longitude)
                        weakself.statusView.model = statusM
                        weakself.mapView?.selectAnnotation(statusModel.currentAnnotation, animated: false)
                        SMainBoardObject.shared().currentChildId = statusM.child.id
                    }
                    if statusM.order.id != 0 && statusM.order.orderStatus != 0 {
                        weakself.mapView?.addAnnotation(statusModel.carAnnotation)
                        guard let startPoint = AMapNaviPoint.location(withLatitude: CGFloat(statusM.order.fromLatitude), longitude: CGFloat(statusM.order.fromLongitude)) else {
                            return
                        }
                        guard let endPoint = AMapNaviPoint.location(withLatitude: CGFloat(statusM.order.toLatitude), longitude: CGFloat(statusM.order.toLongitude)) else {
                            return
                        }
                        AMapNaviDriveObject.shared().calculateDriveRouteId(withStart: [startPoint], end: [endPoint], wayPoints: nil, drivingStrategy: .singleDefault, routeId: statusM.child.id)
                    }
                }
                
            }
        }
        self.view.hideToastActivity()
//        //加载动画
//        self.view.makeToastActivity(.center)
//        HomeRequestObject.shared.requestChildList { [weak self](dataList) in
//            if let weakself = self {
//                weakself.view.hideToastActivity()
//                weakself.childArr = dataList
//                if dataList.count > 0 {
//                    weakself.navLeftLabel.text = dataList[0].name
//                    weakself.showStatusView(duration: 0)
//                }else {
//                    weakself.navLeftLabel.text = "no child"
//                }
//
//                weakself.mapView?.removeAnnotations(weakself.mapView?.annotations)
//                for index in 0..<dataList.count {
//                    let childModel = dataList[index]
//                    HomeRequestObject.shared.requestChildStatus(childId: childModel.id) { (model) in
//                        let statusModel = HomeStatusModel.getFormModel(childStatusModel: model)
//                        weakself.statusArr.append(statusModel)
//                        weakself.addPointAnnotation(model: statusModel)
//                        if index == 0 {
//                            weakself.showMapCeneterPoint(lat: model.device.latitude, lng: model.device.longitude)
//                            weakself.statusView.model = model
////                            if let selectedAnnotations = weakself.mapView?.selectedAnnotations as? [MAAnnotation] {
////                                for seleAnnotation in selectedAnnotations {
////                                    weakself.mapView?.deselectAnnotation(seleAnnotation, animated: false)
////                                }
////                            }
//                            weakself.mapView?.selectAnnotation(statusModel.currentAnnotation, animated: false)
//                            SMainBoardObject.shared().currentChildId = model.child.id
//                        }
//                        if model.order.id != 0 && model.order.orderStatus != 0 {
//                            let endAnnotation = weakself.setEndPoint(childId: model.child.id, lat: model.order.toLatitude, lng: model.order.toLongitude)
////                            var allAnnotations:[MAPointAnnotation] = weakself.mapView?.annotations as! [MAPointAnnotation]
////                            allAnnotations.append(endAnnotation)
////                            weakself.showsAnnotations(allAnnotations, edgePadding: UIEdgeInsets.init(top: NEWNAVHEIGHT, left: 0, bottom: CGFloat(190*IPONE_SCALE), right: 0), andMapView: weakself.mapView)
//                            guard let startPoint = AMapNaviPoint.location(withLatitude: CGFloat(model.order.fromLatitude), longitude: CGFloat(model.order.fromLongitude)) else {
//                                return
//                            }
//                            guard let endPoint = AMapNaviPoint.location(withLatitude: CGFloat(model.order.toLatitude), longitude: CGFloat(model.order.toLongitude)) else {
//                                return
//                            }
//                            AMapNaviDriveObject.shared().calculateDriveRouteId(withStart: [startPoint], end: [endPoint], wayPoints: nil, drivingStrategy: .singleDefault, routeId: model.child.id)
//                        }
//                    }
//                }
//            }
//        }
    }
    
    func requestUnfinishOrder() {
        //加载动画
        self.view.makeToastActivity(.center)
        HomeRequestObject.shared.requestOrderAcceptUnfinish { [weak self](orderList) in
            if let weakself = self {
                weakself.view.hideToastActivity()
                for index in 0..<orderList.count {
                    let orderModel = orderList[index]
                    HomeRequestObject.shared.requestChildStatus(childId: orderModel.childId) { (model) in
                        let statusModel = HomeStatusModel.getFormModel(childStatusModel: model)
                        var isHave = false
                        for homeChildStatusModel in weakself.statusArr {
                            if homeChildStatusModel .childId == model.child.id {
                                isHave = true
                            }
                        }
                        weakself.showMapCeneterPoint(lat: model.order.fromLatitude, lng: model.order.fromLongitude)
                        SMainBoardObject.shared().currentChildId = model.child.id
                        weakself.mapView?.selectAnnotation(statusModel.currentAnnotation, animated: false)
                        if isHave {
                            
                        }else {
                            weakself.statusArr.append(statusModel)
                            weakself.mapView?.addAnnotation(statusModel.carAnnotation)
                            weakself.addPointAnnotation(model: statusModel)
//                            let endAnnotation = weakself.setEndPoint(childId: model.child.id, lat: model.order.toLatitude, lng: model.order.toLongitude)
//                            var allAnnotations:[MAPointAnnotation] = weakself.mapView?.annotations as! [MAPointAnnotation]
//                            allAnnotations.append(endAnnotation)
//                            weakself.showsAnnotations(allAnnotations, edgePadding: UIEdgeInsets.init(top: NEWNAVHEIGHT, left: 0, bottom: CGFloat(190*IPONE_SCALE), right: 0), andMapView: weakself.mapView)
                            guard let startPoint = AMapNaviPoint.location(withLatitude: CGFloat(model.order.fromLatitude), longitude: CGFloat(model.order.fromLongitude)) else {
                                return
                            }
                            guard let endPoint = AMapNaviPoint.location(withLatitude: CGFloat(model.order.toLatitude), longitude: CGFloat(model.order.toLongitude)) else {
                                return
                            }
                            guard let carStartPoint = AMapNaviPoint.location(withLatitude: CGFloat(model.order.carLatitude), longitude: CGFloat(model.order.carLongitude)) else {
                                return
                            }
                            AMapNaviDriveObject.shared().calculateDriveRouteId(withStart: [carStartPoint], end: [endPoint], wayPoints: [startPoint], drivingStrategy: .singleDefault, routeId: model.child.id)
                        }
                        weakself.statusView.model = model
                        weakself.showStatusView(duration: 0)
                    }
                }
            }
        }
    }
}

//状态面板显示
extension HomeController {
    func showStatusView(duration:TimeInterval) {
        if UIViewController.getCurrentViewCtrl().isKind(of: HomeController.self) {
            statusView.animationshow(isCenter: false, duration: duration, isTabbar: true)
        }
    }
    
    func setBlock() {
        //请人接送
        statusView.operatBtnActionBlock = { [weak self](model) in
            if let weakself = self {
                let VC = SRequestHelpController()
//                let amapcoord = AMapCoordinateConvert(CLLocationCoordinate2D(latitude: model.device.latitude, longitude: model.device.longitude), AMapCoordinateType.GPS);
//                VC.childLocationCoordinate = amapcoord
                VC.childModel = model
                VC.delegate = self
                weakself.navigationController?.pushViewController(VC, animated: true)
            }
        }
        
        //取消订单
        statusView.cancelBtnActionBlock = { [weak self](model) in
            if let weakself = self {
                HomeRequestObject.shared.requestFinishOrder(orderId: model.order.id) { (orderModel) in
                    weakself.view.makeToast(NSLocalizedString("Order_cancel", comment: ""), duration: 1.0, position: .center)
                    let statusModel = weakself.statusView.model
                    statusModel.order = OrderModel()
                    weakself.statusView.model = statusModel
                    for statusModel in weakself.statusArr {
                        if statusModel.childId == model.child.id {
                            weakself.mapView?.removeAnnotation(statusModel.endAnnotation)
                            weakself.mapView?.remove(statusModel.currentChildPolyline)
                            break
                        }
                    }
                }
            }
        }
        
        //完成订单
        statusView.finishBtnActionBlock = { [weak self](model) in
            if let weakself = self {
                let alertVC = UIAlertController.initAlertView(message: NSLocalizedString("Confirmation_delivered", comment: ""), sureTitle: NSLocalizedString("Determine", comment: "")) { (alert) in
                    HomeRequestObject.shared.requestFinishOrder(orderId: model.order.id) { (model) in
                        weakself.view.makeToast(NSLocalizedString("Order_completed", comment: ""), duration: 1.0, position: .center)
                        let statusModel = weakself.statusView.model
                        statusModel.order = OrderModel()
                        weakself.statusView.model = statusModel
                        for homeStatusModel in weakself.statusArr {
                            if homeStatusModel.childId == statusModel.child.id {
                                weakself.mapView?.removeAnnotation(homeStatusModel.endAnnotation)
                                weakself.mapView?.remove(homeStatusModel.currentChildPolyline)
                                if !statusModel.myChild {
                                    weakself.mapView?.removeAnnotation(homeStatusModel.carAnnotation)
                                    weakself.mapView?.removeAnnotation(homeStatusModel.currentAnnotation)
                                }
                                break
                            }
                        }
                    }
                }
                weakself.present(alertVC, animated: true, completion: nil)
            }
        }
        
        //同意接送小孩
        statusView.agreeAcceptBtnActionBlock = {[weak self](model) in
            if let weakself = self {
                HomeRequestObject.shared.requestAgreeAcceptOrder(receiverId: model.driveId, orderId: model.orderId) { (model) in
                    //拉取小孩状态
                    HomeRequestObject.shared.requestChildStatus(childId: model.childId) { (model) in
                        weakself.statusView.model = model
                    }
                }
            }
        }
        
        //订单详情
        statusView.orderDetailActionBlock = {[weak self](model) in
            if let weakself = self {
                let orderDetailVC = DriverOrderController()
                orderDetailVC.model = model.order
                weakself.navigationController?.pushViewController(orderDetailVC, animated: true)
            }
        }
    }
}

//设置地图位置点
extension HomeController {
    func addPointAnnotation(model:HomeStatusModel) {
        mapView?.addAnnotation(model.currentAnnotation)
    }
    
    func showMapCeneterPoint(lat:Double,lng:Double) {
        let amapcoord = AMapCoordinateConvert(CLLocationCoordinate2D(latitude: lat, longitude: lng), AMapCoordinateType.GPS);
        mapView?.setCenter(CLLocationCoordinate2D(latitude: amapcoord.latitude, longitude: amapcoord.longitude), animated: false)
    }
    
    func setEndPoint(childId:Int32,lat:Double,lng:Double) -> AnimatedAnnotation {
        let endAnnotation = AnimatedAnnotation() //小孩送达位置
        endAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng)
        endAnnotation.title = ""
        endAnnotation.subtitle = ""
        endAnnotation.animatedImage = UIImage.init(named: "home_journey_ic_end")!
        self.mapView?.addAnnotation(endAnnotation)
        self.statusRefreshEndAnnotation(childId: childId, annotation: endAnnotation)
        return endAnnotation
    }
}

extension HomeController {
    @objc func rightBtnAction() {
        let scanVC = QRScanController.init()
        self.navigationController?.pushViewController(scanVC, animated: true)
    }
    
    @objc func mapTapClick() {
        statusView.animationClose()
    }
}

//MARK:-状态处理
extension HomeController {
    //路径
    func statusRefreshPoyLine(childId:Int32,poyLine:MAPolyline) {
        for (index,model) in statusArr.enumerated() {
            if model.childId == childId {
                statusArr.remove(at: index)
                model.currentChildPolyline = poyLine
                statusArr.append(model)
                break
            }
        }
    }
    
    func statusRefreshOrderEndLocation(childId:Int32,lat:Double,lng:Double) {
        for (index,model) in statusArr.enumerated() {
            if model.childId == childId {
                statusArr.remove(at: index)
                model.endLatitude = lat
                model.endLongitude = lng
                statusArr.append(model)
                break
            }
        }
    }
    
    func statusRefreshEndAnnotation(childId:Int32,annotation:AnimatedAnnotation) {
        for (index,model) in statusArr.enumerated() {
            if model.childId == childId {
                statusArr.remove(at: index)
                model.endAnnotation = annotation
                statusArr.append(model)
                break
            }
        }
    }
}

