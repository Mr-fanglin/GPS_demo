//
//  XCNewFriendMsgModel.swift
//  XinChat
//
//  Created by FangLin on 2019/12/4.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit

class XCNewFriendMsgModel: NSObject {
    // 最近会话
    var recentSession: NIMRecentSession? {
        didSet {
            session = recentSession?.session
            assignMessage = recentSession?.lastMessage
            userId = session?.sessionId
        }
    }
    // 当前会话
    fileprivate var session: NIMSession? { didSet {setSession()} }
    // 指定消息
    var assignMessage: NIMMessage? { didSet {setLastMsg()} }
    // 未读消息数
    var unreadCount: Int = 0
    // 是否已添加好友
    var isAdd:Bool = false
    
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
extension XCNewFriendMsgModel {
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
        chatMsgModel.message = assignMessage
        switch chatMsgModel.modelType {
        case .addFriendRequest:
            subTitle = chatMsgModel.attach
        default:
            break
        }
        time = XCChatMsgTimeHelper.shared.chatTimeString(with: chatMsgModel.time)
    }
}
