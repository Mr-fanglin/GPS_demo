//
//  XCMsgChatListController+Notification.swift
//  XinChat
//
//  Created by FangLin on 2019/10/15.
//  Copyright © 2019 FangLin. All rights reserved.
//

import Foundation
import NIMSDK

extension XCMsgChatListController {
    // MARK: 通知
    func registerNote() {
        // 注册通知 kNoteChatMsgResendMsg
        // 收到当前聊天的用户信息 / 即将发送消息
        NotificationCenter.default.addObserver(self, selector: #selector(insertMsgNote(_:)), name: NSNotification.Name(rawValue: kNoteChatMsgInsertMsg), object: nil)
        // 更新消息状态 发送成功/失败/重发
        NotificationCenter.default.addObserver(self, selector: #selector(updateMsg(_:)), name: NSNotification.Name(rawValue: kNoteChatMsgUpdateMsg), object: nil)
        // 重发(用来删除dataArr中的数据)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteMsg(_:)), name: NSNotification.Name(rawValue: kNoteChatMsgResendMsg), object: nil)
        
        // 点击消息图片
        NotificationCenter.default.addObserver(self, selector: #selector(showImgs(_:)), name: NSNotification.Name(rawValue: kNoteChatMsgTapImg), object: nil)
        // 点击消息视频
        NotificationCenter.default.addObserver(self, selector: #selector(showVideo(_:)), name: NSNotification.Name(rawValue: kNoteChatMsgVideoPlayStart), object: nil)
    }
}

// MARK:- 通知调用的方法
extension XCMsgChatListController {
    // MARK: 插入发送/收到的消息
    @objc fileprivate func insertMsgNote(_ note: Notification) {
        guard let nimMsg = note.object as? NIMMessage else { return }
        
        // 获取格式化后的模型数据
        let msgs = XCChatMsgDataHelper.shared.getFormatMsgs(nimMsgs: [nimMsg])
        let models = XCChatMsgDataHelper.shared.addTimeModel(finalModel: self.msgListView.dataArr.last, models: msgs)
        for model in models {
            self.msgListView.insertRowModel(model: model)
        }
        Dprint("新消息插入")
        
    }
    // MARK: 更新消息
    @objc fileprivate func updateMsg(_ note: NSNotification) {
        guard let nimMsg = note.object as? NIMMessage else {
            return
        }
        // 获取格式化后的模型数据
        let msgs = XCChatMsgDataHelper.shared.getFormatMsgs(nimMsgs: [nimMsg])
        for msg in msgs {
            self.msgListView.updateRowModel(model: msg)
        }
        Dprint("更新消息")
    }
    // MARK: 删除消息
    @objc fileprivate func deleteMsg(_ note: NSNotification) {
        guard let nimMsg = note.object as? NIMMessage else { return }
        // 获取格式化后的模型数据
        let msgs = XCChatMsgDataHelper.shared.getFormatMsgs(nimMsgs: [nimMsg])
        for msg in msgs {
            self.msgListView.deleteRowModel(model: msg)
        }
        Dprint("删除重发的消息")
    }
    // MARK: 显示图片
    @objc fileprivate func showImgs(_ note: NSNotification) {
        XCXinChatTools.shared.searchLocalMsg(userId: user?.userId) { (error, messages) in
            if error != nil {
                Dprint(error)
                return
            } else {
                DispatchQueue.main.async(execute: {
                    var imgMsgs = XCChatMsgDataHelper.shared.getFormatMsgs(nimMsgs: messages)
                    guard let obj = note.object as? [String : Any] else { return }
                    // 当前图片索引
                    var index = 0
                    let model = obj["model"] as! XCChatMsgModel
                    for imgMsg in imgMsgs {
                        if imgMsg.thumbUrl == model.thumbUrl {
                            break
                        } else {
                            index += 1
                        }
                    }
                    // 防止没有同步到本地导致数组越界
                    if imgMsgs.count == 0 {
                        imgMsgs.append(model)
                    }
                    
                    let indexP = IndexPath(item: index, section: 0)
                    let photoBrowserVC = XCPhotoBrowserController(indexPath: indexP, msgModels: imgMsgs)
                    let navphotoBrowserVC = XPRootNavigationController(rootViewController: photoBrowserVC)
                    navphotoBrowserVC.cc_setZoomTransition(originalView: obj["view"] as! UIImageView)
                    self.present(navphotoBrowserVC, animated: true, completion: nil)
                })
                
            }
        }
    }
    
    // MARK:- 播放视频
    @objc fileprivate func showVideo(_ note: Notification) {
        // 取出本地视频地址
        let model = note.object as? XCChatMsgModel
        guard model != nil else {
            return
        }
        let videoPlayVC = XCVideoPlayController(model: model!)
        self.present(videoPlayVC, animated: true, completion: nil)
    }
    
}
