//
//  XCRecentSessionModel.swift
//
//
//  Created by FangLin on 2017/1/17.
//  Copyright © 2017年 FangLin. All rights reserved.
//


/// 会话列表模型
import UIKit
import NIMSDK

class XCRecentSessionModel: NSObject {
    // 最近会话
    var recentSession: NIMRecentSession? {
        didSet {
            session = recentSession?.session
            lastMessage = recentSession?.lastMessage
            unreadCount = recentSession?.unreadCount ?? 0
            userId = session?.sessionId
        }
    }
    // 当前会话
    fileprivate var session: NIMSession? { didSet {setSession()} }
    // 最后一条消息
    fileprivate var lastMessage: NIMMessage? { didSet {setLastMsg()} }
    // 未读消息数
    var unreadCount: Int = 0
    
    var userId:String?
    var avatarPath: String?
    var title: String?
    var subTitle: String?
    var time: String?
    
    override init() {
        super.init()
    }
    
    init(user: NIMUser?) {
        let userInfo = user?.userInfo
        self.title = user?.alias ?? userInfo?.nickName ?? user?.userId
        self.avatarPath = userInfo?.avatarUrl
        self.userId = user?.userId
    }
}

// MARK:- 提取数据
extension XCRecentSessionModel {
    // MARK: setSession
    fileprivate func setSession() {
        guard let user = XCXinChatTools.shared.getFriendInfo(userId: session?.sessionId ?? "") else {
            return
        }
        avatarPath = user.userInfo?.avatarUrl
        title = user.alias ?? user.userInfo?.nickName ?? user.userId
    }
    
    // MARK: setMessage
    fileprivate func setLastMsg() {
        let chatMsgModel = XCChatMsgModel()
        chatMsgModel.message = lastMessage
        switch chatMsgModel.modelType {
        case .text:
            subTitle = chatMsgModel.text
        case .image:
            subTitle = "[\(NSLocalizedString("Message_Image", comment: ""))]"
        case .video:
            subTitle = "[\(NSLocalizedString("Message_Video", comment: ""))]"
        case .audio:
            subTitle = "[\(NSLocalizedString("Message_Audio", comment: ""))]"
        case .location:
            subTitle = "[\(NSLocalizedString("Message_Location", comment: ""))]"
        case .videoCall:
            subTitle = "[\(NSLocalizedString("Message_VideoCall", comment: ""))]"
        case .addFriendSuc:
            subTitle = chatMsgModel.addSucTip
        case .requestPick,.askingPick,.helpPick,.agreePick:
            subTitle = "[\(NSLocalizedString("Message_OrderMessage", comment: ""))]"
        case .tip:
            if (chatMsgModel.sessionId?.contains("system_01"))! {
                subTitle = "[\(NSLocalizedString("Message_OrderMessage", comment: ""))]"
            }
        default:
            break
        }
        
        time = XCChatMsgTimeHelper.shared.chatTimeString(with: chatMsgModel.time)
    }
}
