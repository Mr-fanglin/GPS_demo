//
//  XCXinChatTools+Session.swift
//  
//
//  Created by FangLin on 2019/1/16.
//  Copyright © 2019年 FangLin. All rights reserved.
//


import Foundation
import NIMSDK

// MARK:- 获取最近会话
extension XCXinChatTools {
    // MARK: 获取最近会话
    func getAllRecentSession() -> [NIMRecentSession]? {
        return NIMSDK.shared().conversationManager.allRecentSessions()
    }
}

// MARK:- 消息/会话的删除
extension XCXinChatTools {
    // MARK: 单条消息的删除
    func deleteMessage(with message: NIMMessage) {
        NIMSDK.shared().conversationManager.delete(message)
    }
    // MARK: 单个会话批量消息删除
    // removeRecentSession 标记了最近会话是否会被保留，会话内消息将会标记为已删除
    // 调用此方法会触发最近消息修改的回调，如果选择保留最近会话， lastMessage 属性将会被置成一条空消息。
    func deleteAllMessagesInSession(_ session: NIMSession) {
        let delOption = NIMDeleteMessagesOption.init()
        delOption.removeSession = false
        NIMSDK.shared().conversationManager.deleteAllmessages(in: session, option: delOption)
    }
    
    // MARK: 最近会话的删除
    func deleteRecentSession(_ recentSession: NIMRecentSession) {
        NIMSDK.shared().conversationManager.delete(recentSession)
    }
    
    // MARK: 清空所有会话的消息
    // removeRecentSession 标记了最近会话是否会被保留。
    // 调用这个接口只会触发 - (void)allMessagesDeleted 回调，其他针对单个 recentSession 的回调都不会被调用。
    func deleteAllmessagesInSession(_ session: NIMSession) {
        let delOption = NIMDeleteMessagesOption.init()
        delOption.removeSession = false
        NIMSDK.shared().conversationManager.deleteAllmessages(in: session, option: delOption)
    }
}

// MARK:- 其它
extension XCXinChatTools {
    // MARK: 总未读数获取
    func getAllUnreadCount() -> Int {
        return NIMSDK.shared().conversationManager.allUnreadCount()
    }
    
    // MARK: 标记某个会话为已读
    // 调用这个方法时，会将所有属于这个会话的消息都置为已读状态。
    // 相应的最近会话(如果有的话)未读数会自动置 0 并且触发最近消息修改的回调
    func markAllMessagesReadInSession(userId: String?) {
        guard let userId = userId else { return }
        let session = NIMSession.init(userId, type: .P2P)
        NIMSDK.shared().conversationManager.markAllMessagesRead(in: session)
    }
    
    // MARK: 标记所有会话为已读
    func markAllMessagesRead() {
        NIMSDK.shared().conversationManager.markAllMessagesRead()
    }
}

// MARK:- NIMConversationManagerDelegate
extension XCXinChatTools : NIMConversationManagerDelegate {
    // MARK: 增加最近会话 回调
    func didAdd(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        Dprint("增加最近会话 回调")
    }
    // MARK: 修改最近会话 回调
    func didUpdate(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        Dprint("修改最近会话 回调")
    }
    // MARK: 删除最近会话 回调
    func didRemove(_ recentSession: NIMRecentSession, totalUnreadCount: Int) {
        Dprint("删除最近会话 回调")
    }
}
