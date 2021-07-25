//
//  XCMsgChatController+Delegate.swift
//  XinChat
//
//  Created by FangLin on 2019/10/15.
//  Copyright © 2019 FangLin. All rights reserved.
//

import Foundation

// MARK:- XCMsgChatBarControllerDelegate
extension XCMsgChatController : XCMsgChatBarControllerDelegate {
    /* ============================= barView =============================== */
    func chatBarUpdateHeight(height: CGFloat) {
        chatBarVC.view.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }
    
    func chatBarVC(chatBarVC: XCMsgChatBarController, didChageChatBoxBottomDistance distance: CGFloat) {
        Dprint(distance)
        chatBarVC.view.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-distance)
        }
        UIView.animate(withDuration: kKeyboardChangeFrameTime, animations: {
            self.view.layoutIfNeeded()
        })
        if distance != 0 {
            chatMsgVC.msgListView.scrollToBottom()
        }
    }
    
    func chatBarShowTextKeyboard() {
        UIView.animate(withDuration: kKeyboardChangeFrameTime) {
            self.emotionView.alpha = 0
            self.moreView.alpha = 0
            self.moreView.snp.updateConstraints { (make) in
                make.top.equalTo(self.view.snp.bottom)
            }
            self.emotionView.snp.updateConstraints { (make) in
                make.top.equalTo(self.view.snp.bottom)
            }
        }
    }
    func chatBarShowVoice() {
        // 暂时没用
    }
    func chatBarShowEmotionKeyboard() {
        self.emotionView.alpha = 1
        self.moreView.alpha = 0
        emotionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.view.snp.bottom).offset(-kNoTextKeyboardHeight)
        }
        moreView.snp.updateConstraints { (make) in
            make.top.equalTo(self.view.snp.bottom)
        }
        UIView.animate(withDuration: kKeyboardChangeFrameTime) {
            self.view.layoutIfNeeded()
        }
    }
    func chatBarShowMoreKeyboard() {
        self.emotionView.alpha = 0
        self.moreView.alpha = 1
        emotionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.view.snp.bottom)
        }
        moreView.snp.updateConstraints { (make) in
            make.top.equalTo(self.view.snp.bottom).offset(-kNoTextKeyboardHeight)
        }
        UIView.animate(withDuration: kKeyboardChangeFrameTime) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK:- XCChatMsgControllerDelegate
extension XCMsgChatController : XCChatMsgControllerDelegate {
    func chatMsgVCWillBeginDragging(chatMsgVC: XCMsgChatListController) {
        // 还原barView的位置
        resetChatBarFrame()
    }
}

// MARK:- XCXinChatToolsMediaDelegate
extension XCMsgChatController : XCXinChatToolsMediaDelegate {
    /* ============================== 播放音频的回调 ============================== */
    // 准备开始播放音频
    func weChatToolsMediaPlayAudio(_ filePath: String, didBeganWithError error: Error?) {
        
    }
    // 音频播放结束
    func weChatToolsMediaPlayAudio(_ filePath: String, didCompletedWithError error: Error?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNoteChatMsgAudioPlayEnd), object: filePath)
    }
    /* ============================== 录制音频 ============================== */
    // 准备开始录制
    func weChatToolsMediaRecordAudio(_ filePath: String?, didBeganWithError error: Error?) {
        recordVoiceView.recording()
    }
    // 录音停止
    func weChatToolsMediaRecordAudio(_ filePath: String?, didCompletedWithError error: Error?) {
        Dprint("filePath: --- \(filePath)")
        recordVoiceView.endRecord()
        if error != nil {
            Dprint(error)
        } else {
            // 发送音频
            XCXinChatTools.shared.sendMedia(userId: user?.userId, filePath: filePath ?? "", type: .audio)
        }
    }
    // 获得当前录音时长
    func weChatToolsMediaRecordAudioProgress(_ currentTime: TimeInterval) {
        let averagePower = XCXinChatTools.shared.getRecordVoiceAveragePower()
        let level = pow(10, (0.05 * averagePower) * 10)
        Dprint("level --- \(level)")
        recordVoiceView.updateMetersValue(level)
    }
    // 取消录音
    func weChatToolsMediaRecordAudioDidCancelled() {
        recordVoiceView.endRecord()
    }
    
}
