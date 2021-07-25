//
//  GroupListModel.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/15.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit
import SwiftyJSON

class GroupListModel: NSObject {
    var count:Int16 = 0
    var createDate:String = ""
    var creator:Int32 = 0
    var id:Int32 = 0
    var members:String = ""
    var name:String = ""
    var removable:Bool = true
    
    class func getFromModel(json:JSON) -> GroupListModel {
        let model = GroupListModel()
        model.count = json["count"].int16Value
        model.createDate = json["createDate"].stringValue
        model.creator = json["creator"].int32Value
        model.id = json["id"].int32Value
        model.members = json["members"].stringValue
        model.name = json["name"].stringValue
        model.removable = json["removable"].boolValue
        return model
    }
}
