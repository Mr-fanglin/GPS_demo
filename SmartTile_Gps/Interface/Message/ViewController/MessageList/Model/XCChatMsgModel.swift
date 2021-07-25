//
//  XCChatMsgModel.swift
//  
//
//  Created by FangLin on 2017/1/4.
//  Copyright © 2019年 FangLin. All rights reserved.
//
//  GitHub: https://github.com/LinXunFeng
//  简书: http://www.jianshu.com/users/31e85e7a22a2

import UIKit
import NIMSDK

/// 消息列表模型
enum XCChatMsgUserType: Int {
    case me
    case friend
}

enum XCChatMsgModelType: Int {
    case tip
    case text
    case image
    case time
    case audio
    case video
    case location
    case audioCall
    case videoCall
    case addFriendRequest  //好友请求验证
    case addFriendSuc    //添加好友成功
    case helpPick    //帮忙接送
    case requestPick  //监护人发起请求接送
    case agreePick  //同意司机接送
    case askingPick //小孩请求接送
    case orderTip  //订单状态提醒
}

class XCChatMsgModel: NSObject {
    var cellHeight: CGFloat = 0
    // 会话类型
    var modelType: XCChatMsgModelType = .text
    // 会话来源
    var userType: XCChatMsgUserType = .me
    
    var message: NIMMessage? {
        didSet {
            guard let message = message else {
                return
            }
            self.fromUserId = message.from
            self.sessionId = message.session?.sessionId
            self.messageId = message.messageId
            self.text = message.text
            self.time = message.timestamp
            switch message.messageType {
            case .tip:
                modelType = .tip
            case .text:
                modelType = .text
            case .image:
                modelType = .image
                let imgObj = message.messageObject as! NIMImageObject
                thumbPath = imgObj.thumbPath
                thumbUrl = imgObj.thumbUrl
                imgPath = imgObj.path
                imgUrl = imgObj.url
                imgSize = imgObj.size
                fileLength = imgObj.fileLength
            case .audio:
                modelType = .audio
                let audioObj = message.messageObject as! NIMAudioObject
                audioPath = audioObj.path
                audioUrl = audioObj.url
                audioDuration = CGFloat(audioObj.duration) / 1000.0
            case .video:
                modelType = .video
                let videoObj = message.messageObject as! NIMVideoObject
                videoDisplayName = videoObj.displayName
                videoPath = videoObj.path
                videoUrl = videoObj.url
                videoCoverUrl = videoObj.coverUrl
                videoCoverPath = videoObj.coverPath
                videoCoverSize = videoObj.coverSize
                videoDuration = videoObj.duration
                fileLength = videoObj.fileLength
            case .location:
                modelType = .location
                let locationObj = message.messageObject as! NIMLocationObject
                latitude = locationObj.latitude
                longitude = locationObj.longitude
                title = locationObj.title
            case .custom:
                guard let obj:NIMCustomObject = message.messageObject as? NIMCustomObject else{
                    return
                }
                guard let attachment = obj.attachment else { return }
                if attachment is XCNIMAudioOrVideoCallAttachment {
                    let videoAttachment = attachment as! XCNIMAudioOrVideoCallAttachment
                    if videoAttachment.callType == 0 {
                        modelType = .videoCall
                        self.text = "视频通话"
                    }
                }else if attachment is XCNIMAddFriendSucAttachment {
                    let addFriendSucAttachment = attachment as! XCNIMAddFriendSucAttachment
                    modelType = .addFriendSuc
                    self.addSucTip = addFriendSucAttachment.message
                }else if attachment is XCNIMAddFriendRequestAttachment {
                    let addFriendAttachment = attachment as! XCNIMAddFriendRequestAttachment
                    modelType = .addFriendRequest
                    self.attach = addFriendAttachment.attach
                }else if attachment is XCNIMChildAskPickAttachment {
                    let askPickAttachment = attachment as! XCNIMChildAskPickAttachment
                    modelType = .askingPick
                    self.orderId = Int32(askPickAttachment.orderId)
                    self.childId = Int32(askPickAttachment.childId)
                    self.childName = askPickAttachment.childName
                    self.latitude = askPickAttachment.latitude
                    self.longitude = askPickAttachment.longitude
                }else if attachment is XCNIMSendRequestPickAttachment {
                    let requestPickAttachment = attachment as! XCNIMSendRequestPickAttachment
                    modelType = .requestPick
                    self.userName = requestPickAttachment.userName
                    self.orderId = Int32(requestPickAttachment.orderId)
                    self.userId = Int32(requestPickAttachment.userId)
                    self.fromAddress = requestPickAttachment.fromAddress
                    self.toAddress = requestPickAttachment.toAddress
                    self.latitude = requestPickAttachment.latitude
                    self.longitude = requestPickAttachment.longitude
                    self.toLatitude = requestPickAttachment.toLatitude
                    self.toLongitude = requestPickAttachment.toLongitude
                }else if attachment is XCNIMHelpPickAttachment {
                    let helpPickAttachment = attachment as! XCNIMHelpPickAttachment
                    modelType = .helpPick
                    self.orderId = Int32(helpPickAttachment.orderId)
                    self.childName = helpPickAttachment.childName
                    self.latitude = helpPickAttachment.latitude
                    self.longitude = helpPickAttachment.longitude
                }else if attachment is XCNIMAgreePickAttachment {
                    let agreePickAttachment = attachment as! XCNIMAgreePickAttachment
                    modelType = .agreePick
                    self.orderId = Int32(agreePickAttachment.orderId)
                    self.driverName = agreePickAttachment.driverName
                    self.driverId = Int32(agreePickAttachment.driverId)
                }else if attachment is XCNIMOrderTipsAttachment {
                    let orderTipsAttachment = attachment as! XCNIMOrderTipsAttachment
                    modelType = .orderTip
                    self.orderId = Int32(orderTipsAttachment.orderId)
                    self.status = orderTipsAttachment.status
                    self.childName = orderTipsAttachment.childName
                    self.lat = orderTipsAttachment.lat
                    self.lng = orderTipsAttachment.lng
                }
            default:
                break
            }
            userType = message.from ?? "" == XCXinChatTools.shared.getCurrentUserId() ? .me : .friend
        }
    }
    
    // 信息来源id
    var fromUserId: String?
    // 会话id(即当前聊天的userId)
    var sessionId: String?
    // 信息id
    var messageId: String?
    // 附件
    var messageObject: Any?
    // 信息时间辍
    var time: TimeInterval?
    var timeStr: String?
    
    /* ============================== 文字 ============================== */
    // 文字
    var text: String?
    
    /* ============================== 图片 ============================== */
    // 本地原图地址
    var imgPath: String?
    // 云信原图地址
    var imgUrl: String?
    // 本地缩略图地址
    var thumbPath: String?
    // 云信缩略图地址
    var thumbUrl: String?
    // 图片size
    var imgSize: CGSize?
    // 文件大小
    var fileLength: Int64?
    
    /* ============================== 语音 ============================== */
    // 语音的本地路径
    var audioPath: String?
    // 语音的远程路径
    var audioUrl: String?
    // 语音时长，毫秒为单位
    var audioDuration: CGFloat = 0
    
    /* ============================== 视频 ============================== */
    // 视频展示名
    var videoDisplayName: String?
    // 视频的本地路径
    var videoPath: String?
    // 视频的远程路径
    var videoUrl: String?
    // 视频封面的远程路径
    var videoCoverUrl : String?
    // 视频封面的本地路径
    var videoCoverPath : String?
    // 封面尺寸
    var videoCoverSize: CGSize?
    // 视频时长，毫秒为单位
    var videoDuration: Int?
    
    /* ============================== 位置 ============================= */
    //纬度
    var latitude:Double = 0
    //经度
    var longitude:Double = 0
    //标题
    var title:String?
    
    /* =========================== 自定义 ==================*/
    /// 添加好友请求
    //附言
    var attach:String?
    
    /// 添加好友成功
    //添加好友提示语
    var addSucTip:String?
    
    ///帮忙接送
    var orderId:Int32 = 0
    var childName:String?
    ///请求接送
    var userName:String?
    var userId:Int32 = 0
    var fromAddress:String = ""
    var toAddress:String = ""
    var toLatitude:Double = 0
    var toLongitude:Double = 0
    ///同意接送
    var driverName:String = ""
    var driverId:Int32 = 0
    ///小孩请求接送
    var childId:Int32 = 0
    ///订单提醒
    var status:Int = 0
    var lat:Double = 0
    var lng:Double = 0
    
    override init() {
        super.init()
    }
}

/*
 message.deliveryState
 /**
 *  消息发送失败
 */
 NIMMessageDeliveryStateFailed,
 /**
 *  消息发送中
 */
 NIMMessageDeliveryStateDelivering,
 /**
 *  消息发送成功
 */
 NIMMessageDeliveryStateDeliveried
 */

/* ============================================================ */

/*
 message.messageType
 /**
 *  文本类型消息
 */
 NIMMessageTypeText          = 0,
 /**
 *  图片类型消息
 */
 NIMMessageTypeImage         = 1,
 /**
 *  声音类型消息
 */
 NIMMessageTypeAudio         = 2,
 /**
 *  视频类型消息
 */
 NIMMessageTypeVideo         = 3,
 /**
 *  位置类型消息
 */
 NIMMessageTypeLocation      = 4,
 /**
 *  通知类型消息
 */
 NIMMessageTypeNotification  = 5,
 /**
 *  文件类型消息
 */
 NIMMessageTypeFile          = 6,
 /**
 *  提醒类型消息
 */
 NIMMessageTypeTip           = 10,
 /**
 *  自定义类型消息
 */
 NIMMessageTypeCustom        = 100
 */
