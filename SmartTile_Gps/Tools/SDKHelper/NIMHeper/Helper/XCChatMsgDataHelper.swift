//
//  XCChatMsgDataHelper.swift
//  
//
//  Created by FangLin on 2019/1/3.
//  Copyright © 2019年 FangLin. All rights reserved.
//


import UIKit
import NIMSDK

let kChatMsgImgMaxWidth: CGFloat = 125 //最大的图片宽度
let kChatMsgImgMinWidth: CGFloat = 50 //最小的图片宽度
let kChatMsgImgMaxHeight: CGFloat = 150 //最大的图片高度
let kChatMsgImgMinHeight: CGFloat = 50 //最小的图片高度

// MARK:- 获取缩略图尺寸
class XCChatMsgDataHelper: NSObject {
    static let shared: XCChatMsgDataHelper = XCChatMsgDataHelper()
    
    func getThumbImageSize(_ originalSize: CGSize) -> CGSize {
        let imgRealHeight = originalSize.height
        let imgRealWidth = originalSize.width
        
        var resizeThumbWidth: CGFloat
        var resizeThumbHeight: CGFloat
        
        /**
         *  如果图片的高度 >= 图片的宽度 , 高度就是最大的高度，宽度等比
         *  如果图片的高度 < 图片的宽度 , 以宽度来做等比，算出高度
         */
        if imgRealHeight >=  imgRealWidth {
            let scaleWidth = imgRealWidth * kChatMsgImgMaxHeight / imgRealHeight
            resizeThumbWidth = (scaleWidth > kChatMsgImgMinWidth) ? scaleWidth : kChatMsgImgMinWidth
            resizeThumbHeight = kChatMsgImgMaxHeight
        } else {
            let scaleHeight = imgRealHeight * kChatMsgImgMaxWidth / imgRealWidth
            resizeThumbHeight = (scaleHeight > kChatMsgImgMinHeight) ? scaleHeight : kChatMsgImgMinHeight
            resizeThumbWidth = kChatMsgImgMaxWidth
        }
        
        return CGSize(width: resizeThumbWidth, height: resizeThumbHeight)
    }
}

// MARK:- 获取格式化消息
extension XCChatMsgDataHelper {
    func getFormatMsgs(nimMsgs: [NIMMessage]?) -> [XCChatMsgModel] {
        var formatMsgs: [XCChatMsgModel] = [XCChatMsgModel]()
        guard let nimMsgs = nimMsgs else { return formatMsgs }
        for nimMsg in nimMsgs {
            let model = XCChatMsgModel()
            model.message = nimMsg
            //过滤添加好友请求消息
            if model.modelType == .addFriendRequest { continue }
            formatMsgs.append(model)
        }
        return formatMsgs
    }
}

// MARK:- 获取图片消息数组
extension XCChatMsgDataHelper {
    func getImgMsgs(msgModels: [XCChatMsgModel]) -> [XCChatMsgModel] {
        var newMsgModels = [XCChatMsgModel]()
        for msgModel in msgModels {
            if msgModel.modelType == .image {
                newMsgModels.append(msgModel)
            }
        }
        return newMsgModels
    }
}

// MARK:- 数组添加时间
extension XCChatMsgDataHelper {
    // MARK: 为聊天记录数组添加时间
    // 给历史记录数组使用
    func addTimeModel(finalModel: XCChatMsgModel? = nil, models: [XCChatMsgModel]) -> [XCChatMsgModel] {
        var myModels = [XCChatMsgModel]()
        for index in 0..<models.count {
            if index == 0 { // 第一条
                if finalModel == nil {
                    // 直接添加 时间模型
                    myModels.append(createTimeModel(model: models[index]))
                } else {
                    if XCChatMsgTimeHelper.shared.needAddMinuteModel(preModel: finalModel!, curModel: models[index]) {
                        myModels.append(createTimeModel(model: models[index]))
                    }
                }
            } else {
                // 是否相差五分钟，是则添加
                if XCChatMsgTimeHelper.shared.needAddMinuteModel(preModel: models[index - 1], curModel: models[index]) {
                    myModels.append(createTimeModel(model: models[index]))
                }
            }
            myModels.append(models[index])
        }
        return myModels
    }
    
    // MARK: 创建时间模型
    fileprivate func createTimeModel(model: XCChatMsgModel) -> XCChatMsgModel {
        let timeModel: XCChatMsgModel = XCChatMsgModel()
        timeModel.message = model.message
        timeModel.modelType = .time
        timeModel.time = model.time
        timeModel.timeStr = XCChatMsgTimeHelper.shared.chatTimeString(with: timeModel.time)
        return timeModel
    }
}

