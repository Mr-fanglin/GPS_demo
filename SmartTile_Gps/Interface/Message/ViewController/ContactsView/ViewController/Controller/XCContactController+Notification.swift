//
//  XCContactController+Notification.swift
//  XinChat
//
//  Created by FangLin on 2019/12/5.
//  Copyright © 2019 FangLin. All rights reserved.
//

import Foundation

extension XCContactController {
    func registerNote() {
        /// 添加好友请求验证通知
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMsg(_:)), name: NSNotification.Name(rawValue: kNoteAddFriendRequestMsg), object: nil)
    }
}

// MARK:- 处理添加好友请求消息
extension XCContactController {
    @objc fileprivate func receiveMsg(_ note: Notification) {
        //刷新会话列表
        self.getUnReadCount()
    }
}

