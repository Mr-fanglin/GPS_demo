//
//  HomeRequestObject.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/8/20.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeRequestObject: NSObject {
    class var shared: HomeRequestObject {
        struct instance {
            static let _instance:HomeRequestObject = HomeRequestObject()
        }
        return instance._instance
    }
    
    func requestChildList(sucBlock:((_ list:[ChildModel])->())?){
        SURLRequest.sharedInstance.requestGetWithUrl(GetAllChildList_Url+"\(SMainBoardObject.shared().idAccount)", suc: { (data) in
            Dprint("GetAllChildList_Url:\(data)")
            let dataJson = JSON(data)
            if dataJson["result"].stringValue == "true" {
                var array:[ChildModel] = []
                let contentJsonArr = dataJson["data"].arrayValue
                for contentJson:JSON in contentJsonArr {
                    let model = ChildModel.getFromModel(json: contentJson)
                    array.append(model)
                }
                if let block = sucBlock {
                    block(array)
                }
            }
        }) { (error) in
            Dprint("GetAllChildList_UrlError:\(error)")
        }
    }
    
    func requestChildStatus(childId:Int32,sucBlock:((_ model:ChildStatusModel)->())?) {
        SURLRequest.sharedInstance.requestGetWithUrl(GetChildStatus_Url+"?accountId=\(SMainBoardObject.shared().idAccount)&childId=\(childId)", suc: { (data) in
            Dprint("GetChildStatus_Url:\(data)")
            let dataJson = JSON(data)
            if dataJson["result"].stringValue == "true" {
                let model = ChildStatusModel.getFromModel(json: dataJson["data"])
                if let block = sucBlock {
                    block(model)
                }
            }
        }) { (error) in
            Dprint("GetChildStatus_UrlError:\(error)")
        }
    }
    
    func requestCreateOrder(childId:Int32,fromLatitude:Double,fromLongitude:Double,toLatitude:Double,toLongitude:Double,sucBlock:((_ code:String)->())?) {
        let params = ["guardianId":SMainBoardObject.shared().idAccount,"childId":childId,"fromLatitude":fromLatitude,"fromLongitude":fromLongitude,"toLatitude":toLatitude,"toLongitude":toLongitude] as [String : Any]
        SURLRequest.sharedInstance.requestPostWithUrl(CreateOrder_Url, param: params, suc: { (data) in
            Dprint("CreateOrder_Url:\(data)")
            let dataJson = JSON(data)
            let code = dataJson["code"].stringValue
            let message = dataJson["message"].stringValue
            Dprint(message)
            if let block = sucBlock {
                block(code)
            }
        }) { (error) in
            Dprint("CreateOrder_UrlError:\(error)")
        }
    }
    
    func requestFinishOrder(orderId:Int32,sucBlock:((_ model:OrderModel)->())?) {
//        let params = ["orderId":orderId,"extra":"testcancel","success":false] as [String : Any]
        SURLRequest.sharedInstance.requestPostWithUrl(FinishOrder_Url+"?orderId=\(orderId)&extra=testcancel&success=true", param: nil, suc: { (data) in
            Dprint("FinishOrder_Url:\(data)")
            let dataJson = JSON(data)
            let code = dataJson["code"].stringValue
            let contentJson = dataJson["data"]
            if code == "0" {
                let model = OrderModel.getFromModel(json: contentJson)
                if let block = sucBlock {
                    block(model)
                }
            }
        }) { (error) in
            Dprint("FinishOrder_UrlError:\(error)")
        }
    }
    
    func requestAgreeAcceptOrder(receiverId:Int32,orderId:Int32,sucBlock:((_ model:OrderModel)->())?) {
        let params = ["orderId":orderId,"receiverId":receiverId] as [String : Any]
        SURLRequest.sharedInstance.requestPostWithUrl(AgreeAcceptOrder_Url+"?orderId=\(orderId)&receiverId=\(receiverId)", param: params, suc: { (data) in
            Dprint("AgreeAcceptOrder_Url:\(data)")
            let dataJson = JSON(data)
            let code = dataJson["code"].stringValue
            let contentJson = dataJson["data"]
            Dprint(dataJson["message"].stringValue)
            if code == "0" {
                let model = OrderModel.getFromModel(json: contentJson)
                if let block = sucBlock {
                    block(model)
                }
            }
        }) { (error) in
            Dprint("AgreeAcceptOrder_UrlError:\(error)")
        }
    }
    
    func requestAcceptOrder(acceptId:Int32,acceptName:String,childId:Int32,orderId:Int32,fromLatitude:Double,fromLongitude:Double,sucBlock:(()->())?) {
        let params = ["acceptId":acceptId,"acceptName":acceptName,"childId":childId,"orderId":orderId,"fromLatitude":fromLatitude,"fromLongitude":fromLongitude] as [String:Any]
        SURLRequest.sharedInstance.requestPostWithUrl(AcceptOrder_Url, param: params, suc: { (data) in
            Dprint("AcceptOrder_Url:\(data)")
            let dataJson = JSON(data)
            let code = dataJson["code"].stringValue
            Dprint(dataJson["message"].stringValue)
            if code == "0" {
                if let block = sucBlock {
                    block()
                }
            }
        }) { (error) in
            Dprint("AcceptOrder_UrlError:\(error)")
        }
    }
    
    func requestOrderStatus(orderId:Int32,sucBlock:((_ model:ChildStatusModel)->())?) {
        SURLRequest.sharedInstance.requestGetWithUrl(OrderStatus_Url+"?accountId=\(SMainBoardObject.shared().idAccount)&orderId=\(orderId)", suc: { (data) in
            Dprint("OrderStatus_Url:\(data)")
            let dataJson = JSON(data)
            let code = dataJson["code"].stringValue
            if code == "0" {
                let model = ChildStatusModel.getFromModel(json: dataJson["data"])
                if let block = sucBlock {
                    block(model)
                }
            }
        }) { (error) in
            Dprint("OrderStatus_UrlError:\(error)")
        }
    }
    
    func requestOrderAcceptUnfinish(sucBlock:((_ list:[OrderModel])->())?) {
        SURLRequest.sharedInstance.requestGetWithUrl(OrderAcceptUnfinish+"\(SMainBoardObject.shared().idAccount)", suc: { (data) in
            Dprint("OrderAcceptUnfinish:\(data)")
            let dataJson = JSON(data)
            if dataJson["result"].stringValue == "true" {
                var array:[OrderModel] = []
                let contentJsonArr = dataJson["data"].arrayValue
                for contentJson:JSON in contentJsonArr {
                    let model = OrderModel.getFromModel(json: contentJson)
                    array.append(model)
                }
                if let block = sucBlock {
                    block(array)
                }
            }
        }) { (error) in
            Dprint("OrderAcceptUnfinishError:\(error)")
        }
    }
    
    func requestOrderProgress(orderId:Int32,sucBlock:((_ list:[OrderProgressModel])->())?) {
        SURLRequest.sharedInstance.requestGetWithUrl(OrderProgress_Url+"\(orderId)", suc: { (data) in
            Dprint("OrderProgress_Url:\(data)")
            let dataJson = JSON(data)
            let code = dataJson["code"].stringValue
            if code == "0" {
                var array:[OrderProgressModel] = []
                let contentJsonArr = dataJson["data"].arrayValue
                for contentJson:JSON in contentJsonArr {
                    let model = OrderProgressModel.getFromModel(json: contentJson)
                    array.append(model)
                }
                if let block = sucBlock {
                    block(array)
                }
            }
        }) { (error) in
            Dprint("OrderProgress_UrlError:\(error)")
        }
    }
    
    func requestOrderUpdate(orderId:Int32,status:Int8,sucBlock:((_ list:[OrderProgressModel])->())?) {
        let params = ["accountId":SMainBoardObject.shared().idAccount,"orderId":orderId,"status":status,"extra":"1"] as [String:Any]
        SURLRequest.sharedInstance.requestPostWithUrl(OrderUpdate_Url+"?accountId=\(SMainBoardObject.shared().idAccount)&orderId=\(orderId)&status=\(status)&extra=1", param: params) { (data) in
            Dprint("OrderUpdate_Url:\(data)")
            let dataJson = JSON(data)
            let code = dataJson["code"].stringValue
            if code == "0" {
                var array:[OrderProgressModel] = []
                let contentJsonArr = dataJson["data"].arrayValue
                for contentJson:JSON in contentJsonArr {
                    let model = OrderProgressModel.getFromModel(json: contentJson)
                    array.append(model)
                }
                if let block = sucBlock {
                    block(array)
                }
            }
        } err: { (error) in
            Dprint("OrderUpdate_UrlError:\(error)")
        }

    }
    
    
    func requestMqttCancel(deviceId:String,sucBlock:((_ code:String,_ message:String)->())?) {
        SURLRequest.sharedInstance.requestPostWithUrl(MqttCancel_Url+"?deviceId=\(deviceId)", param: nil) { (data) in
            Dprint("MqttCancel_Url:\(data)")
            let dataJson = JSON(data)
            let code = dataJson["code"].stringValue
            let message = dataJson["message"].stringValue
            Dprint(message)
            if let block = sucBlock {
                block(code,message)
            }
        } err: { (error) in
            Dprint("MqttCancel_UrlError:\(error)")
        }

    }
}
