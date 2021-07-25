//
//  MQTTHelper.swift
//  SmartTile_Gps
//
//  Created by fanglin on 2020/8/24.
//  Copyright © 2020 fanglin. All rights reserved.
//

import UIKit
import CocoaMQTT
import SwiftyJSON
import Toast_Swift

@objc protocol MQTTHelperDelegate : NSObjectProtocol {
    @objc optional func mqttOrderAcceptSuccess(message:HomeStatusModel)
    @objc optional func mqttChildLocationUpdate(message:OrderModel,deviceId:String)
    @objc optional func mqttOrderUpdate(message:OrderModel)
    @objc optional func mqttOrderRequest(message:OrderModel)
    @objc optional func mqttUserGpsUpdate(message:OrderModel)
    @objc optional func mqttUserSOSUpdate(deviceId:String)
}

class MQTTHelper: NSObject {
    
    weak var delegate: MQTTHelperDelegate?
    
    private static var _sharedInstance: MQTTHelper?
    /// 单例
    ///
    /// - Returns: 单例对象
    class func shared() -> MQTTHelper {
        guard let instance = _sharedInstance else {
            _sharedInstance = MQTTHelper()
            return _sharedInstance!
        }
        return instance
    }
    
    /// 销毁单例
    class func destroy() {
        _sharedInstance = nil
    }
    
    var mqtt:CocoaMQTT?{
        didSet{
            if mqtt?.connState == CocoaMQTTConnState.connected {
                //mqtt?.publish("chat", withString: "dtr")
            }
        }
    }

    func initMqtt(){
        let clientID = "user:" + "\(SMainBoardObject.shared().idAccount)"
        mqtt = CocoaMQTT(clientID: clientID, host: Host_Address, port: 1883)
        mqtt?.username = "user"+"\(SMainBoardObject.shared().idAccount)"
        mqtt?.password = "smart123"
//        mqtt?.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
//        mqtt?.publish("chat", withString: "dtet", qos: CocoaMQTTQOS.qos0, retained: true, dup: true)
        mqtt?.keepAlive = 60
        mqtt?.delegate = self
        mqtt?.autoReconnect = true
//        mqtt?.subscribe("device/topic/"+"\()")
        _ = mqtt?.connect()
    }
    
    func convertDictionaryToJSONString(dict:[String:Any])->String {
        let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        return jsonStr! as String
    }
}

extension MQTTHelper:CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
        Dprint("didSubscribeTopic:\(topics)")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        Dprint("mqttDidPing----")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        Dprint("mqttDidReceivePong-----")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        Dprint("mqttDidDisconnect----")
        _ = mqtt.connect()
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        //注意一定要连接成功了之后，才能发布主题和订阅主题。
        if ack.description == "accept" {
            Dprint("------mqtt连接成功------")
//            AMapLocationHelper.shared().startUpdatingLocation()
            SMainBoardObject.shared().isMqttConnect = true
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        
        print(message.string ?? "999")
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
       
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
//        Dprint("didReceiveMessage:\(JSON(message.payload))")
        let stringWithDecode = String.init(bytes: message.payload, encoding: .utf8)
        if JSON(stringWithDecode) == "0" {
            return
        }
        Dprint(message.topic)
        guard let jsonString = stringWithDecode else {
            return
        }
        Dprint(jsonString)
        let dict = self.getDictionaryFromJSONString(jsonString: jsonString)
        if message.topic.contains("order/accept") {
            HomeRequestObject.shared.requestChildStatus(childId: SMainBoardObject.shared().currentChildId) { (model) in
                if model.order.receiverId == 0 && model.order.id != 0 {
                    
                    guard let jsonString = stringWithDecode else {
                        return
                    }
                    Dprint(jsonString)
                    let dict = self.getDictionaryFromJSONString(jsonString: jsonString)
                    guard let orderId = dict["orderId"] as? Int32 else {
                        return
                    }
                    if model.order.id == orderId {
                        let statusModel = HomeStatusModel()
                        statusModel.orderId = orderId
//                        statusModel.orderStatus = dict["orderStatus"] as! Int8
                        statusModel.driveId = dict["acceptId"] as? Int32 ?? 0
                        statusModel.driveName = dict["acceptName"] as? String ?? ""
                        statusModel.childId = dict["childId"] as? Int32 ?? 0
                        self.delegate?.mqttOrderAcceptSuccess?(message: statusModel)
                    }
                }
            }
        }else if message.topic.contains("order/request") {
            let model = OrderModel()
            guard let orderId = dict["orderId"] as? Int32 else {
                return
            }
            guard let orderStatus = dict["orderStatus"] as? Int8 else {
                return
            }
            guard let guardianName = dict["guardianName"] as? String else {
                return
            }
            guard let childName = dict["childName"] as? String else {
                return
            }
            guard let fromLatitude = dict["fromLatitude"] as? Double else {
                return
            }
            guard let fromLongitude = dict["fromLongitude"] as? Double else {
                return
            }
            guard let toLatitude = dict["toLatitude"] as? Double else {
                return
            }
            guard let toLongitude = dict["toLongitude"] as? Double else {
                return
            }
            guard let childId = dict["childId"] as? Int32 else {
                return
            }
            model.id = orderId
            model.orderStatus = orderStatus
            model.guardianName = guardianName
            model.childName = childName
            model.fromLatitude = fromLatitude
            model.fromLongitude = fromLongitude
            model.toLatitude = toLatitude
            model.toLongitude = toLongitude
            model.childId = childId
            delegate?.mqttOrderRequest?(message: model)
        }else if message.topic.contains("order/update") {
            let model = OrderModel()
            guard let childId = dict["childId"] as? Int32 else {
                return
            }
            guard let orderStatus = dict["orderStatus"] as? Int8 else {
                return
            }
            model.childId = childId
            model.orderStatus = orderStatus
            delegate?.mqttOrderUpdate?(message: model)
        }else if message.topic.contains("user/gps") {
            let driveIdStr = message.topic.replacingOccurrences(of: "user/gps/", with: "")
            guard let driveId = Int32(driveIdStr) else {
                return
            }
            let model = OrderModel()
            guard let latitude = dict["latitude"] as? Double else {
                return
            }
            guard let longitude = dict["longitude"] as? Double else {
                return
            }
            model.carLatitude = latitude
            model.carLongitude = longitude
            model.receiverId = driveId
            delegate?.mqttUserGpsUpdate?(message: model)
        }else if message.topic.contains("device/gps") {
            let deviceIdStr = message.topic.replacingOccurrences(of: "device/gps/", with: "")
            let model = OrderModel()
            guard let latitude = dict["latitude"] as? Double else {
                return
            }
            guard let longitude = dict["longitude"] as? Double else {
                return
            }
            guard let time = dict["time"] as? String else {
                return
            }
            guard let gsensorz = dict["gsensorz"] as? String else {
                return
            }
            model.fromLatitude = latitude
            model.fromLongitude = longitude
            model.deviceLatestonline = time
            model.gsensorz = gsensorz
            
            var gsensorStr = ""
            if UserDefaults.standard.string(forKey: deviceIdStr) != nil {
                gsensorStr = FLUserDefaultsStringGet(key: deviceIdStr)
                gsensorStr = gsensorz + "," + gsensorStr
                FLUserDefaultsStringSet(key: deviceIdStr, obj: gsensorStr)
            }else {
                FLUserDefaultsStringSet(key: deviceIdStr, obj: gsensorz)
            }
            UIViewController.getCurrentViewCtrl().view.makeToast("child GPS: \(time) latitude:\(latitude) longitude:\(longitude) gsensorZ:\(gsensorz)", duration: 1.0, position: .bottom)
            delegate?.mqttChildLocationUpdate?(message: model, deviceId: deviceIdStr)
        }else if message.topic.contains("device/ask/pick") {
            guard let action = dict["action"] as? String else {
                return
            }
            if action == "pick/open" {
                let alertVC = UIAlertController.initAlertView(message: "Your child asking pickup!", sureTitle: NSLocalizedString("Determine", comment: "")) { (alert) in
                    
                }
                UIViewController.getCurrentViewCtrl().present(alertVC, animated: true, completion: nil)
            }else if action == "pick/close" {
                let alertVC = UIAlertController.initAlertView(message: "Your child asking cancel!", sureTitle: NSLocalizedString("Determine", comment: "")) { (alert) in
                    
                }
                UIViewController.getCurrentViewCtrl().present(alertVC, animated: true, completion: nil)
            }
        }else if message.topic.contains("device/alarm") {
            let driveIdStr = message.topic.replacingOccurrences(of: "device/alarm/", with: "")
            guard let action = dict["action"] as? String else {
                return
            }
            if action == "sos/open" {
                delegate?.mqttUserSOSUpdate?(deviceId: driveIdStr)
            }else if action == "drown/open" {
                let alertVC = UIAlertController.initAlertView(message: NSLocalizedString("child_drown_open", comment: ""), sureTitle: NSLocalizedString("Determine", comment: "")) { (alert) in
                    
                }
                UIViewController.getCurrentViewCtrl().present(alertVC, animated: true, completion: nil)
            }else if action == "drown/close" {
                let alertVC = UIAlertController.initAlertView(message: NSLocalizedString("child_drown_close", comment: ""), sureTitle: NSLocalizedString("Determine", comment: "")) { (alert) in
                    
                }
                UIViewController.getCurrentViewCtrl().present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        Dprint("didSubscribeTopic")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        Dprint("didUnsubscribeTopic")
    }
    
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        guard let jsonData:Data = jsonString.data(using: .utf8) else {
            return NSDictionary()
        }

        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
}
