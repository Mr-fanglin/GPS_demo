//
//  XCMsgChatBarController+Delegate.swift
//  XinChat
//
//  Created by FangLin on 2019/10/14.
//  Copyright © 2019 FangLin. All rights reserved.
//

import Foundation

// MARK:- 实现代理方法
// MARK:- XCChatBarViewDelegate
extension XCMsgChatBarController : XCChatBarViewDelegate {
    
    func chatBarUpdateHeight(height: CGFloat) {
        delegate?.chatBarUpdateHeight(height: height)
    }
    
    func chatBarShowTextKeyboard() {
        Dprint("普通键盘")
        keyboardType = .text
        delegate?.chatBarShowTextKeyboard()
    }
    
    func chatBarShowMoreKeyboard() {
        Dprint("更多面板")
        keyboardType = .more
        delegate?.chatBarShowMoreKeyboard()
        delegate?.chatBarVC(chatBarVC: self, didChageChatBoxBottomDistance: kNoTextKeyboardHeight-IPHONEX_BH)
    }
    
    func chatBarShowEmotionKeyboard() {
        Dprint("表情面板")
        keyboardType = .emotion
        delegate?.chatBarShowEmotionKeyboard()
        delegate?.chatBarVC(chatBarVC: self, didChageChatBoxBottomDistance: kNoTextKeyboardHeight-IPHONEX_BH)
    }
    
    func chatBarShowVoice() {
        Dprint("声音")
        keyboardType = .voice
        delegate?.chatBarShowVoice()
        delegate?.chatBarVC(chatBarVC: self, didChageChatBoxBottomDistance: 0)
    }
    
    func chatBarSendMessage() {
        Dprint("发送信息")
        sendMessage()
    }
}

// MARK:- XCChatEmotionViewDelegate
extension XCMsgChatBarController : XCChatEmotionViewDelegate {
    func chatEmotionView(emotionView: XCChatEmotionView, didSelectedEmotion emotion: XCChatEmotion) {
        Dprint(emotion)
        // 插入表情
        barView.inputTextView.insertEmotion(emotion: emotion)
    }
    func chatEmotionViewSend(emotionView: XCChatEmotionView) {
        Dprint("发送操作")
        sendMessage()
    }
}

// MARK:- LXFChatMoreViewDelegate
extension XCMsgChatBarController : XCChatMoreViewDelegate {
    func chatMoreView(moreView: XCChatMoreView, didSeletedType type: XCChatMoreType) {
        if type == .pic {   // 图片
            self.present(imgPickerVC, animated: true, completion: nil)
        } else if type == .sight {  // 小视频
            // let videoVC = KZVideoViewController()
            // videoVC.delegate = self
            videoVC.startAnimation(with: .small)
            // self.present(videoVC, animated: true, completion: nil)
        } else if type == .video {  // 视频聊天
////            let sheet = LXFActionSheet(delegate: self, cancelTitle: "取消", otherTitles: ["直播聊天"])
////            sheet.show()
//            let alertController = UIAlertController.initSheetView(sureTitle: "视频聊天") { (alertCtr) in
//                self.present(XCVideoChatController(user: self.user, isInitiator: true), animated: true, completion: nil)
//            }
//            self.present(alertController, animated: true, completion: nil)
//            // 隐藏chatBarView
//            let chatVC = self.delegate as! XCMsgChatController
//            chatVC.resetChatBarFrame()
        } else if type == .location {  //位置
            let locationVC = XCMsgLocationController.init(user: self.user)
            self.present(locationVC, animated: true, completion: nil)
        }
    }
}

// MARK:- TZImagePickerControllerDelegate 图片选择器代理
extension XCMsgChatBarController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        for photo in photos {
            XCXinChatTools.shared.sendImage(userId: user?.userId, image: photo)
        }
    }
}

// MARK:- KZVideoViewControllerDelegate
extension XCMsgChatBarController: KZVideoViewControllerDelegate {
    func videoViewController(_ videoController: KZVideoViewController!, didRecordVideo videoModel: KZVideoModel!) {
        // 视频本地路径
        let videoAbsolutePath = videoModel.videoAbsolutePath ?? ""
        XCXinChatTools.shared.sendMedia(userId: user?.userId, filePath: videoAbsolutePath, type: .video)
        // 缩略图路径
        // let thumAbsolutePath = videoModel.thumAbsolutePath
        // 录制时间
        // let recordTime = videoModel.recordTime
    }
    
    func videoViewControllerDidCancel(_ videoController: KZVideoViewController!) {
        Dprint("没有录到视频")
    }
}
