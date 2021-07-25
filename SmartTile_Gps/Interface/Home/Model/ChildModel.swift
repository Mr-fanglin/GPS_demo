//
//  ChildModel.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/8/20.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChildModel: NSObject {
    
    var avatar:String = ""
    
    var birth:String = ""
    
    var id:Int32 = 0
    
    var idaccount:Int32 = 0
    
    var iddevice:String = ""
    
    var male:Int8 = 0
    
    var name:String = ""
    
    var phone:String = ""
    
    var phone1:String = ""
    
    var phone2:String = ""

    var timecreate:String = ""
    
    class func getFromModel(json:JSON) -> ChildModel {
        let model = ChildModel()
        model.avatar = json["avatar"].stringValue
        model.birth = json["birth"].stringValue
        model.id = json["id"].int32Value
        model.idaccount = json["idaccount"].int32Value
        model.iddevice = json["iddevice"].stringValue
        model.male = json["male"].int8Value
        model.name = json["name"].stringValue
        model.phone = json["phone"].stringValue
        model.phone1 = json["phone1"].stringValue
        model.phone2 = json["phone2"].stringValue
        model.timecreate = json["timecreate"].stringValue
        return model
    }
}
