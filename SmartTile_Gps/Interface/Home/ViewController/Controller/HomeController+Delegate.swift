//
//  HomeController+Delegate.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/8/20.
//  Copyright © 2020 fanglin. All rights reserved.
//

import Foundation

extension HomeController:MAMapViewDelegate {
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation is AnimatedAnnotation {
            let animatedAnnotationIdentifier: String! = "AnimatedAnnotationIdentifier"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: animatedAnnotationIdentifier) as? AnimatedAnnotationView
            
            if annotationView == nil {
                annotationView = AnimatedAnnotationView(annotation: annotation, reuseIdentifier: animatedAnnotationIdentifier)
                annotationView?.canShowCallout = false
                annotationView?.isDraggable = true
                annotationView?.delegate = self
            }
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        if updatingLocation {
            ///更新用户当前位置的标注点图片
            let userLocationRep = MAUserLocationRepresentation()
            userLocationRep.showsHeadingIndicator = true
            mapView.update(userLocationRep)
        }
    }
    
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if wasUserAction {
//            currentLocationCoordinate = mapView.region.center
        }
    }
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
//        mapView.selectAnnotation(view.annotation, animated: true)
//        mapView.deselectAnnotation(view.annotation, animated: false)
        
        
    }
    
    func mapView(_ mapView: MAMapView!, didAnnotationViewTapped view: MAAnnotationView!) {
        if !view.isSelected {
            return
        }
        mapView.setZoomLevel(16, animated: false)
        if UIViewController.getCurrentViewCtrl().isKind(of: HomeController.self) {
            for childModel in self.statusArr {
                if (view.annotation.title ?? "name") == childModel.childName {
                    self.navLeftLabel.text = childModel.childName
                    self.showStatusView(duration: 0)
                    HomeRequestObject.shared.requestChildStatus(childId: childModel.childId) { (model) in
                        self.statusView.model = model
                        let amapcoord = AMapCoordinateConvert(CLLocationCoordinate2D(latitude: model.device.latitude, longitude: model.device.longitude), AMapCoordinateType.GPS);
                        self.mapView?.setCenter(amapcoord, animated: false)
                        SMainBoardObject.shared().currentChildId = model.child.id
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MAPolyline.self) {
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 5
            renderer.strokeColor = UIColor.blue
            return renderer
        }
        return nil
    }
}

extension HomeController {
    func registerNote() {
        ///
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMsg(_:)), name: NSNotification.Name(rawValue: kNoteCallingSOS), object: nil)
    }
    
    @objc fileprivate func receiveMsg(_ note: Notification) {
        guard let nimMsg = note.object as? NIMMessage else { return }
        // 收到自己发送信息的通知则不用理会
        if nimMsg.from == XCXinChatTools.shared.getMineInfo()?.userId { return }
        guard let msgContent = nimMsg.text else {
            return
        }
        for statusModel in self.statusArr {
            if msgContent.contains(statusModel.childName) {
                self.mapView?.selectAnnotation(statusModel.currentAnnotation, animated: false)
                self.mapView?.setCenter(statusModel.currentLocationCoordinate, animated: true)
//                statusModel.currentAnnotation.type = 1
            }
        }
    }
}

extension HomeController:AnimatedAnnotationViewDelegate {
    func btnActionBlock(_ name: String) {
        for statusModel in self.statusArr {
            if statusModel.childName == name {
                UIViewController.getCurrentViewCtrl().view.makeToastActivity(.center)
                HomeRequestObject.shared.requestMqttCancel(deviceId: statusModel.deviceId) { (code,message) in
                    UIViewController.getCurrentViewCtrl().view.hideToastActivity()
                    if code == "0" {
                        statusModel.currentAnnotation.childStatusType = 0
                    }else {
                        UIViewController.getCurrentViewCtrl().view.makeToast(message)
                    }
                }
//                let gpsDict = ["action":"sos/close","value":["latitude":statusModel.currentLocationCoordinate.latitude,"longitude":statusModel.currentLocationCoordinate.longitude],"time":Date.currentTime()] as [String : Any]
//                MQTTHelper.shared().mqtt!.publish("device/alarm/\(SMainBoardObject.shared().idAccount)", withString: MQTTHelper.shared().convertDictionaryToJSONString(dict: gpsDict))
//                statusModel.currentAnnotation.type = 0
            }
        }
    }
}

extension HomeController:MQTTHelperDelegate {
    func mqttOrderAcceptSuccess(message: HomeStatusModel) {
        let childId = message.childId
        for (index,homeStatusModel) in self.statusArr.enumerated() {
            if homeStatusModel.childId == childId {
                self.statusArr.remove(at: index)
                homeStatusModel.driveId = message.driveId
                homeStatusModel.driveName = message.driveName
                homeStatusModel.orderId = message.orderId
                homeStatusModel.orderStatus = message.orderStatus
                homeStatusModel.orderTopic = OrderTopic.orderAccept.rawValue
                self.statusArr.append(homeStatusModel)
                self.statusView.homeStatusModel = homeStatusModel
                break
            }
        }
        let orderModel = OrderModel()
        orderModel.orderStatus = message.orderStatus
        orderModel.id = message.orderId
        self.orderView.model = orderModel
    }
    
    func mqttChildLocationUpdate(message: OrderModel,deviceId:String) {
        for (index,statusModel) in self.statusArr.enumerated() {
            if statusModel.deviceId == deviceId {
                self.statusArr.remove(at: index)
                self.mapView?.removeAnnotation(statusModel.currentAnnotation)
                if !(message.fromLatitude == 0.0 && message.fromLongitude == 0.0) {
                    statusModel.currentLocationCoordinate = AMapCoordinateConvert(CLLocationCoordinate2D(latitude: message.fromLatitude, longitude: message.fromLongitude), AMapCoordinateType.GPS)
                }
//                let GValue = String.init(format: "%.2f", (fabsf(Float(message.gsensorz)!))/9.8)
                let pointAnnotation = AnimatedAnnotation()
                pointAnnotation.coordinate = statusModel.currentLocationCoordinate
                pointAnnotation.title = "\(statusModel.childName)" // + " G:" + GValue
                pointAnnotation.subtitle = "\(message.deviceLatestonline)"
                //gsensorOne？
                var gsensorArr:[String] = []
                if UserDefaults.standard.string(forKey: deviceId) != nil {
                    gsensorArr = FLUserDefaultsStringGet(key: deviceId).components(separatedBy: ",")
                }
                let gsensorFrontArr = [] + gsensorArr.prefix(20)
                let gsensorFrontFloatArr = gsensorFrontArr.compactMap{ Float($0) }
                if let maxValue = gsensorFrontFloatArr.max() {
//                    pointAnnotation.gensorOne = maxValue/9.8
                    self.gsensorValueView.g1Value = maxValue/9.8
                }
//                pointAnnotation.gensorTwo = (fabsf(Float(message.gsensorz)!))/9.8
                
                self.gsensorValueView.g2Value = (fabsf(Float(message.gsensorz)!))/9.8
                pointAnnotation.animatedImage = UIImage.init(named: "home_img01_normal")!
                statusModel.currentAnnotation = pointAnnotation
                self.statusArr.append(statusModel)
                self.mapView?.addAnnotation(statusModel.currentAnnotation)
                self.mapView?.setCenter(statusModel.currentLocationCoordinate, animated: true)
                self.mapView?.selectAnnotation(pointAnnotation, animated: false)
                break
            }
        }
    }
    
    func mqttOrderUpdate(message: OrderModel) {
        
        HomeRequestObject.shared.requestChildStatus(childId: message.childId) { (model) in
            if model.myChild {
                self.requestUnfinishOrder()
                if SMainBoardObject.shared().currentChildId == model.child.id {
                    self.statusView.model = model
                    if message.orderStatus == 7 || model.order.id == 0 {
                        for (index,homeStatusModel) in self.statusArr.enumerated() {
                            if homeStatusModel.childId == model.child.id {
                                self.statusArr.remove(at: index)
                                self.mapView?.removeAnnotation(homeStatusModel.endAnnotation)
                                self.mapView?.remove(homeStatusModel.currentChildPolyline)
                                self.mapView?.removeAnnotation(homeStatusModel.carAnnotation)
                                homeStatusModel.endAnnotation = AnimatedAnnotation()
                                homeStatusModel.endLatitude = 0
                                homeStatusModel.endLongitude = 0
                                homeStatusModel.carLocationCoordinate = CLLocationCoordinate2D()
                                homeStatusModel.currentChildPolyline = MAPolyline()
                                homeStatusModel.carAnnotation = AnimatedAnnotation()
                                self.statusArr.append(homeStatusModel)
                                break
                            }
                        }
                    }
                }
            }else {
                if message.orderStatus == 7 || model.order.id == 0 {
                    for (index,homeStatusModel) in self.statusArr.enumerated() {
                        if homeStatusModel.childId == model.child.id {
                            self.mapView?.removeAnnotation(homeStatusModel.endAnnotation)
                            self.mapView?.remove(homeStatusModel.currentChildPolyline)
                            self.mapView?.removeAnnotation(homeStatusModel.carAnnotation)
                            self.mapView?.removeAnnotation(homeStatusModel.currentAnnotation)
                            self.statusArr.remove(at: index)
                            self.statusView.animationClose()
                            break
                        }
                    }
                }else {
                    self.requestUnfinishOrder()
                }
            }
        }
    }
    
    func mqttOrderRequest(message: OrderModel) {
        self.orderView.model = message
    }
    
    func mqttUserGpsUpdate(message: OrderModel) {
        for (index,statusModel) in self.statusArr.enumerated() {
            if statusModel.driveId == message.receiverId {
                self.statusArr.remove(at: index)
                self.mapView?.removeAnnotation(statusModel.carAnnotation)
                statusModel.carLocationCoordinate = CLLocationCoordinate2D(latitude: message.carLatitude, longitude: message.carLongitude)//AMapCoordinateConvert(CLLocationCoordinate2D(latitude: message.carLatitude, longitude: message.carLongitude), AMapCoordinateType.GPS)
                let pointAnnotation = AnimatedAnnotation()
                pointAnnotation.coordinate = statusModel.carLocationCoordinate
                pointAnnotation.title = ""
                pointAnnotation.subtitle = ""
                pointAnnotation.animatedImage = UIImage.init(named: "home_journey_ic_car")!
                statusModel.carAnnotation = pointAnnotation
                self.statusArr.append(statusModel)
                self.mapView?.addAnnotation(statusModel.carAnnotation)
                break
            }
        }
    }
    
    func mqttUserSOSUpdate(deviceId: String) {
        for statusModel in self.statusArr {
            if statusModel.deviceId == deviceId {
                self.mapView?.selectAnnotation(statusModel.currentAnnotation, animated: false)
                self.mapView?.setCenter(statusModel.currentLocationCoordinate, animated: true)
                statusModel.currentAnnotation.childStatusType = 1
            }
        }
    }
}

extension HomeController:AMapReGeocodeSearchDelegate {
    func onReGeocodeSearchFinish(request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        if Double(request.location.latitude) == self.statusView.model.order.fromLatitude {
            if response.regeocode.roads.count > 0 {
                let roadName = response.regeocode.roads[0].name
                if response.regeocode.pois.count > 0 {
                    let poisName = response.regeocode.pois[0].name
                    self.statusView.startLocation.text = roadName! + "-" + poisName!
                }else {
                    self.statusView.startLocation.text = response.regeocode.formattedAddress
                }
            }else {
                self.statusView.startLocation.text = response.regeocode.formattedAddress
            }
        }else if Double(request.location.latitude) == self.statusView.model.order.toLatitude {
            if response.regeocode.roads.count > 0 {
                let roadName = response.regeocode.roads[0].name
                if response.regeocode.pois.count > 0 {
                    let poisName = response.regeocode.pois[0].name
                    self.statusView.endLocation.text = roadName! + "-" + poisName!
                }else {
                    self.statusView.endLocation.text = response.regeocode.formattedAddress
                }
            }else {
                self.statusView.endLocation.text = response.regeocode.formattedAddress
            }
        }
    }
    
    func amapLocationManagerdidUpdatelocation(location: CLLocation!) {
        if self.statusArr.count == 0 {
            self.mapView?.setCenter(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), animated: true)
//            self.showMapCeneterPoint(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        }
    }
}

extension HomeController:AMapNaviDriveObjectDelegate {
    func onCalculateRouteSuccess(driveManager: AMapNaviDriveManager, routeId: Int32) {
        var lineCoordinates:[CLLocationCoordinate2D] = []
        guard let coordinates = driveManager.naviRoute?.routeCoordinates else {
            return
        }
        for point in coordinates {
            let locationCoordinate = CLLocationCoordinate2D(latitude: Double(point.latitude), longitude: Double(point.longitude))
            lineCoordinates.append(locationCoordinate)
        }
        Dprint("driveManager:\(driveManager.naviRouteID)")
        let polyline: MAPolyline = MAPolyline(coordinates: &lineCoordinates, count: UInt(lineCoordinates.count))
        mapView?.add(polyline)
        self.statusRefreshPoyLine(childId: routeId, poyLine: polyline)
    }
}

extension HomeController:SRequestHelpControllerDelegate {
    func sendOrderRequestSuccess(childId: Int32) {
        HomeRequestObject.shared.requestChildStatus(childId: childId) { [weak self](model) in
            if let weakself = self {
                if model.order.id != 0 {
                    weakself.statusRefreshOrderEndLocation(childId: childId, lat: model.order.toLatitude, lng: model.order.toLongitude)
                    weakself.statusView.model = model
                    let endAnnatation = weakself.setEndPoint(childId: model.child.id, lat: model.order.toLatitude, lng: model.order.toLongitude)
//                    var allAnnotations:[MAPointAnnotation] = weakself.mapView?.annotations as! [MAPointAnnotation]
//                    allAnnotations.append(endAnnatation)
//                    weakself.showsAnnotations(allAnnotations, edgePadding: UIEdgeInsets.init(top: NEWNAVHEIGHT, left: 0, bottom: CGFloat(190*IPONE_SCALE), right: 0), andMapView: weakself.mapView)
                    guard let startPoint = AMapNaviPoint.location(withLatitude: CGFloat(model.order.fromLatitude), longitude: CGFloat(model.order.fromLongitude)) else {
                        return
                    }
                    guard let endPoint = AMapNaviPoint.location(withLatitude: CGFloat(model.order.toLatitude), longitude: CGFloat(model.order.toLongitude)) else {
                        return
                    }
                    AMapNaviDriveObject.shared().calculateDriveRouteId(withStart: [startPoint], end: [endPoint], wayPoints: nil, drivingStrategy: .singleDefault, routeId: model.child.id)
                }
            }
        }
    }
}

extension HomeController {
    /// 根据传入的annotation来展现：保持中心点不变的情况下，展示所有传入annotation
    ///
    /// - Parameters:
    ///   - annotations: annotation
    ///   - insets: 填充框，用于让annotation不会靠在地图边缘显示
    ///   - mapView: 地图view
    func showsAnnotations(_ annotations:Array<MAPointAnnotation>, edgePadding insets:UIEdgeInsets, andMapView mapView:MAMapView!) {
        var rect:MAMapRect = MAMapRectZero

        for annotation:MAPointAnnotation in annotations {
            let diagonalPoint:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude - (annotation.coordinate.latitude - mapView.centerCoordinate.latitude),mapView.centerCoordinate.longitude - (annotation.coordinate.longitude - mapView.centerCoordinate.longitude))

            let annotationMapPoint: MAMapPoint = MAMapPointForCoordinate(annotation.coordinate)
            let diagonalPointMapPoint: MAMapPoint = MAMapPointForCoordinate(diagonalPoint)

            let annotationRect:MAMapRect = MAMapRectMake(min(annotationMapPoint.x, diagonalPointMapPoint.x), min(annotationMapPoint.y, diagonalPointMapPoint.y), abs(annotationMapPoint.x - diagonalPointMapPoint.x), abs(annotationMapPoint.y - diagonalPointMapPoint.y));

            rect = MAMapRectUnion(rect, annotationRect)
        }

        mapView.setVisibleMapRect(rect, edgePadding: insets, animated: true)
    }
}

extension HomeController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is AnimatedAnnotationView {
            return false
        }
        return true
    }
}
