//
//  MineRequestObject.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/11/16.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit
import SwiftyJSON

class MineRequestObject: NSObject {
    class var shared: MineRequestObject {
        struct instance {
            static let _instance:MineRequestObject = MineRequestObject()
        }
        return instance._instance
    }
    
    func requestGetDeviceList(sucBlock:((_ list:[DeviceModel])->())?) {
        SURLRequest.sharedInstance.requestGetWithUrl(GetDeviceList_Url+"\(SMainBoardObject.shared().idAccount)") { (data) in
            Dprint("GetDeviceList_Url:\(data)")
            let dataJson = JSON(data)
            if dataJson["result"].stringValue == "true" {
                var array:[DeviceModel] = []
                let contentJsonArr = dataJson["data"].arrayValue
                for contentJson:JSON in contentJsonArr {
                    let model = DeviceModel.getFromModel(json: contentJson)
                    array.append(model)
                }
                if let block = sucBlock {
                    block(array)
                }
            }
        } err: { (error) in
            Dprint("GetDeviceList_UrlError:\(error)")
        }

    }
    
    func requestAddChild(id:Int32,iddevice:String,name:String,phone:String,phone1:String,phone2:String,sucBlock:((_ code:String,_ message:String)->())?) {
        var params:[String:Any] = [:]
        if id == 0 {
            params = ["id":0,"idaccount":SMainBoardObject.shared().idAccount,"iddevice":iddevice,"name":name,"phone":phone,"phone1":phone1,"phone2":phone2,"timecreate":Date.currentTime()] as [String : Any]
        }else{
            params = ["id":id,"idaccount":SMainBoardObject.shared().idAccount,"iddevice":iddevice,"name":name,"phone":phone,"phone1":phone1,"phone2":phone2,"timecreate":Date.currentTime()] as [String : Any]
        }
        
        SURLRequest.sharedInstance.requestPostWithUrl(AddChild_Url, param: params) { (data) in
            Dprint("AddChild_Url:\(data)")
            let dataJson = JSON(data)
            let code = dataJson["code"].stringValue
            let message = dataJson["message"].stringValue
            Dprint(message)
            if let block = sucBlock {
                block(code,message)
            }
        } err: { (error) in
            Dprint("AddChild_UrlError:\(error)")
        }

    }
    
    func requestDeleteChild(idChild:Int32,sucBlock:((_ code:String)->())?) {
        SURLRequest.sharedInstance.requestPostWithUrl(deleteChild_Url+"\(idChild)", param: nil) { (data) in
            Dprint("deleteChild_Url:\(data)")
            let dataJson = JSON(data)
            let code = dataJson["code"].stringValue
            let message = dataJson["message"].stringValue
            Dprint(message)
            if let block = sucBlock {
                block(code)
            }
        } err: { (error) in
            Dprint("deleteChild_UrlError:\(error)")
        }

    }
}
