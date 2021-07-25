//
//  HomeStatusModel.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/8.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit

enum OrderTopic:Int8 {
    case orderAccept = 0
    case orderRequest = 1
    case orderUpdate = 2
}

class HomeStatusModel: NSObject {
    var childId:Int32 = 0
    var childName:String = ""
    var currentLocationCoordinate = CLLocationCoordinate2D()
    var currentAnnotation = AnimatedAnnotation()
    //当前小孩路线
    var currentChildPolyline = MAPolyline()
    //结束的经纬度
    var endLatitude:Double = 0
    var endLongitude:Double = 0
    
    var endAnnotation = AnimatedAnnotation()
    
    var driveId:Int32 = 0
    var driveName:String = ""
    var orderId:Int32 = 0
    var orderStatus:Int8 = -1
    //0:order/accept   1:
    var orderTopic:Int8 = -1
    
    var carAnnotation = AnimatedAnnotation()
    var carLocationCoordinate = CLLocationCoordinate2D()
    var carPolyline = MAPolyline()
    
    var deviceId:String = ""
    
    class func getFormModel(childStatusModel:ChildStatusModel) -> HomeStatusModel {
        let model = HomeStatusModel()
        model.childId = childStatusModel.child.id
        model.childName = childStatusModel.child.name
        let amapcoord = AMapCoordinateConvert(CLLocationCoordinate2D(latitude: childStatusModel.device.latitude, longitude: childStatusModel.device.longitude), AMapCoordinateType.GPS)
        model.currentLocationCoordinate = amapcoord
        let pointAnnotation = AnimatedAnnotation()
        pointAnnotation.coordinate = amapcoord
        pointAnnotation.title = "\(childStatusModel.child.name)"
        pointAnnotation.subtitle = "\(childStatusModel.device.latestonline)"
        pointAnnotation.animatedImage = UIImage.init(named: "home_img01_normal")!
        model.currentAnnotation = pointAnnotation
        model.currentChildPolyline = MAPolyline()
        model.endLatitude = childStatusModel.order.toLatitude
        model.endLongitude = childStatusModel.order.toLongitude
        model.endAnnotation = AnimatedAnnotation()
        
        let carAmapcoord = CLLocationCoordinate2D(latitude: childStatusModel.order.carLatitude, longitude: childStatusModel.order.carLongitude)
        model.carLocationCoordinate = carAmapcoord
        let carAnnotation = AnimatedAnnotation()
        carAnnotation.coordinate = carAmapcoord
        carAnnotation.title = ""
        carAnnotation.subtitle = ""
        carAnnotation.animatedImage = UIImage.init(named: "home_journey_ic_car")!
        model.carAnnotation = carAnnotation
        
        model.deviceId = childStatusModel.device.id
        
        return model
    }
    
    class func getFromOrderModel(orderModel:OrderModel) -> HomeStatusModel {
        let model = HomeStatusModel()
        model.childId = orderModel.id
        let amapcoord = AMapCoordinateConvert(CLLocationCoordinate2D(latitude: orderModel.fromLatitude, longitude: orderModel.fromLongitude), AMapCoordinateType.GPS)
        model.currentLocationCoordinate = amapcoord
        let pointAnnotation = AnimatedAnnotation()
        pointAnnotation.coordinate = amapcoord
        pointAnnotation.title = "\(orderModel.childName)"
        pointAnnotation.subtitle = ""
        pointAnnotation.animatedImage = UIImage.init(named: "home_img01_normal")!
        model.currentAnnotation = pointAnnotation
        model.currentChildPolyline = MAPolyline()
        model.endLatitude = orderModel.toLatitude
        model.endLongitude = orderModel.toLongitude
        model.endAnnotation = AnimatedAnnotation()
        return model
    }
}
