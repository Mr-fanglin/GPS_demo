//
//  XCXinChatTools+Message.swift
// 
//
//  Created by FangLin on 2019/1/5.
//  Copyright © 2019年 FangLin. All rights reserved.
//


import Foundation
import NIMSDK
import AudioToolbox

enum XCXinChatMessageType {
    case audio
    case video
}

// MARK:- 发送信息
extension XCXinChatTools {
    // MARK: 发送文本消息
    func sendText(userId: String?, text: String?) {
        guard let userId = userId else { return }
        let message = NIMMessage()
        message.text = text
        self.sendMessage(userId: userId, message: message)
    }
    // MARK: 发送图片消息
    func sendImage(userId: String?, image: UIImage) {
        guard let userId = userId else { return }
        let imageObj = NIMImageObject(image: image)
        let message = NIMMessage()
        message.messageObject = imageObj
        self.sendMessage(userId: userId, message: message)
    }
    // MARK: 发送音频/视频消息
    func sendMedia(userId: String?, filePath: String, type: XCXinChatMessageType) {
        guard let userId = userId else { return }
        let message = NIMMessage()
        switch type {
        case .audio:
            message.messageObject = NIMAudioObject(sourcePath: filePath)
        case .video:
            message.messageObject = NIMVideoObject(sourcePath: filePath)
        }
        self.sendMessage(userId: userId, message: message)
    }
    //MARK: 发送位置消息
    func sendLocation(userId:String?, latitude:Double, longitude:Double, title:String) {
        guard let userId = userId else {
            return
        }
        let locationObj = NIMLocationObject.init(latitude: latitude, longitude: longitude, title: title)
        let message = NIMMessage()
        message.messageObject = locationObj
        self.sendMessage(userId: userId, message: message)
    }
    //MARK: 小孩请求接送
    func sendAskPick(userId:String?,orderId:Int32,childId:Int32,childName:String,latitude:Double,longitude:Double) {
        guard let userId = userId else {
            return
        }
        let customObj = NIMCustomObject()
        let attachment = XCNIMChildAskPickAttachment()
        attachment.orderId = Int(orderId)
        attachment.childId = Int(childId)
        attachment.childName = childName
        attachment.latitude = latitude
        attachment.longitude = longitude
        customObj.attachment = attachment
        let message = NIMMessage()
        message.messageObject = customObj
        self.sendMessage(userId: userId, message: message)
    }
    //MARK: 监护人发出接送请求
    func sendRequestPick(userId:String?,orderId:Int32,childId:Int32,userName:String,fromAddress:String,toAddress:String,latitude:Double,longitude:Double,toLatitude:Double,toLongitude:Double) {
        guard let userId = userId else {
            return
        }
        let customObj = NIMCustomObject()
        let attachment = XCNIMSendRequestPickAttachment()
        attachment.orderId = Int(orderId)
        attachment.userId = Int(childId)
        attachment.userName = userName
        attachment.fromAddress = fromAddress
        attachment.toAddress = toAddress
        attachment.latitude = latitude
        attachment.longitude = longitude
        attachment.toLatitude = toLatitude
        attachment.toLongitude = toLongitude
        customObj.attachment = attachment
        let message = NIMMessage()
        message.messageObject = customObj
        self.sendMessage(userId: userId, message: message)
    }
    //MARK: 想要接单
    func sendHelpPick(userId:String?,orderId:Int32,childName:String,latitude:Double,longitude:Double) {
        guard let userId = userId else {
            return
        }
        let customObj = NIMCustomObject()
        let attachment = XCNIMHelpPickAttachment()
        attachment.orderId = Int(orderId)
        attachment.childName = childName
        attachment.latitude = latitude
        attachment.longitude = longitude
        customObj.attachment = attachment
        let message = NIMMessage()
        message.messageObject = customObj
        self.sendMessage(userId: userId, message: message)
    }
    //MARK: 同意某人接送
    func sendAgreePick(userId:String?,orderId:Int32,driverId:Int32,driverName:String) {
        guard let userId = userId else {
            return
        }
        let customObj = NIMCustomObject()
        let attachment = XCNIMAgreePickAttachment()
        attachment.orderId = Int(orderId)
        attachment.driverId = Int(driverId)
        attachment.driverName = driverName
        customObj.attachment = attachment
        let message = NIMMessage()
        message.messageObject = customObj
        self.sendMessage(userId: userId, message: message)
    }
    //MARK: 小孩请求接送
    func sendOrderTips(userId:String?,orderId:Int32,status:Int32,childName:String,lat:Double,lng:Double) {
        guard let userId = userId else {
            return
        }
        let customObj = NIMCustomObject()
        let attachment = XCNIMOrderTipsAttachment()
        attachment.orderId = Int(orderId)
        attachment.status = Int(status)
        attachment.childName = childName
        attachment.lat = lat
        attachment.lng = lng
        customObj.attachment = attachment
        let message = NIMMessage()
        message.messageObject = customObj
        self.sendMessage(userId: userId, message: message)
    }
    
    // MARK: 发送视频聊天
    func sendVideoChat(userId: String?) {
        guard let userId = userId else { return }
        let customObj = NIMCustomObject()
        let attachment = XCNIMAudioOrVideoCallAttachment()
        attachment.callType = 0
        customObj.attachment = attachment
        let message = NIMMessage()
        message.messageObject = customObj
        self.sendMessage(userId: userId, message: message)
    }
    
    // MARK: 发送添加好友请求的自定义消息
    func sendAddFriendRequest(userId:String?, postscript:String) {
        guard let userId = userId else { return }
        let customObj = NIMCustomObject()
        let attachment = XCNIMAddFriendRequestAttachment()
        attachment.attach = postscript
        customObj.attachment = attachment
        let message = NIMMessage()
        message.messageObject = customObj
        self.sendMessage(userId: userId, message: message)
    }
    
    //添加好友成功自定义消息
    func sendAddFriendSuc(userId:String?, message:String) {
        guard let userId = userId else { return }
        let customObj = NIMCustomObject()
        let attachment = XCNIMAddFriendSucAttachment()
        attachment.message = message
        customObj.attachment = attachment
        let message = NIMMessage()
        message.messageObject = customObj
        self.sendMessage(userId: userId, message: message)
    }
    
    // MARK: 发送
    func sendMessage(userId: String, message: NIMMessage) {
        let session = NIMSession.init(userId, type: .P2P)
        guard let call = try? NIMSDK.shared().chatManager.send(message, to: session) else {
            return
        }
        Dprint(call)
    }
}

// MARK:- NIMChatManagerDelegate
extension XCXinChatTools: NIMChatManagerDelegate {
    // MARK:- 发送消息的回调
    // MARK: 即将发送消息回调
    // 仅在收到这个回调后才将消息加入显示用的数据源中。
    func willSend(_ message: NIMMessage) {
        Dprint("即将发送的信息")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:kNoteChatMsgInsertMsg), object: message)
    }
    // MARK: 消息发送进度回调
    // 图片，视频等需要上传附件的消息会有比较详细的进度回调，文本消息则没有这个回调。
    func send(_ message: NIMMessage, progress: Float) {
        Dprint("发送进度 --- \(progress)")
    }
    // MARK: 消息发送完毕回调
    // 如果消息发送成功 error 为 nil，反之 error 会被填充具体的失败原因
    func send(_ message: NIMMessage, didCompleteWithError error: Error?) {
        if error != nil {
            Dprint(error)
        } else {
            Dprint("消息发送成功")
        }
        // 通知更新状态
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:kNoteChatMsgUpdateMsg), object: message)
    }
    
    // MARK: 重发
    // 因为网络原因等导致的发送消息失败而需要重发的情况，直接调用
    // 此时如果再次调用 sendMessage，则会被 NIM SDK 认作新消息。
    func resendMessage(message: NIMMessage) -> Bool {
        guard (try? NIMSDK.shared().chatManager.resend(message)) != nil else {
            return false
        }
        // 通知更新状态
        // 会自动调用上面的 《消息发送完毕回调》
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:kNoteChatMsgResendMsg), object: message)
        return true
    }
    
    // MARK:- 接收消息
    // MARK: 收消息
    func onRecvMessages(_ messages: [NIMMessage]) {
        Dprint("收到消息")
        for msg in messages {
            if msg.session?.sessionType != .P2P {
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNoteChatMsgInsertMsg), object: msg)
            
            if msg.from == currentChatUserId {
                //置为已读
                XCXinChatTools.shared.markAllMessagesReadInSession(userId: currentChatUserId)
            } else {
                Dprint("收到非当前聊天用户发来的消息")
                if msg.setting?.apnsEnabled == false {
                    return
                }
                guard var text = msg.senderName else {
                    return
                }
                switch msg.messageType {
                case .text:
                    text = String.init(format: "%@\n%@", text,msg.text ?? "")
                case .image:
                    text = String.init(format: "%@\n[图片]", text)
                case .audio:
                    text = String.init(format: "%@\n[语音]", text)
                case .video:
                    text = String.init(format: "%@\n[视频]", text)
                case .location:
                    text = String.init(format: "%@\n[位置]", text)
                case .custom:
                    guard let obj:NIMCustomObject = msg.messageObject as? NIMCustomObject else{
                        return
                    }
                    guard let attachment = obj.attachment else { return }
                    if attachment is XCNIMAudioOrVideoCallAttachment {
                        let videoAttachment = attachment as! XCNIMAudioOrVideoCallAttachment
                        if videoAttachment.callType == 0 {
                            text = String.init(format: "%@ [视频通话]", text)
                        }
                    }else if attachment is XCNIMAddFriendRequestAttachment {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNoteAddFriendRequestMsg), object: msg)
                        return
                    }
                case .notification:
                    Dprint("notification")
                case .file:
                    Dprint("file")
                case .tip:
                    Dprint("tip")
                    if let msgText = msg.text {
                        if msgText.contains("calling SOS") {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNoteCallingSOS), object: msg)
                        }
                    }
                case .robot:
                    Dprint("robot")
                @unknown default:
                    Dprint("未知消息")
                }
                //定义本地通知对象
                let notification = UILocalNotification.init()
                notification.alertBody = text
                notification.fireDate = Date.init(timeIntervalSinceNow: 0.1)
                notification.soundName = "in.caf"
                notification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
                notification.userInfo = ["aps":["alert":text,"sound":"default"],"sessionId":msg.from as Any,"nickName":msg.senderName as Any,"nim":"1"]
                UIApplication.shared.scheduleLocalNotification(notification)
                
                //建立的SystemSoundID对象
                var soundID:SystemSoundID = 0
                //获取声音地址
                let path = Bundle.main.path(forResource: "in", ofType: "caf")
                //地址转换
                let baseURL = NSURL(fileURLWithPath: path!)
                //赋值
                AudioServicesCreateSystemSoundID(baseURL, &soundID)
                //提醒（同上面唯一的一个区别）
                AudioServicesPlayAlertSound(soundID)
            }
        }
    }
    
    // 如果收到的是图片，视频等需要下载附件的消息，在回调的处理中还需要调用（SDK 默认会在第一次收到消息时自动调用）
    // MARK: 附件的下载
    // 进行附件的下载，附件的下载过程会通过 这两个回调返回进度和结果。
    func fetchMessageAttachment(_ message: NIMMessage, progress: Float) {
        Dprint("进度： \(progress)")
    }
    
    func fetchMessageAttachment(_ message: NIMMessage, didCompleteWithError error: Error?) {
        Dprint("结果")
        if error != nil {
            Dprint(error)
        } else {
            Dprint(message)
        }
    }
}

// MARK:- 历史记录
extension XCXinChatTools {
    // MARK:- 从本地获取
    func getLocalMsgs(userId: String?, message: NIMMessage? = nil) -> [NIMMessage]? {
        Dprint(userId)
        guard let userId = userId else { return nil }
        let session = NIMSession.init(userId, type: .P2P)
        return NIMSDK.shared().conversationManager.messages(in: session, message: message, limit: 20)
    }
    
    // MARK: 从云端获取
    func getCloudMsgs(currentMessage: NIMMessage? = nil, userId: String?,  resultBlock: @escaping (Error?, [NIMMessage]?) -> ()) {
        guard let userId = userId else { return }
        let session = NIMSession.init(userId, type: .P2P)
        let option = NIMHistoryMessageSearchOption()
        //option.startTime = 0
        option.endTime = currentMessage?.timestamp ?? 0
        option.limit = 20
        option.currentMessage = currentMessage
        option.order = .desc // 检索倒序
        option.sync = false  // 同步到本地(暂时设置为false，供测试)
        NIMSDK.shared().conversationManager.fetchMessageHistory(session, option: option) { (error, messages) in
            if messages != nil {
                resultBlock(error, messages!.reversed())
            } else {
                resultBlock(error, messages)
            }
        }
    }
    
    // MARK: 获取本地指定类型的消息
    func searchLocalMsg(type:NIMMessageType = .image, userId: String?, resultBlock: @escaping (Error?, [NIMMessage]?) -> ()) {
        guard let userId = userId else { return }
        let session = NIMSession.init(userId, type: .P2P)
        let option = NIMMessageSearchOption()
        option.order = .asc
        option.messageTypes = [type.rawValue] as [NSNumber]
        NIMSDK.shared().conversationManager.searchMessages(session, option: option) { (error, messages) in
            resultBlock(error, messages)
        }
    }
}
