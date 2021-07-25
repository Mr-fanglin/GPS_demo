//
//  UserInfoModel.swift
//  Sprayer
//
//  Created by FangLin on 2019/5/16.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import MagicalRecord

class UserInfoModel: NSObject {
    //用户唯一标识
    var id: Int32 = 0
    
    //用户id
    var idaccount: Int32 = 0
    
    
    var address: String = ""
    

    var birthDay: String = ""
    
  
    var createDate: String = ""
    
   
    var email: String = ""
    
    
    var icon: String = ""
    
 
    var sex: Int16 = 0
    
 
    var idnum: String = ""
    
  
    var lastUpdate: String = ""
    
 
    var name: String = ""
    
  
    var phone: String = ""
    
    //网易云信登录凭证
    var token: String = ""
    
    
    class func userData(content: JSON) {
        guard let arr = UserInfo.mr_findAll() as? [UserInfo] else {
            return
        }
        if arr.count > 0{
            for user: UserInfo in arr{
                user.mr_deleteEntity()
                NSManagedObjectContext .mr_default().mr_saveToPersistentStoreAndWait()
            }
        }
        let userInfo: UserInfo = UserInfo.mr_createEntity()!
        
        userInfo.id = content["id"].int32Value
        userInfo.idaccount = content["idaccount"].int32Value
        userInfo.address = content["address"].stringValue
        userInfo.birthDay = content["birthDay"].stringValue
        userInfo.createDate = content["createDate"].stringValue
        userInfo.email = content["email"].stringValue
        
        userInfo.icon = content["icon"].stringValue
        userInfo.sex = content["sex"].int16Value
        userInfo.idnum = content["idnum"].stringValue
        userInfo.lastUpdate = content["lastUpdate"].stringValue
        
        userInfo.name = content["name"].stringValue
        userInfo.phone = content["phone"].stringValue
        userInfo.token = content["token"].stringValue
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }  //存储个人信息数据
    
    class func getFromModel(json: JSON) -> UserInfoModel {
        let model = UserInfoModel()
        model.id = json["id"].int32Value
        model.idaccount = json["idaccount"].int32Value
        model.address = json["address"].stringValue
        model.birthDay = json["birthDay"].stringValue
        model.createDate = json["createDate"].stringValue
        model.email = json["email"].stringValue
        
        model.icon = json["icon"].stringValue
        model.sex = json["sex"].int16Value
        model.idnum = json["idnum"].stringValue
        model.lastUpdate = json["lastUpdate"].stringValue
        
        model.name = json["name"].stringValue
        model.phone = json["phone"].stringValue
        model.token = json["token"].stringValue
        return model
    }
}
