//
//  XinChatController+Notification.swift
//
//
//  Created by FangLin on 2019/7/24.
//  Copyright © 2019年 FangLin. All rights reserved.
//

import Foundation
import NIMSDK

extension XinChatController {
    func registerNote() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMsg(_:)), name: NSNotification.Name(rawValue: kNoteChatMsgInsertMsg), object: nil)
    }
}

// MARK:- 处理全局接收到的消息，这里处理视频聊天
extension XinChatController {
    @objc fileprivate func receiveMsg(_ note: Notification) {
        //刷新会话列表
        self.getSessionsList()
        guard let nimMsg = note.object as? NIMMessage else { return }
        // 收到自己发送信息的通知则不用理会
        if nimMsg.from == XCXinChatTools.shared.getMineInfo()?.userId { return }
        
        if (nimMsg.messageType == .custom) {  // 自定义消息
            guard let obj:NIMCustomObject = nimMsg.messageObject as? NIMCustomObject else{
                return
            }
            guard let attachment = obj.attachment else { return }
            if attachment is XCNIMAudioOrVideoCallAttachment {
                let videoAttachment = attachment as! XCNIMAudioOrVideoCallAttachment
                if videoAttachment.callType == 0 {
                   
                }
            }
        }
        
    }
}
