//
//  OrderProgressModel.swift
//  SmartTile_Gps
//
//  Created by FangLin on 2020/9/30.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderProgressModel: NSObject {
    var createDate:String = ""
    var extra:String = ""
    var id:Int32 = 0
    var orderId:Int32 = 0
    var orderStatus:Int8 = 0
    var tips:String = ""
    var myChild:Bool = false
    
    class func getFromModel(json:JSON) -> OrderProgressModel {
        let model = OrderProgressModel()
        model.createDate = json["createDate"].stringValue
        model.extra = json["extra"].stringValue
        model.id = json["id"].int32Value
        model.orderId = json["orderId"].int32Value
        model.orderStatus = json["orderStatus"].int8Value
        model.tips = json["tips"].stringValue
        return model
    }
}
