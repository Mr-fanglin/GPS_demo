//
//  ChildStatusModel.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/8/20.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChildStatusModel: NSObject {
    var accountInfo:AccountInfoModel = AccountInfoModel()
    var child:ChildModel = ChildModel()
    var device:DeviceModel = DeviceModel()
    var hasAccept:Bool = false
    var myChild:Bool = false
    var order:OrderModel = OrderModel()
    
    class func getFromModel(json:JSON) -> ChildStatusModel {
        let model = ChildStatusModel()
        model.accountInfo = AccountInfoModel.getFromModel(json: json["accountInfo"])
        model.child = ChildModel.getFromModel(json: json["child"])
        model.device = DeviceModel.getFromModel(json: json["device"])
        model.hasAccept = json["hasAccept"].boolValue
        model.myChild = json["myChild"].boolValue
        model.order = OrderModel.getFromModel(json: json["order"])
        return model
    }
}

class AccountInfoModel: NSObject {
    var address:String = ""
    var birthDay:String = ""
    var createDate:String = ""
    var email:String = ""
    var icon:String = ""
    var id:Int32 = 0
    var idaccount:Int32 = 0
    var idnum:String = ""
    var lastUpdate:String = ""
    var name:String = ""
    var phone:String = ""
    var sex:Int8 = 0
    
    class func getFromModel(json:JSON)->AccountInfoModel {
        let model = AccountInfoModel()
        model.address = json["address"].stringValue
        model.birthDay = json["birthDay"].stringValue
        model.createDate = json["createDate"].stringValue
        model.email = json["email"].stringValue
        model.icon = json["icon"].stringValue
        model.id = json["id"].int32Value
        model.idaccount = json["idaccount"].int32Value
        model.idnum = json["idnum"].stringValue
        model.lastUpdate = json["lastUpdate"].stringValue
        model.name = json["name"].stringValue
        model.phone = json["phone"].stringValue
        model.sex = json["sex"].int8Value
        return model
    }
}

class DeviceModel: NSObject {
    var active:Bool = false
    var createtime:String = ""
    var id:String = ""
    var idaccount:Int32 = 0
    var latestonline:String = ""
    var latitude:Double = 0
    var longitude:Double = 0
    var online:Bool = false

    
    class func getFromModel(json:JSON)->DeviceModel {
        let model = DeviceModel()
        model.active = json["active"].boolValue
        model.createtime = json["createtime"].stringValue
        model.id = json["id"].stringValue
        model.idaccount = json["idaccount"].int32Value
        model.latestonline = json["latestonline"].stringValue
        model.latitude = json["latitude"].doubleValue
        model.longitude = json["longitude"].doubleValue
        model.online = json["online"].boolValue
        return model
    }
}

class OrderModel: NSObject {
    var address:String = ""
    var carLatitude:Double = 0
    var carLongitude:Double = 0
    var childId:Int32 = 0
    var createDate:String = ""
    var extra:String = ""
    var finishDate:String = ""
    var fromLatitude:Double = 0
    var fromLongitude:Double = 0
    var guardianId:Int32 = 0
    var id:Int32 = 0
    var name:String = ""
    var orderStatus:Int8 = 0
    var payStatus:Int8 = 0
    var price:Double = 0
    var receiverId:Int32 = 0
    var receiverPhone:String = ""
    var remark:String = ""
    var startTime:String = ""
    var toLatitude:Double = 0
    var toLongitude:Double = 0
    var childName:String = ""
    var guardianName:String = ""
    var deviceLatestonline:String = ""
    var gsensorz:String = ""
    
    class func getFromModel(json:JSON)->OrderModel {
        let model = OrderModel()
        model.address = json["address"].stringValue
        model.carLatitude = json["carLatitude"].doubleValue
        model.carLongitude = json["carLongitude"].doubleValue
        model.childId = json["childId"].int32Value
        model.createDate = json["createDate"].stringValue
        model.extra = json["extra"].stringValue
        model.finishDate = json["finishDate"].stringValue
        model.fromLatitude = json["fromLatitude"].doubleValue
        model.fromLongitude = json["fromLongitude"].doubleValue
        model.guardianId = json["guardianId"].int32Value
        model.id = json["id"].int32Value
        model.name = json["name"].stringValue
        model.orderStatus = json["orderStatus"].int8Value
        model.payStatus = json["payStatus"].int8Value
        model.price = json["price"].doubleValue
        model.receiverId = json["receiverId"].int32Value
        model.receiverPhone = json["receiverPhone"].stringValue
        model.remark = json["remark"].stringValue
        model.startTime = json["startTime"].stringValue
        model.toLatitude = json["toLatitude"].doubleValue
        model.toLongitude = json["toLongitude"].doubleValue
        return model
    }
    
}
