//
//  XCXinChatTools+SystemNotification.swift
//  XinChat
//
//  Created by FangLin on 2019/11/20.
//  Copyright © 2019 FangLin. All rights reserved.
//

import Foundation


enum NIMSystemNotificationHandleStatus:Int {
    case NotificationHandleTypeNone = 0      // 0
    case NotificationHandleTypeOk            // 1
}
///MARK: 代理
//NIMSystemNotificationManagerDelegate
extension XCXinChatTools:NIMSystemNotificationManagerDelegate {
    func onReceive(_ notification: NIMSystemNotification) {
        let type = notification.type
        switch type {
        case .friendAdd:
            Dprint("friendAdd")
            guard let attachment = notification.attachment else { return }
            if attachment is NIMUserAddAttachment {
                let userAddAttachment = attachment as! NIMUserAddAttachment
                switch userAddAttachment.operationType {
                case .add:      // 对方直接加你为好友
                    Dprint("add")
                    
                case .request:  // 对方请求加你为好友
                    Dprint("request")
//                    guard let userId = notification.sourceID else { return }
//                    XCXinChatTools.shared.searchUserInfo(userId) { (code, userInfo) in
//                        if code == "200" {
//                            //当对方请求添加好友时，自己给芯信助手发送一条好友请求的自定义消息，消息主体内容为对方
//                            XCXinChatTools.shared.sendAddFriendRequest(userId: NIM_Admin, toUserId: userId, toNickname: userInfo?.alias ?? userInfo?.userInfo?.nickName ?? userId, toAvatar: userInfo?.userInfo?.avatarUrl ?? "DefaultProfileHead_phone", postscript: notification.postscript ?? "")
//                        }
//                    }
                case .verify:   // 对方通过了你的好友请求
                    Dprint("verify")
                    guard let userId = notification.sourceID else { return }
                    XCXinChatTools.shared.addFriend(userId, message: notification.postscript ?? "") { (error) in
                        if error == nil {
                            notification.handleStatus = NIMSystemNotificationHandleStatus.NotificationHandleTypeOk.rawValue
                            //发送提示消息
                            XCXinChatTools.shared.sendAddFriendSuc(userId: userId, message: "我们已经是好友了，一起聊天吧")
                        }
                    }
                case .reject:   // 对方拒绝了你的好友请求
                    Dprint("reject")
                default:
                    Dprint("error")
                }
            }
        default:
            Dprint("error")
        }
    }
    
    
}
