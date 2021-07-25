//
//  MessageRequestObject.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/9/15.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessageRequestObject: NSObject {
    @objc class var shared: MessageRequestObject {
        struct instance {
            static let _instance:MessageRequestObject = MessageRequestObject()
        }
        return instance._instance
    }
    
    func requestGroupGetList(sucBlock:((_ list:[GroupListModel])->())?) {
        SURLRequest.sharedInstance.requestGetWithUrl(GroupGetList_Url+"\(SMainBoardObject.shared().idAccount)", suc: { (data) in
            Dprint("GroupGetList_Url:\(data)")
            let dataJson = JSON(data)
            if dataJson["result"].stringValue == "true" {
                var array:[GroupListModel] = []
                let contentJsonArr = dataJson["data"].arrayValue
                for contentJson:JSON in contentJsonArr {
                    let model = GroupListModel.getFromModel(json: contentJson)
                    array.append(model)
                }
                if let block = sucBlock {
                    block(array)
                }
            }
        }) { (error) in
            Dprint("GroupGetList_UrlError:\(error)")
        }
    }
    
    @objc func requestGroupCreate(name:String,members:String,createId:String,sucBlock:(()->())?) {
        let arrayId = members.components(separatedBy: ",")
        //首先判断能不能转换
        if (!JSONSerialization.isValidJSONObject(arrayId)) {
            //print("is not a valid json object")
            return
        }
        
        //利用OC的json库转换成OC的NSData，
        //如果设置options为NSJSONWritingOptions.PrettyPrinted，则打印格式更好阅读
        let data : Data! = try? JSONSerialization.data(withJSONObject: arrayId, options: [])
        //NSData转换成NSString打印输出
        let str = NSString(data:data, encoding: String.Encoding.utf8.rawValue)
        let params = ["name":name,"members":str as Any,"creator":createId,"createDate":Date.currentTime(),"count":arrayId.count] as [String:Any]
        SURLRequest.sharedInstance.requestPostWithUrl(GroupCreate_Url, param: params) { (data) in
            Dprint("GroupCreate_Url:\(data)")
            let dataJson = JSON(data)
            let code = dataJson["code"].stringValue
            Dprint(dataJson["message"].stringValue)
            if code == "0" {
                if let block = sucBlock {
                    block()
                }
            }
        } err: { (error) in
            Dprint("GroupCreate_UrlError:\(error)")
        }

    }
}
